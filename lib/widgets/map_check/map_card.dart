// lib/widgets/map_check_in/map_card.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCard extends StatelessWidget {
  final LatLng currentPosition;
  final Marker? marker;
  final void Function(GoogleMapController) onMapCreated;

  const MapCard({
    super.key,
    required this.currentPosition,
    required this.marker,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    const Color surfaceColor = Color(0xFF0D2818);
    const Color cardColor = Color(0xFF1B3D25);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surfaceColor.withOpacity(0.8), cardColor.withOpacity(0.6)],
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentPosition,
              zoom: 16,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: marker != null ? {marker!} : {},
            onMapCreated: onMapCreated,
          ),
        ),
      ),
    );
  }
}
