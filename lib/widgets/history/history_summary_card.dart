// lib/widgets/history/history_summary_card.dart
import 'package:flutter/material.dart';
import 'package:prasta/models/history_absen_model.dart';

class HistorySummaryCard extends StatelessWidget {
  final List<Datum> historyList;

  const HistorySummaryCard({super.key, required this.historyList});

  @override
  Widget build(BuildContext context) {
    // --- LOGIKA BARU UNTUK MENGHITUNG IZIN SECARA TERPISAH ---
    final totalDays = historyList.length;
    final completedDays = historyList
        .where((h) => h.checkOutTime != null)
        .length;
    final izinDays = historyList
        .where((h) => h.status?.toLowerCase() == 'izin')
        .length;
    final onlyCheckIn = historyList
        .where(
          (h) =>
              h.checkInTime != null &&
              h.checkOutTime == null &&
              h.status?.toLowerCase() != 'izin',
        )
        .length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B3D25), Color(0xFF2D5233)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            "Total",
            totalDays.toString(),
            Icons.calendar_today_rounded,
          ),
          _buildSummaryItem(
            "Selesai",
            completedDays.toString(),
            Icons.check_circle_rounded,
          ),
          _buildSummaryItem(
            "Izin",
            izinDays.toString(),
            Icons.description_rounded,
          ),
          _buildSummaryItem(
            "Belum Out",
            onlyCheckIn.toString(),
            Icons.schedule_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }
}
