// lib/views/camera_screen.dart

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class InstagramCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const InstagramCameraScreen({super.key, required this.cameras});

  @override
  State<InstagramCameraScreen> createState() => _InstagramCameraScreenState();
}

class _InstagramCameraScreenState extends State<InstagramCameraScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  bool _isRearCameraSelected = true;
  bool _isFlashOn = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentFilterIndex = 0;

  final List<String> _filterNames = [
    'Normal',
    'Hitam Putih',
    'Sepia',
    'Vintage',
    'Sejuk',
    'Hangat',
  ];
  final List<ColorFilter> _filters = [
    const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
    const ColorFilter.matrix(<double>[
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    const ColorFilter.matrix(<double>[
      0.393,
      0.769,
      0.189,
      0,
      0,
      0.349,
      0.686,
      0.168,
      0,
      0,
      0.272,
      0.534,
      0.131,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    const ColorFilter.matrix(<double>[
      0.9,
      0.5,
      0.1,
      0,
      0,
      0.3,
      0.8,
      0.1,
      0,
      0,
      0.2,
      0.3,
      0.5,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    const ColorFilter.matrix(<double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1.2,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    const ColorFilter.matrix(<double>[
      1.2,
      0,
      0,
      0,
      0,
      0,
      1.1,
      0,
      0,
      0,
      0,
      0,
      0.8,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(_animationController);
    _initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final camera = widget.cameras[_isRearCameraSelected ? 0 : 1];
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  void _switchCamera() async {
    if (_controller != null) {
      await _controller!.dispose();
      _isRearCameraSelected = !_isRearCameraSelected;
      await _initCamera();
    }
  }

  void _toggleFlash() async {
    if (_controller != null) {
      _isFlashOn = !_isFlashOn;
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    _animationController.forward().then((_) => _animationController.reverse());
    try {
      final XFile capturedImage = await _controller!.takePicture();
      File imageFile = File(capturedImage.path);

      if (_currentFilterIndex != 0) {
        final imageBytes = await imageFile.readAsBytes();
        img.Image? originalImage = img.decodeImage(imageBytes);
        if (originalImage != null) {
          img.Image processedImage;
          switch (_currentFilterIndex) {
            case 1:
              processedImage = img.grayscale(originalImage);
              break;
            case 2:
              processedImage = img.sepia(originalImage);
              break;
            default:
              processedImage = originalImage;
              break;
          }
          await imageFile.writeAsBytes(img.encodeJpg(processedImage));
        }
      }
      if (mounted) Navigator.pop(context, imageFile);
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  void _changeFilter() => setState(
    () => _currentFilterIndex = (_currentFilterIndex + 1) % _filters.length,
  );

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.previewSize!.height,
              height: _controller!.value.previewSize!.width,
              child: ColorFiltered(
                colorFilter: _filters[_currentFilterIndex],
                child: CameraPreview(_controller!),
              ),
            ),
          ),
          _buildTopControls(),
          _buildFilterName(),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildTopControls() => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(Icons.close, () => Navigator.pop(context)),
          _buildIconButton(
            _isFlashOn ? Icons.flash_on : Icons.flash_off,
            _toggleFlash,
            color: _isFlashOn ? Colors.yellow : Colors.white,
          ),
        ],
      ),
    ),
  );

  Widget _buildFilterName() => Positioned(
    top: 100,
    left: 0,
    right: 0,
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _filterNames[_currentFilterIndex],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

  Widget _buildBottomControls() => Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(Icons.tune, _changeFilter, size: 28),
          _buildCaptureButton(),
          _buildIconButton(Icons.flip_camera_ios, _switchCamera, size: 28),
        ],
      ),
    ),
  );

  Widget _buildIconButton(
    IconData icon,
    VoidCallback onPressed, {
    double size = 24,
    Color color = Colors.white,
  }) => GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Icon(icon, color: color, size: size),
    ),
  );

  Widget _buildCaptureButton() => GestureDetector(
    onTap: _takePicture,
    child: AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            color: Colors.white.withOpacity(0.3),
          ),
          child: const Icon(Icons.camera, color: Colors.white, size: 32),
        ),
      ),
    ),
  );
}
