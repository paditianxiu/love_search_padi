// ignore_for_file: file_names
import 'package:flutter/material.dart';

class ClassificationPage extends StatelessWidget {
  const ClassificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分类'),
      ),
      body: Center(
          child: FilledButton(onPressed: () {}, child: const Text("在写了.."))),
    );
  }
}
