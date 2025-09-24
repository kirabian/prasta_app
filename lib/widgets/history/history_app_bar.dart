// lib/widgets/history/history_app_bar.dart
import 'package:flutter/material.dart';

class HistoryAppBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onExportPressed;
  final VoidCallback onDateFilterPressed;
  final bool isExportEnabled;

  const HistoryAppBar({
    super.key,
    required this.onBackPressed,
    required this.onExportPressed,
    required this.onDateFilterPressed,
    required this.isExportEnabled,
  });

  @override
  Widget build(BuildContext context) {
    const Color surfaceColor = Color(0xFF0D2818);
    const Color primaryColor = Color(0xFF1B3D25);
    const Color accentColor = Color(0xFF3E6B42);

    return Row(
      children: [
        _buildIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: onBackPressed,
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Text(
            "Riwayat Absensi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildIconButton(
          icon: Icons.date_range_rounded,
          onPressed: onDateFilterPressed,
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: isExportEnabled ? onExportPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: isExportEnabled
                  ? LinearGradient(colors: [primaryColor, accentColor])
                  : LinearGradient(
                      colors: [Colors.grey.shade600, Colors.grey.shade700],
                    ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
              ],
            ),
            child: const Icon(
              Icons.file_download_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0D2818),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
