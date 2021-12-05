import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/models/db/cart_db_model.dart';
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';

class CheckoutCartHandlerBloc
    extends Bloc<CheckoutCartHandlerEvent, CheckoutCartHandlerState> {
  CartRepository cartRepository;
  CheckoutCartHandlerBloc({@required this.cartRepository})
      : super(CheckoutCartHandlerLoading());

  @override
  Stream<CheckoutCartHandlerState> mapEventToState(
    CheckoutCartHandlerEvent event,
  ) async* {
    if (event is CartHandlerStarted) {
      try {
        List<CartHelper> cart = await cartRepository.getProducts();
        yield CheckoutCartHandlerLoaded(cart: cart);
      } catch (_) {
        print(_.toString());
        yield CartHandlerError();
      }
    }
  }
}

//-----------------------------------------------------------------------------
//-------------------------- State --------------------------------------------
class CheckoutCartHandlerState extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckoutCartHandlerLoading extends CheckoutCartHandlerState {}

class CheckoutCartHandlerLoaded extends CheckoutCartHandlerState {
  final cart;
  CheckoutCartHandlerLoaded({@required this.cart});

  List<CartHelper> get getCart => cart;
  @override
  List<Object> get props => [cart];
}

class CartHandlerError extends CheckoutCartHandlerState {}

//-----------------------------------------------------------------------------
//----------------------------Event-------------------------------------------
class CheckoutCartHandlerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CartHandlerStarted extends CheckoutCartHandlerEvent {}
