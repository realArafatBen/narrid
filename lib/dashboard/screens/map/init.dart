import 'package:flutter/material.dart';
import 'package:narrid/dashboard/screens/map/narrd-map.dart';

class InitMap extends StatefulWidget {
  final section;
  InitMap({@required this.section});
  @override
  _InitMapState createState() => _InitMapState(section: section);
}

class _InitMapState extends State<InitMap> {
  final section;
  _InitMapState({@required this.section});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          // Use a Builder to get a context within the Scaffold.
          body: Column(
            children: [
              buildBikeImage(),
              buildSetLocation(context),
            ],
          ),
        ),
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
            "Pick your delivery address",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Column(
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
                      Route route = MaterialPageRoute(
                          builder: (context) => NarridMap(
                                s: section,
                              ));
                      Navigator.pushReplacement(context, route);
                    },
                    child: Text(
                      "Pick your delivery address",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
