import 'package:flutter/material.dart';

class Error404Screen extends StatelessWidget {
  const Error404Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Can't find that page"),
      ),
      body: const Center(
        child: Text('404'),
      ),
    );
  }
}
