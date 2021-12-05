import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/dashboard/bloc/grocery/location/location_auth_bloc.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/screens/food/home_page.dart';
import 'package:narrid/dashboard/screens/grocery/home_page.dart';
import 'package:narrid/dashboard/screens/logistices/home_page.dart';
import 'package:narrid/dashboard/screens/narrid_app.dart';

class CustomLogisticsAppBar extends StatelessWidget {
  final scaffoldKey;
  CustomLogisticsAppBar({@required this.scaffoldKey});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LocationAuthBloc(locationRespos: LocationRespos())..add(Started()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buidTopSection(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  scaffoldKey.currentState.openDrawer();
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Icon(
                    Icons.menu,
                    size: 30,
                  ),
                ),
              ),
              buildLogo(),
              Container(
                margin: const EdgeInsets.only(
                  left: 5,
                ),
                child: Text(
                  "Delivery Service",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buidTopSection(context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NarridApp()));
            },
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('eaeaea'),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "narrid",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Food()));
            },
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('eaeaea'),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Food",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Grocery()));
            },
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('eaeaea'),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Grocery",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Logistics()));
            },
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('f1df00'),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Delivery Services",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildLogo() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/logistics.png",
          ),
        ),
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
    );
  }
}
