import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/models/db/cart_db_model.dart';
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';

class CartCountBloc extends Bloc<CartCountEvent, CartCountState> {
  final CartRepository cartRepository;

  CartCountBloc({@required this.cartRepository}) : super(CartCountLoading());

  @override
  Stream<CartCountState> mapEventToState(
    CartCountEvent event,
  ) async* {
    if (event is CartCountStarted) {
      try {
        final List<CartHelper> cart = await cartRepository.getProductCart();
        yield CartCountLoaded(cart.length.toString());
      } catch (_) {
        print(_.toString());

        yield CartCountError();
      }
    }
  }
}

//event ---------------------
abstract class CartCountEvent extends Equatable {
  const CartCountEvent();

  @override
  List<Object> get props => [];
}

class CartCountStarted extends CartCountEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class CartCountState extends Equatable {
  const CartCountState();

  @override
  List<Object> get props => [];
}

class CartCountLoading extends CartCountState {
  @override
  List<Object> get props => [];
}

class CartCountLoaded extends CartCountState {
  final count;

  const CartCountLoaded(this.count);

  String get getCount => count;

  @override
  List<Object> get props => [count];
}

class CartCountError extends CartCountState {
  @override
  List<Object> get props => [];
}
