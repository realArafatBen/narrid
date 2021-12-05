import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/customerview-repos.dart';

class CustomerViewBloc extends Bloc<CustomerViewEvent, CustomerViewState> {
  CustomerViewRepos customerviews;
  CustomerViewBloc(this.customerviews) : super(CustomerLoading());

  @override
  Stream<CustomerViewState> mapEventToState(
    CustomerViewEvent event,
  ) async* {
    if (event is CustomerStarted) {
      try {
        List<ProductsModel> products =
            await customerviews.getProducts(event._id);
        yield CustomerLoaded(products);
      } catch (_) {
        yield CustomerErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class CustomerViewEvent extends Equatable {
  const CustomerViewEvent();

  @override
  List<Object> get props => [];
}

class CustomerStarted extends CustomerViewEvent {
  final _id;
  const CustomerStarted(this._id);
  @override
  List<Object> get props => [_id];
}

// state ----------------------------------------
abstract class CustomerViewState extends Equatable {
  const CustomerViewState();

  @override
  List<Object> get props => [];
}

class CustomerLoading extends CustomerViewState {
  @override
  List<Object> get props => [];
}

class CustomerLoaded extends CustomerViewState {
  final _products;

  const CustomerLoaded(
    this._products,
  );

  List<ProductsModel> get getProducts => _products;
  @override
  List<Object> get props => [_products];
}

class CustomerErrorLoading extends CustomerViewState {
  @override
  List<Object> get props => [];
}
