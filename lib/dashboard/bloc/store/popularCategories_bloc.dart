import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/categories/popular-categories.dart';

class PopularCategoriesBloc
    extends Bloc<PopularCategoriesEvent, PopularCategoriesState> {
  PopularCategories popularCategories;
  PopularCategoriesBloc(this.popularCategories) : super(Loading());

  @override
  Stream<PopularCategoriesState> mapEventToState(
    PopularCategoriesEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        List<CategoriesModel> categories =
            await popularCategories.getPopularCategories();
        yield Loaded(categories);
      } catch (_) {
        yield ErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class PopularCategoriesEvent extends Equatable {
  const PopularCategoriesEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends PopularCategoriesEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class PopularCategoriesState extends Equatable {
  const PopularCategoriesState();

  @override
  List<Object> get props => [];
}

class Loading extends PopularCategoriesState {
  @override
  List<Object> get props => [];
}

class Loaded extends PopularCategoriesState {
  final _categories;

  const Loaded(
    this._categories,
  );

  List<CategoriesModel> get getCategories => _categories;
  @override
  List<Object> get props => [_categories];
}

class ErrorLoading extends PopularCategoriesState {
  @override
  List<Object> get props => [];
}
