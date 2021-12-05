import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/wishlist_repostory.dart';

class WishListPageBloc extends Bloc<WishListEvent, WishListState> {
  final WishListRepository wishListRespo;

  WishListPageBloc({@required this.wishListRespo}) : super(Loading());

  @override
  Stream<WishListState> mapEventToState(
    WishListEvent event,
  ) async* {
    if (event is Started) {
      try {
        final List<ProductsModel> list = await wishListRespo.fetchWishList();
        print(list);
        yield Loaded(list);
      } catch (_) {
        print(_.toString());

        yield Error();
      }
    } else if (event is Remove) {
      yield Loading();
      try {
        bool status = await wishListRespo.removeFromWishList(event.id);
        if (status == true) {
          final List<ProductsModel> list = await wishListRespo.fetchWishList();
          yield Loaded(list);
        } else {
          yield Error();
        }
      } catch (_) {
        yield Error();
      }
    }
  }
}

//event ---------------------
abstract class WishListEvent extends Equatable {
  const WishListEvent();

  @override
  List<Object> get props => [];
}

class Started extends WishListEvent {
  @override
  List<Object> get props => [];
}

class Remove extends WishListEvent {
  final id;
  Remove(this.id);
  @override
  List<Object> get props => [id];
}

// state ----------------------------------------
abstract class WishListState extends Equatable {
  const WishListState();

  @override
  List<Object> get props => [];
}

class Loading extends WishListState {
  @override
  List<Object> get props => [];
}

class Loaded extends WishListState {
  final wishlist;

  const Loaded(this.wishlist);

  List<ProductsModel> get getWishList => wishlist;

  @override
  List<Object> get props => [wishlist];
}

class Error extends WishListState {
  @override
  List<Object> get props => [];
}
