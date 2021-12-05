import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/bloc/user/auth/authentication_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  RegisterBloc({@required this.userRepository, this.authenticationBloc})
      : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterButtonPressed) {
      yield RegisterLoading();

      try {
        Map<String, dynamic> token = await userRepository.userRegister(
          email: event.email,
          password: event.password,
          first_name: event.first_name,
          last_name: event.last_name,
          mobile: event.mobile,
          state: event.state,
          country: event.country,
        );

        if (token['status'] == "success") {
          authenticationBloc.add(LoggedIn(token: token));
          yield RegisterSuccess();
        } else if (token['status'] == 'email-empty') {
          yield RegisterMessageAlert(msg: "Email address is required");
        } else if (token['status'] == 'password-empty') {
          yield RegisterMessageAlert(msg: "Password is required");
        } else if (token['status'] == 'first-empty') {
          yield RegisterMessageAlert(msg: "First name is required");
        } else if (token['status'] == 'last-empty') {
          yield RegisterMessageAlert(msg: "Last name is required");
        } else if (token['status'] == 'last-empty') {
          yield RegisterMessageAlert(msg: "Last name is required");
        } else if (token['status'] == 'mobile-empty') {
          yield RegisterMessageAlert(msg: "Phone number is required");
        } else if (token['status'] == 'state-empty') {
          yield RegisterMessageAlert(msg: "State is required");
        } else if (token['status'] == 'country-empty') {
          yield RegisterMessageAlert(msg: "Country is required");
        } else if (token['status'] == 'email-exist') {
          yield RegisterMessageAlert(
              msg: "this email already exist on our server");
        }
      } catch (_) {
        print(_.toString());
        yield RegisterFailure(error: _.toString());
      }
    }
  }
}
