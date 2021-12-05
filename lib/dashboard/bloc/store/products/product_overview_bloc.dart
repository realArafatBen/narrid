import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/product-overview.dart';
import 'package:narrid/dashboard/repositories/store/products/product-overview-repos.dart';

class ProductOverviewBloc
    extends Bloc<ProductOverviewEvent, ProductOverviewState> {
  ProductOverviewRepos productOverviewRepos;
  ProductOverviewBloc(this.productOverviewRepos) : super(OverviewLoading());

  @override
  Stream<ProductOverviewState> mapEventToState(
    ProductOverviewEvent event,
  ) async* {
    if (event is OverviewStarted) {
      try {
        ProductOverviewModel overviews =
            await productOverviewRepos.getOverviews(event._id);
        yield OverviewLoaded(overviews);
      } catch (_) {
        yield OverviewErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class ProductOverviewEvent extends Equatable {
  const ProductOverviewEvent();

  @override
  List<Object> get props => [];
}

class OverviewStarted extends ProductOverviewEvent {
  final _id;
  const OverviewStarted(this._id);
  @override
  List<Object> get props => [_id];
}

// state ----------------------------------------
abstract class ProductOverviewState extends Equatable {
  const ProductOverviewState();

  @override
  List<Object> get props => [];
}

class OverviewLoading extends ProductOverviewState {
  @override
  List<Object> get props => [];
}

class OverviewLoaded extends ProductOverviewState {
  final _overviews;

  const OverviewLoaded(
    this._overviews,
  );

  ProductOverviewModel get getOverviews => _overviews;
  @override
  List<Object> get props => [_overviews];
}

class OverviewErrorLoading extends ProductOverviewState {
  @override
  List<Object> get props => [];
}
