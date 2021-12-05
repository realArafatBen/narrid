import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/food/products/products_repos.dart';

class ProductCartBloc extends Bloc<CartEvent, CartState> {
  FoodProductRep foodProductRep;

  ProductCartBloc(this.foodProductRep) : super(CartLoading());

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is CartStarted) {
      try {
        List<Map<String, dynamic>> carts =
            await foodProductRep.getItemCart(event.id);
        yield CartLoaded(carts);
      } catch (_) {
        yield CartError();
      }
    } else if (event is CartInsertCart) {
      try {
        bool _insert = await foodProductRep.insert(
          event.id,
          event.product_name,
          event.qty,
          event.price,
          event.image,
          event.shipping_cost,
        );
        if (_insert == true) {
          List<Map<String, dynamic>> cart =
              await foodProductRep.getItemCart(event.id);

          yield CartLoaded(cart);
        } else {
          print("error1");
          yield CartError();
        }
      } catch (_) {
        print("error2");
        yield CartError();
      }
    } else if (event is CartMinus) {
      final __qty = int.parse(event.qty) - 1;

      try {
        //check if the qty is == 1
        // then remove the product from the cart
        if (int.parse(event.qty) == 1) {
          bool _remove = await foodProductRep.removeFromCart(event.id);

          if (_remove) {
            List<Map<String, dynamic>> cart =
                await foodProductRep.getItemCart(event.id);
            yield CartLoaded(cart);
          } else {
            yield CartError();
          }
        } else {
          bool _increment =
              await foodProductRep.quantityCart(event.id, __qty.toString());

          if (_increment) {
            List<Map<String, dynamic>> cart =
                await foodProductRep.getItemCart(event.id);

            yield CartLoaded(cart);
          } else {
            yield CartError();
          }
        }
      } catch (_) {
        yield CartError();
      }
    } else if (event is CartRemove) {
      try {
        bool _remove = await foodProductRep.removeFromCart(event.id);

        if (_remove) {
          List<Map<String, dynamic>> cart =
              await foodProductRep.getItemCart(event.id);

          yield CartLoaded(cart);
        } else {
          yield CartError();
        }
      } catch (_) {
        yield CartError();
      }
    } else if (event is AddToCart) {
      final __qty = int.parse(event.qty) + 1;

      try {
        bool _increment =
            await foodProductRep.quantityCart(event.id, __qty.toString());

        if (_increment) {
          List<Map<String, dynamic>> cart =
              await foodProductRep.getItemCart(event.id);
          yield CartLoaded(cart);
        } else {
          yield CartError();
        }
      } catch (_) {
        yield CartError();
      }
    }
  }
}

//event ---------------------
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {
  final id;
  CartStarted({@required this.id});
  @override
  List<Object> get props => [id];
}

class AddToCart extends CartEvent {
  final String id;
  final String qty;
  const AddToCart({this.id, this.qty});

  @override
  List<Object> get props => [id, qty];
}

class CartMinus extends CartEvent {
  final String id;
  final String qty;
  const CartMinus({this.id, this.qty});

  @override
  List<Object> get props => [id, qty];
}

class CartInsertCart extends CartEvent {
  final String id;
  final String product_name;
  final String qty;
  final String price;
  final String image;
  final String shipping_cost;
  const CartInsertCart(
      {this.id,
      this.product_name,
      this.qty,
      this.price,
      this.image,
      this.shipping_cost});

  @override
  List<Object> get props =>
      [id, product_name, qty, price, image, shipping_cost];
}

class CartRemove extends CartEvent {
  final String id;

  const CartRemove({this.id});

  @override
  List<Object> get props => [id];
}

// state ----------------------------------------
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  final cart;
  const CartLoaded(this.cart);

  List<Map<String, dynamic>> get getCarts => cart;
  @override
  List<Object> get props => [cart];
}

class CartError extends CartState {
  @override
  List<Object> get props => [];
}
