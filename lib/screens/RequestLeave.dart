import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/User.dart';
import '../models/LeaveRequest.dart';

class RequestLeavePage extends StatefulWidget {
  final UserModel user;
  const RequestLeavePage({Key? key, required this.user}) : super(key: key);

  @override
  State<RequestLeavePage> createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  String? selectedReason;
  DateTime? startDate;
  DateTime? endDate;
  String? evidenceUrl;
  final _descriptionController = TextEditingController();

  final List<String> leaveReasons = [
    'Wedding leave',
    'Annual leave',
    'Business Trip',
    'Sick leave',
    'Other',
  ];

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (startDate ?? now) : (endDate ?? now),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart)
          startDate = picked;
        else
          endDate = picked;
      });
    }
  }

  Future<void> _pickImage(ImageSource src) async {
    final picker = ImagePicker();
    final XFile? xfile = await picker.pickImage(source: src, imageQuality: 80);
    if (xfile == null) return;

    final bytes = await xfile.readAsBytes();
    final bucketId = 'requests';
    final bucket = Supabase.instance.client.storage.from(bucketId);
    final fileName =
        '${widget.user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      final String uploadedPath = await bucket.uploadBinary(fileName, bytes);
      print('uploadedPath: $uploadedPath');

      String rawPath = uploadedPath;
      if (uploadedPath.startsWith('$bucketId/')) {
        rawPath = uploadedPath.substring(bucketId.length + 1);
      }

      final String publicUrl = bucket.getPublicUrl(rawPath);

      setState(() => evidenceUrl = publicUrl);
    } catch (err) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload gagal: $err')));
    }
  }

  Future<void> _submitRequest() async {
    // Validasi
    if (selectedReason == null ||
        startDate == null ||
        endDate == null ||
        evidenceUrl == null ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    // Buat model & simpan ke Firestore
    final req = LeaveRequest(
      userId: widget.user.uid,
      reason: selectedReason!,
      description: _descriptionController.text.trim(),
      startDate: startDate!,
      endDate: endDate!,
      evidenceUrl: evidenceUrl!,
    );

    await FirebaseFirestore.instance.collection('requests').add(req.toMap());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Leave request submitted')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String fmt(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Leave"),
        backgroundColor: Colors.blue,
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Reason
          const Text("Reason", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap:
                () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder:
                      (_) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            leaveReasons
                                .map(
                                  (r) => ListTile(
                                    title: Text(r),
                                    onTap: () {
                                      setState(() => selectedReason = r);
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedReason ?? "Choose",
                    style: TextStyle(
                      color:
                          selectedReason == null ? Colors.grey : Colors.black,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          // Start Date
          const Text(
            "Start Date",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _pickDate(isStart: true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                startDate != null ? fmt(startDate!) : "Choose",
                style: TextStyle(
                  color: startDate == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          // End Date
          const Text("End Date", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _pickDate(isStart: false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                endDate != null ? fmt(endDate!) : "Choose",
                style: TextStyle(
                  color: endDate == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          // Description
          const Text(
            "Detailed Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: "Explanation",
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),

          const SizedBox(height: 20),
          // Evidence buttons
          const Text("Evidence", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload File"),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text("Capture Photo"),
              ),
            ],
          ),

          if (evidenceUrl != null) ...[
            const SizedBox(height: 12),
            Image.network(evidenceUrl!),
          ],

          const SizedBox(height: 30),
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitRequest,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Submit Request"),
            ),
          ),
        ],
      ),
    );
  }
}
