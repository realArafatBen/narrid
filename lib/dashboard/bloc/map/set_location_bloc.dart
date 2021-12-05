import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';

class SetLocationBloc extends Bloc<SetLocationEvent, SetLocationState> {
  final LocationRespos locationRespos;

  SetLocationBloc({@required this.locationRespos}) : super(Init());

  @override
  Stream<SetLocationState> mapEventToState(
    SetLocationEvent event,
  ) async* {
    if (event is Pin) {
      yield Loading();
      try {
        await locationRespos.setAuthLocation(
          event.address,
          event.lat,
          event.lng,
          event.city,
        );

        yield Success();
      } catch (_) {
        yield Error();
      }
    }
  }
}

//----------------------------------------------------------------------------
//---------------------------- state
class SetLocationState extends Equatable {
  @override
  List<Object> get props => [];
}

class Loading extends SetLocationState {}

class Error extends SetLocationState {}

class Init extends SetLocationState {}

class Success extends SetLocationState {}

//----------------------------------------------------------------------------
//-------------------------- event
class SetLocationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Pin extends SetLocationEvent {
  final address;
  final lat;
  final lng;
  final city;
  Pin({
    @required this.address,
    @required this.lat,
    @required this.lng,
    @required this.city,
  });
  @override
  List<Object> get props => [address, lat, lng, city];
}
