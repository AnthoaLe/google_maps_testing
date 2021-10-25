import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _lJohnAirport = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(33.67635, -117.86739),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414
  );

  final Location _location = Location();
  late CameraPosition _kUser;

  @override
  Widget build(BuildContext context) {
    _location.getLocation().then((l) {
      _kUser = CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15);
    });
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kUser,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheJohnAirport,
        label: Text('To the airport!'),
        icon: Icon(Icons.flight),
      ),
    );
  }

  Future<void> _goToTheJohnAirport() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_lJohnAirport));
  }
}