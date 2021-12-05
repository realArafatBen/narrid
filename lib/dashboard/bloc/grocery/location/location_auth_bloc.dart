import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';

class LocationAuthBloc extends Bloc<LocationAuthEvent, LocationAuthState> {
  final LocationRespos locationRespos;

  LocationAuthBloc({@required this.locationRespos}) : super(Loading());

  @override
  Stream<LocationAuthState> mapEventToState(
    LocationAuthEvent event,
  ) async* {
    if (event is Started) {
      final bool hasToken = await locationRespos.checkAuthLocation();

      if (hasToken) {
        Map<String, dynamic> location = await locationRespos.fetchLocation();
        yield Authenticated(location: location);
      } else {
        yield Unauthenticated();
      }
    }
  }
}

//----------------------------------------------------------------------------
//---------------------------- state
class LocationAuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class Loading extends LocationAuthState {}

class Uninitialized extends LocationAuthState {}

class Authenticated extends LocationAuthState {
  final location;
  Authenticated({this.location});

  Map<String, dynamic> get getLocation => location;
  @override
  List<Object> get props => [location];
}

class Unauthenticated extends LocationAuthState {}

//----------------------------------------------------------------------------
//-------------------------- event
class LocationAuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Located extends LocationAuthEvent {}

class Started extends LocationAuthEvent {}
