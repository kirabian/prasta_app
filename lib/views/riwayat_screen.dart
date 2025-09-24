// lib/views/riwayat_screen.dart (Ganti dari AttendanceHistoryPage)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:prasta/api/absen_service.dart';
import 'package:prasta/models/history_absen_model.dart';
import 'package:prasta/widgets/history/history_app_bar.dart';
import 'package:prasta/widgets/history/history_list.dart';
import 'package:prasta/widgets/history/history_loading_shimmer.dart';
import 'package:prasta/widgets/history/history_summary_card.dart';
import 'package:printing/printing.dart';

class AttendanceHistoryPage extends StatefulWidget {
  static const id = '/history';
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  bool _isLoading = true;
  List<Datum> _historyList = [];
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  final Color backgroundColor = const Color(0xFF0A1E0F);
  final Color primaryColor = const Color(0xFF1B3D25);
  final Color surfaceColor = const Color(0xFF0D2818);
  final Color accentColor = const Color(0xFF3E6B42);

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final response = await AbsenService.getAbsenHistory(
        startDate: _startDate,
        endDate: _endDate,
      );
      if (mounted && response?.data != null) {
        setState(() => _historyList = response!.data!);
      }
    } catch (e) {
      if (mounted) _showSnackbar("Gagal memuat riwayat: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: accentColor,
            onPrimary: Colors.white,
            surface: surfaceColor,
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      await _loadHistory();
    }
  }

  Future<void> _exportToPDF() async {
    // ... Logika export PDF tidak berubah
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Riwayat Absensi',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(DateFormat('dd MMM yyyy').format(DateTime.now())),
                ],
              ),
            ),
            pw.Text(
              'Periode: ${DateFormat('dd MMM yyyy').format(_startDate)} - ${DateFormat('dd MMM yyyy').format(_endDate)}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: [
                'Tanggal',
                'Check In',
                'Check Out',
                'Status',
                'Keterangan',
              ],
              data: _historyList.map((history) {
                final status = history.status?.toLowerCase() == 'izin'
                    ? 'Izin'
                    : (history.checkOutTime != null ? 'Hadir' : 'Belum Out');
                return [
                  DateFormat('dd/MM/yy').format(history.attendanceDate!),
                  history.checkInTime ?? '-',
                  history.checkOutTime ?? '-',
                  status,
                  history.alasanIzin ?? '-',
                ];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
                4: pw.Alignment.centerLeft,
              },
            ),
          ];
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundColor, primaryColor],
            ),
          ),
          child: _isLoading
              ? const HistoryLoadingShimmer()
              : _buildHistoryContent(),
        ),
      ),
    );
  }

  Widget _buildHistoryContent() {
    return RefreshIndicator(
      onRefresh: _loadHistory,
      backgroundColor: surfaceColor,
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        children: [
          HistoryAppBar(
            onBackPressed: () => Navigator.pop(context),
            isExportEnabled: _historyList.isNotEmpty,
            onExportPressed: _exportToPDF,
            onDateFilterPressed: _showDateRangePicker,
          ),
          const SizedBox(height: 24),
          HistorySummaryCard(historyList: _historyList),
          const SizedBox(height: 24),
          HistoryList(historyList: _historyList),
        ],
      ),
    );
  }
}
