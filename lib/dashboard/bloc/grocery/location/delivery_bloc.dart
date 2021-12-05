import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/grocery/store/extimate_delivery_repos.dart';

class DeliveryExBloc extends Bloc<DeliveryExEvent, DeliveryExState> {
  final ExtimateDeliveryRepos extimateDeliveryRepos;

  DeliveryExBloc({@required this.extimateDeliveryRepos})
      : super(DeliveryExLoading());

  @override
  Stream<DeliveryExState> mapEventToState(
    DeliveryExEvent event,
  ) async* {
    if (event is DeliveryExStarted) {
      try {
        Map<String, dynamic> data =
            await extimateDeliveryRepos.getExtimateTime(event.lat, event.lng);

        yield DeliveryExSuccess(data: data);
      } catch (_) {
        print("Error" + _.toString());
        yield DeliveryExError();
      }
    }
  }
}

//----------------------------------------------------------------------------
//---------------------------- state
class DeliveryExState extends Equatable {
  @override
  List<Object> get props => [];
}

class DeliveryExLoading extends DeliveryExState {}

class DeliveryExError extends DeliveryExState {}

class DeliveryExSuccess extends DeliveryExState {
  final data;
  DeliveryExSuccess({this.data});
  Map<String, dynamic> get getData => data;
  @override
  List<Object> get props => [data];
}

//----------------------------------------------------------------------------
//-------------------------- event
class DeliveryExEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DeliveryExStarted extends DeliveryExEvent {
  final lat;
  final lng;
  DeliveryExStarted({this.lat, this.lng});
  @override
  List<Object> get props => [lat, lng];
}
