import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  Interpreter? _interpreter;
  late List<String> _labels;
  final int inputSize = 224;

  /// Load model dan label dari assets
  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('model.tflite'); 
      final labelsData =
          await rootBundle.loadString('assets/probability-labels-en.txt');
      _labels = labelsData.split('\n').map((e) => e.trim()).toList();
    } catch (e) {
      throw Exception("Gagal load model: $e");
    }
  }

  /// Klasifikasi gambar
  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (_interpreter == null) {
      throw Exception("Model belum diload. Panggil loadModel() dulu.");
    }

    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final resizedImage =
        img.copyResize(rawImage, width: inputSize, height: inputSize);

    // Buat input tensor [1, 224, 224, 3]
    var input = List.generate(
      1,
      (i) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            final pixel = resizedImage.getPixel(x, y);
            return [
              img.getRed(pixel) / 255.0,
              img.getGreen(pixel) / 255.0,
              img.getBlue(pixel) / 255.0,
            ];
          },
        ),
      ),
    );

    // Buat output tensor
    var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

    _interpreter!.run(input, output);

    // Cari probabilitas tertinggi
    final scores = output[0];
    int maxIndex = 0;
    double maxScore = 0;
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] > maxScore) {
        maxIndex = i;
        maxScore = scores[i];
      }
    }

    return {
      "label": _labels[maxIndex],
      "confidence": "${(maxScore * 100).toStringAsFixed(2)}%",
    };
  }

  void close() {
    _interpreter?.close();
  }
}
