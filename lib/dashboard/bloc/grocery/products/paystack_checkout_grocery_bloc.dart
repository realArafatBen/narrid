import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/grocery/products/paystack_grocery_repos.dart';

class PaystackCheckoutGroceryBloc
    extends Bloc<PaystackCheckoutEvent, PaystackCheckoutState> {
  final PaystackGroceryRespo paystackRespo;

  PaystackCheckoutGroceryBloc({@required this.paystackRespo})
      : super(PaystackLoading());

  @override
  Stream<PaystackCheckoutState> mapEventToState(
    PaystackCheckoutEvent event,
  ) async* {
    if (event is PaystackStarted) {
      try {
        final Map<String, dynamic> data =
            await paystackRespo.initialize(event.shipping, event.total);
        yield PaystackLoaded(data);
      } catch (_) {
        print(_.toString());

        yield PaystackError();
      }
    }
  }
}

//event ---------------------
abstract class PaystackCheckoutEvent extends Equatable {
  const PaystackCheckoutEvent();

  @override
  List<Object> get props => [];
}

class PaystackStarted extends PaystackCheckoutEvent {
  final shipping;
  final total;
  PaystackStarted(this.shipping, this.total);
  @override
  List<Object> get props => [shipping, total];
}

// state ----------------------------------------
abstract class PaystackCheckoutState extends Equatable {
  const PaystackCheckoutState();

  @override
  List<Object> get props => [];
}

class PaystackLoading extends PaystackCheckoutState {
  @override
  List<Object> get props => [];
}

class PaystackLoaded extends PaystackCheckoutState {
  final data;

  const PaystackLoaded(this.data);

  Map<String, dynamic> get getData => data;

  @override
  List<Object> get props => [data];
}

class PaystackError extends PaystackCheckoutState {
  @override
  List<Object> get props => [];
}
