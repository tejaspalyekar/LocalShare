import 'package:LocalShare/features/data_sharing/viewmodel/qr_scanner_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class MyQrCode extends StatelessWidget {
  const MyQrCode({super.key});

  @override
  Widget build(BuildContext context) {
    final qrViewModel = Get.put(QrScannerViewmodel());
    return Container(
      child: PrettyQrView.data(
  data: qrViewModel.getMyData.toString(),
  decoration: const PrettyQrDecoration(
    // image: PrettyQrDecorationImage(

    //   image: AssetImage('images/flutter.png'),
    // ),
    quietZone: PrettyQrQuietZone.standart,
  ),
),
    );
  }
}