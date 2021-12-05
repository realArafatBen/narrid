import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/models/store/order/order_modal.dart';
import 'package:narrid/dashboard/repositories/grocery/orders_repos.dart';

class GroceryOrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GroceryOrdersRepository ordersRepository;

  GroceryOrdersBloc({@required this.ordersRepository}) : super(Loading());

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is Started) {
      try {
        final List<OrderModel> order = await ordersRepository.fetchOrders();
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
  @override
  List<Object> get props => [];
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

  List<OrderModel> get getOrders => orders;

  @override
  List<Object> get props => [orders];
}

class Error extends OrdersState {
  @override
  List<Object> get props => [];
}
