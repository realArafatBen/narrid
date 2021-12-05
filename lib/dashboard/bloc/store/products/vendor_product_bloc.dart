import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/categories/product-category.dart';

class VendorProductBloc extends Bloc<VendorProductEvent, VendorProductState> {
  ProductCategoriesRepos productCategoriesRepos;
  VendorProductBloc(this.productCategoriesRepos) : super(Loading());

  @override
  Stream<VendorProductState> mapEventToState(
    VendorProductEvent event,
  ) async* {
    if (event is Started) {
      try {
        List<ProductsModel> products =
            await productCategoriesRepos.getVendorProducts(event._id);
        yield Loaded(products);
      } catch (_) {
        yield ErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class VendorProductEvent extends Equatable {
  const VendorProductEvent();

  @override
  List<Object> get props => [];
}

class Started extends VendorProductEvent {
  final _id;
  const Started(this._id);
  @override
  List<Object> get props => [_id];
}

// state ----------------------------------------
abstract class VendorProductState extends Equatable {
  const VendorProductState();

  @override
  List<Object> get props => [];
}

class Loading extends VendorProductState {
  @override
  List<Object> get props => [];
}

class Loaded extends VendorProductState {
  final _products;

  const Loaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class ErrorLoading extends VendorProductState {
  @override
  List<Object> get props => [];
}
