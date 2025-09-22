import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
// Ganti dengan path project Anda yang benar
import 'package:prasta/api/absen_service.dart';
import 'package:prasta/models/absen_checkin_model.dart';
import 'package:prasta/models/absen_checkout_model.dart';
import 'package:prasta/widgets/quotes.dart';
import 'package:shimmer/shimmer.dart';

// ===== SUCCESS QUOTE DIALOG =====
class SuccessQuoteDialog extends StatefulWidget {
  final String title;
  final Map<String, String> quote;
  final Color primaryColor;
  final Color darkTextColor;
  final Color lightTextColor;

  const SuccessQuoteDialog({
    super.key,
    required this.title,
    required this.quote,
    required this.primaryColor,
    required this.darkTextColor,
    required this.lightTextColor,
  });

  @override
  State<SuccessQuoteDialog> createState() => _SuccessQuoteDialogState();
}

class _SuccessQuoteDialogState extends State<SuccessQuoteDialog> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 800),
      child: AlertDialog(
        backgroundColor: const Color(0xFF1B3D25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    '"${widget.quote['content']}"',
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 60),
                    textStyle: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
                isRepeatingAnimation: false,
                displayFullTextOnTap: true,
              ),
              const SizedBox(height: 16),
              Text(
                '- ${widget.quote['author']}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapCheckInPage extends StatefulWidget {
  const MapCheckInPage({super.key});

  @override
  State<MapCheckInPage> createState() => _MapCheckInPageState();
}

class _MapCheckInPageState extends State<MapCheckInPage> {
  // State Management
  bool _isLoading = true;
  Map<String, dynamic>? _absenTodayData;
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(-6.200000, 106.816666);
  Marker? _marker;
  String _currentAddress = "Mendapatkan lokasi...";

  // Dark Green Color Palette matching Dashboard
  final Color primaryDark = const Color(0xFF0D2818);
  final Color primaryColor = const Color(0xFF1B3D25);
  final Color primaryLight = const Color(0xFF2D5233);
  final Color accentColor = const Color(0xFF3E6B42);
  final Color backgroundColor = const Color(0xFF0A1E0F);
  final Color surfaceColor = const Color(0xFF0D2818);
  final Color cardColor = const Color(0xFF1B3D25);

  @override
  void initState() {
    super.initState();
    _getInitialData();
  }

