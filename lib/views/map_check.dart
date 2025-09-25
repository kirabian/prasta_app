// lib/views/map_check_in_page.dart

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prasta/api/absen_service.dart';
import 'package:prasta/models/absen_checkin_model.dart';
import 'package:prasta/models/absen_checkout_model.dart';
import 'package:prasta/widgets/map_check/action_button_section.dart';
import 'package:prasta/widgets/map_check/date_time_card.dart';
import 'package:prasta/widgets/map_check/location_info_card.dart';
import 'package:prasta/widgets/map_check/map_app_bar.dart';
import 'package:prasta/widgets/map_check/map_card.dart';
import 'package:prasta/widgets/map_check/map_loading_shimmer.dart';
import 'package:prasta/widgets/map_check/reminders_card.dart';
import 'package:prasta/widgets/map_check/success_dialog.dart';
import 'package:prasta/widgets/quotes.dart';

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
  LatLng _currentPosition = const LatLng(
    -6.200000,
    106.816666,
  ); // Default Jakarta
  Marker? _marker;
  String _currentAddress = "Mendapatkan lokasi...";

  // Palet Warna
  final Color backgroundColor = const Color(0xFF0A1E0F);
  final Color accentColor = const Color(0xFF3E6B42);

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
      if (mounted)
        _showSnackbar("Gagal memuat data: ${e.toString()}", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    // ... Logika untuk mendapatkan lokasi tetap sama ...
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Layanan lokasi tidak aktif.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
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

  // --- FUNGSI DIPERBARUI UNTUK MENYIMPAN STATUS ---
  Future<void> _absenToday() async {
    final response = await AbsenService.getAbsenToday();
    if (mounted) {
      setState(() {
        if (response != null && response.data != null) {
          _absenTodayData = {
            "status": response.data!.status, // Simpan status
            "check_in": response.data!.checkInTime,
            "check_out": response.data!.checkOutTime,
          };
        } else {
          _absenTodayData = {
            "status": null,
            "check_in": null,
            "check_out": null,
          };
        }
      });
    }
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
        await _showSuccessDialog("Check-in Berhasil!", getRandomQuote());
      } else {
        _showSnackbar("Anda sudah check-in hari ini.", isError: true);
      }
    } catch (e) {
      _showSnackbar("Error saat check-in: ${e.toString()}", isError: true);
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
        await _showSuccessDialog("Check-out Berhasil!", getRandomQuote());
      } else {
        _showSnackbar("Gagal melakukan check-out.", isError: true);
      }
    } catch (e) {
      _showSnackbar("Error saat check-out: ${e.toString()}", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper methods untuk UI
  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red.shade600 : accentColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showSuccessDialog(
    String title,
    Map<String, String> quote,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          SuccessQuoteDialog(title: title, quote: quote),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _isLoading ? const MapLoadingShimmer() : _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          children: [
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: MapAppBar(onBackPressed: () => Navigator.pop(context)),
            ),
            const SizedBox(height: 24),
            FadeInUp(delay: Duration(milliseconds: 200), child: DateTimeCard()),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: MapCard(
                currentPosition: _currentPosition,
                marker: _marker,
                onMapCreated: (controller) => _mapController = controller,
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: LocationInfoCard(currentAddress: _currentAddress),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: Duration(milliseconds: 500),
              child: RemindersCard(),
            ),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: ActionButtonSection(
              absenTodayData: _absenTodayData,
              isLoading: _isLoading,
              onCheckIn: _checkIn,
              onCheckOut: _checkOut,
            ),
          ),
        ),
      ],
    );
  }
}
