// lib/widgets/history/history_loading_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HistoryLoadingShimmer extends StatelessWidget {
  const HistoryLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B3D25);
    const Color accentColor = Color(0xFF3E6B42);
    const Color surfaceColor = Color(0xFF0D2818);

    return Shimmer.fromColors(
      baseColor: primaryColor.withOpacity(0.3),
      highlightColor: accentColor.withOpacity(0.5),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
