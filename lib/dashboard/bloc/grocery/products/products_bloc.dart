import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/grocery/products/products_repos.dart';

class GroceryProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  GroceryProductRep groceryProductRep;

  GroceryProductsBloc(this.groceryProductRep) : super(ProductLoading());

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is ProductStarted) {
      try {
        List<ProductsModel> products =
            await groceryProductRep.fetchProducts(event.id, event.storeId);
        yield ProductLoaded(products);
      } catch (_) {
        yield ProductError();
      }
    }
  }
}

//event ---------------------
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductStarted extends ProductsEvent {
  final id;
  final storeId;
  ProductStarted({@required this.id, @required this.storeId});
  @override
  List<Object> get props => [id, storeId];
}

class CartRemove extends ProductsEvent {
  final String id;

  const CartRemove({this.id});

  @override
  List<Object> get props => [id];
}

// state ----------------------------------------
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductsState {
  @override
  List<Object> get props => [];
}

class ProductLoaded extends ProductsState {
  final _products;
  const ProductLoaded(this._products);

  List<ProductsModel> get getProducts => _products;

  @override
  List<Object> get props => [_products];
}

class ProductError extends ProductsState {
  @override
  List<Object> get props => [];
}
