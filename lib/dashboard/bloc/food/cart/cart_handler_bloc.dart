import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/models/db/food_cart_model.dart';
import 'package:narrid/dashboard/repositories/food/products/products_repos.dart';

class CartHandlerBloc extends Bloc<CartHandlerEvent, CartHandlerState> {
  FoodProductRep foodProductRep;
  CartHandlerBloc({@required this.foodProductRep})
      : super(CartHandlerLoading());

  @override
  Stream<CartHandlerState> mapEventToState(
    CartHandlerEvent event,
  ) async* {
    if (event is CartHandlerStarted) {
      try {
        List<FoodCartHelper> cart = await foodProductRep.getProducts();
        yield CartHandlerLoaded(cart: cart);
      } catch (_) {
        print(_.toString());
        yield CartHandlerError();
      }
    }
  }
}

//-----------------------------------------------------------------------------
//-------------------------- State --------------------------------------------
class CartHandlerState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartHandlerLoading extends CartHandlerState {}

class CartHandlerLoaded extends CartHandlerState {
  final cart;
  CartHandlerLoaded({@required this.cart});

  List<FoodCartHelper> get getCart => cart;
  @override
  List<Object> get props => [cart];
}

class CartHandlerError extends CartHandlerState {}

//-----------------------------------------------------------------------------
//----------------------------Event-------------------------------------------
class CartHandlerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CartHandlerStarted extends CartHandlerEvent {}
