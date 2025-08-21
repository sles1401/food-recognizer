import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  late Interpreter _interpreter;
  late List<String> _labels;
  final int inputSize = 224;

  Classifier() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('model.tflite');
    // Load labels from asset
    final labelsData =
        await rootBundle.loadString('assets/probability-labels.txt');
    _labels = labelsData.split('\n').map((e) => e.trim()).toList();
  }

  Future<Map<String, dynamic>> classify(File imageFile) async {
    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final resizedImage =
        img.copyResize(rawImage, width: inputSize, height: inputSize);

    // Convert image to input tensor [1, 224, 224, 3]
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

    // Prepare output tensor
    var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

    _interpreter.run(input, output);

    // Get max probability
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
    _interpreter.close();
  }
}
