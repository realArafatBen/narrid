import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/repositories/store/products/product-images.dart';

class ProductImagesBloc extends Bloc<ProductImagesEvent, ProductImagesState> {
  ProductImageRep productImageRep;
  ProductImagesBloc(this.productImageRep) : super(Loading());

  @override
  Stream<ProductImagesState> mapEventToState(
    ProductImagesEvent event,
  ) async* {
    if (event is ImageStarted) {
      try {
        List<dynamic> images = await productImageRep.getImages(event._id);
        yield Loaded(images);
      } catch (_) {
        yield ErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class ProductImagesEvent extends Equatable {
  const ProductImagesEvent();

  @override
  List<Object> get props => [];
}

class ImageStarted extends ProductImagesEvent {
  final _id;
  const ImageStarted(this._id);
  @override
  List<Object> get props => [_id];
}

// state ----------------------------------------
abstract class ProductImagesState extends Equatable {
  const ProductImagesState();

  @override
  List<Object> get props => [];
}

class Loading extends ProductImagesState {
  @override
  List<Object> get props => [];
}

class Loaded extends ProductImagesState {
  final _images;

  const Loaded(
    this._images,
  );

  List<dynamic> get getImages => _images;
  @override
  List<Object> get props => [_images];
}

class ErrorLoading extends ProductImagesState {
  @override
  List<Object> get props => [];
}
