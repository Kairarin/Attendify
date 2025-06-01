// import 'package:flutter/material.dart';

// class RequestLeavePage extends StatefulWidget {
//   const RequestLeavePage({super.key});

//   @override
//   State<RequestLeavePage> createState() => _RequestLeavePageState();
// }

// class _RequestLeavePageState extends State<RequestLeavePage> {
//   String? selectedReason;
//   DateTime? selectedDate;
//   int leaveDays = 1;
//   final TextEditingController _descriptionController = TextEditingController();

//   final List<String> leaveReasons = [
//     'Wedding leave',
//     'Annual leave',
//     'Business Trip',
//     'Sick leave',
//     'Other'
//   ];

//   void _showReasonPicker() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: leaveReasons.map((reason) {
//               return ListTile(
//                 title: Text(reason),
//                 onTap: () {
//                   setState(() {
//                     selectedReason = reason;
//                   });
//                   Navigator.pop(context);
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   void _showDatePicker() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   void _decreaseDays() {
//     if (leaveDays > 1) {
//       setState(() {
//         leaveDays--;
//       });
//     }
//   }

//   void _increaseDays() {
//     setState(() {
//       leaveDays++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Request Leave"),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "The reason for the permit",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             GestureDetector(
//               onTap: _showReasonPicker,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       selectedReason ?? "Choose",
//                       style: TextStyle(
//                         color: selectedReason != null ? Colors.black : Colors.grey,
//                       ),
//                     ),
//                     const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//             const Text(
//               "Start Date",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             GestureDetector(
//               onTap: _showDatePicker,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       selectedDate != null
//                           ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
//                           : "Choose",
//                       style: TextStyle(
//                         color: selectedDate != null ? Colors.black : Colors.grey,
//                       ),
//                     ),
//                     const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//             const Text(
//               "How many days",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     leaveDays.toString(),
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: _decreaseDays,
//                         icon: const Icon(Icons.remove),
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                       ),
//                       const SizedBox(width: 20),
//                       IconButton(
//                         onPressed: _increaseDays,
//                         icon: const Icon(Icons.add),
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),
//             const Text(
//               "Detailed Description",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: TextField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   hintText: "Explanation",
//                   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   border: InputBorder.none,
//                 ),
//                 maxLines: 5,
//               ),
//             ),

//             const SizedBox(height: 20),
//             const Text(
//               "Evidence",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text(
//                     "Upload File",
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 40),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Process the leave request
//                   // You can add validation and submission logic here
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Leave request submitted')),
//                   );
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 child: const Text("Submit Request"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }
// }

// File: lib/screens/RequestLeavePage.dart

import 'package:flutter/material.dart';
import '../models/User.dart';

class RequestLeavePage extends StatefulWidget {
  final UserModel user;

  const RequestLeavePage({Key? key, required this.user}) : super(key: key);

  @override
  State<RequestLeavePage> createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  String? selectedReason;
  DateTime? selectedDate;
  int leaveDays = 1;
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> leaveReasons = [
    'Wedding leave',
    'Annual leave',
    'Business Trip',
    'Sick leave',
    'Other',
  ];

  void _showReasonPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                leaveReasons.map((reason) {
                  return ListTile(
                    title: Text(reason),
                    onTap: () {
                      setState(() {
                        selectedReason = reason;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _decreaseDays() {
    if (leaveDays > 1) {
      setState(() {
        leaveDays--;
      });
    }
  }

  void _increaseDays() {
    setState(() {
      leaveDays++;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Leave"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Ketuk back → kembalikan ke tab Home dengan _currentIndex = 0 di MainScreen
            // Karena RequestLeavePage sudah di‐embed di MainScreen, cukup popping satu level:
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "The reason for the permit",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showReasonPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedReason ?? "Choose",
                      style: TextStyle(
                        color:
                            selectedReason != null ? Colors.black : Colors.grey,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Start Date",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showDatePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                          : "Choose",
                      style: TextStyle(
                        color:
                            selectedDate != null ? Colors.black : Colors.grey,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "How many days",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leaveDays.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _decreaseDays,
                        icon: const Icon(Icons.remove),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: _increaseDays,
                        icon: const Icon(Icons.add),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Detailed Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "Explanation",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: 5,
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Evidence",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Upload File", style: TextStyle(color: Colors.grey)),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Process the leave request (validasi & simpan ke backend)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Leave request submitted')),
                  );
                  // Setelah submit, kembalikan ke tab Home (currentIndex = 0 di MainScreen)
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Submit Request"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
