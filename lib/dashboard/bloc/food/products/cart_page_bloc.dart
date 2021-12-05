import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/models/db/food_cart_model.dart';
import 'package:narrid/dashboard/repositories/food/products/products_repos.dart';

class CartGroceryBloc extends Bloc<CartEvent, CartState> {
  FoodProductRep foodProductRep;
  CartGroceryBloc({@required this.foodProductRep}) : super(CartPageLoading());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    List<FoodCartHelper> carts;
    if (event is CartPageStarted) {
      yield CartPageLoading();
      try {
        bool status = await foodProductRep.checkCartStatus();
        if (status == false) {
          yield CartPageEmpty();
        } else {
          carts = await foodProductRep.getProducts();

          // print(carts);
          yield CartPageLoaded(cart: carts);
        }
      } catch (_) {
        yield CartPageError();
      }
    } else if (event is CartPageAdd) {
      final __qty = int.parse(event.qty) + 1;

      await foodProductRep.quantityCart(event.id, __qty.toString());
      carts = await foodProductRep.getProducts();
      yield CartPageLoaded(cart: carts);
    } else if (event is CartPageMinus) {
      if (int.parse(event.qty) == 1) {
        //do nothing
      } else {
        final __qty = int.parse(event.qty) - 1;

        await foodProductRep.quantityCart(event.id, __qty.toString());
        carts = await foodProductRep.getProducts();
        yield CartPageLoaded(cart: carts);
      }
    } else if (event is CartPageRemove) {
      yield CartPageLoading();
      try {
        bool _remove = await foodProductRep.removeFromCart(event.id);

        if (_remove) {
          bool status = await foodProductRep.checkCartStatus();
          if (status == false) {
            yield CartPageEmpty();
          } else {
            carts = await foodProductRep.getProducts();
            yield CartPageLoaded(cart: carts);
          }
        } else {
          yield CartPageError();
        }
      } catch (_) {
        yield CartPageError();
      }
    }
  }
}

//--------------------------------------------------------------------
//----------------------------Event-----------------------------------
class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CartPageStarted extends CartEvent {}

class CartPageAdd extends CartEvent {
  final String id;
  final String qty;
  CartPageAdd({this.id, this.qty});

  @override
  List<Object> get props => [id, qty];
}

class CartPageMinus extends CartEvent {
  final String id;
  final String qty;
  CartPageMinus({this.id, this.qty});

  @override
  List<Object> get props => [id, qty];
}

class CartPageRemove extends CartEvent {
  final String id;

  CartPageRemove({this.id});

  @override
  List<Object> get props => [id];
}

//--------------------------------------------------------------------
//----------------------------State-----------------------------------
class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartPageLoading extends CartState {}

class CartPageLoaded extends CartState {
  final cart;
  CartPageLoaded({@required this.cart});

  List<FoodCartHelper> get getCartList => cart;
  List<Object> get props => [cart];
}

class CartPageEmpty extends CartState {}

class CartPageError extends CartState {}
