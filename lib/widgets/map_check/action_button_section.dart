// lib/widgets/map_check_in/action_button_section.dart

import 'package:flutter/material.dart';

class ActionButtonSection extends StatelessWidget {
  final Map<String, dynamic>? absenTodayData;
  final bool isLoading;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  const ActionButtonSection({
    super.key,
    required this.absenTodayData,
    required this.isLoading,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  @override
  Widget build(BuildContext context) {
    // --- LOGIKA BARU UNTUK MENANGANI STATUS IZIN ---
    final status = absenTodayData?['status']?.toString().toLowerCase() ?? '';
    if (status == 'izin') {
      return _actionButton(
        label: "Anda Sedang Izin",
        icon: Icons.block_rounded,
        gradientColors: [Colors.grey.shade600, Colors.grey.shade700],
        onPressed: null, // Tombol tidak bisa dipencet
      );
    }
    // --- AKHIR LOGIKA BARU ---

    final bool hasCheckedIn = absenTodayData?['check_in'] != null;
    final bool hasCheckedOut = absenTodayData?['check_out'] != null;

    if (!hasCheckedIn) {
      return _actionButton(
        label: "Check In Sekarang",
        icon: Icons.login_rounded,
        gradientColors: [const Color(0xFF1B3D25), const Color(0xFF3E6B42)],
        onPressed: isLoading ? null : onCheckIn,
      );
    } else if (hasCheckedIn && !hasCheckedOut) {
      return _actionButton(
        label: "Check Out Sekarang",
        icon: Icons.logout_rounded,
        gradientColors: [Colors.amber.shade700, Colors.orange.shade600],
        onPressed: isLoading ? null : onCheckOut,
      );
    } else {
      return _actionButton(
        label: "Absensi Hari Ini Selesai",
        icon: Icons.check_circle_rounded,
        gradientColors: [Colors.grey.shade600, Colors.grey.shade700],
        onPressed: null,
      );
    }
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback? onPressed,
  }) {
    // ... Isi widget ini sama seperti di file lama Anda ...
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
