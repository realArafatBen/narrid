import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/models/db/cart_db_model.dart';
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';

class CartPageBloc extends Bloc<CartPageEvent, CartPageState> {
  CartRepository cartRepository;
  CartPageBloc({@required this.cartRepository}) : super(CartPageLoading());

  @override
  Stream<CartPageState> mapEventToState(CartPageEvent event) async* {
    List<CartHelper> carts;
    if (event is CartPageStarted) {
      yield CartPageLoading();
      try {
        bool status = await cartRepository.checkCartStatus();
        if (status == false) {
          yield CartPageEmpty();
        } else {
          carts = await cartRepository.getProducts();

          // print(carts);
          yield CartPageLoaded(cart: carts);
        }
      } catch (_) {
        yield CartPageError();
      }
    } else if (event is CartPageAdd) {
      final __qty = int.parse(event.qty) + 1;

      await cartRepository.quantityCart(event.id, __qty.toString());
      carts = await cartRepository.getProducts();
      yield CartPageLoaded(cart: carts);
    } else if (event is CartPageMinus) {
      if (int.parse(event.qty) == 1) {
        //do nothing
      } else {
        final __qty = int.parse(event.qty) - 1;

        await cartRepository.quantityCart(event.id, __qty.toString());
        carts = await cartRepository.getProducts();
        yield CartPageLoaded(cart: carts);
      }
    } else if (event is CartPageRemove) {
      yield CartPageLoading();
      try {
        bool _remove = await cartRepository.removeFromCart(event.id);

        if (_remove) {
          bool status = await cartRepository.checkCartStatus();
          if (status == false) {
            yield CartPageEmpty();
          } else {
            carts = await cartRepository.getProducts();
            yield CartPageLoaded(cart: carts);
          }
        } else {
          yield CartPageError();
        }
      } catch (_) {
        yield CartPageError();
      }
    } else if (event is CartRemoveSelected) {
      yield CartPageLoading();
      //remove selected
      await cartRepository.removeSelected();
      carts = await cartRepository.getProducts();
      if (carts.isEmpty) {
        yield CartPageEmpty();
      } else {
        yield CartPageLoaded(cart: carts);
      }
    }
  }
}

//--------------------------------------------------------------------
//----------------------------Event-----------------------------------
class CartPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CartPageStarted extends CartPageEvent {}

class CartPageAdd extends CartPageEvent {
  final String id;
  final String qty;
  CartPageAdd({this.id, this.qty});

  @override
  List<Object> get props => [id, qty];
}

class CartPageMinus extends CartPageEvent {
  final String id;
  final String qty;
  CartPageMinus({this.id, this.qty});

  @override
  List<Object> get props => [id, qty];
}

class CartPageRemove extends CartPageEvent {
  final String id;

  CartPageRemove({this.id});

  @override
  List<Object> get props => [id];
}

class CartRemoveSelected extends CartPageEvent {}

//--------------------------------------------------------------------
//----------------------------State-----------------------------------
class CartPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartPageLoading extends CartPageState {}

class CartPageLoaded extends CartPageState {
  final cart;
  CartPageLoaded({@required this.cart});

  List<CartHelper> get getCartList => cart;
  List<Object> get props => [cart];
}

class CartPageEmpty extends CartPageState {}

class CartPageError extends CartPageState {}
