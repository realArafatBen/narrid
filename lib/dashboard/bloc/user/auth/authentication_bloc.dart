import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository authenticationRepository;

  AuthenticationBloc({@required this.authenticationRepository})
      : super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthStarted) {
      final bool hasToken = await authenticationRepository.hasToken();
      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    } else if (event is LoggedIn) {
      yield AuthenticationLoading();
      await authenticationRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
      print(event.token);
    } else if (event is LoggedOut) {
      yield AuthenticationLoading();
      await authenticationRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
