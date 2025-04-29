// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// class LocationService {
//   // Function to get the current latitude and longitude
//   Future<Position?> getCurrentLocation(BuildContext context) async {
//     // Check if location services are enabled
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled, show a message to the user
//       _showLocationServiceDialog(context);
//       return null;
//     }

//     // Check for permission
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       // Request permission if not granted
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permission denied, handle the case here
//         print("Location permission denied.");
//         return null;
//       }
//     }

//     // Now get the current position
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     return position;
//   }

//   // Show a dialog asking the user to enable location services
//   void _showLocationServiceDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Location Services Disabled'),
//           content: Text(
//               'Location services are required to fetch your current location. Please enable them in your device settings.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
