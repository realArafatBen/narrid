import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/user/account/address_repos.dart';

class DefauthAddressBloc
    extends Bloc<DefauthAddressEvent, DefauthAddressState> {
  final AddressRepos addressRepos;

  DefauthAddressBloc({@required this.addressRepos})
      : super(DefauthAddressLoading());

  @override
  Stream<DefauthAddressState> mapEventToState(
    DefauthAddressEvent event,
  ) async* {
    if (event is DefauthAddressStarted) {
      try {
        final Map<String, dynamic> address =
            await addressRepos.fetchUserDefaultAddress();
        yield DefauthAddressLoaded(address);
      } catch (_) {
        print(_.toString());

        yield DefaultAddressError();
      }
    }
  }
}

//event ---------------------
abstract class DefauthAddressEvent extends Equatable {
  const DefauthAddressEvent();

  @override
  List<Object> get props => [];
}

class DefauthAddressStarted extends DefauthAddressEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class DefauthAddressState extends Equatable {
  const DefauthAddressState();

  @override
  List<Object> get props => [];
}

class DefauthAddressLoading extends DefauthAddressState {
  @override
  List<Object> get props => [];
}

class DefauthAddressLoaded extends DefauthAddressState {
  final address;

  const DefauthAddressLoaded(
    this.address,
  );

  Map<String, dynamic> get getAddress => address;

  @override
  List<Object> get props => [address];
}

class DefaultAddressError extends DefauthAddressState {
  @override
  List<Object> get props => [];
}
