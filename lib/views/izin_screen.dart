// lib/views/leave_request_page.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:prasta/api/absen_service.dart';
import 'package:prasta/models/izin_model.dart';
import 'package:prasta/widgets/izin/custom_reason_card.dart';
import 'package:prasta/widgets/izin/leave_app_bar.dart';
import 'package:prasta/widgets/izin/leave_date_card.dart';
import 'package:prasta/widgets/izin/leave_info_card.dart';
import 'package:prasta/widgets/izin/reason_selection_card.dart';
import 'package:prasta/widgets/izin/submit_leave_button.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  final TextEditingController _reasonController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isCheckingStatus = true;

  final List<String> _predefinedReasons = [
    'Sakit',
    'Keperluan Keluarga',
    'Acara Penting',
    'Keperluan Mendadak',
    'Check-up Kesehatan',
    'Urusan Administrasi',
  ];
  String? _selectedReason;

  final Color primaryColor = const Color(0xFF1B3D25);
  final Color accentColor = const Color(0xFF3E6B42);
  final Color backgroundColor = const Color(0xFF0A1E0F);
  final Color surfaceColor = const Color(0xFF0D2818);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkInitialStatus());
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _checkInitialStatus() async {
    try {
      final todayAttendance = await AbsenService.getAbsenToday();
      if (mounted && todayAttendance?.data?.checkInTime != null) {
        await _showAlreadyAttendedDialog();
        Navigator.of(context).pop();
      } else {
        setState(() => _isCheckingStatus = false);
      }
    } catch (e) {
      setState(() => _isCheckingStatus = false);
      _showSnackbar("Gagal memeriksa status: ${e.toString()}", isError: true);
    }
  }

  Future<void> _submitLeaveRequest() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;
    final reason = _selectedReason ?? _reasonController.text.trim();
    if (reason.isEmpty) {
      _showSnackbar("Silakan pilih atau tulis alasan izin", isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final IzinModel? result = await AbsenService.submitIzin(alasan: reason);
      if (mounted && result != null) {
        await _showSuccessDialog(result);
      } else {
        _showSnackbar("Gagal mengajukan izin.", isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackbar(
          "Error: ${e.toString().replaceAll('Exception: ', '')}",
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _selectPredefinedReason(String reason) {
    setState(() {
      _selectedReason = reason;
      _reasonController.clear();
      FocusScope.of(context).unfocus(); // Tutup keyboard
    });
  }

  void _clearPredefinedReason() {
    setState(() => _selectedReason = null);
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
            colors: [backgroundColor, primaryColor],
          ),
        ),
        child: _isCheckingStatus
            ? Center(child: CircularProgressIndicator(color: accentColor))
            : Stack(
                children: [
                  _buildMainContent(),
                  if (_isLoading) _buildLoadingOverlay(),
                ],
              ),
      ),
    );
  }

  Widget _buildMainContent() {
    bool hasReason =
        _selectedReason != null || _reasonController.text.trim().isNotEmpty;

    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          children: [
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: const LeaveAppBar(),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const LeaveDateCard(),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: ReasonSelectionCard(
                reasons: _predefinedReasons,
                selectedReason: _selectedReason,
                onReasonSelected: _selectPredefinedReason,
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: CustomReasonCard(
                controller: _reasonController,
                selectedReason: _selectedReason,
                onClearSelection: _clearPredefinedReason,
                onTextChanged: () => setState(() {}), // <-- TAMBAHKAN BARIS INI
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: const LeaveInfoCard(),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: SubmitLeaveButton(
                hasReason: hasReason,
                onPressed: _submitLeaveRequest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods (Dialogs, Snackbar, Overlay) ---

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                "Mengajukan izin...",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Future<void> _showAlreadyAttendedDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/error.json', width: 120, height: 120),
              const SizedBox(height: 16),
              const Text(
                "Sudah Melakukan Absensi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Anda tidak dapat mengajukan izin karena sudah melakukan check-in hari ini.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Kembali",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog(IzinModel result) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final dateText = DateFormat(
          'dd MMMM yyyy',
          'id_ID',
        ).format(DateTime.now());
        return Dialog(
          backgroundColor: surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.greenAccent,
                  size: 60,
                ),
                const SizedBox(height: 20),
                Text(
                  result.message ?? "Izin Berhasil Diajukan",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Tanggal: $dateText\nAlasan: ${result.data?.alasanIzin ?? ''}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
