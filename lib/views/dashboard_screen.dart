import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static const id = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Palet warna Prasta
  final Color primaryColor = const Color(0xFF347338);
  final Color secondaryColor = const Color(0xFFA5BF99);
  final Color darkColor = const Color(0xFF11261A);
  final Color whiteColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text(
          "Absensi Prasta",
          style: TextStyle(color: darkColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Icon(Icons.arrow_back, color: darkColor),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: darkColor),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, Fabian Syah!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Selamat datang kembali.",
              style: TextStyle(fontSize: 16, color: darkColor.withOpacity(0.7)),
            ),
            const SizedBox(height: 20),

            // Card Status Absen
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status Absen Hari Ini",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: darkColor,
                          ),
                        ),
                        Icon(Icons.check_circle, color: primaryColor),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          "Status: ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: darkColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Tepat Waktu",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Check In:",
                          style: TextStyle(fontSize: 14, color: darkColor),
                        ),
                        Text(
                          "08:00 WIB",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: darkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Check Out:",
                          style: TextStyle(fontSize: 14, color: darkColor),
                        ),
                        Text(
                          "Belum Absen",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Check In / Check Out
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      iconColor: const Color.fromARGB(255, 0, 0, 0),
                      backgroundColor: secondaryColor,
                      foregroundColor: darkColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.login),
                    label: const Text("Check In"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    icon: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(
                        3.1416,
                      ), // Membalikkan ikon 180 derajat
                      child: const Icon(Icons.logout),
                    ),
                    label: const Text(
                      "Check Out",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Card Waktu
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Waktu Berguna",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: darkColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Waktu Lokal:",
                          style: TextStyle(color: darkColor),
                        ),
                        Text(
                          "-- : -- : --",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: darkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Waktu Server:",
                          style: TextStyle(color: darkColor),
                        ),
                        Text(
                          "-- : -- : --",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: darkColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Absen",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Statistik",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
