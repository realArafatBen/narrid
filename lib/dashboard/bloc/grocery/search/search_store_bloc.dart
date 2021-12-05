import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/models/store/search/search_store_modal.dart';
import 'package:narrid/dashboard/repositories/grocery/search/store_search_repos.dart';

class SearchStoreBloc extends Bloc<SearchStoreEvent, SearchStoreState> {
  GrocerySearchRepository searchRepository;
  SearchStoreBloc({@required this.searchRepository}) : super(Init());

  @override
  Stream<SearchStoreState> mapEventToState(
    SearchStoreEvent event,
  ) async* {
    if (event is KeyUp) {
      yield SearchLoading();
      try {
        List<SearchModal> results = await searchRepository.fetchSearch(event.q);
        yield SearchLoaded(results: results);
      } catch (_) {
        yield SearchError();
      }
    }
  }
}

//event ---------------------
abstract class SearchStoreEvent extends Equatable {
  const SearchStoreEvent();

  @override
  List<Object> get props => [];
}

class KeyUp extends SearchStoreEvent {
  final q;
  KeyUp({@required this.q});
  @override
  List<Object> get props => [q];
}

// state ----------------------------------------
abstract class SearchStoreState extends Equatable {
  const SearchStoreState();

  @override
  List<Object> get props => [];
}

class Init extends SearchStoreState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchStoreState {
  @override
  List<Object> get props => [];
}

class SearchLoaded extends SearchStoreState {
  final results;
  SearchLoaded({@required this.results});

  List<SearchModal> get getResults => results;
  @override
  List<Object> get props => [results];
}

class SearchError extends SearchStoreState {
  @override
  List<Object> get props => [];
}
