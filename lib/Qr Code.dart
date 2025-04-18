import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const EmployeeCodeScreen(),
    );
  }
}

class EmployeeCodeScreen extends StatefulWidget {
  const EmployeeCodeScreen({super.key});

  @override
  State<EmployeeCodeScreen> createState() => _EmployeeCodeScreenState();
}

class _EmployeeCodeScreenState extends State<EmployeeCodeScreen> {
  String scannedData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendify'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Barcode and QR Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),
            _buildCodeContainer(
              title: 'Barcode',
              child: BarcodeWidget(
                barcode: Barcode.code128(),
                data: 'EMP-123456',
                width: 200,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            _buildCodeContainer(
              title: 'QR Code',
              child: QrImageView(
                data: 'https://attendify.com/emp-123456',
                version: QrVersions.auto,
                size: 150,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              onPressed: _scanCode,
              child: const Text(
                'Scan this code to show data profiling',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  void _scanCode() async {
    final scannerController = MobileScannerController();
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Scan Code'),
            actions: [
              IconButton(
                icon: ValueListenableBuilder(
                  valueListenable: scannerController.torchState,
                  builder: (context, state, child) {
                    switch (state) {
                      case TorchState.off:
                        return const Icon(Icons.flash_off, color: Colors.grey);
                      case TorchState.on:
                        return const Icon(Icons.flash_on, color: Colors.yellow);
                    }
                  },
                ),
                onPressed: () => scannerController.toggleTorch(),
              ),
            ],
          ),
          body: MobileScanner(
            controller: scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                Navigator.pop(context);
                setState(() {
                  scannedData = barcode.rawValue ?? 'No data found';
                });
                // Handle scanned data here
              }
            },
          ),
        ),
      ),
    );
  }
}