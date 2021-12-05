import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/categories/subcategories.dart';

class SubCategoriesBloc extends Bloc<SubCategoriesEvent, SubCategoriesState> {
  SubCategoriesRepos categoriesRepos;
  SubCategoriesBloc(this.categoriesRepos) : super(CatLoading());

  @override
  Stream<SubCategoriesState> mapEventToState(
    SubCategoriesEvent event,
  ) async* {
    if (event is AppStartedCat) {
      try {
        var categories = await categoriesRepos.getCategories(event._catId);

        yield CatLoaded(categories);
      } catch (_) {
        yield CatErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class SubCategoriesEvent extends Equatable {
  const SubCategoriesEvent();

  @override
  List<Object> get props => [];
}

class AppStartedCat extends SubCategoriesEvent {
  final _catId;
  const AppStartedCat(this._catId);
  @override
  List<Object> get props => [_catId];
}

// state ----------------------------------------
abstract class SubCategoriesState extends Equatable {
  const SubCategoriesState();

  @override
  List<Object> get props => [];
}

class CatLoading extends SubCategoriesState {
  @override
  List<Object> get props => [];
}

class CatLoaded extends SubCategoriesState {
  final _categories;

  const CatLoaded(
    this._categories,
  );

  List<CategoriesModel> get getCategories => _categories;

  @override
  List<Object> get props => [_categories];
}

class CatErrorLoading extends SubCategoriesState {
  @override
  List<Object> get props => [];
}
