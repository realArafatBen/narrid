import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';

class BannerFoodBloc extends Bloc<BannerEvent, BannerState> {
  BannersRep bannersRep;
  BannerFoodBloc({@required this.bannersRep}) : super(BannerLoading());

  @override
  Stream<BannerState> mapEventToState(
    BannerEvent event,
  ) async* {
    if (event is BannerStarted) {
      try {
        List<BannersModel> banner = await bannersRep.getBannerFood();
        yield BannerLoaded(banner: banner);
      } catch (_) {
        print(_.toString());
        yield BannerError();
      }
    }
  }
}

//-----------------------------------------------------------------------------
//-------------------------- State --------------------------------------------
class BannerState extends Equatable {
  @override
  List<Object> get props => [];
}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final banner;
  BannerLoaded({@required this.banner});

  List<BannersModel> get getBanners => banner;
  @override
  List<Object> get props => [banner];
}

class BannerError extends BannerState {}

//-----------------------------------------------------------------------------
//----------------------------Event-------------------------------------------
class BannerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BannerStarted extends BannerEvent {}
