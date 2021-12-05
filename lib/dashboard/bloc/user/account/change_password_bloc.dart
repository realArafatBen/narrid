import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository userRepository;

  ChangePasswordBloc({@required this.userRepository}) : super(Started());

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is ChangePass) {
      yield Loading();
      try {
        final Map<String, dynamic> data = await userRepository.changePassword(
          event.password,
          event.prev_password,
        );
        yield Success(data);
      } catch (_) {
        print(_.toString());

        yield Error();
      }
    }
  }
}

//event ---------------------
abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePass extends ChangePasswordEvent {
  final password;
  final prev_password;

  ChangePass({this.password, this.prev_password});
  @override
  List<Object> get props => [password, prev_password];
}

// state ----------------------------------------
abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class Started extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class Loading extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class Success extends ChangePasswordState {
  final msg;
  Success(this.msg);
  Map<String, dynamic> get getMessage => msg;
  @override
  List<Object> get props => [msg];
}

class Error extends ChangePasswordState {
  @override
  List<Object> get props => [];
}
