// lib/widgets/history/history_list_item_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prasta/models/history_absen_model.dart';

class HistoryListItemCard extends StatelessWidget {
  final Datum history;

  const HistoryListItemCard({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final bool isIzin = history.status?.toLowerCase() == 'izin';
    final bool hasCheckOut = history.checkOutTime != null;

    final String statusText;
    final Color statusColor;
    final Color statusTextColor;

    if (isIzin) {
      statusText = "Izin";
      statusColor = Colors.blue.shade100;
      statusTextColor = Colors.blue.shade800;
    } else if (hasCheckOut) {
      statusText = "Selesai";
      statusColor = Colors.greenAccent;
      statusTextColor = Colors.green.shade800;
    } else {
      statusText = "Belum Out";
      statusColor = Colors.orangeAccent;
      statusTextColor = Colors.orange.shade800;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3D25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat(
                  'EEEE, dd MMM yyyy',
                  'id_ID',
                ).format(history.attendanceDate!),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tampilan kondisional: tampilkan alasan izin atau waktu check-in/out
          isIzin
              ? _buildIzinInfo(history.alasanIzin)
              : _buildAttendanceTimes(
                  history.checkInTime,
                  history.checkOutTime,
                ),
        ],
      ),
    );
  }

  Widget _buildIzinInfo(String? reason) {
    return Row(
      children: [
        Icon(
          Icons.description_outlined,
          color: Colors.white.withOpacity(0.7),
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            reason ?? 'Tidak ada keterangan',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTimes(String? checkIn, String? checkOut) {
    return Row(
      children: [
        Expanded(
          child: _buildTimeColumn("Check In", checkIn, Icons.login_rounded),
        ),
        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
        Expanded(
          child: _buildTimeColumn(
            "Check Out",
            checkOut,
            Icons.logout_rounded,
            isCheckOut: true,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeColumn(
    String title,
    String? time,
    IconData icon, {
    bool isCheckOut = false,
  }) {
    return Column(
      crossAxisAlignment: isCheckOut
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isCheckOut)
              Icon(icon, color: Colors.white.withOpacity(0.8), size: 16),
            if (!isCheckOut) const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isCheckOut) const SizedBox(width: 8),
            if (isCheckOut)
              Icon(icon, color: Colors.white.withOpacity(0.8), size: 16),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.only(
            left: isCheckOut ? 0 : 24,
            right: isCheckOut ? 24 : 0,
          ),
          child: Text(
            time ?? "--:--",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
