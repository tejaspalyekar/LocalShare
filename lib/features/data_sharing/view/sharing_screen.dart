import 'package:LocalShare/constants/app_constants.dart';
import 'package:LocalShare/extensions/context_extension.dart';
import 'package:LocalShare/features/data_sharing/viewmodel/qr_scanner_viewmodel.dart';
import 'package:LocalShare/features/data_sharing/viewmodel/sharing_viewmodel.dart';
import 'package:LocalShare/features/data_sharing/widgets/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SharingScreen extends StatelessWidget {
  const SharingScreen({super.key, required this.sharingEnum});
  final SharingEnum sharingEnum;
  @override
  Widget build(BuildContext context) {
        final scannerViewModel = Get.put(QrScannerViewmodel());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Share Files",style: TextStyle(fontWeight: FontWeight.w600),)),
      body: Obx(()=> scannerViewModel.isQrScannerVisible.value?
       Center(
        child: QrScanner(),
      ):
      Center(
        child: ShareText()
        ),
      )
     
    );
  }
}

class ShareText extends StatelessWidget {
  const ShareText({super.key});

  @override
  Widget build(BuildContext context) {
        final scannerViewModel = Get.put(QrScannerViewmodel());
    final sharingViewModel = Get.put(SharingViewModel());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: sharingViewModel.dataController,
            decoration: InputDecoration(
              labelText: "Text to Send",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: Icon(Icons.text_fields),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            minLines: 5,
            maxLines: 10,
          ),
          SizedBox(height: context.screenHeight * 0.05),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("Send Text"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => scannerViewModel.showQrScanner(context),
            ),
          ),
        ],
      ),
    );
  }
}
