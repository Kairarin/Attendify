import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/User.dart';
import '../models/Schedule.dart';
import '../models/Attendance.dart';
import 'AttendanceHistory.dart';

class EmployeeAttendancePage extends StatefulWidget {
  final UserModel user;
  const EmployeeAttendancePage({Key? key, required this.user})
    : super(key: key);

  @override
  State<EmployeeAttendancePage> createState() => _EmployeeAttendancePageState();
}

class _EmployeeAttendancePageState extends State<EmployeeAttendancePage> {
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSub;
  String? _wfhEvidenceUrl; // <-- URL photo for WFH

  static const _kGeofenceLat = -6.972666570140133;
  static const _kGeofenceLng = 107.63963111847609;
  static const _kGeofenceRadius = 500;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied ||
        p == LocationPermission.deniedForever) {
      p = await Geolocator.requestPermission();
    }
    if (p == LocationPermission.whileInUse || p == LocationPermission.always) {
      _positionStreamSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((pos) {
        setState(() => _currentPosition = pos);
      });
    }
  }

  Stream<Schedule?> watchTodaySchedule() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('schedule')
        .where('meeting_date', isEqualTo: today)
        .limit(1)
        .snapshots()
        .map((snap) {
          if (snap.docs.isEmpty) return null;
          return Schedule.fromFirestore(snap.docs.first);
        });
  }

  Future<void> _pickWFHPhoto() async {
    final picker = ImagePicker();
    final XFile? xfile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (xfile == null) return;

    final bytes = await xfile.readAsBytes();
    final bucketId = 'attendance';
    final bucket = Supabase.instance.client.storage.from(bucketId);
    final fileName =
        '${widget.user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      final String uploadedPath = await bucket.uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(upsert: true),
      );
      print('uploadedPath: $uploadedPath');

      String rawPath = uploadedPath;
      if (uploadedPath.startsWith('$bucketId/')) {
        rawPath = uploadedPath.substring(bucketId.length + 1);
      }

      final String publicUrl = bucket.getPublicUrl(rawPath);

      setState(() {
        _wfhEvidenceUrl = publicUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload photo failed: $e')));
    }
  }

  Future<void> _doCheckIn(Schedule schedule) async {
    String evidence;
    if (schedule.isWFH) {
      if (_wfhEvidenceUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a photo first')),
        );
        return;
      }
      evidence = _wfhEvidenceUrl!;
    } else {
      if (_currentPosition == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Location not available')));
        return;
      }
      evidence = '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    }

    final ref = await FirebaseFirestore.instance
        .collection('attendance')
        .add(
          Attendance(
            id: '',
            userId: widget.user.uid,
            scheduleId: schedule.id,
            evidence: evidence,
            createdAt: null,
          ).toMap(),
        );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Check-In successful')));
    setState(() {}); // force rebuild so button updates
  }

  Future<bool> _hasCheckedIn(String scheduleId) async {
    final q =
        await FirebaseFirestore.instance
            .collection('attendance')
            .where('schedule_id', isEqualTo: scheduleId)
            .where('user_id', isEqualTo: widget.user.uid)
            .limit(1)
            .get();
    return q.docs.isNotEmpty;
  }

  double _distance(double lat1, double lng1, double lat2, double lng2) {
    return Distance().as(
      LengthUnit.Meter,
      LatLng(lat1, lng1),
      LatLng(lat2, lng2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Attendance"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Hello, ${widget.user.nama}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // jadwal hari ini
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<Schedule?>(
                stream: watchTodaySchedule(),
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final schedule = snap.data;
                  if (schedule == null) {
                    return _noScheduleCard();
                  }
                  final formattedDate = DateFormat(
                    'EEE, dd MMM yyyy',
                  ).format(schedule.meetingDate);

                  return FutureBuilder<bool>(
                    future: _hasCheckedIn(schedule.id),
                    builder: (ctx2, csnap) {
                      final already = csnap.data == true;
                      // only for non-WFH: check time & geofence
                      bool withinTime = true, withinGeo = true;
                      if (!schedule.isWFH) {
                        final now = TimeOfDay.now();
                        final st = schedule.startTime.split(':'),
                            et = schedule.endTime.split(':');
                        final start = TimeOfDay(
                          hour: int.parse(st[0]),
                          minute: int.parse(st[1]),
                        );
                        final end = TimeOfDay(
                          hour: int.parse(et[0]),
                          minute: int.parse(et[1]),
                        );
                        final nm = now.hour * 60 + now.minute;
                        final sm = start.hour * 60 + start.minute;
                        final em = end.hour * 60 + end.minute;
                        withinTime = nm >= sm && nm <= em;
                        if (_currentPosition != null) {
                          final d = _distance(
                            _kGeofenceLat,
                            _kGeofenceLng,
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          );
                          withinGeo = d <= _kGeofenceRadius;
                        } else
                          withinGeo = false;
                      }
                      final canCheck =
                          schedule.isWFH
                              ? (_wfhEvidenceUrl != null && !already)
                              : (!already && withinTime && withinGeo);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // peta & detail sama seperti sebelum
                          if (!schedule.isWFH) ...[_mapPreview()],
                          _scheduleDetailCard(schedule, formattedDate),

                          // jika WFH: tombol upload foto
                          if (schedule.isWFH) ...[
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _pickWFHPhoto,
                              icon: const Icon(Icons.camera_alt),
                              label: Text(
                                _wfhEvidenceUrl == null
                                    ? 'Upload Photo'
                                    : 'Retake Photo',
                              ),
                            ),
                            if (_wfhEvidenceUrl != null) ...[
                              const SizedBox(height: 8),
                              Image.network(_wfhEvidenceUrl!),
                            ],
                          ],

                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed:
                                canCheck ? () => _doCheckIn(schedule) : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  schedule.isWFH
                                      ? (canCheck ? Colors.green : Colors.grey)
                                      : (canCheck ? Colors.green : Colors.grey),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              already
                                  ? 'Already Checked In'
                                  : schedule.isWFH
                                  ? 'Check In'
                                  : (!withinTime
                                      ? 'Not In Time Range'
                                      : (!withinGeo
                                          ? 'Not At Location'
                                          : 'Check In')),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AttendanceHistoryPage(user: widget.user),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Attendance History'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _noScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'No schedule for ${DateFormat('EEE, dd MMM yyyy').format(DateTime.now())}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              '-- : -- - -- : --',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'No Check-In Available',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapPreview() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: FlutterMap(
        options: MapOptions(
          initialCenter:
              _currentPosition != null
                  ? LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  )
                  : const LatLng(_kGeofenceLat, _kGeofenceLng),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.attendify_app',
          ),
          if (_currentPosition != null)
            CircleLayer(
              circles: [
                CircleMarker(
                  point: const LatLng(_kGeofenceLat, _kGeofenceLng),
                  color: Colors.red.withOpacity(0.2),
                  useRadiusInMeter: true,
                  radius: _kGeofenceRadius.toDouble(),
                ),
              ],
            ),
          if (_currentPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.circle, size: 16, color: Colors.blue),
                ),
                Marker(
                  point: const LatLng(_kGeofenceLat, _kGeofenceLng),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _scheduleDetailCard(Schedule s, String formattedDate) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Schedule",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(formattedDate, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${s.startTime} - ${s.endTime}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            s.description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
