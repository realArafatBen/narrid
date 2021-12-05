import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class AcctBloc extends Bloc<AcctEvent, AcctState> {
  final UserRepository authenticationRepository;

  AcctBloc({@required this.authenticationRepository}) : super(AcctLoading());

  @override
  Stream<AcctState> mapEventToState(
    AcctEvent event,
  ) async* {
    if (event is AcctStarted) {
      try {
        final Map<String, dynamic> token =
            await authenticationRepository.getUserToken();
        yield FetchToken(token);
      } catch (_) {
        print(_.toString());
        yield ErrorAcctLoading();
      }
    }
  }
}

//event ---------------------
abstract class AcctEvent extends Equatable {
  const AcctEvent();

  @override
  List<Object> get props => [];
}

class AcctStarted extends AcctEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class AcctState extends Equatable {
  const AcctState();

  @override
  List<Object> get props => [];
}

class AcctLoading extends AcctState {
  @override
  List<Object> get props => [];
}

class FetchToken extends AcctState {
  final token;

  const FetchToken(
    this.token,
  );

  Map<String, dynamic> get getToken => token;

  @override
  List<Object> get props => [token];
}

class ErrorAcctLoading extends AcctState {
  @override
  List<Object> get props => [];
}
