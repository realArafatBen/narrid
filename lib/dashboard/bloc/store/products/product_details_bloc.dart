import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/product-details.dart';
import 'package:narrid/dashboard/repositories/store/products/product-details-repos.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsRepos productDetailsRep;
  ProductDetailsBloc(this.productDetailsRep) : super(DetailsLoading());

  @override
  Stream<ProductDetailsState> mapEventToState(
    ProductDetailsEvent event,
  ) async* {
    if (event is DetailsStarted) {
      try {
        ProductDetailsModel details =
            await productDetailsRep.getDetails(event._id);
        yield DetailsLoaded(details);
      } catch (_) {
        yield DetailsErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class DetailsStarted extends ProductDetailsEvent {
  final _id;
  const DetailsStarted(this._id);
  @override
  List<Object> get props => [_id];
}

// state ----------------------------------------
abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

class DetailsLoading extends ProductDetailsState {
  @override
  List<Object> get props => [];
}

class DetailsLoaded extends ProductDetailsState {
  final _details;

  const DetailsLoaded(
    this._details,
  );

  ProductDetailsModel get getDetails => _details;
  @override
  List<Object> get props => [_details];
}

class DetailsErrorLoading extends ProductDetailsState {
  @override
  List<Object> get props => [];
}
