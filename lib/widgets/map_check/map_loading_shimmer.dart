// lib/widgets/map_check_in/map_loading_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MapLoadingShimmer extends StatelessWidget {
  const MapLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B3D25);
    const Color accentColor = Color(0xFF3E6B42);
    const Color surfaceColor = Color(0xFF0D2818);

    return Shimmer.fromColors(
      baseColor: primaryColor.withOpacity(0.3),
      highlightColor: accentColor.withOpacity(0.5),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
