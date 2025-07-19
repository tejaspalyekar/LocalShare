import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/home_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            onPressed: () {}, // Placeholder for future global share action
          ),
        ],
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
                    child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.wifi, color: Colors.deepPurple),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Your Device',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'IP Address:  ${viewModel.myIpAddress}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Port:  ${viewModel.myPortNumber}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Obx(() => Chip(
                          label: Text(
                            viewModel.isServerRunning.value
                                ? 'Server Running'
                                : 'Server Stopped',
                            style: TextStyle(
                              color: viewModel.isServerRunning.value
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          backgroundColor: viewModel.isServerRunning.value
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                        )),
                      ],
                    )),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Send Data',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.play_circle_fill),
                                label: const Text("Start Server"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: viewModel.isServerRunning.value
                                      ? Colors.green
                                      : Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () => viewModel.startTcpServer(context, onServerStarted: () => setState(() {})),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
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
                              onPressed: () {}, // Placeholder
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
                              onPressed: () {}, // Placeholder
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
                              onPressed: () {}, // Placeholder
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
                              onPressed: () {}, // Placeholder
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
} 