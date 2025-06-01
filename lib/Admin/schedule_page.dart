import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay checkInTime = const TimeOfDay(hour: 7, minute: 30);
  TimeOfDay checkOutTime = const TimeOfDay(hour: 15, minute: 0);

  final dateController = TextEditingController();
  final checkInController = TextEditingController();
  final checkOutController = TextEditingController();

  bool isEditing = false;
  final Set<DateTime> scheduledDates = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateControllers();
  }

  void _updateControllers() {
    dateController.text = DateFormat('MM/dd/yyyy').format(selectedDate);
    checkInController.text = checkInTime.format(context);
    checkOutController.text = checkOutTime.format(context);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null) setState(() {
      selectedDate = picked;
      _updateControllers();
    });
  }

  Future<void> _selectTime(bool isIn) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isIn ? checkInTime : checkOutTime,
    );
    if (picked != null) setState(() {
      if (isIn) checkInTime = picked; else checkOutTime = picked;
      _updateControllers();
    });
  }

  void _setSchedule() {
    setState(() {
      scheduledDates.add(DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day));
    });
  }

  Widget _buildCalendar() {
    final year = selectedDate.year;
    final month = selectedDate.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(daysInMonth, (i) {
        final d = DateTime(year, month, i + 1);
        final isSel = d.day == selectedDate.day;
        final isSch = scheduledDates.contains(d);
        return GestureDetector(
          onTap: () => setState(() {
            selectedDate = d; _updateControllers();
          }),
          child: Container(
            width: 40, height: 40, margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSel ? Colors.blue.shade100 : null,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text('${d.day}'),
                if (isSch)
                  const Positioned(
                    bottom: 6,
                    child: CircleAvatar(radius: 3, backgroundColor: Colors.green),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _toggleMode(bool edit) => setState(() => isEditing = edit);

  @override
  Widget build(BuildContext context) {
    final monthYear = DateFormat('MMMM yyyy').format(selectedDate);
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // <-- Header Bulan & Tahun
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                monthYear,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            _buildCalendar(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _toggleMode(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isEditing ? Colors.blue : Colors.white,
                      foregroundColor: !isEditing ? Colors.white : Colors.black,
                    ),
                    child: const Text('Add Schedule'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _toggleMode(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEditing ? Colors.blue : Colors.white,
                      foregroundColor: isEditing ? Colors.white : Colors.black,
                    ),
                    child: const Text('Change Schedule'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Choose Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: _selectDate,
            ),
            const SizedBox(height: 16),
            const Text('Attendance Time', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: checkInController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Check In Time'),
                    onTap: () => _selectTime(true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: checkOutController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Check Out Time'),
                    onTap: () => _selectTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setSchedule,
              child: Text(isEditing ? 'Change Schedule' : 'Set Schedule'),
            ),
          ],
        ),
      ),
      // **Hapus** bottomNavigationBar duplikat di sini!
    );
  }
}
