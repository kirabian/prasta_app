// lib/views/profile_page.dart

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prasta/api/register_service.dart';
import 'package:prasta/auth/login.dart';
import 'package:prasta/models/get_user_model.dart';
import 'package:prasta/views/about_app_screen.dart';
import 'package:prasta/views/camera_screen.dart';
import 'package:prasta/views/edit_profile_screen.dart';
import 'package:prasta/widgets/profile/image_source_dialog.dart';
import 'package:prasta/widgets/profile/logout_button.dart';
import 'package:prasta/widgets/profile/profile_header.dart';
import 'package:prasta/widgets/profile/profile_menu.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onProfileUpdated;

  const ProfilePage({super.key, required this.onProfileUpdated});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<GetUserModel> futureProfile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  List<CameraDescription>? _cameras;

  // Palet Warna
  final Color primaryColor = const Color(0xFF1B3D25);
  final Color accentColor = const Color(0xFF3E6B42);
  final Color backgroundColor = const Color(0xFF0A1E0F);

  @override
  void initState() {
    super.initState();
    futureProfile = AuthenticationAPI.getProfile();
    _initCameras();
  }

  Future<void> _initCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint('Error getting cameras: $e');
    }
  }

  Future<void> _showImageSourceDialog() async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ImageSourceDialog(
          onCameraPressed: () {
            Navigator.of(context).pop();
            _pickImageFromCamera();
          },
          onGalleryPressed: () {
            Navigator.of(context).pop();
            _pickImageFromGallery();
          },
        );
      },
    );
  }

  Future<void> _pickImageFromCamera() async {
    if (_cameras == null || _cameras!.isEmpty) {
      _showSnackbar("Kamera tidak tersedia", isError: true);
      return;
    }
    try {
      final File? imageFile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InstagramCameraScreen(cameras: _cameras!),
        ),
      );
      if (imageFile != null) {
        await _cropImage(XFile(imageFile.path));
      }
    } catch (e) {
      _showSnackbar("Gagal mengambil foto: $e", isError: true);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) await _cropImage(pickedFile);
    } catch (e) {
      _showSnackbar("Gagal memilih gambar: $e", isError: true);
    }
  }

  Future<void> _cropImage(XFile imageFile) async {
    setState(() => _isLoading = true);
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Foto Profil',
            toolbarColor: primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Foto Profil',
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (croppedFile != null) {
        await _uploadCroppedImage(File(croppedFile.path));
      }
    } catch (e) {
      _showSnackbar("Gagal crop gambar: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadCroppedImage(File croppedFile) async {
    setState(() => _isLoading = true);
    try {
      await AuthenticationAPI.updateFoto(imageFile: croppedFile);
      setState(() {
        futureProfile = AuthenticationAPI.getProfile();
      });
      widget.onProfileUpdated();
      if (mounted) _showSnackbar("Foto profil berhasil diperbarui");
    } catch (e) {
      _showSnackbar("Gagal update foto: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  Future<void> _logout() async {
    await AuthenticationAPI.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPage.id,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          FutureBuilder<GetUserModel>(
            future: futureProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !_isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data?.data == null) {
                return const Center(
                  child: Text(
                    "Data tidak ditemukan",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              final user = snapshot.data!.data!;
              return _buildProfileContent(user);
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(Data user) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const ProfileAppBar(),
          const SizedBox(height: 30),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: ProfileHeader(
              user: user,
              onEditPhoto: _showImageSourceDialog,
            ),
          ),
          const SizedBox(height: 40),
          ProfileMenu(
            onEditProfile: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(user: user),
                ),
              );
              if (result == true && mounted) {
                setState(() {
                  futureProfile = AuthenticationAPI.getProfile();
                });
                widget.onProfileUpdated();
              }
            },
            onChangePassword: () => _showSnackbar("Fitur ini belum tersedia."),
            onAboutApp: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutAppPage()),
            ),
            onHelpCenter: () => _showSnackbar("Fitur ini belum tersedia."),
          ),
          const SizedBox(height: 40),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 700),
            child: LogoutButton(onLogout: _logout),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
