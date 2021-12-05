import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/grocery/search/store_search_repos.dart';

class ProductCatalogBloc
    extends Bloc<ProductCatalogEvent, ProductCatalogState> {
  GrocerySearchRepository searchRepository;
  ProductCatalogBloc(this.searchRepository) : super(CatLoading());

  @override
  Stream<ProductCatalogState> mapEventToState(
    ProductCatalogEvent event,
  ) async* {
    if (event is CatStarted) {
      try {
        List<ProductsModel> products =
            await searchRepository.getCatalog(event.name);
        yield CatLoaded(products);
      } catch (_) {
        yield CatError();
      }
    }
  }
}

//event ---------------------
abstract class ProductCatalogEvent extends Equatable {
  const ProductCatalogEvent();

  @override
  List<Object> get props => [];
}

class CatStarted extends ProductCatalogEvent {
  final name;
  const CatStarted(this.name);
  @override
  List<Object> get props => [name];
}

// state ----------------------------------------
abstract class ProductCatalogState extends Equatable {
  const ProductCatalogState();

  @override
  List<Object> get props => [];
}

class CatLoading extends ProductCatalogState {
  @override
  List<Object> get props => [];
}

class CatLoaded extends ProductCatalogState {
  final _products;

  const CatLoaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class CatError extends ProductCatalogState {
  @override
  List<Object> get props => [];
}
