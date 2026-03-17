import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Data model representing a single parking spot.
class ParkingSpot {
  final String name;
  final String distance;
  final String walkingTime;
  final double latitude;
  final double longitude;

  const ParkingSpot({
    required this.name,
    required this.distance,
    required this.walkingTime,
    required this.latitude,
    required this.longitude,
  });
}

/// Page displaying parking spots near the school.
///
/// Each entry shows:
/// - The name of the parking spot
/// - Walking distance from school
/// - Estimated walking time
/// - A button to open Google Maps directions
///
/// To add more parking spots, simply add a new [ParkingSpot] entry
/// to the [_parkingSpots] list below.
class ParkingPlanPage extends StatelessWidget {
  const ParkingPlanPage({super.key});

  /// List of parking spots near BK Witten.
  /// Add new [ParkingSpot] entries here to extend the list.
  static const List<ParkingSpot> _parkingSpots = [
    ParkingSpot(
      name: 'Parkplatz bei der Feuerwehr',
      distance: '1 km',
      walkingTime: '15 min',
      latitude: 51.4367,
      longitude: 7.3355,
    ),
    ParkingSpot(
      name: 'Parkplatz auf der Backstrasse',
      distance: '0,3 km',
      walkingTime: '5 min',
      latitude: 51.4408,
      longitude: 7.3372,
    ),
  ];

  /// Opens Google Maps with walking directions to the given coordinates.
  /// Shows a [SnackBar] if the URL cannot be launched.
  Future<void> _openGoogleMaps(
      BuildContext context, double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=walking',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Maps konnte nicht geöffnet werden.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parkplätze')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _parkingSpots.length,
        itemBuilder: (context, index) {
          final spot = _parkingSpots[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_parking,
                          size: 28, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          spot.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.directions_walk,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text('${spot.distance} – ca. ${spot.walkingTime} zu Fuß'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _openGoogleMaps(context, spot.latitude, spot.longitude),
                      icon: const Icon(Icons.map),
                      label: const Text('In Google Maps öffnen'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
