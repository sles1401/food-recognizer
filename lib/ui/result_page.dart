import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/home_controller.dart';
import '../widget/classification_item.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Result Page'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child:
                    controller.image != null
                        ? Image.file(controller.image!, fit: BoxFit.cover)
                        : const Icon(Icons.fastfood, size: 120),
              ),
            ),
            if (controller.label != null && controller.confidence != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ClassificationItem(
                  item: controller.label!,
                  value: controller.confidence!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
