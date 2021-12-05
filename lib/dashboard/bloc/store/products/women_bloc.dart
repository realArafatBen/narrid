import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/women-repos.dart';

class WomenBloc extends Bloc<WomenEvent, WomenState> {
  WomenRepos popularCategories;
  WomenBloc(this.popularCategories) : super(Loading());

  @override
  Stream<WomenState> mapEventToState(
    WomenEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        List<ProductsModel> categories = await popularCategories.getProducts();
        yield Loaded(categories);
      } catch (_) {
        yield ErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class WomenEvent extends Equatable {
  const WomenEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends WomenEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class WomenState extends Equatable {
  const WomenState();

  @override
  List<Object> get props => [];
}

class Loading extends WomenState {
  @override
  List<Object> get props => [];
}

class Loaded extends WomenState {
  final _products;

  const Loaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class ErrorLoading extends WomenState {
  @override
  List<Object> get props => [];
}