  Future<void> _getInitialData() async {
    try {
      await _getCurrentLocation();
      await _absenToday();
    } catch (e) {
      if (mounted) _showSnackbar("Gagal memuat data: $e", isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted)
        setState(() => _currentAddress = "Layanan lokasi tidak aktif.");
      throw Exception('Layanan lokasi tidak aktif.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _currentAddress = "Izin lokasi ditolak.");
      throw Exception('Izin lokasi ditolak.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (mounted) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _marker = Marker(
          markerId: const MarkerId("current_location"),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: "Lokasi Anda Saat Ini"),
        );
        _currentAddress = placemarks.isNotEmpty
            ? "${placemarks.first.street}, ${placemarks.first.locality}"
            : "Alamat tidak ditemukan.";
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 16),
      );
    }
  }

  Future<void> _absenToday() async {
    final response = await AbsenService.getAbsenToday();
    if (mounted) {
      setState(() {
        if (response != null && response.data != null) {
          _absenTodayData = {
            "check_in": response.data!.checkInTime,
            "check_out": response.data!.checkOutTime,
          };
        } else {
          _absenTodayData = {"check_in": null, "check_out": null};
        }
      });
    }
  }

  Future<void> _showSuccessDialog(
    String title,
    Map<String, String> quote,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessQuoteDialog(
          title: title,
          quote: quote,
          primaryColor: primaryColor,
          darkTextColor: Colors.white,
          lightTextColor: Colors.white.withOpacity(0.8),
        );
      },
    );
  }

  Future<void> _checkIn() async {
    setState(() => _isLoading = true);
    try {
      AbsenCheckIn? result = await AbsenService.checkIn(
        checkInLat: _currentPosition.latitude,
        checkInLng: _currentPosition.longitude,
        checkInLocation:
            (await placemarkFromCoordinates(
              _currentPosition.latitude,
              _currentPosition.longitude,
            )).first.locality ??
            "Lokasi Tidak Diketahui",
        checkInAddress: _currentAddress,
      );

      if (!mounted) return;

      if (result != null) {
        final quote = getRandomQuote();
        await _showSuccessDialog("Check-in Berhasil!", quote);
      } else {
        _showSnackbar("Anda sudah check-in hari ini.", isError: true);
      }
    } catch (e) {
      _showSnackbar("Error saat check-in: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _checkOut() async {
    setState(() => _isLoading = true);
    try {
      AbsenCheckOut? result = await AbsenService.checkOut(
        checkOutLat: _currentPosition.latitude,
        checkOutLng: _currentPosition.longitude,
        checkOutLocation:
            (await placemarkFromCoordinates(
              _currentPosition.latitude,
              _currentPosition.longitude,
            )).first.locality ??
            "Lokasi Tidak Diketahui",
        checkOutAddress: _currentAddress,
      );

      if (!mounted) return;

      if (result != null) {
        final quote = getRandomQuote();
        await _showSuccessDialog("Check-out Berhasil!", quote);
      } else {
        _showSnackbar("Gagal melakukan check-out.", isError: true);
      }
    } catch (e) {
      _showSnackbar("Error saat check-out: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: isError ? Colors.red.shade600 : accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryDark, primaryColor, backgroundColor],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: _isLoading ? _buildLoadingShimmer() : _buildPageContent(),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: primaryColor.withOpacity(0.3),
      highlightColor: accentColor.withOpacity(0.5),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            FadeInUp(
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    return SafeArea(
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 100,
            ),
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 100),
                child: _buildCustomAppBar(),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 200),
                child: _buildDateTimeCard(),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 300),
                child: _buildMapCard(),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 400),
                child: _buildLocationInfoCard(),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 500),
                child: _buildRemindersCard(),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 600),
              child: _buildActionButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Lokasi Absensi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surfaceColor.withOpacity(0.8), cardColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Perhatikan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.2),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildReminderRow(
            Icons.location_on_rounded,
            "Pastikan Anda berada di lokasi yang benar.",
          ),
          _buildReminderRow(
            Icons.phone_android_rounded,
            "Pastikan GPS dan koneksi internet Anda aktif.",
          ),
          _buildReminderRow(
            Icons.error_outline_rounded,
            "Segera laporkan jika terjadi kendala absensi.",
          ),
        ],
      ),
    );
  }

  Widget _buildReminderRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryLight, accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Waktu Saat Ini",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  DateFormat('HH:mm:ss').format(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surfaceColor.withOpacity(0.8), cardColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 16,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: _marker != null ? {_marker!} : {},
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surfaceColor.withOpacity(0.8), cardColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Lokasi Anda Terdeteksi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentAddress,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final bool hasCheckedIn = _absenTodayData?['check_in'] != null;
    final bool hasCheckedOut = _absenTodayData?['check_out'] != null;

    if (!hasCheckedIn) {
      return _actionButton(
        label: "Check In Sekarang",
        icon: Icons.login_rounded,
        gradientColors: [primaryColor, accentColor],
        onPressed: _checkIn,
      );
    } else if (hasCheckedIn && !hasCheckedOut) {
      return _actionButton(
        label: "Check Out Sekarang",
        icon: Icons.logout_rounded,
        gradientColors: [Colors.amber.shade700, Colors.orange.shade600],
        onPressed: _checkOut,
      );
    } else {
      return _actionButton(
        label: "Absensi Hari Ini Selesai",
        icon: Icons.check_circle_rounded,
        gradientColors: [Colors.grey.shade600, Colors.grey.shade700],
        onPressed: null,
      );
    }
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
