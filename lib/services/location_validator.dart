import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';

class LocationValidator {
  final double geofenceLatitude;
  final double geofenceLongitude;
  final double geofenceRadius; // in meters

  LocationValidator({
    required this.geofenceLatitude,
    required this.geofenceLongitude,
    required this.geofenceRadius,
  });

  // Haversine formula to calculate distance between two lat/lon points
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // Earth radius in meters
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c; // Distance in meters
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  // Method to determine current position
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Method to check if user is within the geofence
  Future<bool> isWithinGeofence() async {
    try {
      Position position = await _getCurrentPosition();
      print("latitude is ${position.latitude}");
      print("latitude is ${position.longitude}");
      double distance = _calculateDistance(
        geofenceLatitude,
        geofenceLongitude,
        position.latitude,
        position.longitude,
      );
      print(distance);
      return distance <= geofenceRadius;
    } catch (e) {
      throw Exception('Error checking geofence: $e');
    }
  }
}
