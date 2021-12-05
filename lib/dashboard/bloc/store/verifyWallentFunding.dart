import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class VerifyWalletPaymentBloc
    extends Bloc<VerifyPaymentEvent, VerifyPaymentState> {
  final UserRepository userRepository;

  VerifyWalletPaymentBloc({@required this.userRepository})
      : super(VerifyLoading());

  @override
  Stream<VerifyPaymentState> mapEventToState(
    VerifyPaymentEvent event,
  ) async* {
    if (event is VerifyStarted) {
      try {
        final Map<String, dynamic> data =
            await userRepository.verifyWalletFunding(event.ref, event.amount);
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
  final amount;
  VerifyStarted(this.ref, this.amount);
  @override
  List<Object> get props => [ref, amount];
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
