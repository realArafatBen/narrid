import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  final UserRepository userRepository;

  EditAccountBloc({@required this.userRepository}) : super(Loading());

  @override
  Stream<EditAccountState> mapEventToState(
    EditAccountEvent event,
  ) async* {
    if (event is Edit) {
      yield Loading();
      try {
        final Map<String, dynamic> data = await userRepository.editAccount(
          event.first_name,
          event.last_name,
          event.mobile,
        );
        if (data['status'] == 'success') {
          final Map<String, dynamic> record =
              await userRepository.fetchDetails();
          if (record['res'] == 'success') {
            yield Success(record);
          } else {
            yield Error();
          }
        } else {
          yield Error();
        }
      } catch (_) {
        print(_.toString());

        yield Error();
      }
    } else if (event is Started) {
      yield Loading();
      try {
        final Map<String, dynamic> record = await userRepository.fetchDetails();
        print(record);

        if (record['res'] == 'success') {
          yield Success(record);
        } else {
          yield Error();
        }
      } catch (e) {
        yield Error();
      }
    }
  }
}

//event ---------------------
abstract class EditAccountEvent extends Equatable {
  const EditAccountEvent();

  @override
  List<Object> get props => [];
}

class Edit extends EditAccountEvent {
  final first_name;
  final last_name;
  final mobile;

  Edit({this.first_name, this.last_name, this.mobile});
  @override
  List<Object> get props => [first_name, last_name, mobile];
}

class Started extends EditAccountEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class EditAccountState extends Equatable {
  const EditAccountState();

  @override
  List<Object> get props => [];
}

class Loading extends EditAccountState {
  @override
  List<Object> get props => [];
}

class Success extends EditAccountState {
  final record;
  Success(this.record);
  Map<String, dynamic> get getDetails => record;
  @override
  List<Object> get props => [record];
}

class Error extends EditAccountState {
  @override
  List<Object> get props => [];
}
