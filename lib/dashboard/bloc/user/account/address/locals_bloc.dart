import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/models/store/account/addresses_modal.dart';
import 'package:narrid/dashboard/repositories/user/account/addresses_repost.dart';

class LocalsBloc extends Bloc<LocalsEvent, LocalsState> {
  final AddressesRepos addressRepos;

  LocalsBloc({@required this.addressRepos}) : super(LocalsLoading());

  @override
  Stream<LocalsState> mapEventToState(
    LocalsEvent event,
  ) async* {
    if (event is LocalsStarted) {
      try {
        final List<AddressModal> citys = await addressRepos.fetchLocalState();
        yield LocalsLoaded(citys);
      } catch (_) {
        print(_.toString());

        yield LocalsError();
      }
    } else if (event is LocalsFetch) {
      try {
        final List<dynamic> lga = await addressRepos.fetchLocalLGA(event.alias);
        yield LocalsLoadedLGA(lga);
      } catch (_) {
        yield LocalsErrorLGA();
      }
    }
  }
}

//event ---------------------
abstract class LocalsEvent extends Equatable {
  const LocalsEvent();

  @override
  List<Object> get props => [];
}

class LocalsStarted extends LocalsEvent {
  @override
  List<Object> get props => [];
}

class LocalsFetch extends LocalsEvent {
  final alias;
  LocalsFetch(this.alias);
  @override
  List<Object> get props => [alias];
}

// state ----------------------------------------
abstract class LocalsState extends Equatable {
  const LocalsState();

  @override
  List<Object> get props => [];
}

class LocalsLoading extends LocalsState {
  @override
  List<Object> get props => [];
}

class LocalsLoaded extends LocalsState {
  final city;

  const LocalsLoaded(
    this.city,
  );

  List<AddressModal> get getCities => city;

  @override
  List<Object> get props => [city];
}

class LocalsLoadedLGA extends LocalsState {
  final lga;

  const LocalsLoadedLGA(
    this.lga,
  );

  List<dynamic> get getLga => lga;

  @override
  List<Object> get props => [lga];
}

class LocalsError extends LocalsState {
  @override
  List<Object> get props => [];
}

class LocalsErrorLGA extends LocalsState {
  @override
  List<Object> get props => [];
}
