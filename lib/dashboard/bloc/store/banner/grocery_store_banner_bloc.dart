import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';

class GroceryStoreBannerBloc
    extends Bloc<GroceryStoreBannerEvent, GroceryStoreBannerState> {
  BannersRep bannersRep;
  GroceryStoreBannerBloc(this.bannersRep) : super(GroceryStoreLoading());

  @override
  Stream<GroceryStoreBannerState> mapEventToState(
    GroceryStoreBannerEvent event,
  ) async* {
    if (event is GroceryStoreStarted) {
      try {
        var banners = await bannersRep.getGroceryStoreFashionBanners();

        yield GroceryStoreLoaded(banners);
      } catch (_) {
        yield GroceryStoreError();
      }
    }
  }
}

//event ---------------------
abstract class GroceryStoreBannerEvent extends Equatable {
  const GroceryStoreBannerEvent();

  @override
  List<Object> get props => [];
}

class GroceryStoreStarted extends GroceryStoreBannerEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class GroceryStoreBannerState extends Equatable {
  const GroceryStoreBannerState();

  @override
  List<Object> get props => [];
}

class GroceryStoreLoading extends GroceryStoreBannerState {
  @override
  List<Object> get props => [];
}

class GroceryStoreLoaded extends GroceryStoreBannerState {
  final _banners;

  const GroceryStoreLoaded(
    this._banners,
  );

  List<BannersModel> get getBanners => _banners;

  @override
  List<Object> get props => [_banners];
}

class GroceryStoreError extends GroceryStoreBannerState {
  @override
  List<Object> get props => [];
}
