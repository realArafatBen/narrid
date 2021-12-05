import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';

class MenFashionBannerBloc
    extends Bloc<MenFashionBannerEvent, MenFashionBannerState> {
  BannersRep bannersRep;
  MenFashionBannerBloc(this.bannersRep) : super(MenLoading());

  @override
  Stream<MenFashionBannerState> mapEventToState(
    MenFashionBannerEvent event,
  ) async* {
    if (event is MenStarted) {
      try {
        var banners = await bannersRep.getMenFashionBanners();

        yield MenLoaded(banners);
      } catch (_) {
        yield MenError();
      }
    }
  }
}

//event ---------------------
abstract class MenFashionBannerEvent extends Equatable {
  const MenFashionBannerEvent();

  @override
  List<Object> get props => [];
}

class MenStarted extends MenFashionBannerEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class MenFashionBannerState extends Equatable {
  const MenFashionBannerState();

  @override
  List<Object> get props => [];
}

class MenLoading extends MenFashionBannerState {
  @override
  List<Object> get props => [];
}

class MenLoaded extends MenFashionBannerState {
  final _banners;

  const MenLoaded(
    this._banners,
  );

  List<BannersModel> get getBanners => _banners;

  @override
  List<Object> get props => [_banners];
}

class MenError extends MenFashionBannerState {
  @override
  List<Object> get props => [];
}
