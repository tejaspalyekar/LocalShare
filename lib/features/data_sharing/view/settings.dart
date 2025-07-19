import 'package:LocalShare/features/data_sharing/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Device Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Obx(() => ListTile(
                  leading: const Icon(Icons.computer),
                  title: const Text('Device IP'),
                  subtitle: Text(viewModel.myIpAddress.value),
                )),
            Obx(() => ListTile(
                  leading: const Icon(Icons.dns),
                  title: const Text('Port'),
                  subtitle: Text(viewModel.myPortNumber.value.toString()),
                )),
          ],
        ),
      ),
    );
  }
} 