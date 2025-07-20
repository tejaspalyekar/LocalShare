import 'package:LocalShare/constants/app_constants.dart';
import 'package:LocalShare/extensions/context_extension.dart';
import 'package:LocalShare/features/data_sharing/view/sharing_screen.dart';
import 'package:LocalShare/features/data_sharing/viewmodel/qr_scanner_viewmodel.dart';
import 'package:LocalShare/features/data_sharing/viewmodel/sharing_viewmodel.dart';
import 'package:LocalShare/features/data_sharing/widgets/how_to_share_info.dart';
import 'package:LocalShare/features/data_sharing/widgets/qr_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/home_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final scannerViewModel = Get.put(QrScannerViewmodel());
    final sharingViewModel = Get.put(SharingViewModel());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Share',style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
      ),
      drawer: const HomeDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () => scannerViewModel.toggleMyQrCode(context),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.qr_code,
                                
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'My QR Code (Receive Files)',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    scannerViewModel.isShowQrVisible.value
                                        ? Icons.close
                                        : Icons.qr_code,
                                  ),
                                  onPressed: () {
                                    scannerViewModel.toggleMyQrCode(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (scannerViewModel.isShowQrVisible.value)
                            Center(child: MyQrCode()),
                          if (scannerViewModel.isShowQrVisible.value)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text('Show this QR to the sender.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.screenHeight * 0.016),
                HowToShareInfo(),
                SizedBox(height: context.screenHeight * 0.016),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Share Files',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: context.screenHeight * 0.016),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.description),
                              label: const Text('Document'),
                              onPressed:
                                  () => Get.to(
                                    () => SharingScreen(
                                      sharingEnum: SharingEnum.document,
                                    ),
                                  ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.audiotrack),
                              label: const Text('Audio'),
                              onPressed:
                                  () => Get.to(
                                    () => SharingScreen(
                                      sharingEnum: SharingEnum.audio,
                                    ),
                                  ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.videocam),
                              label: const Text('Video'),
                              onPressed:
                                  () => Get.to(
                                    () => SharingScreen(
                                      sharingEnum: SharingEnum.video,
                                    ),
                                  ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.text_snippet),
                              label: const Text('Text'),
                              onPressed:
                                  () => Get.to(
                                    () => SharingScreen(
                                      sharingEnum: SharingEnum.text,
                                    ),
                                  ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                //         Card(
                //   elevation: 2,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(16),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(20.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: [
                //         Text(
                //           'Send Data',
                //           style: Theme.of(context).textTheme.titleMedium,
                //         ),
                //         SizedBox(height: context.screenHeight * 0.016),
                //         TextField(
                //           controller:
                //               sharingViewModel.remoteIpAddressController,
                //           decoration: const InputDecoration(
                //             labelText: "Remote IP Address",
                //             prefixIcon: Icon(Icons.computer),
                //             border: OutlineInputBorder(),
                //           ),
                //         ),
                //         SizedBox(height: context.screenHeight * 0.016),
                //         TextField(
                //           controller: sharingViewModel.remotePortNumber,
                //           decoration: const InputDecoration(
                //             labelText: "Remote Port Number",
                //             prefixIcon: Icon(Icons.dns),
                //             border: OutlineInputBorder(),
                //           ),
                //           keyboardType: TextInputType.number,
                //         ),
                //         SizedBox(height: context.screenHeight * 0.016),
                //         TextField(
                //           controller: sharingViewModel.dataController,
                //           decoration: const InputDecoration(
                //             labelText: "Text to Send",
                //             prefixIcon: Icon(Icons.text_fields),
                //             border: OutlineInputBorder(),
                //           ),
                //           minLines: 1,
                //           maxLines: 3,
                //         ),
                //         SizedBox(height: context.screenHeight * 0.020),
                //         Row(
                //           children: [
                //             Expanded(
                //               child: ElevatedButton.icon(
                //                 icon: const Icon(Icons.qr_code_scanner),
                //                 label: const Text("Scan Receiver QR"),
                //                 style: ElevatedButton.styleFrom(
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(12),
                //                   ),
                //                   padding: const EdgeInsets.symmetric(
                //                     vertical: 14,
                //                   ),
                //                 ),
                //                 onPressed: () {},
                //               ),
                //             ),
                //             SizedBox(height: context.screenHeight * 0.012),
                //             Expanded(
                //               child: ElevatedButton.icon(
                //                 icon: const Icon(Icons.send),
                //                 label: const Text("Send Text"),
                //                 style: ElevatedButton.styleFrom(
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(12),
                //                   ),
                //                   padding: const EdgeInsets.symmetric(
                //                     vertical: 14,
                //                   ),
                //                 ),
                //                 onPressed:
                //                     () => sharingViewModel.sendDataTo(
                //                       sharingViewModel.remoteIpAddressController.text.trim(),
                //                    sharingViewModel.remotePortNumber.text
                //                     ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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
}



