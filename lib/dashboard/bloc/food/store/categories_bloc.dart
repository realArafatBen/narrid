import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/food/store/categories_repos.dart';

class StoreCategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoryRepos categoriesRepos;
  StoreCategoriesBloc(this.categoriesRepos) : super(CatLoading());

  @override
  Stream<CategoriesState> mapEventToState(
    CategoriesEvent event,
  ) async* {
    if (event is CatStarted) {
      try {
        var categories = await categoriesRepos.getCategories();

        yield CatLoaded(categories);
      } catch (_) {
        yield CatError();
      }
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

// state ----------------------------------------
abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CatLoading extends CategoriesState {
  @override
  List<Object> get props => [];
}

class CatLoaded extends CategoriesState {
  final _categories;

  const CatLoaded(
    this._categories,
  );

  List<CategoriesModel> get getCategories => _categories;

  @override
  List<Object> get props => [_categories];
}

class CatError extends CategoriesState {
  @override
  List<Object> get props => [];
}
