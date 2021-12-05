import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/models/db/cart_db_model.dart';
import 'package:narrid/dashboard/repositories/store/checkout_cart_repository.dart';

class CheckoutProductBloc
    extends Bloc<CheckoutProductEvent, CheckoutProductState> {
  final CheckoutCartRepository cartRepository;

  CheckoutProductBloc({@required this.cartRepository})
      : super(CheckoutProductLoading());

  @override
  Stream<CheckoutProductState> mapEventToState(
    CheckoutProductEvent event,
  ) async* {
    if (event is CheckoutProductStarted) {
      try {
        final List<CartHelper> cart = await cartRepository.getProducts();
        yield CheckoutProductLoaded(cart);
      } catch (_) {
        print(_.toString());

        yield CheckoutProductError();
      }
    }
  }
}

//event ---------------------
abstract class CheckoutProductEvent extends Equatable {
  const CheckoutProductEvent();

  @override
  List<Object> get props => [];
}

class CheckoutProductStarted extends CheckoutProductEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class CheckoutProductState extends Equatable {
  const CheckoutProductState();

  @override
  List<Object> get props => [];
}

class CheckoutProductLoading extends CheckoutProductState {
  @override
  List<Object> get props => [];
}

class CheckoutProductLoaded extends CheckoutProductState {
  final cart;

  const CheckoutProductLoaded(this.cart);

  List<CartHelper> get getCart => cart;

  @override
  List<Object> get props => [cart];
}

class CheckoutProductError extends CheckoutProductState {
  @override
  List<Object> get props => [];
}
