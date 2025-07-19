import 'dart:developer';
import 'dart:io';
import 'package:LocalShare/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../../../extensions/context_extension.dart';

class HomeViewModel extends GetxController{
  RxString myIpAddress = ''.obs;
  final RxInt myPortNumber = portNumber.obs;
  RxBool isServerRunning = false.obs;
  TextEditingController remoteIpAddressController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController remotePortNumber = TextEditingController(
    text: portNumber.toString(),
  );

  ServerSocket? _server;

  void startTcpServer(BuildContext context, {VoidCallback? onServerStarted}) async {
    try {
      _server = await ServerSocket.bind(
        InternetAddress.anyIPv4,
        myPortNumber.value,
      );
      isServerRunning.value = true;
      onServerStarted?.call();
      log("TCP Server running on ${_server!.address.address}:${_server!.port}");
      context.showSnackBar(
        "TCP Server running on ${_server!.address.address}:${_server!.port}",
      );
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

  void sendDataTo(BuildContext context) async {
    if (isServerRunning.value) {
      try {
        Socket socket = await Socket.connect(
          remoteIpAddressController.text.trim(),
          int.parse(remotePortNumber.text.trim()),
        );
        socket.write(dataController.text.trim());
        socket.listen((data) {
          context.showSnackBar('Send Data ${String.fromCharCodes(data)}');
          log("Response: ${String.fromCharCodes(data)}");
        });
      } catch (e) {
        context.showSnackBar(e.toString());
        log("Error: $e");
      }
    } else {
      context.showSnackBar("Please start server first");
    }
  }

  Future<void> getLocalIP() async {
    final info = NetworkInfo();
    myIpAddress.value = await info.getWifiIP()??"";
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

        remoteIpAddressController.dispose();
    dataController.dispose();
    remotePortNumber.dispose();
    _server?.close();
  }
} 