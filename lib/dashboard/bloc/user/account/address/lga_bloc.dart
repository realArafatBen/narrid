import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/user/account/addresses_repost.dart';

class LgaBloc extends Bloc<LgaEvent, LgaState> {
  final AddressesRepos addressRepos;

  LgaBloc({@required this.addressRepos}) : super(LgaLoading());

  @override
  Stream<LgaState> mapEventToState(
    LgaEvent event,
  ) async* {
    if (event is LgaFetch) {
      try {
        final List<dynamic> lga = await addressRepos.fetchLocalLGA(event.alias);
        yield LgaLoaded(lga);
      } catch (_) {
        yield LgaError();
      }
    }
  }
}

//event ---------------------
abstract class LgaEvent extends Equatable {
  const LgaEvent();

  @override
  List<Object> get props => [];
}

class LgaFetch extends LgaEvent {
  final alias;
  LgaFetch(this.alias);
  @override
  List<Object> get props => [alias];
}

// state ----------------------------------------
abstract class LgaState extends Equatable {
  const LgaState();

  @override
  List<Object> get props => [];
}

class LgaLoading extends LgaState {
  @override
  List<Object> get props => [];
}

class LgaLoaded extends LgaState {
  final lga;

  const LgaLoaded(
    this.lga,
  );

  List<dynamic> get getLga => lga;

  @override
  List<Object> get props => [lga];
}

class LgaError extends LgaState {
  @override
  List<Object> get props => [];
}
