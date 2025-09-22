// lib/api/absen_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // <-- Tambahkan import ini untuk format tanggal
import 'package:prasta/api/endpoint/endpoint.dart';
import 'package:prasta/models/absen_checkin_model.dart';
import 'package:prasta/models/absen_checkout_model.dart';
import 'package:prasta/models/absen_stats_model.dart';
import 'package:prasta/models/absen_today_model.dart';
import 'package:prasta/shared_preferenced/preferenced.dart';

class AbsenService {
  /// Absen Check In
  static Future<AbsenCheckIn?> checkIn({
    required double checkInLat,
    required double checkInLng,
    required String checkInLocation,
    required String checkInAddress,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();

      final now = DateTime.now();
      // Menggunakan intl untuk format yang lebih konsisten
      final attendanceDate = DateFormat('yyyy-MM-dd').format(now);
      final checkInTime = DateFormat('HH:mm').format(now);

      final response = await http.post(
        Uri.parse(Endpoint.checkIn),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "attendance_date": attendanceDate,
          "check_in": checkInTime,
          "check_in_lat": checkInLat.toString(),
          "check_in_lng": checkInLng.toString(),
          "check_in_location": checkInLocation,
          "check_in_address": checkInAddress,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return AbsenCheckIn.fromJson(jsonResponse);
      } else {
        print("CheckIn Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error CheckIn: $e");
      return null;
    }
  }

  /// Absen Check Out
  static Future<AbsenCheckOut?> checkOut({
    required double checkOutLat,
    required double checkOutLng,
    required String checkOutLocation,
    required String checkOutAddress,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();

      final now = DateTime.now();
      final attendanceDate = DateFormat('yyyy-MM-dd').format(now);
      final checkOutTime = DateFormat('HH:mm').format(now);

      final response = await http.post(
        Uri.parse(Endpoint.checkOut),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "attendance_date": attendanceDate,
          "check_out": checkOutTime,
          "check_out_lat": checkOutLat.toString(),
          "check_out_lng": checkOutLng.toString(),
          "check_out_location": checkOutLocation,
          "check_out_address": checkOutAddress,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return AbsenCheckOut.fromJson(jsonResponse);
      } else {
        print("CheckOut Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error CheckOut: $e");
      return null;
    }
  }

  /// Absen Today
  static Future<AbsenToday?> getAbsenToday() async {
    try {
      final token = await PreferenceHandler.getToken();
      final now = DateTime.now();
      final attendanceDate = DateFormat('yyyy-MM-dd').format(now);

      final response = await http.get(
        Uri.parse("${Endpoint.absenToday}?attendance_date=$attendanceDate"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return AbsenToday.fromJson(jsonDecode(response.body));
      } else {
        print("Get Absen Today Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error Get Absen Today: $e");
      return null;
    }
  }

  // ===== BAGIAN YANG DIPERBARUI =====
  /// Absen Stats with Date Range
  static Future<AbsenStatsModel?> getAbsenStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();

      // 1. Format tanggal sesuai kebutuhan API (yyyy-MM-dd)
      final String formattedStartDate = DateFormat(
        'yyyy-MM-dd',
      ).format(startDate);
      final String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

      // 2. Bangun URL lengkap dengan parameter query start dan end
      final url = Uri.parse(
        "${Endpoint.absenStats}?start=$formattedStartDate&end=$formattedEndDate",
      );

      final response = await http.get(
        url, // Gunakan URL yang sudah dibangun
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return AbsenStatsModel.fromJson(jsonResponse);
      } else {
        print("Get Absen Stats Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error Get Absen Stats: $e");
      return null;
    }
  }

  // ===== AKHIR BAGIAN YANG DIPERBARUI =====
}
