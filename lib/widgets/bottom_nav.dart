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
    return MotionTabBar(
      initialSelectedTab: currentIndex == 0 ? "Beranda" : "Profil",
      labels: const ["Beranda", "Profil"],
      icons: const [Icons.home, Icons.person],
      tabSize: 55,
      tabBarHeight: 60,
      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      tabIconColor: Colors.grey,
      tabIconSelectedColor: primaryColor,
      tabSelectedColor: primaryColor.withOpacity(0.15),
      tabIconSize: 28.0,
      tabBarColor: Colors.white,
      onTabItemSelected: (int index) {
        onTabItemSelected(index);
      },
    );
  }
}
