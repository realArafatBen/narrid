import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';

class AdsBannerBloc extends Bloc<AdsBannerEvent, AdsBannerState> {
  BannersRep bannersRep;
  AdsBannerBloc(this.bannersRep) : super(AdsLoading());

  @override
  Stream<AdsBannerState> mapEventToState(
    AdsBannerEvent event,
  ) async* {
    if (event is AdsStarted) {
      try {
        var banners = await bannersRep.getAdsBanners();

        yield AdsLoaded(banners);
      } catch (_) {
        yield AdsError();
      }
    }
  }
}

//event ---------------------
abstract class AdsBannerEvent extends Equatable {
  const AdsBannerEvent();

  @override
  List<Object> get props => [];
}

class AdsStarted extends AdsBannerEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class AdsBannerState extends Equatable {
  const AdsBannerState();

  @override
  List<Object> get props => [];
}

class AdsLoading extends AdsBannerState {
  @override
  List<Object> get props => [];
}

class AdsLoaded extends AdsBannerState {
  final _banners;

  const AdsLoaded(
    this._banners,
  );

  List<BannersModel> get getBanners => _banners;

  @override
  List<Object> get props => [_banners];
}

class AdsError extends AdsBannerState {
  @override
  List<Object> get props => [];
}
