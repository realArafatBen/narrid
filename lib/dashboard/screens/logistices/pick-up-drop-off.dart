import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:narrid/dashboard/models/logistices/directions_model.dart';
import 'package:narrid/dashboard/repositories/logistices/direction_repos.dart';
import 'package:narrid/dashboard/screens/logistices/book.dart';
import 'package:search_map_place/search_map_place.dart';

double _origin_lat = 0;
double _origin_lng = 0;
String _origin_address = "";

double _destination_lat = 0;
double _destination_lng = 0;
String _destination_address = "";

String _duration = "";
String _distance = "";

//value
String _durationvalue = "";
String _distancevalue = "";

LatLng _geolocation;

class PickUpDropOff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: MapView(),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(16.0),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.red,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))),
              onPressed: () {
                if (_origin_address == "" && _destination_address == "") {
                  //do nothing
                } else {
                  Route route = MaterialPageRoute(
                      builder: (context) => Book(
                            origin_lat: _origin_lat,
                            origin_lng: _origin_lng,
                            origin_address: _origin_address,
                            destination_lat: _destination_lat,
                            destination_lng: _destination_lng,
                            destination_address: _destination_address,
                            distance: _distance,
                            duration: _duration,
                            distancevalue: _distancevalue,
                            durationvalue: _durationvalue,
                          ));
                  Navigator.push(context, route);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController _controller;

  Marker _origin;
  Marker _destination;
  Directions _info;

  @override
  void initState() {
    _origin_lat = 0;
    _origin_lng = 0;
    _origin_address = "";

    _destination_lat = 0;
    _destination_lng = 0;
    _destination_address = "";
    _geolocation = LatLng(9.0765, 7.3986);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            zoom: 15,
            target: _geolocation,
          ),
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              _controller = controller;
            });
          },
          markers: {
            if (_origin != null) _origin,
            if (_destination != null) _destination
          },
          polylines: {
            if (_info != null)
              Polyline(
                polylineId: PolylineId("overview_polyline"),
                color: Colors.red,
                width: 5,
                points: _info.polylinePoints
                    .map((e) => LatLng(e.latitude, e.longitude))
                    .toList(),
              )
          },
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: SearchMapPlaceWidget(
                  placeholder: "Enter your pick address",
                  placeType: PlaceType.address,
                  hasClearButton: true,
                  apiKey: "AIzaSyBIgZP9pMhvjCCen9THQLMGG3vOxKoEldA",
                  onSelected: (Place place) async {
                    _fetchPlaceOrigin(place);
                  },
                  onSearch: (Place place) async {
                    _fetchPlaceOrigin(place);
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: SizedBox(
                width: double.infinity,
                child: SearchMapPlaceWidget(
                  placeholder: "Enter your destination",
                  placeType: PlaceType.address,
                  hasClearButton: true,
                  apiKey: "AIzaSyBIgZP9pMhvjCCen9THQLMGG3vOxKoEldA",
                  onSelected: (Place place) async {
                    _fetchPlaceDestination(place);
                  },
                  onSearch: (Place place) async {
                    _fetchPlaceDestination(place);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _fetchPlaceOrigin(place) async {
    Geolocation geolocation = await place.geolocation;
    var fulljson = geolocation.fullJSON;
    _origin_address = fulljson['formatted_address'];
    _origin_lat = fulljson['geometry']['location']['lat'];
    _origin_lng = fulljson['geometry']['location']['lng'];
    _controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
    _controller
        .animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));

    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: MarkerId("Location"),
          draggable: false,
          infoWindow: const InfoWindow(title: "Origin"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () {
            print("Marker Tapped");
          },
          position: geolocation.coordinates,
        );
        //reset destination
        _destination = null;
        //reset info
        _info = null;
      });
    }
  }

  Future<void> _fetchPlaceDestination(place) async {
    Geolocation geolocation = await place.geolocation;
    var fulljson = geolocation.fullJSON;
    _destination_address = fulljson['formatted_address'];
    _destination_lat = fulljson['geometry']['location']['lat'];
    _destination_lng = fulljson['geometry']['location']['lng'];
    _controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
    _controller
        .animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
    if (_origin == null || (_origin != null && _destination != null)) {
    } else {
      setState(() {
        _destination = Marker(
          markerId: MarkerId("Location"),
          draggable: false,
          infoWindow: const InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            print("Marker Tapped");
          },
          position: geolocation.coordinates,
        );
      });
    }

    //get direction
    final directions = await DirectionRepository().getDirections(
        origin: LatLng(_origin_lat, _origin_lng),
        destination: LatLng(_destination_lat, _destination_lng));
    setState(() {
      _info = directions;
    });
    _duration = _info.totalDuration;
    _distance = _info.totalDirections;
    //value
    _durationvalue = _info.durationValue;
    _distancevalue = _info.directionValue;
  }
}
