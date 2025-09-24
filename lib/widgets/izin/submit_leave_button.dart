// lib/widgets/leave_request/submit_leave_button.dart
import 'package:flutter/material.dart';

class SubmitLeaveButton extends StatelessWidget {
  final bool hasReason;
  final VoidCallback? onPressed;

  const SubmitLeaveButton({
    super.key,
    required this.hasReason,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF3E6B42);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasReason ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          disabledBackgroundColor: Colors.grey.shade700,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "Ajukan Izin",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
