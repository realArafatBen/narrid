import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/models/food/food_feature_model.dart';
import 'package:narrid/dashboard/repositories/grocery/products/products_repos.dart';

class FeatureGroceryProductBloc
    extends Bloc<FeatureProductEvent, FeatureProductState> {
  GroceryProductRep groceryProductRep;
  FeatureGroceryProductBloc({@required this.groceryProductRep})
      : super(FeatureLoading());

  @override
  Stream<FeatureProductState> mapEventToState(
    FeatureProductEvent event,
  ) async* {
    if (event is FeatureStarted) {
      try {
        List<FeatureFoodModel> products =
            await groceryProductRep.getFeatureProducts();
        yield FeatureLoaded(products: products);
      } catch (_) {
        yield FeatureError();
      }
    }
  }
}

//--------------------------- state
class FeatureProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class FeatureLoading extends FeatureProductState {}

class FeatureLoaded extends FeatureProductState {
  final products;
  FeatureLoaded({@required this.products});
  List<FeatureFoodModel> get getProducts => products;
  @override
  List<Object> get props => [products];
}

class FeatureError extends FeatureProductState {}

//-------------------------------- event

class FeatureProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FeatureStarted extends FeatureProductEvent {}
