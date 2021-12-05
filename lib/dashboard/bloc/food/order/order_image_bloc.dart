import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/food/orders_repos.dart';

class FoodOrderImageBloc extends Bloc<OrderEvent, OrderState> {
  final FoodOrdersRepository ordersRepository;

  FoodOrderImageBloc({@required this.ordersRepository}) : super(ImageLoading());

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is ImageStarted) {
      try {
        String image = await ordersRepository.fetchImage(event.id);
        // print(image);
        yield ImageLoaded(image);
      } catch (_) {
        print(_.toString());

        yield ImageError();
      }
    }
  }
}

//event ---------------------
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class ImageStarted extends OrderEvent {
  final id;
  ImageStarted({@required this.id});
  @override
  List<Object> get props => [id];
}

// state ----------------------------------------
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class ImageLoading extends OrderState {
  @override
  List<Object> get props => [];
}

class ImageLoaded extends OrderState {
  final image;

  const ImageLoaded(this.image);

  String get getImage => image;

  @override
  List<Object> get props => [image];
}

class ImageError extends OrderState {
  @override
  List<Object> get props => [];
}
