import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/map/set_location_bloc.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/screens/food/home_page.dart';
import 'package:narrid/dashboard/screens/grocery/home_page.dart';
import 'package:narrid/dashboard/screens/narrid_app.dart';

var section;

class SetLocation extends StatelessWidget {
  final address;
  final lat;
  final lng;
  final city;
  final s;
  SetLocation({
    Key key,
    @required this.address,
    @required this.lat,
    @required this.lng,
    @required this.city,
    @required this.s,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    section = s;
    return Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text(
            "Set Location",
            style: TextStyle(color: Colors.grey[800]),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocProvider(
          create: (context) =>
              SetLocationBloc(locationRespos: LocationRespos()),
          child: Column(
            children: [
              buildBikeImage(),
              buildSetLocation(context),
            ],
          ),
        ));
  }

  Expanded buildSetLocation(context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Icon(
            Icons.location_pin,
            color: Colors.yellow,
            size: 50,
          ),
          Text(
            "Your Delivery address",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            address.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 17,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BlocBuilder<SetLocationBloc, SetLocationState>(
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.black,
                          ),
                        ),
                        onPressed: () {
                          BlocProvider.of<SetLocationBloc>(context)
                            ..add(Pin(
                              address: address,
                              lat: lat,
                              lng: lng,
                              city: city,
                            ));
                          if (section == 'food') {
                            Route route =
                                MaterialPageRoute(builder: (context) => Food());
                            Navigator.pushReplacement(context, route);
                          } else if (section == 'grocery') {
                            Route route = MaterialPageRoute(
                                builder: (context) => Grocery());
                            Navigator.pushReplacement(context, route);
                          } else if (section == 'store') {
                            Route route = MaterialPageRoute(
                                builder: (context) => NarridApp());
                            Navigator.pushReplacement(context, route);
                          } else {
                            Route route = MaterialPageRoute(
                                builder: (context) => NarridApp());
                            Navigator.pushReplacement(context, route);
                          }
                        },
                        child: Text(
                          "Set Location",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Expanded buildBikeImage() {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bike_man.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
