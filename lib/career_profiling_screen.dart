import 'package:flutter/material.dart';

class CareerProfilingScreen extends StatelessWidget {
  const CareerProfilingScreen({super.key});

  void _showSheet(BuildContext c, Widget sheet) {
    showModalBottomSheet(
      context: c,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
        child: sheet,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Career Profiling')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          CircleAvatar(radius:40, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3')),
          const SizedBox(height:12),
          const Text('Dustin Henderson', style: TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
          const SizedBox(height:4),
          Text('Employee', style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height:24),
          // About
          _section(context, 'About', 'Add Work Experience', () {
            _showSheet(context, const _WorkExpSheet());
          }),
          const SizedBox(height:16),
          // Skills
          _section(context, 'Skills', 'Add Skill', () {
            _showSheet(context, const _AddSkillSheet());
          }),
        ]),
      ),
    );
  }

  Widget _section(BuildContext ctx, String title, String btn, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:12, vertical:8),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[
        Text(title, style: const TextStyle(fontSize:16,fontWeight: FontWeight.w600)),
        ElevatedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.add, size:18),
          label: Text(btn),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22577A), padding: const EdgeInsets.symmetric(horizontal:12,vertical:8)),
        ),
      ]),
    );
  }
}

class _WorkExpSheet extends StatefulWidget { const _WorkExpSheet(); @override _WorkExpSheetState createState() => _WorkExpSheetState(); }
class _WorkExpSheetState extends State<_WorkExpSheet> {
  final _ctrl = TextEditingController();
  static const _max=255;
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16,vertical:24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children:[
        Center(child: Container(width:40,height:4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)))),
        const SizedBox(height:16),
        const Center(child: Text('Add Work Experience', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold))),
        const SizedBox(height:12),
        const Text('Write your work experience', style: TextStyle(fontSize:14,color: Colors.black87)),
        const SizedBox(height:8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
          child: TextField(controller: _ctrl, maxLines:5, maxLength: _max, decoration: const InputDecoration(border: InputBorder.none, hintText: 'Write here...', counterText: '')),
        ),
        const SizedBox(height:4),
        Align(alignment: Alignment.centerRight, child: Text('${_ctrl.text.length}/$_max', style: TextStyle(color: Colors.grey[600], fontSize:12))),
        const SizedBox(height:16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Experience added!')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22577A)),
            child: const Text('Done'),
          ),
        ),
      ]),
    );
  }
}

class _AddSkillSheet extends StatefulWidget { const _AddSkillSheet(); @override _AddSkillSheetState createState() => _AddSkillSheetState(); }
class _AddSkillSheetState extends State<_AddSkillSheet> {
  final _ctrl = TextEditingController();
  static const _max=255;
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16,vertical:24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children:[
        Center(child: Container(width:40,height:4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)))),
        const SizedBox(height:16),
        const Center(child: Text('Add Skill', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold))),
        const SizedBox(height:12),
        const Text('Write your skills', style: TextStyle(fontSize:14,color: Colors.black87)),
        const SizedBox(height:8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
          child: TextField(controller: _ctrl, maxLines:5, maxLength: _max, decoration: const InputDecoration(border: InputBorder.none, hintText: 'Write here...', counterText: '')),
        ),
        const SizedBox(height:4),
        Align(alignment: Alignment.centerRight, child: Text('${_ctrl.text.length}/$_max', style: TextStyle(color: Colors.grey[600], fontSize:12))),
        const SizedBox(height:16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Skill added!')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22577A)),
            child: const Text('Done'),
          ),
        ),
      ]),
    );
  }
}
