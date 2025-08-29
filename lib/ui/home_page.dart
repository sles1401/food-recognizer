import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controller/home_controller.dart';
import 'result_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Food Recognizer')),
      body: Center(
        child: _buildBody(context, controller),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeController controller) {
    if (controller.isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Memuat model...', style: TextStyle(fontSize: 16)),
        ],
      );
    }

    if (controller.errorMessage != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            controller.errorMessage!,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text("Coba Lagi"),
            onPressed: () {
              context.read<HomeController>().retryLoadModel();
            },
          ),
        ],
      );
    }

    if (controller.isModelReady) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          controller.image != null
              ? Image.file(controller.image!, height: 200)
              : const Icon(Icons.fastfood, size: 120),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.photo_camera),
            label: const Text("Ambil dari Kamera"),
            onPressed: () {
              context.read<HomeController>().pickImage(ImageSource.camera);
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.photo),
            label: const Text("Ambil dari Galeri"),
            onPressed: () {
              context.read<HomeController>().pickImage(ImageSource.gallery);
            },
          ),
          if (controller.label != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResultPage()),
                );
              },
              child: const Text("Lihat Hasil"),
            ),
          ],
        ],
      );
    }

    return const CircularProgressIndicator();
  }
}
