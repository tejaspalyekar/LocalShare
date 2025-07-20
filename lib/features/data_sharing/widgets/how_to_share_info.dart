import 'package:flutter/material.dart';

class HowToShareInfo extends StatelessWidget {
  const HowToShareInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Card(
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
                          'How to Share',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        _buildStep(
                          '1. On receiver device, open LocalShare and tap the QR icon to show your QR.',
                        ),
                        _buildStep(
                          '2. On sender device, tap "Send Data" and scan the receiver\'s QR code.',
                        ),
                        _buildStep(
                          '3. Enter your message or select a file to share.',
                        ),
                        _buildStep('4. Tap send!'),
                      ],
                    ),
                  ),
                );
  }
}


  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }