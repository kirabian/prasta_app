// lib/widgets/dashboard/quick_access_grid.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:prasta/views/izin_screen.dart';
import 'package:prasta/views/map_check.dart';
import 'package:prasta/views/riwayat_screen.dart';
import 'package:prasta/views/statistik_screen.dart';

class QuickAccessGrid extends StatelessWidget {
  final VoidCallback onNavigate;

  const QuickAccessGrid({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final quickAccessItems = [
      {
        'title': 'Absensi',
        'icon': Icons.location_on_rounded,
        'gradient': [const Color(0xFF1B3D25), const Color(0xFF2D5233)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MapCheckInPage()),
          ).then((value) {
            if (value == true) onNavigate();
          });
        },
      },
      {
        'title': 'Izin',
        'icon': Icons.description_rounded,
        'gradient': [const Color(0xFF0D2818), const Color(0xFF1B3D25)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LeaveRequestPage()),
          ).then((success) {
            if (success == true) {
              // Refresh dashboard data
              onNavigate();
            }
          });
          // Navigasi ke Halaman Izin
        },
      },
      {
        'title': 'Riwayat',
        'icon': Icons.history_rounded,
        'gradient': [const Color(0xFF1B3D25), const Color(0xFF3E6B42)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AttendanceHistoryPage()),
          );
        },
      },
      {
        'title': 'Statistik',
        'icon': Icons.bar_chart_rounded,
        'gradient': [const Color(0xFF2D5233), const Color(0xFF3E6B42)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AttendanceStatsPage()),
          );
        },
      },
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.25,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quickAccessItems.length,
      itemBuilder: (context, index) {
        final item = quickAccessItems[index];
        return _buildQuickAccessCard(
          item['title'] as String,
          item['icon'] as IconData,
          item['gradient'] as List<Color>,
          item['onTap'] as VoidCallback,
          index,
        );
      },
    );
  }

  Widget _buildQuickAccessCard(
    String title,
    IconData icon,
    List<Color> gradientColors,
    VoidCallback onTap,
    int index,
  ) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: Duration(milliseconds: 600 + (index * 150)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
