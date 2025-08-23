import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/classifier.dart';

class HomeController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  final Classifier _classifier = Classifier();

  File? _image;
  String? _label;
  String? _confidence;

  File? get image => _image;
  String? get label => _label;
  String? get confidence => _confidence;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await classify();
      notifyListeners();
    }
  }

  Future<void> classify() async {
    if (_image == null) return;
    final result = await _classifier.classify(_image!);
    _label = result['label'];
    _confidence = result['confidence'];
    notifyListeners();
  }
}
