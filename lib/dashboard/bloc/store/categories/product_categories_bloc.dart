import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/categories/product-category.dart';

class ProductCategoriesBloc
    extends Bloc<ProductCategoriesEvent, ProductCategoriesState> {
  ProductCategoriesRepos productCategoriesRepos;
  ProductCategoriesBloc(this.productCategoriesRepos) : super(CatVLoading());

  @override
  Stream<ProductCategoriesState> mapEventToState(
    ProductCategoriesEvent event,
  ) async* {
    if (event is CatVStarted) {
      try {
        List<ProductsModel> products = await productCategoriesRepos.getProducts(
          event._id,
          event.brandId,
          event.max_price,
          event.min_price,
          event.productType,
          event.shipping_type,
        );
        yield CatVLoaded(products);
      } catch (_) {
        yield CatVErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class ProductCategoriesEvent extends Equatable {
  const ProductCategoriesEvent();

  @override
  List<Object> get props => [];
}

class CatVStarted extends ProductCategoriesEvent {
  final _id;
  final brandId;
  final productType;
  final shipping_type;
  final min_price;
  final max_price;

  const CatVStarted(
    this._id,
    this.brandId,
    this.productType,
    this.shipping_type,
    this.min_price,
    this.max_price,
  );
  @override
  List<Object> get props => [
        _id,
        brandId,
        productType,
        shipping_type,
        min_price,
        max_price,
      ];
}

// state ----------------------------------------
abstract class ProductCategoriesState extends Equatable {
  const ProductCategoriesState();

  @override
  List<Object> get props => [];
}

class CatVLoading extends ProductCategoriesState {
  @override
  List<Object> get props => [];
}

class CatVLoaded extends ProductCategoriesState {
  final _products;

  const CatVLoaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class CatVErrorLoading extends ProductCategoriesState {
  @override
  List<Object> get props => [];
}
