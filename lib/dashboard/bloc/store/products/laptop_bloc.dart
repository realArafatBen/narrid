import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/laptop-repos.dart';

class LaptopBloc extends Bloc<LaptopEvent, LaptopState> {
  LaptopRepos popularCategories;
  LaptopBloc(this.popularCategories) : super(Loading());

  @override
  Stream<LaptopState> mapEventToState(
    LaptopEvent event,
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
abstract class LaptopEvent extends Equatable {
  const LaptopEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends LaptopEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class LaptopState extends Equatable {
  const LaptopState();

  @override
  List<Object> get props => [];
}

class Loading extends LaptopState {
  @override
  List<Object> get props => [];
}

class Loaded extends LaptopState {
  final _products;

  const Loaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class ErrorLoading extends LaptopState {
  @override
  List<Object> get props => [];
}
