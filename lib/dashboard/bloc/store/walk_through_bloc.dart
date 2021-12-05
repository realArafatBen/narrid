import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/repositories/store/walkthrough_repositories.dart';

class WalkThroughBloc extends Bloc<WalkThroughEvent, WalkThroughState> {
  WalkThroughRepositories walkThroughRepositories;
  WalkThroughBloc({@required this.walkThroughRepositories})
      : super(WalkThroughLoading());

  @override
  Stream<WalkThroughState> mapEventToState(WalkThroughEvent event) async* {
    if (event is WalkThroughStarted) {
      try {
        //check if walk through
        bool status = await walkThroughRepositories.hasWalkThrough();
        if (status) {
          yield WalkThroughSet();
        } else {
          yield WalkThroughNotSet();
        }
      } catch (e) {
        yield WalkThroughError();
      }
    } else if (event is WalkThroughDone) {
      //setWalk through
      await walkThroughRepositories.setWalkThrough();
      yield WalkThroughSet();
    }
  }
}

//event --------------------------------------
class WalkThroughState extends Equatable {
  @override
  List<Object> get props => [];
}

class WalkThroughLoading extends WalkThroughState {}

class WalkThroughNotSet extends WalkThroughState {}

class WalkThroughSet extends WalkThroughState {}

class WalkThroughError extends WalkThroughState {}

//state --------------------------------------

class WalkThroughEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class WalkThroughStarted extends WalkThroughEvent {}

class WalkThroughDone extends WalkThroughEvent {}
