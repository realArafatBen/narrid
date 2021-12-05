import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/repositories/store/products/product-variants-repos.dart';

class ProductColorBloc extends Bloc<ProductColorEvent, ProductColorState> {
  ProductVariantsRepos productVariantsRepos;
  ProductColorBloc(this.productVariantsRepos) : super(ColorLoading());

  @override
  Stream<ProductColorState> mapEventToState(
    ProductColorEvent event,
  ) async* {
    if (event is ColorStarted) {
      try {
        Map<String, dynamic> colors =
            await productVariantsRepos.getColors(event._id);

        yield ColorLoaded(colors);
      } catch (_) {
        yield ColorError();
      }
    } else if (event is ColorSelected) {
      yield ColorLoading();
      try {
        Map<String, dynamic> colors =
            await productVariantsRepos.getColors(event._id);

        yield ColorLoaded(colors);
      } catch (_) {
        yield ColorError();
      }
    }
  }
}

//event ---------------------
abstract class ProductColorEvent extends Equatable {
  const ProductColorEvent();

  @override
  List<Object> get props => [];
}

class ColorStarted extends ProductColorEvent {
  final _id;
  const ColorStarted(this._id);
  @override
  List<Object> get props => [_id];
}

class ColorSelected extends ProductColorEvent {
  final _id;
  const ColorSelected(this._id);
  @override
  List<Object> get props => [_id];
}

// state ----------------------------------------
abstract class ProductColorState extends Equatable {
  const ProductColorState();

  @override
  List<Object> get props => [];
}

class ColorLoading extends ProductColorState {
  @override
  List<Object> get props => [];
}

class ColorLoaded extends ProductColorState {
  final colors;

  const ColorLoaded(
    this.colors,
  );
  Map<String, dynamic> get getColors => colors;
  @override
  List<Object> get props => [colors];
}

class ColorError extends ProductColorState {
  @override
  List<Object> get props => [];
}
