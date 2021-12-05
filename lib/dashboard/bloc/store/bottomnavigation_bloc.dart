import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class BottomnavigationBloc
    extends Bloc<BottomnavigationEvent, BottomnavigationState> {
  //current page
  int currentIndex = 0;
  BottomnavigationBloc() : super(PageLoading());

  @override
  Stream<BottomnavigationState> mapEventToState(
    BottomnavigationEvent event,
  ) async* {
    if (event is AppStarted) {
      this.add(PageTapped(index: this.currentIndex));
    }

    if (event is PageTapped) {
      this.currentIndex = event.index;
      CurrentIndexChanged(index: currentIndex);
      if (currentIndex == 0) {
        yield FirstPageLoaded();
      } else if (currentIndex == 1) {
        yield SecondPageLoaded();
      } else if (currentIndex == 2) {
        yield ThirdPageLoaded();
      } else if (currentIndex == 3) {
        yield ForthPageLoaded();
      } else if (currentIndex == 4) {
        yield FifthPageLoaded();
      } else if (currentIndex == 5) {
        yield SixthPageLoaded();
      }
    }
  }
}

//event ---------------------
abstract class BottomnavigationEvent extends Equatable {
  const BottomnavigationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends BottomnavigationEvent {
  @override
  List<Object> get props => [];
}

class PageTapped extends BottomnavigationEvent {
  final int index;

  PageTapped({this.index});

  @override
  List<Object> get props => [index];
}

// state ----------------------------------------
abstract class BottomnavigationState extends Equatable {
  const BottomnavigationState();

  @override
  List<Object> get props => [];
}

class BottomNavigationInitial extends BottomnavigationState {
  final int index;
  const BottomNavigationInitial({this.index});
  @override
  List<Object> get props => [index];
}

class CurrentIndexChanged extends BottomnavigationState {
  final int index;
  const CurrentIndexChanged({this.index});
  @override
  List<Object> get props => [index];
}

class PageLoading extends BottomnavigationState {
  @override
  List<Object> get props => [];
}

class FirstPageLoaded extends BottomnavigationState {
  FirstPageLoaded();

  @override
  List<Object> get props => [];
}

class SecondPageLoaded extends BottomnavigationState {
  SecondPageLoaded();

  @override
  List<Object> get props => [];
}

class ThirdPageLoaded extends BottomnavigationState {
  ThirdPageLoaded();

  @override
  List<Object> get props => [];
}

class ForthPageLoaded extends BottomnavigationState {
  ForthPageLoaded();

  @override
  List<Object> get props => [];
}

class FifthPageLoaded extends BottomnavigationState {
  FifthPageLoaded();

  @override
  List<Object> get props => [];
}

class SixthPageLoaded extends BottomnavigationState {
  SixthPageLoaded();

  @override
  List<Object> get props => [];
}
