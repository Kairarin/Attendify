import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  const EmployeeAttendanceScreen({super.key});

  @override
  _EmployeeAttendanceScreenState createState() => _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
  DateTime? _checkIn, _checkOut;
  final scheduleStart = const TimeOfDay(hour: 7, minute: 3);
  final scheduleEnd = const TimeOfDay(hour: 15, minute: 3);
  final int locations = 1;

  String fmt(DateTime dt) => DateFormat('HH:mm').format(dt);

  void _onCheckIn() {
    if (_checkIn == null) setState(() => _checkIn = DateTime.now());
    else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Already checked in at ${fmt(_checkIn!)}')));
  }

  void _onCheckOut() {
    if (_checkIn == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please check in first')));
      return;
    }
    if (_checkOut == null) setState(() => _checkOut = DateTime.now());
    else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Already checked out at ${fmt(_checkOut!)}')));
  }

  void _scanQR() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('QR Scanned'),
      content: const Text('Result: EMPLOYEE12345'),
      actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('OK'))],
    ));
  }

  void _toHistory() => Navigator.pushNamed(context, '/history');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Attendance')),
      body: Column(children: [
        Container(height:200, color: Colors.grey[300], child: const Center(child: Text('Map Placeholder'))),
        const SizedBox(height:16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:24,horizontal:16),
              child: Column(children: [
                const Text('Attendance Time', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height:16),
                Row(children: [
                  Expanded(child: Column(children: [
                    const Text('Check In'),
                    const SizedBox(height:8),
                    Text(_checkIn!=null?fmt(_checkIn!):'--:--', style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
                    const SizedBox(height:8),
                    ElevatedButton(onPressed: _onCheckIn, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22577A)), child: const Text('Check In'))
                  ])),
                  const SizedBox(width:16),
                  Expanded(child: Column(children: [
                    const Text('Check Out'),
                    const SizedBox(height:8),
                    Text(_checkOut!=null?fmt(_checkOut!):'--:--', style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
                    const SizedBox(height:8),
                    ElevatedButton(onPressed: _onCheckOut, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22577A)), child: const Text('Check Out'))
                  ])),
                ]),
              ]),
            ),
          ),
        ),
        const SizedBox(height:12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16),
          child: ElevatedButton.icon(onPressed: _scanQR, icon: const Icon(Icons.qr_code_scanner), label: const Text('Scan QR'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22577A), minimumSize: const Size.fromHeight(48))),
        ),
        const SizedBox(height:16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                const Icon(Icons.schedule),
                const SizedBox(width:8),
                Expanded(child: Text('${scheduleStart.format(context)} - ${scheduleEnd.format(context)}')),
                const Icon(Icons.location_on),
                const SizedBox(width:4),
                Text('$locations Locations'),
              ]),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(onPressed: _toHistory, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22577A), minimumSize: const Size.fromHeight(48)), child: const Text('Attendance History')),
        ),
      ]),
    );
  }
}
