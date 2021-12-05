import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/repositories/store/checkout/paystackRespo.dart';

class TopUpWalletBloc extends Bloc<TopUpWalletEvent, TopUpWalletState> {
  PaystackRespo paystackRespo;
  TopUpWalletBloc({@required this.paystackRespo}) : super(TopUpWalletLoading());

  @override
  Stream<TopUpWalletState> mapEventToState(
    TopUpWalletEvent event,
  ) async* {
    if (event is TopUpStarted) {
      try {
        Map<String, dynamic> data =
            await paystackRespo.walletTopUp(event.amount);

        yield TopUpWalletSuccess(data: data);
      } catch (e) {
        yield TopUpWalletFailed();
      }
    }
  }
}

//------------------- state
class TopUpWalletState extends Equatable {
  @override
  List<Object> get props => [];
}

class TopUpWalletLoading extends TopUpWalletState {}

class TopUpWalletSuccess extends TopUpWalletState {
  final data;
  TopUpWalletSuccess({@required this.data});
  Map<String, dynamic> get getData => data;
  @override
  List<Object> get props => [data];
}

class TopUpWalletFailed extends TopUpWalletState {}

//------------- event
class TopUpWalletEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TopUpStarted extends TopUpWalletEvent {
  final amount;
  TopUpStarted({@required this.amount});
  @override
  List<Object> get props => [amount];
}
