import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prasta/api/absen_service.dart';
import 'package:prasta/api/register_service.dart';
import 'package:prasta/extension/navigation.dart';
import 'package:prasta/models/absen_checkin_model.dart';
import 'package:prasta/models/absen_checkout_model.dart';
import 'package:prasta/models/get_user_model.dart';
import 'package:prasta/views/profile_screen.dart';
import 'package:prasta/views/statistik_screen.dart';
import 'package:prasta/views/test.dart';
import 'package:prasta/views/testing_dua.dart';

class TestDashBoard extends StatefulWidget {
  static const id = '/dashboard';
  const TestDashBoard({super.key});

  @override
  State<TestDashBoard> createState() => _TestDashBoardState();
}

class _TestDashBoardState extends State<TestDashBoard> {
  final int _currentIndex = 0;
  late Future<GetUserModel> _profileFuture;
  String _localTime = "--:--:--";
  Map<String, dynamic>? _absenTodayData;

  Timer? _timer;

  // Palet warna
  final Color primaryColor = const Color(0xFF347338);
  final Color secondaryColor = const Color(0xFFA5BF99);
  final Color darkColor = const Color(0xFF11261A);
  final Color whiteColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _profileFuture = AuthenticationAPI.getProfile();
    _startClock();
    _absenToday();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      setState(() {
        _localTime =
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
      });
    });
  }

  Future<void> _absenToday() async {
    final response = await AbsenService.getAbsenToday();
    if (response != null && response.data != null) {
      setState(() {
        _absenTodayData = {
          "status": response.data!.status ?? "Belum Absen",
          "check_in": response.data!.checkInTime ?? "--:--",
          "check_out": response.data!.checkOutTime ?? "--:--",
        };
      });
    } else {
      setState(() {
        _absenTodayData = {
          "status": "Belum Absen",
          "check_in": "--:--",
          "check_out": "--:--",
        };
      });
    }
  }

  Future<void> _absenCheckIn() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}"
          : "Alamat tidak ditemukan";

      AbsenCheckIn? result = await AbsenService.checkIn(
        checkInLat: position.latitude,
        checkInLng: position.longitude,
        checkInLocation: placemarks.first.locality ?? "Lokasi Tidak Diketahui",
        checkInAddress: address,
      );

      if (!mounted) return;
      if (result != null) {
        await _absenToday();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Check-in berhasil: ${result.message}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Anda sudah absen hari ini")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _absenCheckOut() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}"
          : "Alamat tidak ditemukan";

      AbsenCheckOut? result = await AbsenService.checkOut(
        checkOutLat: position.latitude,
        checkOutLng: position.longitude,
        checkOutLocation: placemarks.first.locality ?? "Lokasi Tidak Diketahui",
        checkOutAddress: address,
      );

      if (!mounted) return;
      if (result != null) {
        await _absenToday();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Check-out berhasil: ${result.message}")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Check-out gagal")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget _buildDashboardPage() {
    final checkIn = _absenTodayData?['check_in'] ?? "--:--";
    final checkOut = _absenTodayData?['check_out'] ?? "--:--";
    final status = _absenTodayData?['status'] ?? "Belum Absen";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salam
          FutureBuilder<GetUserModel>(
            future: _profileFuture,
            builder: (context, snapshot) {
              final name = snapshot.data?.data?.name ?? "Pengguna";
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Selamat Datang,", style: TextStyle(fontSize: 18)),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  Text(
                    "${DateTime.now().toLocal()}".split(" ")[0],
                    style: TextStyle(color: darkColor.withOpacity(0.6)),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Card Status Absen
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status Absensi Hari Ini",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: status == "Belum Absen"
                              ? Colors.amber
                              : primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text("Check In"),
                          Text(
                            checkIn,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Check Out"),
                          Text(
                            checkOut,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: checkOut == "--:--"
                                  ? Colors.red
                                  : darkColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tombol Check In / Out
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // hijau
                    foregroundColor: Colors.white, // teks putih
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.push(MapCheckInPage());
                  },
                  icon: const Icon(Icons.login),
                  label: const Text("Check In"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300], // abu terang
                    foregroundColor: Colors.black87, // teks hitam
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _absenCheckOut,
                  icon: const Icon(Icons.logout),
                  label: const Text("Check Out"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          Text(
            "Akses Cepat",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildQuickAccess("Izin", Icons.note_add),
              _buildQuickAccess("Absen Today", Icons.today),
              _buildQuickAccess("Statistik", Icons.bar_chart),
              _buildQuickAccess("Profil", Icons.person),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess(String title, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: primaryColor, size: 32),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildDashboardPage(),
      StatistikPage(),
      GoogleMapsScreen(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: whiteColor,
        centerTitle: true,
      ),
      body: pages[_currentIndex],
      // bottomNavigationBar: BottomNav(
      //   currentIndex: _currentIndex,
      //   onTap: (i) => setState(() => _currentIndex = i),
      //   primaryColor: primaryColor,
      // ),
    );
  }
}
