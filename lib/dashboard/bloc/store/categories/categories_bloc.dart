import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/bloc/store/categories/subcategories_bloc.dart';
import 'package:narrid/dashboard/models/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/categories/subcategories.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesRepos categoriesRepos;
  CategoriesBloc(this.categoriesRepos) : super(Loading());

  @override
  Stream<CategoriesState> mapEventToState(
    CategoriesEvent event,
  ) async* {
    if (event is CatStarted) {
      try {
        var categories = await categoriesRepos.getCategories();

        yield Loaded(categories);
      } catch (_) {
        yield ErrorLoading();
      }
    }

    if (event is Tapped) {
      SubCategoriesBloc(SubCategoriesRepos())..add(AppStartedCat(event._catId));
    }
  }
}

//event ---------------------
abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class CatStarted extends CategoriesEvent {
  @override
  List<Object> get props => [];
}

class Tapped extends CategoriesEvent {
  final _catId;
  const Tapped(this._catId);
  @override
  List<Object> get props => [_catId];
}

// state ----------------------------------------
abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class Loading extends CategoriesState {
  @override
  List<Object> get props => [];
}

class Loaded extends CategoriesState {
  final _categories;

  const Loaded(
    this._categories,
  );

  List<CategoriesModel> get getCategories => _categories;

  @override
  List<Object> get props => [_categories];
}

class ErrorLoading extends CategoriesState {
  @override
  List<Object> get props => [];
}
