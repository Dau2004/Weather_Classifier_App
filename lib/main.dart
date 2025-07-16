import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'model_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await ModelService.initialize();
  } catch (e) {
    print('Model initialization failed: $e');
  }
  runApp(const WeatherClassifierApp());
}

class WeatherClassifierApp extends StatelessWidget {
  const WeatherClassifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Image Classifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}