import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_screen.dart';
import 'model_service.dart';
import 'results_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _pickFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      try {
        final predictions = await ModelService.classifyImage(image.path);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsPage(
                imagePath: image.path,
                predictions: predictions,
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB), Color(0xFFE0F6FF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Weather Classifier',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Identify weather conditions using AI',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5D6D7E),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF87CEEB).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.wb_sunny,
                          size: 80,
                          color: Color(0xFF4682B4),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildActionButton(
                        icon: Icons.camera_alt,
                        label: 'Take Photo',
                        color: const Color(0xFF4682B4),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CameraScreen()),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildActionButton(
                        icon: Icons.photo_library,
                        label: 'Choose from Gallery',
                        color: const Color(0xFF5DADE2),
                        onPressed: () => _pickFromGallery(context),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        width: 100,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Developed by',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5D6D7E),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Access Denied Team',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const Text(
                        'African Leadership University',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5D6D7E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}