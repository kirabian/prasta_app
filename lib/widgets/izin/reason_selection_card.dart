// lib/widgets/leave_request/reason_selection_card.dart
import 'package:flutter/material.dart';

class ReasonSelectionCard extends StatelessWidget {
  final List<String> reasons;
  final String? selectedReason;
  final ValueChanged<String> onReasonSelected;

  const ReasonSelectionCard({
    super.key,
    required this.reasons,
    required this.selectedReason,
    required this.onReasonSelected,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFF1B3D25);
    const Color accentColor = Color(0xFF3E6B42);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pilih Alasan Izin",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: reasons.map((reason) {
              final isSelected = selectedReason == reason;
              return GestureDetector(
                onTap: () => onReasonSelected(reason),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? accentColor : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    reason,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
