import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart'; // for MainNav

// Model for attendance record
typedef AttendanceRecord = _AttendanceRecord;
class _AttendanceRecord {
  final String name;
  final DateTime date;
  final String checkIn;
  final String checkOut;
  final String status;

  _AttendanceRecord({
    required this.name,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });
}

class AttendanceMonitoringPage extends StatefulWidget {
  const AttendanceMonitoringPage({Key? key}) : super(key: key);

  @override
  _AttendanceMonitoringPageState createState() => _AttendanceMonitoringPageState();
}

class _AttendanceMonitoringPageState extends State<AttendanceMonitoringPage> {
  // Dummy attendance data
  final List<_AttendanceRecord> _allRecords = [
    _AttendanceRecord(name: 'Dustin Henderson', date: DateTime(2025, 4, 15), checkIn: '08:03', checkOut: '17:04', status: 'Present'),
    _AttendanceRecord(name: 'Jane Doe', date: DateTime(2025, 4, 15), checkIn: '08:12', checkOut: '17:10', status: 'Late'),
    _AttendanceRecord(name: 'John Smith', date: DateTime(2025, 4, 16), checkIn: '08:00', checkOut: '17:00', status: 'Present'),
    _AttendanceRecord(name: 'Mike Wheeler', date: DateTime(2025, 4, 16), checkIn: '08:05', checkOut: '17:02', status: 'Present'),
    _AttendanceRecord(name: 'Erica Sinclair', date: DateTime(2025, 4, 17), checkIn: '08:20', checkOut: '17:15', status: 'Late'),
    _AttendanceRecord(name: 'Lucas Sinclair', date: DateTime(2025, 4, 17), checkIn: '08:00', checkOut: '17:00', status: 'Present'),
    _AttendanceRecord(name: 'Nancy Wheeler', date: DateTime(2025, 4, 18), checkIn: '08:10', checkOut: '17:05', status: 'Present'),
    _AttendanceRecord(name: 'Steve Harrington', date: DateTime(2025, 4, 18), checkIn: '08:00', checkOut: '17:00', status: 'Present'),
    _AttendanceRecord(name: 'Eleven', date: DateTime(2025, 4, 19), checkIn: '08:30', checkOut: '17:30', status: 'Present'),
  ];

  DateTime _selectedDate = DateTime.now();
  String _selectedEmployee = 'All Employees';

  // Build unique employee list for dropdown
  List<String> get _employeeNames {
    final names = _allRecords.map((r) => r.name).toSet().toList()..sort();
    return ['All Employees', ...names];
  }

  // Filter records by date & employee
  List<_AttendanceRecord> get _filteredRecords => _allRecords.where((r) {
    final sameDate = r.date.year == _selectedDate.year &&
        r.date.month == _selectedDate.month &&
        r.date.day == _selectedDate.day;
    final matchesEmployee =
        _selectedEmployee == 'All Employees' || r.name == _selectedEmployee;
    return sameDate && matchesEmployee;
  }).toList();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _applyFilter() {
    setState(() {});
  }

  int _navIndex = 1;
  void _onNavTap(int idx) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainNav(initialIndex: idx)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Monitoring')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter row
            Row(
              children: [
                // Date picker container
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(dateStr, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Employee dropdown container
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: _selectedEmployee,
                      items: _employeeNames
                          .map((name) => DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedEmployee = v);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Filter button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _applyFilter,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Filter'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Data table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Check In')),
                    DataColumn(label: Text('Check Out')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: _filteredRecords.map((r) {
                    return DataRow(cells: [
                      DataCell(Text(r.name)),
                      DataCell(Text(DateFormat('yyyy-MM-dd').format(r.date))),
                      DataCell(Text(r.checkIn)),
                      DataCell(Text(r.checkOut)),
                      DataCell(Text(r.status)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
