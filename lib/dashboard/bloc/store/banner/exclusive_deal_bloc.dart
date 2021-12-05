import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';

class ExclusiveDealsBannerBloc
    extends Bloc<ExclusiveDealsBannerEvent, ExclusiveDealsBannerState> {
  BannersRep bannersRep;
  ExclusiveDealsBannerBloc(this.bannersRep) : super(ExclusiveLoading());

  @override
  Stream<ExclusiveDealsBannerState> mapEventToState(
    ExclusiveDealsBannerEvent event,
  ) async* {
    if (event is ExclusiveStarted) {
      try {
        var banners = await bannersRep.getExclusiveDealsBanners();

        yield ExclusiveLoaded(banners);
      } catch (_) {
        yield ExclusiveError();
      }
    }
  }
}

//event ---------------------
abstract class ExclusiveDealsBannerEvent extends Equatable {
  const ExclusiveDealsBannerEvent();

  @override
  List<Object> get props => [];
}

class ExclusiveStarted extends ExclusiveDealsBannerEvent {
  @override
  List<Object> get props => [];
}

// state ----------------------------------------
abstract class ExclusiveDealsBannerState extends Equatable {
  const ExclusiveDealsBannerState();

  @override
  List<Object> get props => [];
}

class ExclusiveLoading extends ExclusiveDealsBannerState {
  @override
  List<Object> get props => [];
}

class ExclusiveLoaded extends ExclusiveDealsBannerState {
  final _banners;

  const ExclusiveLoaded(
    this._banners,
  );

  List<BannersModel> get getBanners => _banners;

  @override
  List<Object> get props => [_banners];
}

class ExclusiveError extends ExclusiveDealsBannerState {
  @override
  List<Object> get props => [];
}
