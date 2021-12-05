import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/repositories/store/checkout_cart_repository.dart';

class CheckoutCartBloc extends Bloc<CheckoutCartEvent, CheckoutCartState> {
  CheckoutCartRepository cartRepository;
  CheckoutCartBloc({@required this.cartRepository})
      : super(LoadingCheckoutCartState());

  @override
  Stream<CheckoutCartState> mapEventToState(
    CheckoutCartEvent event,
  ) async* {
    if (event is CheckoutCartClearAll) {
      //clear all the checkout cart record
      await cartRepository.clearCart();
    } else if (event is AddAllToCheckoutChart) {
      await cartRepository.insertAll();
    } else if (event is AddSingleToCheckoutChart) {
      bool _insert = await cartRepository.insert(
          event.id,
          event.product_name,
          event.qty,
          event.variant,
          event.variantName,
          event.variantPrice,
          event.image);
      print(_insert);
    } else if (event is RemoveSingleToCheckoutChart) {
      bool _remove = await cartRepository.removeFromCart(event.id);
    }
  }
}

//State-------------------------------------------------
class CheckoutCartState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingCheckoutCartState extends CheckoutCartState {}

//Event-------------------------------------------------
class CheckoutCartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckoutCartClearAll extends CheckoutCartEvent {}

class AddAllToCheckoutChart extends CheckoutCartEvent {}

class AddSingleToCheckoutChart extends CheckoutCartEvent {
  final String id;
  final String product_name;
  final String qty;
  final String variant;
  final String variantName;
  final String variantPrice;
  final String image;
  final String color;
  AddSingleToCheckoutChart({
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

class RemoveSingleToCheckoutChart extends CheckoutCartEvent {
  final String id;
  RemoveSingleToCheckoutChart({this.id});

  @override
  List<Object> get props => [id];
}
