// lib/views/dashboard_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:prasta/api/absen_service.dart';
import 'package:prasta/api/register_service.dart';
import 'package:prasta/models/get_user_model.dart';
import 'package:prasta/views/profile_screen.dart';
import 'package:prasta/widgets/bottom_nav.dart';
import 'package:prasta/widgets/dashboard/attendance_card.dart';
import 'package:prasta/widgets/dashboard/dashboard_header.dart';
import 'package:prasta/widgets/dashboard/loading_shimmer.dart';
import 'package:prasta/widgets/dashboard/quick_access_grid.dart';

class DashboardScreen extends StatefulWidget {
  static const id = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  late Future<GetUserModel> _profileFuture;
  Map<String, dynamic>? _absenTodayData;
  bool _isLoading = true;

  // Palet Warna
  final Color backgroundColor = const Color(0xFF0A1E0F);
  final Color surfaceColor = const Color(0xFF0D2818);
  final Color primaryColor = const Color(0xFF1B3D25);
  final Color accentColor = const Color(0xFF3E6B42);
  final Color gradientStart = const Color(0xFF0A1E0F);
  final Color gradientEnd = const Color(0xFF1B3D25);

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      _profileFuture = AuthenticationAPI.getProfile();
      await _absenToday();
      await _profileFuture; // Tunggu kedua proses selesai
    } catch (e) {
      debugPrint("Error loading dashboard data: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _absenToday() async {
    final response = await AbsenService.getAbsenToday();
    if (mounted) {
      setState(() {
        if (response != null && response.data != null) {
          _absenTodayData = {
            "status": response.data!.status ?? "On Progress",
            "check_in": response.data!.checkInTime ?? "--:--",
            "check_out": response.data!.checkOutTime ?? "--:--",
          };
        } else {
          _absenTodayData = {
            "status": "On Progress",
            "check_in": "--:--",
            "check_out": "--:--",
          };
        }
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildDashboardContent(),
      ProfilePage(onProfileUpdated: _loadDashboardData),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientStart, gradientEnd, backgroundColor],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: _isLoading
            ? DashboardLoadingShimmer(
                baseColor: primaryColor.withOpacity(0.3),
                highlightColor: accentColor.withOpacity(0.5),
                surfaceColor: surfaceColor,
              )
            : pages[_currentIndex],
      ),
      bottomNavigationBar: SlideInUp(
        duration: const Duration(milliseconds: 800),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [surfaceColor, primaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNav(
            currentIndex: _currentIndex,
            onTabItemSelected: _onTabTapped,
            primaryColor: accentColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadDashboardData,
        backgroundColor: primaryColor,
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: DashboardHeader(profileFuture: _profileFuture),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 200),
              child: AttendanceCard(absenTodayData: _absenTodayData),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 400),
              child: const Text(
                "Akses Cepat",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            QuickAccessGrid(onNavigate: _loadDashboardData),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "© 2025 PPKDJP and BIAN. All rights reserved.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
