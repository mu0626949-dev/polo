import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';



void main() => runApp(App());


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng origin = LatLng(41.2995, 69.2401); // Toshkent
  LatLng destination = LatLng(39.767968, 64.421725); // Samarqand
  LatLng pdp = LatLng(41.323913, 69.2418894); // pdp
  LatLng maktab = LatLng(41.38443, 69.22004); // maktab
  List<LatLng> polylineCoordinates = [];
  String googleAPIKey = "AIzaSyDZzYCJ9AoKIZM3ZKX-vP-Ga--SQHlqdi8"; // API keyi sho'tga qo'yasila

  @override
  void initState() {
    super.initState();
    getPolyline();
  }

  Future<void> getPolyline() async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleAPIKey";

    var response = await http.get(Uri.parse(url));
    var jsonData = json.decode(response.body);

    if (jsonData["status"] == "OK") {
      List<PointLatLng> points = PolylinePoints.decodePolyline(
        jsonData["routes"][0]["overview_polyline"]["points"],
      );

      setState(() {
        polylineCoordinates = points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      });
    } else {
      print("Xatolik: ${jsonData["status"]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps Route")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: origin, zoom: 5),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: {
          Marker(markerId: MarkerId("origin"), position: origin),
          Marker(markerId: MarkerId("destination"), position: destination),
          Marker(markerId: MarkerId("pdp"), position: pdp),
          Marker(markerId: MarkerId("maktab"), position: maktab),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        },
      ),
    );
  }
}
