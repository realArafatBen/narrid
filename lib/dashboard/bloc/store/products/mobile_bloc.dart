import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/mobile-repos.dart';

class MobileBloc extends Bloc<MobileEvent, MobileState> {
  MobileRepos popularCategories;
  MobileBloc(this.popularCategories) : super(Loading());

  @override
  Stream<MobileState> mapEventToState(
    MobileEvent event,
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
abstract class MobileEvent extends Equatable {
  const MobileEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends MobileEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class MobileState extends Equatable {
  const MobileState();

  @override
  List<Object> get props => [];
}

class Loading extends MobileState {
  @override
  List<Object> get props => [];
}

class Loaded extends MobileState {
  final _products;

  const Loaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class ErrorLoading extends MobileState {
  @override
  List<Object> get props => [];
}
