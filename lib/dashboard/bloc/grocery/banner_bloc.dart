import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';

class BannerStoreBloc extends Bloc<BannerStoreEvent, BannerStoreState> {
  BannersRep bannersRep;
  BannerStoreBloc({@required this.bannersRep}) : super(BannerLoading());

  @override
  Stream<BannerStoreState> mapEventToState(
    BannerStoreEvent event,
  ) async* {
    if (event is BannerStarted) {
      try {
        List<BannersModel> banners = await bannersRep.getBannerStore();
        yield BannerLoaded(banners: banners);
      } catch (_) {
        print(_.toString());
        yield BannerError();
      }
    }
  }
}

//-----------------------------------------------------------------------------
//-------------------------- State --------------------------------------------
class BannerStoreState extends Equatable {
  @override
  List<Object> get props => [];
}

class BannerLoading extends BannerStoreState {}

class BannerLoaded extends BannerStoreState {
  final banners;
  BannerLoaded({@required this.banners});

  List<BannersModel> get getBanners => banners;
  @override
  List<Object> get props => [banners];
}

class BannerError extends BannerStoreState {}

//-----------------------------------------------------------------------------
//----------------------------Event-------------------------------------------
class BannerStoreEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BannerStarted extends BannerStoreEvent {}
