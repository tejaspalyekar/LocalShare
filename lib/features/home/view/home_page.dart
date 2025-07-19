import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../viewmodel/home_viewmodel.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? scannedQrData;
  bool showQr = false;
  bool showScanner = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(HomeViewModel());
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalShare'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Settings', style: TextStyle(color: Colors.white, fontSize: 24)),
                  const SizedBox(height: 16),
                  Obx(() => Text('Device IP:  ${viewModel.myIpAddress}', style: const TextStyle(color: Colors.white))),
                  Obx(() => Text('Port:  ${viewModel.myPortNumber}', style: const TextStyle(color: Colors.white))),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.qr_code, color: Colors.deepPurple),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'QR Code',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            IconButton(
                              icon: Icon(showQr ? Icons.close : Icons.qr_code),
                              onPressed: () {
                                setState(() {
                                  showQr = !showQr;
                                });
                              },
                            ),
                          ],
                        ),
                        if (showQr)
                          Obx(() => Center(
                                child: QrImage(
                                  data: '{"ip":"${viewModel.myIpAddress}","port":${viewModel.myPortNumber}}',
                                  version: QrVersions.auto,
                                  size: 180.0,
                                ),
                              )),
                        if (showQr)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Show this QR to the sender.'),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('How to Share', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        _buildStep('1. On receiver device, open LocalShare and tap the QR icon to show your QR.'),
                        _buildStep('2. On sender device, tap "Send Data" and scan the receiver\'s QR code.'),
                        _buildStep('3. Enter your message or select a file to share.'),
                        _buildStep('4. Tap send!'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (showScanner)
                  SizedBox(
                    height: 300,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: (controller) {
                            controller.scannedDataStream.listen((scanData) {
                              setState(() {
                                scannedQrData = scanData.code;
                                showScanner = false;
                              });
                              // Parse and set remote IP/port here
                              try {
                                final data = scanData.code;
                                if (data != null) {
                                  Map<String, dynamic>? map;
                                  try {
                                    map = Map<String, dynamic>.from(jsonDecode(data));
                                  } catch (_) {
                                    map = null;
                                  }
                                  if (map != null) {
                                    viewModel.remoteIpAddressController.text = map['ip'] ?? '';
                                    viewModel.remotePortNumber.text = map['port']?.toString() ?? '';
                                  }
                                }
                              } catch (_) {}
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                if (!showScanner)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Send Data', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 16),
                          TextField(
                            controller: viewModel.remoteIpAddressController,
                            decoration: const InputDecoration(
                              labelText: "Remote IP Address",
                              prefixIcon: Icon(Icons.computer),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: viewModel.remotePortNumber,
                            decoration: const InputDecoration(
                              labelText: "Remote Port Number",
                              prefixIcon: Icon(Icons.dns),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: viewModel.dataController,
                            decoration: const InputDecoration(
                              labelText: "Text to Send",
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(),
                            ),
                            minLines: 1,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.qr_code_scanner),
                                  label: const Text("Scan Receiver QR"),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showScanner = true;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.send),
                                  label: const Text("Send Text"),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: () => viewModel.sendDataTo(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Share Files',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.description),
                              label: const Text('Document'),
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.audiotrack),
                              label: const Text('Audio'),
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.videocam),
                              label: const Text('Video'),
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.text_snippet),
                              label: const Text('Text'),
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
} 