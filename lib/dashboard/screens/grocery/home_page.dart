import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/location/location_auth_bloc.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/screens/map/init.dart';

import 'grocery_app.dart';

class Grocery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LocationAuthBloc(locationRespos: LocationRespos())..add(Started()),
      child: Scaffold(
        body: BlocBuilder<LocationAuthBloc, LocationAuthState>(
          builder: (context, state) {
            if (state is Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is Unauthenticated) {
              return InitMap(
                section: "grocery",
              );
            } else if (state is Authenticated) {
              Map<String, dynamic> location = state.getLocation;
              return GroceryApp(location: location);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
