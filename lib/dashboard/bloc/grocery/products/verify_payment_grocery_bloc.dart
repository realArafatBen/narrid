import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/grocery/products/paystack_grocery_repos.dart';

class VerifyPaymentGroceryBloc
    extends Bloc<VerifyPaymentEvent, VerifyPaymentState> {
  final PaystackGroceryRespo verifyPaymentRespo;

  VerifyPaymentGroceryBloc({@required this.verifyPaymentRespo})
      : super(VerifyLoading());

  @override
  Stream<VerifyPaymentState> mapEventToState(
    VerifyPaymentEvent event,
  ) async* {
    if (event is VerifyStarted) {
      try {
        final Map<String, dynamic> data =
            await verifyPaymentRespo.verify(event.ref);
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
