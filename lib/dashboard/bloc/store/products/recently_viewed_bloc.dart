import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/product-repository.dart';

class RecentlyViewedBloc extends Bloc<RecentlyViewedEvent, RecentlyViewState> {
  ProductRepository productRepository;

  RecentlyViewedBloc({@required this.productRepository})
      : super(RecentlyViewLoading());

  @override
  Stream<RecentlyViewState> mapEventToState(
    RecentlyViewedEvent event,
  ) async* {
    if (event is RecentlyViewStarted) {
      try {
        List<ProductsModel> products =
            await productRepository.getViewedProduct();
        yield RecentlyViewLoaded(products: products);
      } catch (_) {
        yield RecentlyViewError();
      }
    }
  }
}

/// state
class RecentlyViewState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecentlyViewLoading extends RecentlyViewState {}

class RecentlyViewError extends RecentlyViewState {}

class RecentlyViewLoaded extends RecentlyViewState {
  final products;
  RecentlyViewLoaded({@required this.products});

  List<ProductsModel> get getProducts => products;
  @override
  List<Object> get props => [products];
}

//event
class RecentlyViewedEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RecentlyViewStarted extends RecentlyViewedEvent {}
