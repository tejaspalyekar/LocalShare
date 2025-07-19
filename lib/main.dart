import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:LocalShare/context_extension.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Sharing App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? myIpAddress;
  static int myPortNumber = 4040;
  bool isServerRunning = false;
  TextEditingController remoteIpAddressController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController remotePortNumber = TextEditingController(
    text: myPortNumber.toString(),
  );

  //receiver
  void startTcpServer(BuildContext context) async {
    try {
      final server = await ServerSocket.bind(
        InternetAddress.anyIPv4,
        myPortNumber,
      );
      setState(() {
        isServerRunning = true;
      });
      log("TCP Server running on ${server.address.address}:${server.port}");
      context.showSnackBar(
        "TCP Server running on ${server.address.address}:${server.port}",
      );
      await for (Socket client in server) {
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

  //send
  void sendDataTo(
    String targetIP,
    int port,
    String data,
    BuildContext context,
  ) async {
    if (isServerRunning) {
      try {
        Socket socket = await Socket.connect(targetIP, port);
        socket.write(data);
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

  Future<dynamic> getLocalIP() async {
    final info = NetworkInfo();
    myIpAddress = await info.getWifiIP();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalIP();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    remoteIpAddressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('My IP Address: $myIpAddress | Port: $myPortNumber'),
            TextField(
              controller: remoteIpAddressController,
              decoration: InputDecoration(hintText: "Enter Remote IP Address"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: remotePortNumber,
              decoration: InputDecoration(hintText: "Enter Remote Port number"),
            ),
            SizedBox(height: 50),
            TextField(
              controller: dataController,

              decoration: InputDecoration(hintText: "Enter Data"),
            ),
            SizedBox(height: 50),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed:
                        () => sendDataTo(
                          remoteIpAddressController.text.trim(),
                          int.parse(remotePortNumber.text.trim()),
                          dataController.text.trim(),
                          context,
                        ),
                    child: Text("Send Data"),
                  ),
                  TextButton(
                    onPressed: () => startTcpServer(context),
                    child: Text(
                      isServerRunning
                          ? "TCP Server Running"
                          : "Start TCP Server",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
