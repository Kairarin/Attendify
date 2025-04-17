import 'package:flutter/material.dart';

class EmployeePayrollScreen extends StatelessWidget {
  const EmployeePayrollScreen({super.key});

  String _fmt(int v) =>
      'Rp${v.toString().replaceAllMapped(RegExp(r'(\\d)(?=(\\d{3})+\$)'), (m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        'name': 'Dustin Henderson',
        'worked': 155,
        'total': 160,
        'rate': 125000,
        'bonus': 0,
        'deduction': 625000,
        'status': 'Unpaid',
      },
      {
        'name': 'Jane Doe',
        'worked': 160,
        'total': 160,
        'rate': 125000,
        'bonus': 0,
        'deduction': 0,
        'status': 'Paid',
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) {
            final d = data[i];
            final pay = d['worked'] * d['rate'] - d['deduction'];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: const Color(0xFFFDF5F5),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Hours Worked: ${d['worked']} / ${d['total']}'),
                    Text('Hourly Rate: ${_fmt(d['rate'])}'),
                    Text('Pay This Month: ${_fmt(pay)}'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Bonus: ${_fmt(d['bonus'])}'),
                        Text('Deduction: ${_fmt(d['deduction'])}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: d['status'] == 'Paid' ? Colors.green.shade200 : Colors.yellow.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(d['status'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: d['status'] == 'Paid' ? Colors.green : Colors.black87,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
