import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/product-variants.dart';
import 'package:narrid/dashboard/repositories/store/products/product-variants-repos.dart';

class ProductVariantsBloc
    extends Bloc<ProductVariantsEvent, ProductVariantsState> {
  ProductVariantsRepos productVariantsRepos;
  ProductVariantsBloc(this.productVariantsRepos) : super(VariantLoading());

  @override
  Stream<ProductVariantsState> mapEventToState(
    ProductVariantsEvent event,
  ) async* {
    if (event is VariantStarted) {
      try {
        List<ProductVariantsModel> variant =
            await productVariantsRepos.getVariants(event._id);

        yield VariantLoaded(variant);
      } catch (_) {
        yield VariantErrorLoading();
      }
    } else if (event is VariantSelected) {
      try {
        List<ProductVariantsModel> variant =
            await productVariantsRepos.getVariants(event._id);

        yield VariantLoaded(variant);
      } catch (_) {
        yield VariantErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class ProductVariantsEvent extends Equatable {
  const ProductVariantsEvent();

  @override
  List<Object> get props => [];
}

class VariantStarted extends ProductVariantsEvent {
  final _id;
  const VariantStarted(this._id);
  @override
  List<Object> get props => [_id];
}

class VariantSelected extends ProductVariantsEvent {
  final _id;
  const VariantSelected(this._id);
  @override
  List<Object> get props => [_id];
}

// state ----------------------------------------
abstract class ProductVariantsState extends Equatable {
  const ProductVariantsState();

  @override
  List<Object> get props => [];
}

class VariantLoading extends ProductVariantsState {
  @override
  List<Object> get props => [];
}

class VariantLoaded extends ProductVariantsState {
  final _variant;

  const VariantLoaded(
    this._variant,
  );

  List<ProductVariantsModel> get getVariants => _variant;
  @override
  List<Object> get props => [_variant];
}

class VariantErrorLoading extends ProductVariantsState {
  @override
  List<Object> get props => [];
}
