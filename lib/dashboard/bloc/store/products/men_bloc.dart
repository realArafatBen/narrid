import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/men-repos.dart';

class MenBloc extends Bloc<MenEvent, MenState> {
  MenRepos popularCategories;
  MenBloc(this.popularCategories) : super(Loading());

  @override
  Stream<MenState> mapEventToState(
    MenEvent event,
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
abstract class MenEvent extends Equatable {
  const MenEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends MenEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class MenState extends Equatable {
  const MenState();

  @override
  List<Object> get props => [];
}

class Loading extends MenState {
  @override
  List<Object> get props => [];
}

class Loaded extends MenState {
  final _products;

  const Loaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class ErrorLoading extends MenState {
  @override
  List<Object> get props => [];
}
