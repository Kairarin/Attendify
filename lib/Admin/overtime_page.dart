import 'package:flutter/material.dart';
import 'main.dart'; // untuk MainNav

class OvertimePage extends StatefulWidget {
  const OvertimePage({Key? key}) : super(key: key);

  @override
  State<OvertimePage> createState() => _OvertimePageState();
}

class _OvertimePageState extends State<OvertimePage> {
  int _selectedIndex = 2; // Index untuk tab Overtime
  String searchQuery = '';

  void _onItemTapped(int index) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainNav(initialIndex: index)),
    );
  }

  void _onSearchChanged(String v) {
    setState(() {
      searchQuery = v;
      // Tambahkan logika filter data berdasarkan query jika diperlukan
    });
  }

  void _pickFilter() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tambahkan opsi filter sesuai kebutuhan
          ListTile(
            title: const Text('Filter by Date'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Filter by Status'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overtime'),
      ),
      body: Column(
        children: [
          // Search + Filter Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search Name',
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _pickFilter,
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                ),
              ],
            ),
          ),
          // Overtime List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  OvertimeItem(
                    name: 'Dustin Henderson',
                    date: '2 hours on Monday',
                    status: 'APPROVE',
                    onApprove: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Approved')),
                      );
                    },
                    onReject: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rejected')),
                      );
                    },
                  ),
                  OvertimeItem(
                    name: 'Joyce Byers',
                    date: '3 hours on Thursday',
                    status: 'PENDING',
                    onApprove: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Approved')),
                      );
                    },
                    onReject: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rejected')),
                      );
                    },
                  ),
                  OvertimeItem(
                    name: 'Sam Smith',
                    date: '3 hours on Saturday',
                    status: 'REJECT',
                    onApprove: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Approved')),
                      );
                    },
                    onReject: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rejected')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class OvertimeItem extends StatelessWidget {
  final String name;
  final String date;
  final String status;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const OvertimeItem({
    super.key,
    required this.name,
    required this.date,
    required this.status,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'APPROVE'
                        ? Colors.green.withOpacity(0.1)
                        : status == 'REJECT'
                        ? Colors.red.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: status == 'APPROVE'
                          ? Colors.green
                          : status == 'REJECT'
                          ? Colors.red
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('REJECT'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('APPROVE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
