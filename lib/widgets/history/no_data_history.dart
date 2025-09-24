// lib/widgets/history/no_data_history.dart
import 'package:flutter/material.dart';

class NoDataHistory extends StatelessWidget {
  const NoDataHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3D25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_rounded,
            color: Colors.white.withOpacity(0.6),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            "Tidak ada data",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Silakan pilih rentang tanggal lain",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
