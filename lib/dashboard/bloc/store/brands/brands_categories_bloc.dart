import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/product-repository.dart';

class BrandsCategoriesBloc
    extends Bloc<BrandsCategoriesEvent, BrandsCategoriesState> {
  ProductRepository productRepository;
  BrandsCategoriesBloc(this.productRepository) : super(BrandsCatLoading());

  @override
  Stream<BrandsCategoriesState> mapEventToState(
    BrandsCategoriesEvent event,
  ) async* {
    if (event is BrandsCatStarted) {
      yield BrandsCatLoading();
      try {
        List<ProductsModel> products = await productRepository.getProductsBrand(
          event._id,
          event.categoryId,
          event.max_price,
          event.min_price,
          event.productType,
          event.shipping_type,
        );
        yield BrandsCatLoaded(products);
      } catch (_) {
        yield BrandsCatErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class BrandsCategoriesEvent extends Equatable {
  const BrandsCategoriesEvent();

  @override
  List<Object> get props => [];
}

class BrandsCatStarted extends BrandsCategoriesEvent {
  final _id;
  final productType;
  final categoryId;
  final shipping_type;
  final min_price;
  final max_price;

  const BrandsCatStarted(
    this._id,
    this.productType,
    this.categoryId,
    this.shipping_type,
    this.min_price,
    this.max_price,
  );
  @override
  List<Object> get props => [
        _id,
        productType,
        categoryId,
        shipping_type,
        min_price,
        max_price,
      ];
}

// state ----------------------------------------
abstract class BrandsCategoriesState extends Equatable {
  const BrandsCategoriesState();

  @override
  List<Object> get props => [];
}

class BrandsCatLoading extends BrandsCategoriesState {
  @override
  List<Object> get props => [];
}

class BrandsCatLoaded extends BrandsCategoriesState {
  final _products;

  const BrandsCatLoaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class BrandsCatErrorLoading extends BrandsCategoriesState {
  @override
  List<Object> get props => [];
}
