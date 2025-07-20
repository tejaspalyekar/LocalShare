import 'package:LocalShare/extensions/context_extension.dart';
import 'package:LocalShare/features/data_sharing/viewmodel/qr_scanner_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatelessWidget {
  const QrScanner({super.key});

  @override
  Widget build(BuildContext context) {
    final qrViewModel = Get.put(QrScannerViewmodel());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: context.screenHeight * 0.6,
      width: context.screenWidth * 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MobileScanner(
                  onDetect:
                      (result) => qrViewModel.updateRemoteDeviceData(
                        result,
                        
                        context
                      ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "To connect with receiver scan receiver Qr code",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
