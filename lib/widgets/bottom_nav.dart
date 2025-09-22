import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabItemSelected;
  final Color primaryColor;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabItemSelected,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    // Dark Green Color Palette to match dashboard
    final Color darkGreenBackground = const Color(0xFF0D2818);
    final Color mediumDarkGreen = const Color(0xFF1B3D25);
    final Color lightDarkGreen = const Color(0xFF2D5233);
    final Color accentGreen = const Color(0xFF3E6B42);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [mediumDarkGreen, darkGreenBackground],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, -5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: MotionTabBar(
        initialSelectedTab: currentIndex == 0 ? "Beranda" : "Profil",
        labels: const ["Beranda", "Profil"],
        icons: const [Icons.home_rounded, Icons.person_rounded],
        tabSize: 55,
        tabBarHeight: 70,
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        tabIconColor: Colors.white.withOpacity(0.6), // Inactive icon color
        tabIconSelectedColor:
            Colors.white, // Active icon color (white for contrast)
        tabSelectedColor: accentGreen, // Selection background (solid color)
        tabIconSize: 28.0,
        tabBarColor: Colors.transparent, // Make transparent to show gradient
        onTabItemSelected: (int index) {
          onTabItemSelected(index);
        },
      ),
    );
  }
}
