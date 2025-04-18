import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  const PayrollPage({super.key});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
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
  ];

  String _formatCurrency(double value) {
    final f = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return f.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter button
            ElevatedButton.icon(
              onPressed: () {
                // TODO: implement filter
              },
              icon: const Icon(Icons.filter_list),
              label: const Text('Filter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            // Title
            const Text(
              'Salary Overview (Hourly Based)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // List of payroll cards
            Column(
              children: _data.asMap().entries.map((entry) {
                final idx = entry.key;
                final emp = entry.value;
                final payThisMonth = (emp.hoursWorked * emp.hourlyRate) + emp.bonus - emp.deduction;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    child: Column(
                      children: [
                        // Nama & status + action button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Info kiri
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(emp.name,
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('Hours Worked: ${emp.hoursWorked} / ${emp.totalHours}'),
                                  Text('Hourly Rate: ${_formatCurrency(emp.hourlyRate)}'),
                                  Text('Pay This Month: ${_formatCurrency(payThisMonth)}'),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: emp.isPaid
                                              ? Colors.green.shade100
                                              : Colors.yellow.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          emp.isPaid ? 'Paid' : 'Unpaid',
                                          style: TextStyle(
                                            color:
                                            emp.isPaid ? Colors.green.shade800 : Colors.orange.shade800,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (!emp.isPaid)
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              emp.isPaid = true;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Mark as Paid'),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Info kanan (bonus & deduction)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Bonus: ${_formatCurrency(emp.bonus)}'),
                                Text('Deduction: ${_formatCurrency(emp.deduction)}'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
