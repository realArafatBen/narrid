import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/dashboard/bloc/grocery/location/location_auth_bloc.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/screens/food/home_page.dart';
import 'package:narrid/dashboard/screens/grocery/home_page.dart';
import 'package:narrid/dashboard/screens/logistices/home_page.dart';
import 'package:narrid/dashboard/screens/map/init.dart';
import 'package:narrid/dashboard/screens/store/search-view.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LocationAuthBloc(locationRespos: LocationRespos())..add(Started()),
      child: Column(
        children: [
          buidTopSection(context),
          Row(
            children: [
              buildLogo(),
              buildSearchField(context),
            ],
          ),
          buildLocation(),
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
            onTap: () {},
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

  Widget buildLocation() {
    return BlocBuilder<LocationAuthBloc, LocationAuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          Map<String, dynamic> data = state.getLocation;
          return Container(
            padding: EdgeInsets.only(
              left: 10,
              top: 2,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InitMap(
                              section: "store",
                            )));
              },
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey[700],
                  ),
                  Text(
                    "Deliver to - ",
                  ),
                  Flexible(
                    child: AutoSizeText(
                      data['address'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FaIcon(
                    FontAwesomeIcons.chevronCircleRight,
                    size: 16,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          );
        } else if (state is Unauthenticated) {
          return Container();
        } else if (state is Loading) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Expanded buildSearchField(BuildContext context) {
    return Expanded(
      flex: 9,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchView()));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "What are u looking for?",
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Icon(
                  Icons.search,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded buildLogo() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Image.asset('assets/images/logo-black.png', width: 30.0),
            AutoSizeText(
              "Narrid",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.0,
                color: Colors.grey[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
