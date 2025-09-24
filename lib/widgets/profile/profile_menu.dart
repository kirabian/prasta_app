// lib/widgets/profile/profile_menu.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: const Row(
          children: [
            SizedBox(width: 48), // Spacer
            Expanded(
              child: Center(
                child: Text(
                  "Profil Saya",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 48), // Spacer to balance
          ],
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onAboutApp;
  final VoidCallback onHelpCenter;

  const ProfileMenu({
    super.key,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onAboutApp,
    required this.onHelpCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("PENGATURAN AKUN", 300),
        _buildMenuBlock(
          delay: 400,
          children: [
            _buildMenuTile(
              icon: Icons.person_outline_rounded,
              title: "Edit Profil",
              onTap: onEditProfile,
              isFirst: true,
            ),
            // _buildMenuTile(
            //   icon: Icons.lock_outline_rounded,
            //   title: "Ubah Password",
            //   onTap: onChangePassword,
            //   isLast: true,
            // ),
          ],
        ),
        const SizedBox(height: 30),
        _buildSectionHeader("BANTUAN & INFORMASI", 500),
        _buildMenuBlock(
          delay: 600,
          children: [
            _buildMenuTile(
              icon: Icons.info_outline_rounded,
              title: "Tentang Aplikasi",
              onTap: onAboutApp,
              isFirst: true,
            ),
            // _buildMenuTile(
            //   icon: Icons.help_outline_rounded,
            //   title: "Pusat Bantuan",
            //   onTap: onHelpCenter,
            //   isLast: true,
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int delay) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: Duration(milliseconds: delay),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBlock({required List<Widget> children, required int delay}) {
    const Color surfaceColor = Color(0xFF0D2818);
    const Color cardColor = Color(0xFF1B3D25);

    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: Duration(milliseconds: delay),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [surfaceColor.withOpacity(0.8), cardColor.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.6),
                    size: 16,
                  ),
                ],
              ),
            ),
            if (!isLast)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  height: 1,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
