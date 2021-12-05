import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';

class WomenFashionBannerBloc
    extends Bloc<WomenFashionBannerEvent, WomenFashionBannerState> {
  BannersRep bannersRep;
  WomenFashionBannerBloc(this.bannersRep) : super(WomenLoading());

  @override
  Stream<WomenFashionBannerState> mapEventToState(
    WomenFashionBannerEvent event,
  ) async* {
    if (event is WomenStarted) {
      try {
        var banners = await bannersRep.getWomenFashionBanners();

        yield WomenLoaded(banners);
      } catch (_) {
        yield WomenError();
      }
    }
  }
}

//event ---------------------
abstract class WomenFashionBannerEvent extends Equatable {
  const WomenFashionBannerEvent();

  @override
  List<Object> get props => [];
}

class WomenStarted extends WomenFashionBannerEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class WomenFashionBannerState extends Equatable {
  const WomenFashionBannerState();

  @override
  List<Object> get props => [];
}

class WomenLoading extends WomenFashionBannerState {
  @override
  List<Object> get props => [];
}

class WomenLoaded extends WomenFashionBannerState {
  final _banners;

  const WomenLoaded(
    this._banners,
  );

  List<BannersModel> get getBanners => _banners;

  @override
  List<Object> get props => [_banners];
}

class WomenError extends WomenFashionBannerState {
  @override
  List<Object> get props => [];
}
