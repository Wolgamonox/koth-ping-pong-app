import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Helper function to show the QR code reader widget
Future<String?> showQRCodePage(BuildContext context) async {
  final String result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const QRCodePage()),
  );
  if (result.isNotEmpty) {
    return result;
  } else {
    return null;
  }
}

class QRCodePage extends StatefulWidget {
  const QRCodePage({Key? key}) : super(key: key);

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan code')),
      body: MobileScanner(
        allowDuplicates: false,
        onDetect: (barcode, args) {
          if (barcode.rawValue == null) {
            debugPrint('Failed to scan Barcode');
            Navigator.of(context).pop('Fail');
          } else {
            final String code = barcode.rawValue!;
            debugPrint('Barcode found! $code');
            Navigator.of(context).pop(code);
          }
        },
      ),
    );
  }
}
