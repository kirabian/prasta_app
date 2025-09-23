// lib/widgets/profile/image_source_dialog.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ImageSourceDialog extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ImageSourceDialog({
    super.key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Palet Warna Lokal
    const Color primaryColor = Color(0xFF1B3D25);
    const Color primaryLight = Color(0xFF2D5233);
    const Color accentColor = Color(0xFF3E6B42);
    const Color surfaceColor = Color(0xFF0D2818);
    const Color cardColor = Color(0xFF1B3D25);

    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Dialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [surfaceColor, cardColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.photo_camera_rounded,
                color: Colors.white,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                "Pilih Sumber Foto",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildOption(
                "Kamera dengan Filter",
                Icons.camera_alt_rounded,
                onCameraPressed,
                [primaryColor, accentColor],
              ),
              const SizedBox(height: 12),
              _buildOption(
                "Galeri",
                Icons.photo_library_rounded,
                onGalleryPressed,
                [primaryLight, accentColor],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Batal",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    String title,
    IconData icon,
    VoidCallback onTap,
    List<Color> gradientColors,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
