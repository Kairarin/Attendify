import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart'; // untuk MainNav

class EmployeePayroll {
  final String name;
  final int hoursWorked;
  final int totalHours;
  final double hourlyRate;
  final double bonus;
  final double deduction;
  bool isPaid;

  EmployeePayroll({
    required this.name,
    required this.hoursWorked,
    required this.totalHours,
    required this.hourlyRate,
    this.bonus = 0,
    this.deduction = 0,
    this.isPaid = false,
  });
}

class PayrollPage extends StatefulWidget {
  const PayrollPage({Key? key}) : super(key: key);

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  // Ganti nama list data jadi "_data"
  final List<EmployeePayroll> _data = [
    EmployeePayroll(
      name: 'Dustin Henderson',
      hoursWorked: 155,
      totalHours: 160,
      hourlyRate: 125000,
      bonus: 0,
      deduction: 625000,
      isPaid: false,
    ),
    EmployeePayroll(
      name: 'Jane Doe',
      hoursWorked: 160,
      totalHours: 160,
      hourlyRate: 125000,
      bonus: 2000000,
      deduction: 0,
      isPaid: true,
    ),
    // Tambah data lain jika perlu...
  ];

  String search = '';
  String? filterPaid;

  String _fmt(double v) =>
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(v);

  // Gunakan _data di sini
  List<EmployeePayroll> get _filtered => _data.where((e) {
    if (filterPaid != null) {
      final status = e.isPaid ? 'Paid' : 'Unpaid';
      if (status != filterPaid) return false;
    }
    if (search.isNotEmpty &&
        !e.name.toLowerCase().contains(search.toLowerCase())) return false;
    return true;
  }).toList();

  void _pickFilter() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
        RadioListTile<String?>(
          title: const Text('All'),
          value: null,
          groupValue: filterPaid,
          onChanged: (v) => setState(() => filterPaid = v),
        ),
        RadioListTile<String?>(
          title: const Text('Paid'),
          value: 'Paid',
          groupValue: filterPaid,
          onChanged: (v) => setState(() => filterPaid = v),
        ),
        RadioListTile<String?>(
          title: const Text('Unpaid'),
          value: 'Unpaid',
          groupValue: filterPaid,
          onChanged: (v) => setState(() => filterPaid = v),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payroll')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Search + Filter
          Row(children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search Name'),
                onChanged: (v) => setState(() => search = v),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _pickFilter,
              icon: const Icon(Icons.filter_list),
              label: const Text('Filter'),
            ),
          ]),
          const SizedBox(height: 16),
          // Daftar karyawan
          Column(
            children: _filtered.map((e) {
              final pay = (e.hoursWorked * e.hourlyRate) + e.bonus - e.deduction;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    // Info kiri
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text('Hours: ${e.hoursWorked}/${e.totalHours}'),
                            Text('Rate: ${_fmt(e.hourlyRate)}'),
                            Text('Pay: ${_fmt(pay)}'),
                            const SizedBox(height: 8),
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: e.isPaid
                                      ? Colors.green.shade100
                                      : Colors.yellow.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(e.isPaid ? 'Paid' : 'Unpaid'),
                              ),
                              const SizedBox(width: 8),
                              if (!e.isPaid)
                                ElevatedButton(
                                  onPressed: () =>
                                      setState(() => e.isPaid = true),
                                  child: const Text('Mark as Paid'),
                                ),
                            ]),
                          ]),
                    ),
                    // Info kanan
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('Bonus: ${_fmt(e.bonus)}'),
                      Text('Deduction: ${_fmt(e.deduction)}'),
                    ]),
                  ]),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Schedule tab
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => MainNav(initialIndex: i)),
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
