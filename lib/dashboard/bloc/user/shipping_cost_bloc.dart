import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/user/account/shipping_cost.dart';

class ShippingCostBloc extends Bloc<ShippingCostEvent, ShippingCostState> {
  final ShippingCostResp shippingCostResp;

  ShippingCostBloc({@required this.shippingCostResp})
      : super(ShippingCostLoading());

  @override
  Stream<ShippingCostState> mapEventToState(
    ShippingCostEvent event,
  ) async* {
    if (event is ShippingCostStarted) {
      try {
        final Map<String, dynamic> cost =
            await shippingCostResp.fetchShippingCost();
        yield ShippingCostLoaded(cost);
      } catch (_) {
        print(_.toString());

        yield ShippingCostError();
      }
    }
  }
}

//event ---------------------
abstract class ShippingCostEvent extends Equatable {
  const ShippingCostEvent();

  @override
  List<Object> get props => [];
}

class ShippingCostStarted extends ShippingCostEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class ShippingCostState extends Equatable {
  const ShippingCostState();

  @override
  List<Object> get props => [];
}

class ShippingCostLoading extends ShippingCostState {
  @override
  List<Object> get props => [];
}

class ShippingCostLoaded extends ShippingCostState {
  final cost;

  const ShippingCostLoaded(this.cost);

  Map<String, dynamic> get getCost => cost;

  @override
  List<Object> get props => [cost];
}

class ShippingCostError extends ShippingCostState {
  @override
  List<Object> get props => [];
}
