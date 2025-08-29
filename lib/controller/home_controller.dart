import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/classifier.dart';

class HomeController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  Classifier? _classifier;

  File? _image;
  String? _label;
  String? _confidence;
  bool _isModelReady = false;
  String? _errorMessage;
  bool _isLoading = true;

  File? get image => _image;
  String? get label => _label;
  String? get confidence => _confidence;
  bool get isModelReady => _isModelReady;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  HomeController() {
    _initClassifier();
  }

  Future<void> _initClassifier() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Add timeout to prevent infinite loading
      final result = await _loadModelWithTimeout();

      if (result) {
        _isModelReady = true;
        _errorMessage = null;
      } else {
        _errorMessage = "Gagal memuat model. Waktu habis.";
      }
    } catch (e) {
      _errorMessage = "Error: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _loadModelWithTimeout() async {
    try {
      final completer = Completer<bool>();
      final timeout = const Duration(seconds: 10);

      _classifier = Classifier();

      // Start model loading
      _classifier!.loadModel().then((_) {
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      }).catchError((error) {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });

      // Set timeout
      Timer(timeout, () {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });

      return await completer.future;
    } catch (e) {
      return false;
    }
  }

  Future<void> retryLoadModel() async {
    await _initClassifier();
  }

  Future<void> pickImage(ImageSource source) async {
    if (!_isModelReady) {
      throw Exception("Model belum siap, tunggu sebentar...");
    }

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await classify();
      notifyListeners();
    }
  }

  Future<void> classify() async {
    if (_image == null || _classifier == null || !_isModelReady) return;
    final result = await _classifier!.classify(_image!);
    _label = result['label'];
    _confidence = result['confidence'];
    notifyListeners();
  }
}
