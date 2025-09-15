import 'package:flutter/material.dart';
import 'package:prasta/extension/navigation.dart';

class RegisterPage extends StatefulWidget {
  static const id = "/register";

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool agree = false;

  @override
  Widget build(BuildContext test) {
    return Scaffold(
      body: Stack(
        children: [
          // Background daun
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png", // ganti dengan file daun kamu
              fit: BoxFit.cover,
            ),
          ),

          // Konten utama
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),

                // Logo Prasta
                Center(
                  child: Image.asset(
                    "assets/images/logo_prasta_putih.png",
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 40),

                // Container putih melengkung
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white, // Putih dari palet
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      const Text(
                        "Bergabung dengan Prasta",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF347338), // Hijau utama
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Nama Lengkap
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Nama Lengkap",
                          hintStyle: const TextStyle(color: Color(0xFF11261A)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFA5BF99),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF347338),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Input Email
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Email Kantor",
                          hintStyle: const TextStyle(color: Color(0xFF11261A)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFA5BF99),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF347338),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Input Password
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Kata Sandi",
                          hintStyle: const TextStyle(color: Color(0xFF11261A)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFA5BF99),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF347338),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Checkbox syarat
                      Row(
                        children: [
                          Checkbox(
                            value: agree,
                            activeColor: const Color(0xFF347338), // Hijau utama
                            onChanged: (val) {
                              setState(() {
                                agree = val ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "Saya menyetujui Syarat & Ketentuan",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF11261A), // Hijau gelap
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tombol daftar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF347338,
                            ), // Hijau utama
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "DAFTAR SEKARANG",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Putih
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Sudah punya akun?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sudah punya akun? ",
                            style: TextStyle(color: Color(0xFF11261A)),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pop();
                              // Arahkan ke login page
                            },
                            child: const Text(
                              "Masuk di sini",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF347338), // Hijau utama
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
