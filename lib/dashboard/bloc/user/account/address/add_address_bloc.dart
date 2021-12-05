import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/user/account/addresses_repost.dart';

class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  final AddressesRepos addressRepos;

  AddAddressBloc({@required this.addressRepos}) : super(AddAddressInit());

  @override
  Stream<AddAddressState> mapEventToState(
    AddAddressEvent event,
  ) async* {
    if (event is AddAddressPress) {
      yield AddAddressLoading();
      try {
        final Map<String, dynamic> data = await addressRepos.addUserAddress(
            event.first_name,
            event.last_name,
            event.line1,
            event.line2,
            event.address,
            event.city,
            event.region);
        if (data['status'] == 'success') {
          yield AddAddressSuccess();
        } else {
          yield AddAddressError();
        }
      } catch (_) {
        print(_.toString());

        yield AddAddressError();
      }
    }
  }
}

//event ---------------------
abstract class AddAddressEvent extends Equatable {
  const AddAddressEvent();

  @override
  List<Object> get props => [];
}

class AddAddressPress extends AddAddressEvent {
  final first_name;
  final last_name;
  final line1;
  final line2;
  final address;
  final city;
  final region;

  AddAddressPress(
      {this.first_name,
      this.last_name,
      this.line1,
      this.line2,
      this.address,
      this.city,
      this.region});
  @override
  List<Object> get props =>
      [first_name, last_name, line1, line2, address, city, region];
}

// state ----------------------------------------
abstract class AddAddressState extends Equatable {
  const AddAddressState();

  @override
  List<Object> get props => [];
}

class AddAddressInit extends AddAddressState {
  @override
  List<Object> get props => [];
}

class AddAddressLoading extends AddAddressState {
  @override
  List<Object> get props => [];
}

class AddAddressSuccess extends AddAddressState {
  @override
  List<Object> get props => [];
}

class AddAddressError extends AddAddressState {
  @override
  List<Object> get props => [];
}
