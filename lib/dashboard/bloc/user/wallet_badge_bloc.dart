import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class WalletBadgeBloc extends Bloc<WalletBadgeEvent, WalletBadgeState> {
  UserRepository userRepos;
  WalletBadgeBloc({@required this.userRepos}) : super(WalletBadgeLoading());

  @override
  Stream<WalletBadgeState> mapEventToState(
    WalletBadgeEvent event,
  ) async* {
    if (event is WalletBadgeStarted) {
      try {
        Map<String, dynamic> data = await userRepos.getWalletBadge();
        yield WalletBadgeLoaded(data: data);
      } catch (_) {
        yield WalletBadgeError();
      }
    }
  }
}

//------------------ state
class WalletBadgeState extends Equatable {
  @override
  List<Object> get props => [];
}

class WalletBadgeLoading extends WalletBadgeState {}

class WalletBadgeError extends WalletBadgeState {}

class WalletBadgeLoaded extends WalletBadgeState {
  final data;
  WalletBadgeLoaded({@required this.data});
  Map<String, dynamic> get getData => data;
  @override
  List<Object> get props => [data];
}

//----------------- event
class WalletBadgeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class WalletBadgeStarted extends WalletBadgeEvent {}
