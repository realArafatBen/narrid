import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/recommendation-repos.dart';

class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  RecommdationRepos popularCategories;
  RecommendationBloc(this.popularCategories) : super(Loading());

  @override
  Stream<RecommendationState> mapEventToState(
    RecommendationEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        List<ProductsModel> categories =
            await popularCategories.getRecommdation();
        yield Loaded(categories);
      } catch (_) {
        yield ErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class RecommendationEvent extends Equatable {
  const RecommendationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends RecommendationEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object> get props => [];
}

class Loading extends RecommendationState {
  @override
  List<Object> get props => [];
}

class Loaded extends RecommendationState {
  final _products;

  const Loaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class ErrorLoading extends RecommendationState {
  @override
  List<Object> get props => [];
}
