import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:narrid/dashboard/screens/map/set_location.dart';
import 'package:search_map_place/search_map_place.dart';

var _lat;
var _lng;
var _address;
var _city;
LatLng _geolocation;

class DeliveryAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: AddressMap(),
        ),
      ),
    );
  }
}

class AddressMap extends StatefulWidget {
  @override
  _AddressMapState createState() => _AddressMapState();
}

class _AddressMapState extends State<AddressMap> {
  GoogleMapController _controller;
  List<Marker> marker = [];
  @override
  void initState() {
    _geolocation = LatLng(9.0765, 7.3986);
    marker.add(Marker(
      markerId: MarkerId("Location"),
      draggable: false,
      onTap: () {
        print("Marker Tapped");
      },
      position: _geolocation,
    ));
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
          markers: Set.from(marker),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: double.infinity,
            child: SearchMapPlaceWidget(
              placeholder: "Enter your address",
              placeType: PlaceType.address,
              hasClearButton: true,
              apiKey: "AIzaSyBIgZP9pMhvjCCen9THQLMGG3vOxKoEldA",
              onSelected: (Place place) async {
                _fetchPlace(place);
              },
              onSearch: (Place place) async {
                _fetchPlace(place);
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchPlace(place) async {
    Geolocation geolocation = await place.geolocation;
    var fulljson = geolocation.fullJSON;
    _address = fulljson['formatted_address'];
    _lat = fulljson['geometry']['location']['lat'];
    _lng = fulljson['geometry']['location']['lng'];
    _city = fulljson['address_components'][1]['short_name'];
    _controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
    _controller
        .animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
    //the list
    marker.clear();
    setState(() {
      marker.add(Marker(
        markerId: MarkerId("Location"),
        draggable: false,
        onTap: () {
          print("Marker Tapped");
        },
        position: geolocation.coordinates,
      ));
    });

    await Future.delayed(const Duration(seconds: 5));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SetLocation(
                  address: _address,
                  lat: _lat,
                  lng: _lng,
                  city: _city,
                  s: "grocery",
                )));
  }
}
