import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/models/store/account/addresses_modal.dart';
import 'package:narrid/dashboard/repositories/user/account/addresses_repost.dart';

class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  final AddressesRepos addressRepos;

  AddressesBloc({@required this.addressRepos}) : super(AddressLoading());

  @override
  Stream<AddressesState> mapEventToState(
    AddressesEvent event,
  ) async* {
    if (event is AddressStarted) {
      try {
        final List<AddressModal> addresses =
            await addressRepos.fetchUserDefaultAddress();
        yield AddressLoaded(addresses);
      } catch (_) {
        print(_.toString());

        yield AddressError();
      }
    } else if (event is AddressMakeDefault) {
      try {
        yield AddressLoading();
        Map<String, dynamic> data = await addressRepos.makeDefault(event.id);
        if (data['status'] == 'success') {
          final List<AddressModal> addresses =
              await addressRepos.fetchUserDefaultAddress();
          yield AddressLoaded(addresses);
        } else {
          yield AddressError();
        }
      } catch (_) {
        print(_.toString());

        yield AddressError();
      }
    }
  }
}

//event ---------------------
abstract class AddressesEvent extends Equatable {
  const AddressesEvent();

  @override
  List<Object> get props => [];
}

class AddressStarted extends AddressesEvent {
  @override
  List<Object> get props => [];
}

class AddressMakeDefault extends AddressesEvent {
  final id;
  AddressMakeDefault(this.id);
  @override
  List<Object> get props => [id];
}

// state ----------------------------------------
abstract class AddressesState extends Equatable {
  const AddressesState();

  @override
  List<Object> get props => [];
}

class AddressLoading extends AddressesState {
  @override
  List<Object> get props => [];
}

class AddressLoaded extends AddressesState {
  final addresses;

  const AddressLoaded(
    this.addresses,
  );

  List<AddressModal> get getAddresses => addresses;

  @override
  List<Object> get props => [addresses];
}

class AddressError extends AddressesState {
  @override
  List<Object> get props => [];
}
