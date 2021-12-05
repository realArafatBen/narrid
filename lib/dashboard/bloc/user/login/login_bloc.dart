import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/bloc/user/auth/authentication_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  LoginBloc({@required this.userRepository, this.authenticationBloc})
      : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        Map<String, dynamic> token = await userRepository.userLogin(
            email: event.email, password: event.password);
        if (token['status'] == "success") {
          authenticationBloc.add(LoggedIn(token: token));
          yield LoginSuccess();
        } else if (token['status'] == 'email-empty') {
          yield LoginMessageAlert(msg: "Email address is required");
        } else if (token['status'] == 'password-empty') {
          yield LoginMessageAlert(msg: "Password is required");
        } else if (token['status'] == 'inactive') {
          yield LoginMessageAlert(
              msg: "Account inactive, contact support team");
        } else if (token['status'] == 'blocked') {
          yield LoginMessageAlert(msg: "Account blocked, contact support team");
        } else if (token['status'] == 'wrong-password') {
          yield LoginMessageAlert(msg: "You entered a wrong password");
        } else if (token['status'] == 'email-error') {
          yield LoginMessageAlert(msg: "Email do not exist on our server");
        }
      } catch (_) {
        print(_.toString());
        yield LoginFailure(error: _.toString());
      }
    }
  }
}
