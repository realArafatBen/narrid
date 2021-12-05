import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/models/food/store_model.dart';
import 'package:narrid/dashboard/repositories/food/store/store_repos.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreRepos storeRepos;
  StoreBloc({@required this.storeRepos}) : super(StoreLoading());

  @override
  Stream<StoreState> mapEventToState(
    StoreEvent event,
  ) async* {
    if (event is StoreStarted) {
      try {
        List<StoreFoodModel> stores = await storeRepos.getStores();
        yield StoreLoaded(stores: stores);
      } catch (e) {
        print(e.toString());
        yield StoreError();
      }
    }
  }
}

//---------------------------------------------------------------------------
//----------------------------State-----------------------------------------
class StoreState extends Equatable {
  @override
  List<Object> get props => [];
}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final stores;
  StoreLoaded({@required this.stores});
  List<StoreFoodModel> get getStores => stores;
  @override
  List<Object> get props => [stores];
}

class StoreError extends StoreState {}

//---------------------------------------------------------------------------
//-------------------------Event---------------------------------------------
class StoreEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StoreStarted extends StoreEvent {}
