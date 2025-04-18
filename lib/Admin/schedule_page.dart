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

  final TextEditingController dateController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();

  bool isEditing = false;
  final Set<DateTime> scheduledDates = {};

  @override
  void initState() {
    super.initState();
    // jangan panggil _updateControllers() di sini
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // sekarang context sudah lengkap dengan Localizations
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
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _updateControllers();
      });
    }
  }

  Future<void> _selectTime({required bool isCheckIn}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isCheckIn ? checkInTime : checkOutTime,
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInTime = picked;
        } else {
          checkOutTime = picked;
        }
        _updateControllers();
      });
    }
  }

  void _setSchedule() {
    setState(() {
      scheduledDates.add(DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      ));
    });
  }

  Widget _buildCalendar() {
    final year = selectedDate.year;
    final month = selectedDate.month;
    final lastDay = DateTime(year, month + 1, 0).day;
    final days = List.generate(lastDay, (i) => DateTime(year, month, i + 1));

    return Wrap(
      alignment: WrapAlignment.center,
      children: days.map((d) {
        final isSel = d.day == selectedDate.day;
        final isSch = scheduledDates.any((sd) =>
        sd.year == d.year && sd.month == d.month && sd.day == d.day);

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = d;
              _updateControllers();
            });
          },
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSel ? Colors.blue.shade100 : Colors.transparent,
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
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: Colors.green,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _toggleMode(bool edit) => setState(() => isEditing = edit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            const Text('Attendance Time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: checkInController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Check In Time'),
                    onTap: () => _selectTime(isCheckIn: true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: checkOutController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Check Out Time'),
                    onTap: () => _selectTime(isCheckIn: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setSchedule,
              child:
              Text(isEditing ? 'Change Schedule' : 'Set Schedule'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
