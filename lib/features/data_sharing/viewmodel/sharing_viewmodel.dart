import 'dart:developer';
import 'dart:io';
import 'package:LocalShare/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:network_info_plus/network_info_plus.dart';

class SharingViewModel extends GetxController {
  RxString myIpAddress = ''.obs;
  final RxInt myPortNumber = portNumber.obs;
  RxBool isServerRunning = false.obs;

   TextEditingController remoteIpAddressController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController remotePortNumber = TextEditingController(
    text: portNumber.toString(),
  );

  ServerSocket? _server;

  void startTcpServer({VoidCallback? onServerStarted}) async {
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
    Get.closeCurrentSnackbar();
        Get.showSnackbar(

          GetSnackBar(title: "Connection Successful",message: "Connection Received from ${client.remoteAddress.address}",),
        );
        client.listen((data) async {
         Get.closeCurrentSnackbar();
          Get.showSnackbar(
            GetSnackBar(title: 'Data',message:' ${String.fromCharCodes(data)}' ,),
          );
        });
      }
      Get.back();
    } catch (e) {
      Get.closeCurrentSnackbar();
      Get.showSnackbar(GetSnackBar(title: 'Error',message: e.toString(),));
      log(e.toString());
    }
  }

  void sendDataTo(String remoteIp, String remotePort) async {
    if (isServerRunning.value) {
      try {
        Socket socket = await Socket.connect(
          remoteIp.trim(),
          int.parse(remotePort),
          timeout: Duration(seconds: 10),
        );
        log("Connected to server");
        log(dataController.text.trim());
        socket.write(dataController.text.trim());
        socket.listen((data) {
         Get.closeCurrentSnackbar();
          Get.showSnackbar(
            GetSnackBar(title: "Data Send",message:'Send Data ${String.fromCharCodes(data)}' ,),
          );

          log("Response: ${String.fromCharCodes(data)}");
        });
        //Get.back();
      } catch (e) {
        Get.closeCurrentSnackbar();
        Get.showSnackbar(GetSnackBar(title: "Error",message: e.toString(),));
        log("Error: $e");
      }
    } else {
      startTcpServer();
    }
  }

  Future<void> getLocalIP() async {
    final info = NetworkInfo();
    final ip = await info.getWifiIP();
    if (ip != null && ip.isNotEmpty) {
      myIpAddress.value = ip;
      log("Local IP Address: $ip");
      if (!isServerRunning.value) {
        startTcpServer();
      }
    } else {
      log("Failed to get local IP. Make sure WiFi is connected.");
    }
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
