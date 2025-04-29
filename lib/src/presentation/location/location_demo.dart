// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// import '../../services/location_service.dart';

// class LocationScreen extends StatefulWidget {
//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<LocationScreen> {
//   String _locationMessage = "";
// 
//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }

//   // Function to get the location and update the UI
//   _getLocation() async {
//     LocationService locationService = LocationService();
//     Position? position = await locationService.getCurrentLocation(context);

//     if (position != null) {
//       setState(() {
//         _locationMessage =
//             "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
//       });
//     } else {
//       setState(() {
//         _locationMessage = "Could not get location";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Get Latitude and Longitude'),
//       ),
//       body: Center(
//         child: Text(
//           _locationMessage,
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
