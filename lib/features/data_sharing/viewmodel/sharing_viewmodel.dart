import 'dart:developer';
import 'dart:io';
import 'package:LocalShare/constants/app_constants.dart';
import 'package:LocalShare/features/data_sharing/viewmodel/qr_scanner_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../../../extensions/context_extension.dart';

class SharingViewModel extends GetxController {
  RxString myIpAddress = ''.obs;
  final RxInt myPortNumber = portNumber.obs;
  RxBool isServerRunning = false.obs;

  //  TextEditingController remoteIpAddressController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  // TextEditingController remotePortNumber = TextEditingController(
  //   text: portNumber.toString(),
  //);



  ServerSocket? _server;

  void startTcpServer(
    BuildContext context, {
    VoidCallback? onServerStarted,
  }) async {
    try {
      _server = await ServerSocket.bind(
        InternetAddress.anyIPv4,
        myPortNumber.value,
      );
      isServerRunning.value = true;
      onServerStarted?.call();
      
      log("TCP Server running on ${_server!.address.address}:${_server!.port}");
      // context.showSnackBar(
      //   "TCP Server running on ${_server!.address.address}:${_server!.port}",
      // );
      await for (Socket client in _server!) {
        log("Connection from ${client.remoteAddress.address}");
        context.showSnackBar("Connection from ${client.remoteAddress.address}");
        client.listen((data) async {
          context.showSnackBar('Receive Data ${String.fromCharCodes(data)}');
        });
      }
    } catch (e) {
      context.showSnackBar(e.toString());
      log(e.toString());
    }
  }

  void sendDataTo(BuildContext context,String remoteIp,String remotePort) async {
    if (isServerRunning.value) {

        try {
          Socket socket = await Socket.connect(
            remoteIp.trim(),
            int.parse(remotePort.trim()),
          );
          socket.write(dataController.text.trim());
          socket.listen((data) {
            context.showSnackBar('Send Data ${String.fromCharCodes(data)}');
            log("Response: ${String.fromCharCodes(data)}");
          });
         Get.back();
        } catch (e) {
          context.showSnackBar(e.toString());
          log("Error: $e");
        
      }
    } else {
      startTcpServer(context);
    }
  }

  Future<void> getLocalIP() async {
    final info = NetworkInfo();
    myIpAddress.value = await info.getWifiIP() ?? "";
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLocalIP();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    dataController.dispose();
    _server?.close();
  }
}
