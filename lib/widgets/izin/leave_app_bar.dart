// lib/widgets/leave_request/leave_app_bar.dart
import 'package:flutter/material.dart';

class LeaveAppBar extends StatelessWidget {
  const LeaveAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    const Color surfaceColor = Color(0xFF0D2818);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          style: IconButton.styleFrom(backgroundColor: surfaceColor),
        ),
        const Text(
          "Pengajuan Izin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.assignment_rounded, color: Colors.white),
          style: IconButton.styleFrom(backgroundColor: surfaceColor),
        ),
      ],
    );
  }
}
