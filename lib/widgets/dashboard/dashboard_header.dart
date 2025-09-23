// lib/widgets/dashboard/dashboard_header.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:prasta/models/get_user_model.dart';
import 'package:prasta/widgets/dashboard/live_clock_widget.dart';

class DashboardHeader extends StatelessWidget {
  final Future<GetUserModel> profileFuture;

  const DashboardHeader({super.key, required this.profileFuture});

  @override
  Widget build(BuildContext context) {
    // Palet Warna Lokal
    const Color surfaceColor = Color(0xFF0D2818);
    const Color primaryColor = Color(0xFF1B3D25);
    const Color primaryLight = Color(0xFF2D5233);
    const Color accentColor = Color(0xFF3E6B42);

    return FutureBuilder<GetUserModel>(
      future: profileFuture,
      builder: (context, snapshot) {
        final userData = snapshot.data?.data;
        final name = userData?.name ?? "User";
        final imageUrl = userData?.profilePhotoUrl;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                surfaceColor.withOpacity(0.8),
                primaryColor.withOpacity(0.6),
              ],
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
            children: [
              ZoomIn(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [accentColor, primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                        ? NetworkImage(imageUrl)
                        : null,
                    child: (imageUrl == null || imageUrl.isEmpty)
                        ? const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FadeInRight(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang,",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              FadeInLeft(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 400),
                child: const LiveClockWidget(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
