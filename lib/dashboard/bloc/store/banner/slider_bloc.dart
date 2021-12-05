import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';

class SliderBannerBloc extends Bloc<SliderBannerEvent, SliderBannerState> {
  BannersRep bannersRep;
  SliderBannerBloc(this.bannersRep) : super(Loading());

  @override
  Stream<SliderBannerState> mapEventToState(
    SliderBannerEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        var banners = await bannersRep.getBanners();

        yield Loaded(banners);
      } catch (_) {
        yield ErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class SliderBannerEvent extends Equatable {
  const SliderBannerEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends SliderBannerEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class SliderBannerState extends Equatable {
  const SliderBannerState();

  @override
  List<Object> get props => [];
}

class Loading extends SliderBannerState {
  @override
  List<Object> get props => [];
}

class Loaded extends SliderBannerState {
  final _banners;

  const Loaded(
    this._banners,
  );

  List<BannersModel> get getBanners => _banners;

  @override
  List<Object> get props => [_banners];
}

class ErrorLoading extends SliderBannerState {
  @override
  List<Object> get props => [];
}
