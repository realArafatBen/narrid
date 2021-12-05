import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/models/store/order/order_product_modal.dart';
import 'package:narrid/dashboard/repositories/food/orders_repos.dart';

class FoodOrderBloc extends Bloc<OrdersEvent, OrdersState> {
  final FoodOrdersRepository ordersRepository;

  FoodOrderBloc({@required this.ordersRepository}) : super(Loading());

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is Started) {
      try {
        final List<OrderProductModel> order =
            await ordersRepository.fetchOrderProduct(event.id);
        // print(order);
        yield Loaded(order);
      } catch (_) {
        // print(_.toString());

        yield Error();
      }
    }
  }
}

//event ---------------------
abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class Started extends OrdersEvent {
  final id;
  Started({@required this.id});
  @override
  List<Object> get props => [id];
}

// state ----------------------------------------
abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class Loading extends OrdersState {
  @override
  List<Object> get props => [];
}

class Loaded extends OrdersState {
  final orders;

  const Loaded(this.orders);

  List<OrderProductModel> get getOrders => orders;

  @override
  List<Object> get props => [orders];
}

class Error extends OrdersState {
  @override
  List<Object> get props => [];
}
