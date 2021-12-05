import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final UserRepository authenticationRepository;

  ResetPasswordBloc({@required this.authenticationRepository})
      : super(Started());

  @override
  Stream<ResetPasswordState> mapEventToState(
    ResetPasswordEvent event,
  ) async* {
    if (event is Reset) {
      yield Loading();
      try {
        String msg = await authenticationRepository.resetPassword(event.email);
        yield Success(msg);
      } catch (_) {
        print(_.toString());
        yield Error();
      }
    }
  }
}

//event ---------------------
abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class Reset extends ResetPasswordEvent {
  final email;
  Reset(this.email);
  @override
  List<Object> get props => [email];
}

// state ----------------------------------------
abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

class Started extends ResetPasswordState {
  @override
  List<Object> get props => [];
}

class Loading extends ResetPasswordState {
  @override
  List<Object> get props => [];
}

class Success extends ResetPasswordState {
  final msg;

  const Success(
    this.msg,
  );

  String get getMessage => msg;

  @override
  List<Object> get props => [msg];
}

class Error extends ResetPasswordState {
  @override
  List<Object> get props => [];
}
