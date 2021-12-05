import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrid/dashboard/repositories/store/products/wishlist_repostory.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  final WishListRepository wishListRepository;

  WishListBloc({@required this.wishListRepository}) : super(WishListLoading());

  @override
  Stream<WishListState> mapEventToState(
    WishListEvent event,
  ) async* {
    if (event is WishListStarted) {
      try {
        bool status = await wishListRepository.checkWishListStatus(event.id);
        if (status == false) {
          yield NotListed();
        } else {
          yield Listed();
        }
      } catch (_) {
        print(_.toString());

        yield WishListError();
      }
    } else if (event is WishListAdd) {
      try {
        bool status = await wishListRepository.addToWishList(event.id);
        if (status == false) {
          yield NotListed();
        } else {
          yield Listed();
        }
      } catch (_) {
        yield WishListError();
      }
    } else if (event is WishListRemove) {
      try {
        bool status = await wishListRepository.removeFromWishList(event.id);
        if (status == true) {
          yield NotListed();
        } else {}
      } catch (_) {
        yield WishListError();
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

class WishListStarted extends WishListEvent {
  final id;
  WishListStarted(this.id);
  @override
  List<Object> get props => [id];
}

class WishListAdd extends WishListEvent {
  final id;
  WishListAdd(this.id);
  @override
  List<Object> get props => [id];
}

class WishListRemove extends WishListEvent {
  final id;
  WishListRemove(this.id);
  @override
  List<Object> get props => [id];
}

// state ----------------------------------------
abstract class WishListState extends Equatable {
  const WishListState();

  @override
  List<Object> get props => [];
}

class WishListLoading extends WishListState {
  @override
  List<Object> get props => [];
}

class NotListed extends WishListState {
  @override
  List<Object> get props => [];
}

class Listed extends WishListState {
  @override
  List<Object> get props => [];
}

class WishListError extends WishListState {
  @override
  List<Object> get props => [];
}
