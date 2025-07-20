import 'dart:convert';
import 'dart:developer';

import 'package:LocalShare/extensions/context_extension.dart';
import 'package:LocalShare/features/data_sharing/viewmodel/sharing_viewmodel.dart';
import 'package:LocalShare/models/qr_scanner_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerViewmodel extends GetxController {
  final sharingViewModel = Get.put(SharingViewModel());

  RxString remoteIpAddress = ''.obs;
  RxString remoteDeviceName = ''.obs;
  RxBool isLoading = false.obs;
  RxString remotePortNumber = ''.obs;

  RxBool isQrScannerVisible = false.obs;
  RxBool isShowQrVisible = false.obs;

  Map<String, dynamic> get getMyData =>
      QrScannerDataModel(
        remoteDeviceName: "Device: ${sharingViewModel.myIpAddress.value}",
        remoteIpAddress: sharingViewModel.myIpAddress.value,
        remotePortNumber: sharingViewModel.myPortNumber.value,
      ).toJson();

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    detectionTimeoutMs: 300,
    torchEnabled: true,
    autoZoom: true,
  );

  updateRemoteDeviceData(BarcodeCapture barcodeData, BuildContext context) {
    context.showLoading();

    if (
        barcodeData.barcodes.first.rawValue!.isNotEmpty) {
             isQrScannerVisible.value = false;
             Get.closeCurrentSnackbar();
             Get.showSnackbar(GetSnackBar(
               duration: Duration(seconds: 1),
              title: "Sharing Data",message: "Please wait data sharing is in progress",));
      log((barcodeData.barcodes.first.rawValue.toString()));
      final response = parseQrData(
        barcodeData.barcodes.first.rawValue.toString(),
      );
    
      if (response != null) {
          log(response.remoteIpAddress. toString());
        remoteIpAddress.value = response.remoteIpAddress;
        remoteDeviceName.value = response.remoteDeviceName;
        remotePortNumber.value = response.remotePortNumber.toString();
        sharingViewModel.sendDataTo(remoteIpAddress.value,remotePortNumber.value);     
      }
    }
    context.dismissLoading();
  }

  QrScannerDataModel? parseQrData(String rawValue) {
    try {
      String cleaned = rawValue
          .replaceAllMapped(
            RegExp(r'(\w+):'),
            (match) => '"${match.group(1)}":',
          )
          .replaceAllMapped(RegExp(r': ([^,}]+)'), (match) {
            String value = match.group(1)!.trim();
            if (RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
              return ': $value'; // Keep numbers as is
            } else {
              return ': "${value.replaceAll('"', '')}"'; // Wrap strings
            }
          });
      final jsonMap = json.decode(cleaned);
      return QrScannerDataModel.fromJson(jsonMap);
    } catch (e) {
      print("QR Parse Error: $e");
      return null;
    }
  }

  showQrScanner(BuildContext context) {
    FocusScope.of(context).unfocus();
    isQrScannerVisible.value = true;

    
  }

  toggleMyQrCode(BuildContext context) {
    isShowQrVisible.value = !isShowQrVisible.value;

  }
}
