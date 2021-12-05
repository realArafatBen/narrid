import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/models/db/cart_db_model.dart';
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartRepository cartRepository;
  CartBloc({@required this.cartRepository}) : super(CartLoading());

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    List<CartHelper> cart;
    if (event is CartStarted) {
      try {
        bool _inserted = await cartRepository.countInCart(event.id);
        if (_inserted == false) {
          cart = await cartRepository.getItemCart(event.id);
          yield CartLoaded(cart);
        } else {
          yield CartNotInserted();
        }
      } catch (_) {
        yield CartError();
      }
    } else if (event is CartAdd) {
      final __qty = int.parse(event.qty) + 1;
      try {
        bool _increment =
            await cartRepository.quantityCart(event.id, __qty.toString());

        if (_increment) {
          cart = await cartRepository.getItemCart(event.id);

          yield CartLoaded(cart);
        } else {
          yield CartError();
        }
      } catch (_) {
        yield CartError();
      }
    } else if (event is CartMinus) {
      final __qty = int.parse(event.qty) - 1;
      try {
        //check if the qty is == 1
        // then remove the product from the cart
        if (int.parse(event.qty) == 1) {
          bool _remove = await cartRepository.removeFromCart(event.id);

          if (_remove) {
            cart = await cartRepository.getItemCart(event.id);

            yield CartNotInserted();
          } else {
            yield CartError();
          }
        } else {
          bool _increment =
              await cartRepository.quantityCart(event.id, __qty.toString());

          if (_increment) {
            cart = await cartRepository.getItemCart(event.id);

            yield CartLoaded(cart);
          } else {
            yield CartError();
          }
        }
      } catch (_) {
        yield CartError();
      }
    } else if (event is CartInsertCart) {
      try {
        bool _insert = await cartRepository.insert(
          event.id,
          event.product_name,
          event.qty,
          event.variant,
          event.variantName,
          event.variantPrice,
          event.image,
          event.color,
        );
        if (_insert == true) {
          cart = await cartRepository.getItemCart(event.id);

          yield CartLoaded(cart);
        } else {
          yield CartError();
        }
      } catch (_) {
        yield CartError();
      }
    } else if (event is CartRemove) {
      try {
        bool _remove = await cartRepository.removeFromCart(event.id);

        if (_remove) {
          cart = await cartRepository.getItemCart(event.id);

          yield CartNotInserted();
        } else {
          yield CartError();
        }
      } catch (_) {
        yield CartError();
      }
    }
  }
}

//--------------------------------------------------------------------
//--------------------Event-------------------------------------------
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => throw UnimplementedError();
}

class CartStarted extends CartEvent {
  final String id;
  const CartStarted({this.id});

  @override
  List<Object> get props => [id];
}

class CartAdd extends CartEvent {
  final String id;
  final String qty;
  const CartAdd({this.id, this.qty});

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
  final String variant;
  final String variantName;
  final String variantPrice;
  final String image;
  final String color;
  const CartInsertCart({
    this.id,
    this.product_name,
    this.qty,
    this.variant,
    this.variantName,
    this.variantPrice,
    this.image,
    this.color,
  });

  @override
  List<Object> get props => [
        id,
        product_name,
        qty,
        variant,
        variantName,
        variantPrice,
        image,
        color,
      ];
}

class CartRemove extends CartEvent {
  final String id;

  const CartRemove({this.id});

  @override
  List<Object> get props => [id];
}

//------------------------------------------------------------------
//-------------------State------------------------------------------

class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final _cart;

  const CartLoaded(this._cart);

  List<CartHelper> get getCart => _cart;
}

class CartNotInserted extends CartState {}

class CartError extends CartState {}
