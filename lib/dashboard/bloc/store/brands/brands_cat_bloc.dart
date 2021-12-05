import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/repositories/store/brands/brands_repository.dart';

class BrandCatBloc extends Bloc<BrandCatEvent, BrandCatState> {
  BrandsRepository brandsRepository;
  BrandCatBloc({@required this.brandsRepository}) : super(BrandCatLoading());

  @override
  Stream<BrandCatState> mapEventToState(BrandCatEvent event) async* {
    if (event is BrandCatStarted) {
      try {
        List<dynamic> brands = await brandsRepository.getBrands(event.id);
        yield BrandCatLoaded(brands);
      } catch (_) {
        yield BrandCatError();
      }
    }
  }
}

//state
class BrandCatState extends Equatable {
  @override
  List<Object> get props => [];
}

class BrandCatLoading extends BrandCatState {}

class BrandCatLoaded extends BrandCatState {
  final brands;
  BrandCatLoaded(this.brands);
  List<dynamic> get getBrand => brands;
  @override
  List<Object> get props => [brands];
}

class BrandCatError extends BrandCatState {}

//event
class BrandCatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BrandCatStarted extends BrandCatEvent {
  final id;
  BrandCatStarted({@required this.id});
  @override
  List<Object> get props => [id];
}
