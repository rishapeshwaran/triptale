import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMaps(double latitude, double longitude) async {
  final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch Google Maps';
  }
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  var p = 0.017453292519943295; // Pi/180 (to convert degrees to radians)
  var c = cos; // Cosine function

  // Haversine formula:
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km (Earth's radius)
}
