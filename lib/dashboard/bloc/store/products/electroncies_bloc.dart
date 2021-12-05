import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/electronics-repos.dart';

class ElectronicsBloc extends Bloc<ElectronicsEvent, ElectronicsState> {
  ElectroniesRepos popularCategories;
  ElectronicsBloc(this.popularCategories) : super(Loading());

  @override
  Stream<ElectronicsState> mapEventToState(
    ElectronicsEvent event,
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
abstract class ElectronicsEvent extends Equatable {
  const ElectronicsEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends ElectronicsEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class ElectronicsState extends Equatable {
  const ElectronicsState();

  @override
  List<Object> get props => [];
}

class Loading extends ElectronicsState {
  @override
  List<Object> get props => [];
}

class Loaded extends ElectronicsState {
  final _products;

  const Loaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class ErrorLoading extends ElectronicsState {
  @override
  List<Object> get props => [];
}
