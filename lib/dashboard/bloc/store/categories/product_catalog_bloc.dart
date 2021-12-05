import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/search/store_search_repos.dart';

class ProductCatalogBloc
    extends Bloc<ProductCatalogEvent, ProductCatalogState> {
  StoreSearchRepository searchRepository;
  ProductCatalogBloc(this.searchRepository) : super(ProCatLoading());

  @override
  Stream<ProductCatalogState> mapEventToState(
    ProductCatalogEvent event,
  ) async* {
    if (event is ProCatStarted) {
      try {
        List<ProductsModel> products =
            await searchRepository.getCatalog(event.name);
        yield ProCatLoaded(products);
      } catch (_) {
        yield ProCatError();
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

class ProCatStarted extends ProductCatalogEvent {
  final name;
  final brandId;
  final productType;
  final shipping_type;
  final min_price;
  final max_price;
  const ProCatStarted(
    this.name,
    this.brandId,
    this.productType,
    this.shipping_type,
    this.min_price,
    this.max_price,
  );
  @override
  List<Object> get props => [
        name,
        brandId,
        productType,
        shipping_type,
        min_price,
        max_price,
      ];
}

// state ----------------------------------------
abstract class ProductCatalogState extends Equatable {
  const ProductCatalogState();

  @override
  List<Object> get props => [];
}

class ProCatLoading extends ProductCatalogState {
  @override
  List<Object> get props => [];
}

class ProCatLoaded extends ProductCatalogState {
  final _products;

  const ProCatLoaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class ProCatError extends ProductCatalogState {
  @override
  List<Object> get props => [];
}
