import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RequestLeaveScreen extends StatefulWidget {
  const RequestLeaveScreen({super.key});
  @override
  _RequestLeaveScreenState createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<RequestLeaveScreen> {
  final _reasons = ['Sick Leave','Annual Leave','Maternity Leave','Unpaid Leave'];
  final _dayOpts = List.generate(30, (i)=>i+1);
  String? _reason;
  DateTime? _start;
  int? _days;
  final _desc = TextEditingController();
  String? _evidence;

  Future<T?> _showPicker<T>(List<T> items, String Function(T) label) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: items.map((e) => ListTile(
          title: Text(label(e)),
          onTap: () => Navigator.pop(context, e),
        )).toList(),
      ),
    );
  }

  Future<void> _pickReason() async {
    final r = await _showPicker<String>(_reasons, (s)=>s);
    if (r!=null) setState(()=>_reason=r);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year-1),
      lastDate: DateTime(now.year+1),
    );
    if (d!=null) setState(()=>_start=d);
  }

  Future<void> _pickDays() async {
    final d = await _showPicker<int>(_dayOpts, (i)=>'$i day${i>1?'s':''}');
    if (d!=null) setState(()=>_days=d);
  }

  Future<void> _pickFile() async {
    final res = await FilePicker.platform.pickFiles();
    if (res!=null && res.files.isNotEmpty) {
      setState(()=>_evidence=res.files.first.name);
    }
  }

  @override
  void dispose() {
    _desc.dispose();
    super.dispose();
  }

  Widget _dropdown(String? value, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      height:50,
      padding: const EdgeInsets.symmetric(horizontal:12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Expanded(child: Text(value ?? 'Choose', style: TextStyle(color: value==null?Colors.grey:Colors.black))),
        Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
      ]),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Leave')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
          const Text('The reason for the permit', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height:8),
          _dropdown(_reason, _pickReason),
          const SizedBox(height:16),
          const Text('Start Date', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height:8),
          _dropdown(_start==null?null:'${_start!.day}/${_start!.month}/${_start!.year}', _pickDate),
          const SizedBox(height:16),
          const Text('How many days', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height:8),
          _dropdown(_days==null?null:'$_days', _pickDays),
          const SizedBox(height:16),
          const Text('Detailed Description', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height:8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal:12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
            child: TextField(
              controller: _desc,
              maxLines:5,
              decoration: const InputDecoration(hintText: 'Explanation', border: InputBorder.none),
            ),
          ),
          const SizedBox(height:16),
          const Text('Evidence', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height:8),
          _dropdown(_evidence, _pickFile),
          const SizedBox(height:32),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_reason==null||_start==null||_days==null||_desc.text.isEmpty||_evidence==null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request submitted!')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22577A), minimumSize: const Size.fromHeight(48)),
              child: const Text('Submit Request'),
            ),
          ),
        ]),
      ),
    );
  }
}
