import 'package:flutter/material.dart';

class WaktuCard extends StatelessWidget {
  final String localTime;

  const WaktuCard({super.key, required this.localTime});

  @override
  Widget build(BuildContext context) {
    // Palet warna
    const Color darkColor = Color(0xFF11261A);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Waktu Berguna",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: darkColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Waktu Lokal:", style: TextStyle(color: darkColor)),
                Text(
                  localTime,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Waktu Server:",
                  style: TextStyle(color: Color(0xFF11261A)),
                ),
                Text(
                  "-- : -- : --",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF11261A),
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
