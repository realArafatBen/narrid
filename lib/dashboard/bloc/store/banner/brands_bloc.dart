import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';

class BrandsBannerBloc extends Bloc<BrandsBannerEvent, BrandsBannerState> {
  BannersRep bannersRep;
  BrandsBannerBloc({@required this.bannersRep}) : super(BrandsBannerLoading());

  @override
  Stream<BrandsBannerState> mapEventToState(BrandsBannerEvent event) async* {
    if (event is BrandsBannerStarted) {
      try {
        List<dynamic> brands = await bannersRep.getBrandsBanner();
        yield BrandsBannerLoaded(brands: brands);
      } catch (e) {
        print(e.toString());
        yield BrandsBannerError();
      }
    }
  }
}

//State
class BrandsBannerState extends Equatable {
  @override
  List<Object> get props => [];
}

class BrandsBannerLoading extends BrandsBannerState {}

class BrandsBannerLoaded extends BrandsBannerState {
  final brands;
  BrandsBannerLoaded({@required this.brands});
  List<dynamic> get getBrandsBanner => brands;
  @override
  List<Object> get props => [brands];
}

class BrandsBannerError extends BrandsBannerState {}

//event
class BrandsBannerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BrandsBannerStarted extends BrandsBannerEvent {}
