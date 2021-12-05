import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/groceries-repos.dart';

class GroceriesBloc extends Bloc<GroceriesEvent, GroceriesState> {
  GroceriesRepos popularCategories;
  GroceriesBloc(this.popularCategories) : super(Loading());

  @override
  Stream<GroceriesState> mapEventToState(
    GroceriesEvent event,
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
abstract class GroceriesEvent extends Equatable {
  const GroceriesEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends GroceriesEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class GroceriesState extends Equatable {
  const GroceriesState();

  @override
  List<Object> get props => [];
}

class Loading extends GroceriesState {
  @override
  List<Object> get props => [];
}

class Loaded extends GroceriesState {
  final _products;

  const Loaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class ErrorLoading extends GroceriesState {
  @override
  List<Object> get props => [];
}
