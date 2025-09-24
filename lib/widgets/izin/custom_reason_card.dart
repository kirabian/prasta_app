// lib/widgets/leave_request/custom_reason_card.dart
import 'package:flutter/material.dart';

class CustomReasonCard extends StatelessWidget {
  final TextEditingController controller;
  final String? selectedReason;
  final VoidCallback onClearSelection;
  final VoidCallback onTextChanged; // <-- TAMBAHKAN CALLBACK BARU INI

  const CustomReasonCard({
    super.key,
    required this.controller,
    required this.selectedReason,
    required this.onClearSelection,
    required this.onTextChanged, // <-- TAMBAHKAN DI CONSTRUCTOR
  });

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFF1B3D25);
    const Color accentColor = Color(0xFF3E6B42);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Atau Tulis Alasan Lain",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: controller,
            maxLines: 4,
            enabled: selectedReason == null,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: selectedReason == null
                  ? "Jelaskan alasan Anda..."
                  : "Alasan sudah dipilih dari daftar",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: accentColor),
              ),
            ),
            // --- PERUBAHAN UTAMA DI SINI ---
            onChanged: (value) {
              onTextChanged(); // Panggil callback setiap kali teks berubah
              if (value.isNotEmpty && selectedReason != null) {
                onClearSelection();
              }
            },
            // --- AKHIR PERUBAHAN ---
          ),
        ],
      ),
    );
  }
}
