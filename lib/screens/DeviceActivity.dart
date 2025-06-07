import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/User.dart';
import '../utils/DeviceActivity.dart';

class DeviceActivityPage extends StatefulWidget {
  final UserModel user;
  const DeviceActivityPage({Key? key, required this.user}) : super(key: key);

  @override
  State<DeviceActivityPage> createState() => _DeviceActivityPageState();
}

class _DeviceActivityPageState extends State<DeviceActivityPage> {
  late Future<List<DeviceActivity>> _future;

  @override
  void initState() {
    super.initState();
    _future = DeviceActivityDb.instance.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Activity"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<DeviceActivity>>(
        future: _future,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data ?? [];
          if (list.isEmpty) {
            return Center(
              child: Text(
                "No activity recorded",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) {
              final e = list[i];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(e.timestamp),
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    e.activity.toUpperCase(),
                    style: TextStyle(
                      color: e.activity == 'login' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
