import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/food/products/paystack_food_repos.dart';

class VerifyPaymentFoodBloc
    extends Bloc<VerifyPaymentEvent, VerifyPaymentState> {
  final PaystackFoodRespo paystackFoodRespo;

  VerifyPaymentFoodBloc({@required this.paystackFoodRespo})
      : super(VerifyLoading());

  @override
  Stream<VerifyPaymentState> mapEventToState(
    VerifyPaymentEvent event,
  ) async* {
    if (event is VerifyStarted) {
      try {
        final Map<String, dynamic> data =
            await paystackFoodRespo.verify(event.ref);
        yield VerifyLoaded(data);
      } catch (_) {
        print(_.toString());

        yield VerifyError();
      }
    }
  }
}

//event ---------------------
abstract class VerifyPaymentEvent extends Equatable {
  const VerifyPaymentEvent();

  @override
  List<Object> get props => [];
}

class VerifyStarted extends VerifyPaymentEvent {
  final ref;
  VerifyStarted(this.ref);
  @override
  List<Object> get props => [ref];
}

// state ----------------------------------------
abstract class VerifyPaymentState extends Equatable {
  const VerifyPaymentState();

  @override
  List<Object> get props => [];
}

class VerifyLoading extends VerifyPaymentState {
  @override
  List<Object> get props => [];
}

class VerifyLoaded extends VerifyPaymentState {
  final data;

  const VerifyLoaded(this.data);

  Map<String, dynamic> get getData => data;

  @override
  List<Object> get props => [data];
}

class VerifyError extends VerifyPaymentState {
  @override
  List<Object> get props => [];
}
