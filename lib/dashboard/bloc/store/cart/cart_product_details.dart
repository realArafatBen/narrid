import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';

class CartProductDetailsBloc
    extends Bloc<CartProductDEvent, CartProductDState> {
  CartRepository cartRepository;
  CartProductDetailsBloc({@required this.cartRepository}) : super(DLoading());

  @override
  Stream<CartProductDState> mapEventToState(
    CartProductDEvent event,
  ) async* {
    if (event is DStarted) {
      try {
        Map<String, dynamic> data =
            await cartRepository.getProductDetails(event.id);
        yield DLoaded(data: data);
      } catch (e) {
        yield DError();
      }
    }
  }
}

// --- state
class CartProductDState extends Equatable {
  @override
  List<Object> get props => [];
}

class DLoading extends CartProductDState {}

class DError extends CartProductDState {}

class DLoaded extends CartProductDState {
  final data;
  DLoaded({@required this.data});
  Map<String, dynamic> get getData => data;
  @override
  List<Object> get props => [data];
}

//---- event
class CartProductDEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DStarted extends CartProductDEvent {
  final id;
  DStarted({@required this.id});
  @override
  List<Object> get props => [id];
}
