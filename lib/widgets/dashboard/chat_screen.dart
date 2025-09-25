// lib/views/chat_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// GANTI DENGAN API KEY GROQ ANDA
const String groqApiKey =
    "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";

const String apiUrl = "https://api.groq.com/openai/v1/chat/completions";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // Palet Warna Sesuai Tema
  final Color backgroundColor = const Color(0xFF0A1E0F);
  final Color appBarColor = const Color(0xFF1B3D25);
  final Color userBubbleColor = const Color(0xFF3E6B42);
  final Color botBubbleColor = const Color(0xFF0D2818);
  final Color accentColor = const Color(0xFF3E6B42);
  final Color surfaceColor = const Color(0xFF0D2818);

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final userMessage = _textController.text;
    _textController.clear();

    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _isLoading = true;
    });

    try {
      List<Map<String, String>> historyForApi = [
        {
          "role": "system",
          "content":
              "Kamu adalah 'Prasta', asisten virtual untuk aplikasi absensi PPKD. "
              "Jawab pertanyaan dengan ramah, profesional, dan relevan dengan topik pelatihan dan karir. "
              "Tolak dengan sopan untuk menjawab topik di luar itu.",
        },
        ..._messages,
      ];

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Authorization': 'Bearer $groqApiKey',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              "messages": historyForApi,
              // --- PERUBAHAN DI SINI ---
              "model":
                  "llama-3.3-70b-versatile", // Menggunakan model Mixtral yang aktif
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final String botMessage =
            data['choices'][0]['message']['content'] ??
            "Maaf, saya tidak mengerti.";

        setState(() {
          _messages.add({'role': 'assistant', 'content': botMessage});
        });
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage =
            errorBody['error']?['message'] ?? "Terjadi error dari server.";
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': "Gagal memproses: $errorMessage",
          });
        });
      }
    } catch (e) {
      debugPrint("Error saat menghubungi API: $e");
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content':
              "Gagal terhubung. Pastikan API Key valid & koneksi internet ada.",
        });
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Asisten AI Prasta",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isUser = message['role'] == 'user';
                if (message['role'] == 'system') return const SizedBox.shrink();

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? userBubbleColor : botBubbleColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SelectableText(
                      message['content']!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: appBarColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Ketik pesanmu di sini...",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  filled: true,
                  fillColor: surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (value) => _isLoading ? null : _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _isLoading ? null : _sendMessage,
              style: IconButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
