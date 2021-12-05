import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class MemberLevelGuideBloc
    extends Bloc<MemberLevelGuideEvent, MemberLevelGuideState> {
  UserRepository userRepository;
  MemberLevelGuideBloc({@required this.userRepository})
      : super(MemberLevelLoading());

  @override
  Stream<MemberLevelGuideState> mapEventToState(
    MemberLevelGuideEvent event,
  ) async* {
    if (event is MemberLevelStarted) {
      try {
        List<dynamic> data = await userRepository.getMemberLevel();
        yield MemberLevelLoaded(data: data);
      } catch (e) {
        yield MemberLevelError();
      }
    }
  }
}

// state
class MemberLevelGuideState extends Equatable {
  @override
  List<Object> get props => [];
}

class MemberLevelLoading extends MemberLevelGuideState {}

class MemberLevelLoaded extends MemberLevelGuideState {
  final data;
  MemberLevelLoaded({@required this.data});

  List<dynamic> get getData => data;
  @override
  List<Object> get props => [data];
}

class MemberLevelError extends MemberLevelGuideState {}

//event
class MemberLevelGuideEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MemberLevelStarted extends MemberLevelGuideEvent {}
