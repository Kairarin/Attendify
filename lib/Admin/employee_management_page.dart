import 'package:flutter/material.dart';
import 'main.dart'; // for MainNav

class Employee {
  String name;
  String email;
  String position;
  String role;

  Employee({
    required this.name,
    required this.email,
    required this.position,
    required this.role,
  });
}

class EmployeeManagementPage extends StatefulWidget {
  const EmployeeManagementPage({Key? key}) : super(key: key);

  @override
  State<EmployeeManagementPage> createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  List<Employee> _employees = [
    Employee(name: 'Dustin Henderson', email: 'dustin@company.com', position: 'Software Engineer', role: 'Admin'),
    Employee(name: 'Jane Doe', email: 'jane@company.com', position: 'HR Manager', role: 'Employee'),
    Employee(name: 'John Smith', email: 'john@company.com', position: 'Data Scientist', role: 'Employee'),
    Employee(name: 'Mike Wheeler', email: 'mike@company.com', position: 'Software Engineer', role: 'Employee'),
    Employee(name: 'Erica Sinclair', email: 'erica@company.com', position: 'HR Manager', role: 'Admin'),
    Employee(name: 'Lucas Sinclair', email: 'lucas@company.com', position: 'Data Scientist', role: 'Employee'),
    Employee(name: 'Nancy Wheeler', email: 'nancy@company.com', position: 'UX Designer', role: 'Employee'),
    Employee(name: 'Steve Harrington', email: 'steve@company.com', position: 'Product Manager', role: 'Admin'),
    Employee(name: 'Eleven', email: 'eleven@company.com', position: 'AI Specialist', role: 'Employee'),
  ];

  String search = '';
  String? filterPosition = 'All';
  String? filterRole = 'All';

  List<Employee> get _filtered => _employees.where((e) {
    final matchesSearch = search.isEmpty || e.name.toLowerCase().contains(search.toLowerCase());
    final matchesPosition = filterPosition == 'All' || e.position == filterPosition;
    final matchesRole = filterRole == 'All' || e.role == filterRole;
    return matchesSearch && matchesPosition && matchesRole;
  }).toList();

  void _pickFilter() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        String? tempPosition = filterPosition;
        String? tempRole = filterRole;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Filter Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Position'),
                  value: tempPosition,
                  items: ['All', 'Software Engineer', 'HR Manager', 'Data Scientist', 'UX Designer', 'Product Manager', 'AI Specialist']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setModalState(() => tempPosition = v),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Role'),
                  value: tempRole,
                  items: ['All', 'Employee', 'Admin']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setModalState(() => tempRole = v),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filterPosition = tempPosition;
                      filterRole = tempRole;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ]),
            );
          },
        );
      },
    );
  }

  void _editEmployee(Employee employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${employee.name}')),
    );
  }

  void _deleteEmployee(Employee employee) {
    setState(() {
      _employees.remove(employee);
    });
  }

  void _addEmployee() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Employee action triggered')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Management')),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search Name',
                        ),
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
                  ..._filtered.map((e) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(e.email),
                          Text('Position: ${e.position}'),
                          Text('Role: ${e.role}'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _editEmployee(e),
                                icon: const Icon(Icons.edit, color: Colors.white),
                                label: const Text('Edit'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () => _deleteEmployee(e),
                                icon: const Icon(Icons.delete, color: Colors.white),
                                label: const Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton.extended(
              onPressed: _addEmployee,
              icon: const Icon(Icons.add),
              label: const Text('Add Employee'),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => MainNav(initialIndex: i)),
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
