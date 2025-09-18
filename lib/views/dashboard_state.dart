import 'package:flutter/material.dart';

class StatusAbsenCard extends StatelessWidget {
  final Map<String, dynamic>? absenTodayData;

  const StatusAbsenCard({super.key, required this.absenTodayData});

  @override
  Widget build(BuildContext context) {
    final checkIn = absenTodayData?['check_in'] ?? "-";
    final checkOut = absenTodayData?['check_out'] ?? "Belum Absen";
    final status = absenTodayData?['status'] ?? "Belum Absen";

    // Palet warna
    const Color primaryColor = Color(0xFF347338);
    const Color darkColor = Color(0xFF11261A);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status Absen Hari Ini",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darkColor,
                  ),
                ),
                Icon(Icons.check_circle, color: primaryColor),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  "Status: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: darkColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Check In:", style: TextStyle(color: darkColor)),
                Text(
                  checkIn,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Check Out:", style: TextStyle(color: darkColor)),
                Text(
                  checkOut,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: checkOut == "Belum Absen" ? Colors.red : darkColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
