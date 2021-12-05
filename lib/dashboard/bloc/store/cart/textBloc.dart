import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(Loading());

  @override
  Stream<TestState> mapEventToState(
    TestEvent event,
  ) {
    if (event is TestStarted) {
      print("Hello");
    }
  }
}

class TestState extends Equatable {
  @override
  List<Object> get props => [];
}

class Loading extends TestState {}

class TestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TestStarted extends TestEvent {}
