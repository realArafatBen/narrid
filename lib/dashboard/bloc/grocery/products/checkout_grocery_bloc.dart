import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/models/db/grocery_cart_model.dart';
import 'package:narrid/dashboard/repositories/grocery/products/products_repos.dart';

class CheckoutGroceryBloc
    extends Bloc<CheckoutProductEvent, CheckoutProductState> {
  final GroceryProductRep groceryProductRep;

  CheckoutGroceryBloc({@required this.groceryProductRep})
      : super(CheckoutProductLoading());

  @override
  Stream<CheckoutProductState> mapEventToState(
    CheckoutProductEvent event,
  ) async* {
    if (event is CheckoutProductStarted) {
      try {
        final List<GroceryCartHelper> cart =
            await groceryProductRep.getProducts();
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

  List<GroceryCartHelper> get getCart => cart;

  @override
  List<Object> get props => [cart];
}

class CheckoutProductError extends CheckoutProductState {
  @override
  List<Object> get props => [];
}
