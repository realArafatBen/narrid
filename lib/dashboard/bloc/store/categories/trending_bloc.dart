import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/categories/trending-repos.dart';

class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  TrendingRepos trendingRepos;
  TrendingBloc(this.trendingRepos) : super(TrendLoading());

  @override
  Stream<TrendingState> mapEventToState(
    TrendingEvent event,
  ) async* {
    if (event is TrendStarted) {
      try {
        List<ProductsModel> products = await trendingRepos.getProducts(
            event.categoryId,
            event.brandId,
            event.productType,
            event.shipping_type,
            event.min_price,
            event.max_price);
        yield TrendLoaded(products);
      } catch (_) {
        yield TrendErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class TrendingEvent extends Equatable {
  const TrendingEvent();

  @override
  List<Object> get props => [];
}

class TrendStarted extends TrendingEvent {
  final categoryId, brandId, productType, shipping_type, min_price, max_price;

  TrendStarted(
    this.categoryId,
    this.brandId,
    this.productType,
    this.shipping_type,
    this.min_price,
    this.max_price,
  );
  @override
  List<Object> get props => [
        categoryId,
        brandId,
        productType,
        shipping_type,
        min_price,
        max_price,
      ];
}

// state ----------------------------------------
abstract class TrendingState extends Equatable {
  const TrendingState();

  @override
  List<Object> get props => [];
}

class TrendLoading extends TrendingState {
  @override
  List<Object> get props => [];
}

class TrendLoaded extends TrendingState {
  final _products;

  const TrendLoaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class TrendErrorLoading extends TrendingState {
  @override
  List<Object> get props => [];
}
