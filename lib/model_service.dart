import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelService {
  static Interpreter? _interpreter;
  static bool _isInitialized = false;

  // Initialize the model
  static Future<void> initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/weather_model.tflite');
      _isInitialized = true;
    } catch (e) {
      print('Model not found, using mock predictions: $e');
      _isInitialized = false;
    }
  }

  // Classify an image
  static Future<Map<String, double>> classifyImage(String imagePath) async {
    if (!_isInitialized || _interpreter == null) {
      // Return mock predictions when model is not available
      return _getMockPredictions();
    }

    try {
      // Load and preprocess image
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes)!;
      final resizedImage = img.copyResize(image, width: 224, height: 224);
      final input = _preprocessImage(resizedImage);

      // Run inference
      final output = List.filled(1 * 4, 0.0).reshape([1, 4]);
      _interpreter!.run(input, output);

      // Get results
      final labels = ['Cloudy', 'Rain', 'Shine', 'Sunrise'];
      final results = <String, double>{};
      
      for (var i = 0; i < labels.length; i++) {
        results[labels[i]] = output[0][i].toDouble();
      }

      return results;
    } catch (e) {
      print('Prediction error: $e');
      return _getMockPredictions();
    }
  }

  // Generate mock predictions for testing
  static Map<String, double> _getMockPredictions() {
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    return {
      'Cloudy': (random % 25 + 10) / 100.0,
      'Rain': (random % 30 + 15) / 100.0,
      'Shine': (random % 35 + 25) / 100.0,
      'Sunrise': (random % 20 + 5) / 100.0,
    };
  }

  // Preprocess image for model input
  static List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    final input = List.generate(
      1,
      (_) => List.generate(
        224,
        (_) => List.generate(
          224,
          (_) => List.filled(3, 0.0),
        ),
      ),
    );

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        input[0][y][x][0] = (pixel.r - 127.5) / 127.5;
        input[0][y][x][1] = (pixel.g - 127.5) / 127.5;
        input[0][y][x][2] = (pixel.b - 127.5) / 127.5;
      }
    }

    return input;
  }
}