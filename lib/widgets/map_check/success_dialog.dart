// lib/widgets/map_check_in/success_dialog.dart

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SuccessQuoteDialog extends StatefulWidget {
  final String title;
  final Map<String, String> quote;

  const SuccessQuoteDialog({
    super.key,
    required this.title,
    required this.quote,
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
        Navigator.of(context).pop(); // Close the dialog
        Navigator.of(context).pop(true); // Pop the page with success result
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
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 28),
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
        content: Column(
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
            ),
            const SizedBox(height: 16),
            Text(
              '- ${widget.quote['author']}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
