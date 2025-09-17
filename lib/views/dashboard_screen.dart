import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prasta/api/register_service.dart';
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

  // Palet warna Prasta
  final Color primaryColor = const Color(0xFF347338);
  final Color secondaryColor = const Color(0xFFA5BF99);
  final Color darkColor = const Color(0xFF11261A);
  final Color whiteColor = Colors.white;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _locationFuture = _getCurrentLocation();
    _pages = [
      _buildBerandaPage(),
      StatistikPage(),
      GoogleMapsScreen(),
      ProfilePage(),
    ];
  }

  Widget _buildBerandaPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<GetUserModel>(
            future: AuthenticationAPI.getProfile(),
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
                  "Halo, $name!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkColor,
                  ),
                );
              }
            },
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

          // Map Section with FutureBuilder
          FutureBuilder(
            future: _locationFuture,
            builder: (context, snapshot) {
              return Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: secondaryColor, width: 1.5),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentPosition,
                            zoom: 15,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          mapType: MapType.hybrid,
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                          markers: _marker != null ? {_marker!} : {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _currentAddress,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _locationFuture = _getCurrentLocation();
                          });
                        },
                        child: Text("Get Current Location"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Tombol Check In / Check Out
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
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
                    transform: Matrix4.rotationY(3.1416),
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
                      Text("Waktu Lokal:", style: TextStyle(color: darkColor)),
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
                      Text("Waktu Server:", style: TextStyle(color: darkColor)),
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
    );
  }

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
      body: _pages[_currentIndex],
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
        _currentAddress = "Izin lokasi ditolak secara permanen";
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
