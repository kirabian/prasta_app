import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prasta/api/absen_service.dart';
import 'package:prasta/api/register_service.dart';
import 'package:prasta/models/absen_checkin_model.dart';
import 'package:prasta/models/absen_checkout_model.dart';
import 'package:prasta/models/get_user_model.dart';
import 'package:prasta/views/profile_screen.dart';
import 'package:prasta/views/statistik_screen.dart';
import 'package:prasta/views/test.dart';
import 'package:prasta/widgets/bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  static const id = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(-6.200000, 106.816666);
  String _currentAddress = "Mendapatkan lokasi...";
  Marker? _marker;
  int _currentIndex = 0;
  late Future<void> _locationFuture;
  late Future<GetUserModel> _profileFuture;
  String _localTime = "--:--:--";

  Map<String, dynamic>? _absenTodayData;

  // Palet warna
  final Color primaryColor = const Color(0xFF347338);
  final Color secondaryColor = const Color(0xFFA5BF99);
  final Color darkColor = const Color(0xFF11261A);
  final Color whiteColor = Colors.white;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _locationFuture = _getCurrentLocation();
    _profileFuture = AuthenticationAPI.getProfile(); // simpan future profile
    _startClock();
    _absenToday();
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

      String address = "Alamat tidak ditemukan";
      String locationName = "Lokasi Tidak Diketahui";
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        locationName = place.locality ?? "Lokasi Tidak Diketahui";
      }

      AbsenCheckOut? result = await AbsenService.checkOut(
        checkOutLat: position.latitude,
        checkOutLng: position.longitude,
        checkOutLocation: locationName,
        checkOutAddress: address,
      );

      if (!mounted) return;

      if (result != null) {
        await _absenToday(); // refresh data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Check-out berhasil: ${result.message}")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Check-out gagal")));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
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

      String address = "Alamat tidak ditemukan";
      String locationName = "Lokasi Tidak Diketahui";
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        locationName = place.locality ?? "Lokasi Tidak Diketahui";
      }

      AbsenCheckIn? result = await AbsenService.checkIn(
        checkInLat: position.latitude,
        checkInLng: position.longitude,
        checkInLocation: locationName,
        checkInAddress: address,
      );

      if (!mounted) return;

      if (result != null) {
        await _absenToday(); // refresh data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Check-in berhasil: ${result.message}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Anda sudah melakukan absen hari ini")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _absenToday() async {
    final response = await AbsenService.getAbsenToday();
    if (response != null && response.data != null) {
      setState(() {
        _absenTodayData = {
          "status": response.data!.status ?? "Belum Absen",
          "check_in": response.data!.checkInTime ?? "-",
          "check_out": response.data!.checkOutTime ?? "Belum Absen",
        };
      });
    } else {
      setState(() {
        _absenTodayData = {
          "status": "Belum Absen",
          "check_in": "-",
          "check_out": "Belum Absen",
        };
      });
    }
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildBerandaPage() {
    final checkIn = _absenTodayData?['check_in'] ?? "-";
    final checkOut = _absenTodayData?['check_out'] ?? "Belum Absen";
    final status = _absenTodayData?['status'] ?? "Belum Absen";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<GetUserModel>(
            future: _profileFuture, // pake future dari initState
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data?.data == null) {
                return const Text("Halo, Pengguna!");
              } else {
                final name = snapshot.data!.data!.name ?? "Pengguna";
                return Text(
                  "Halo, $name 👋",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkColor,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 6),
          Text(
            "Selamat datang kembali di Prasta!",
            style: TextStyle(fontSize: 16, color: darkColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 20),

          // Status Absen
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
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
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Check In:", style: TextStyle(color: darkColor)),
                      Text(
                        checkIn,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Check Out:", style: TextStyle(color: darkColor)),
                      Text(
                        checkOut,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: checkOut == "Belum Absen"
                              ? Colors.red
                              : darkColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Google Map
          FutureBuilder(
            future: _locationFuture,
            builder: (context, snapshot) {
              return Container(
                height: 320,
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: secondaryColor, width: 1.5),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentPosition,
                            zoom: 15,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                          markers: _marker != null ? {_marker!} : {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _currentAddress,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: darkColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _locationFuture = _getCurrentLocation();
                          });
                        },
                        icon: const Icon(Icons.my_location),
                        label: const Text("Refresh Lokasi"),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Tombol
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: darkColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _absenCheckIn,
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
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _absenCheckOut,
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.1416),
                    child: const Icon(Icons.logout),
                  ),
                  label: const Text("Check Out"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Time
          _buildTimeCard(),
        ],
      ),
    );
  }

  Widget _buildTimeCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
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
                Text("Waktu Lokal:", style: TextStyle(color: darkColor)),
                Text(
                  _localTime,
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
              children: const [
                Text(
                  "Waktu Server:",
                  style: TextStyle(color: Color(0xFF11261A)),
                ),
                Text(
                  "-- : -- : --",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF11261A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildBerandaPage(),
      StatistikPage(),
      GoogleMapsScreen(),
      ProfilePage(),
    ];

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkColor),
          onPressed: () async {
            await AuthenticationAPI.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: darkColor),
            onPressed: () {},
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        primaryColor: primaryColor,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _currentAddress = "Mendapatkan lokasi...";
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = "Layanan lokasi tidak aktif";
      });
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _currentAddress = "Izin lokasi ditolak";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentAddress = "Izin lokasi ditolak permanen";
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        setState(() {
          _marker = Marker(
            markerId: MarkerId("lokasi_saya"),
            position: _currentPosition,
            infoWindow: InfoWindow(
              title: 'Lokasi Anda',
              snippet: "${place.street}, ${place.locality}",
            ),
          );

          _currentAddress =
              "${place.name}, ${place.street}, ${place.locality}, ${place.country}";

          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _currentPosition, zoom: 16),
            ),
          );
        });
      } else {
        setState(() {
          _currentAddress = "Alamat tidak ditemukan";
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Gagal mendapatkan lokasi: $e";
      });
    }
  }
}
