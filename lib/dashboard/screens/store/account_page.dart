import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/user/auth/authentication_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/user/account/index.dart';
import 'package:narrid/dashboard/screens/user/account/user.dart';
import 'package:narrid/dashboard/screens/user/loading_indicator.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }
}

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc.observer = SimpleBlocDelegate();
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            AuthenticationBloc(authenticationRepository: UserRepository())
              ..add(AuthStarted()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return LoadingIndicator();
          } else if (state is AuthenticationAuthenticated) {
            return UserAccount();
          } else if (state is AuthenticationUnauthenticated) {
            return Index();
          } else if (state is AuthenticationLoading) {
            return LoadingIndicator();
          } else {
            return null;
          }
        }),
      ),
    );
  }
}
