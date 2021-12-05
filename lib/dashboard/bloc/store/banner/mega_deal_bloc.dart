import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';

class MegaDealsBannerBloc
    extends Bloc<MegeDealsBannerEvent, MegaDealsBannerState> {
  BannersRep bannersRep;
  MegaDealsBannerBloc(this.bannersRep) : super(MegaLoading());

  @override
  Stream<MegaDealsBannerState> mapEventToState(
    MegeDealsBannerEvent event,
  ) async* {
    if (event is MegaStarted) {
      try {
        var banners = await bannersRep.getMegaDealsBanners();

        yield MegaLoaded(banners);
      } catch (_) {
        yield MegaError();
      }
    }
  }
}

//event ---------------------
abstract class MegeDealsBannerEvent extends Equatable {
  const MegeDealsBannerEvent();

  @override
  List<Object> get props => [];
}

class MegaStarted extends MegeDealsBannerEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class MegaDealsBannerState extends Equatable {
  const MegaDealsBannerState();

  @override
  List<Object> get props => [];
}

class MegaLoading extends MegaDealsBannerState {
  @override
  List<Object> get props => [];
}

class MegaLoaded extends MegaDealsBannerState {
  final _banners;

  const MegaLoaded(
    this._banners,
  );

  List<BannersModel> get getBanners => _banners;

  @override
  List<Object> get props => [_banners];
}

class MegaError extends MegaDealsBannerState {
  @override
  List<Object> get props => [];
}
