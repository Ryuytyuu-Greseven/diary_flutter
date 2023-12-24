import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';
  static const bookTitle = 'Los Santos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(bookTitle),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
