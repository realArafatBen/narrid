import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/logistices/book_logistics_repos.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository bookRepository;

  BookBloc({@required this.bookRepository}) : super(Loading());

  @override
  Stream<BookState> mapEventToState(
    BookEvent event,
  ) async* {
    if (event is Started) {
      Map<String, dynamic> pass = event.data;
      //cash
      if (pass['payment_method'] == '0') {
        try {
          Map<String, dynamic> data = await bookRepository.bookCash(event.data);
          yield SuccessCash(data: data);
        } catch (_) {
          yield Error();
        }
      }
      //card
      else if (pass['payment_method'] == '1') {
        try {
          Map<String, dynamic> data = await bookRepository.bookCard(event.data);
          yield SuccessCard(data: data);
        } catch (_) {
          yield Error();
        }
      }
    }
  }
}

//----------------------------------------------------------------------------
//---------------------------- state
class BookState extends Equatable {
  @override
  List<Object> get props => [];
}

class Loading extends BookState {}

class Error extends BookState {}

class SuccessCard extends BookState {
  final data;
  SuccessCard({this.data});
  Map<String, dynamic> get getDataCard => data;
  @override
  List<Object> get props => [data];
}

class SuccessCash extends BookState {
  final data;
  SuccessCash({this.data});
  Map<String, dynamic> get getDataCash => data;
  @override
  List<Object> get props => [data];
}

//----------------------------------------------------------------------------
//-------------------------- event
class BookEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Started extends BookEvent {
  final data;
  Started({this.data});
  @override
  List<Object> get props => [data];
}
