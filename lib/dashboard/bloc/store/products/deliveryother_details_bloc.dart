import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:narrid/dashboard/models/store/products/deliveryothers-details.dart';
import 'package:narrid/dashboard/repositories/store/products/deliveryothers-details-repos.dart';

class DeliveryOthersDetailsBloc
    extends Bloc<DeliveryOthersDetailsEvent, DeliveryOthersDetailsState> {
  DeliveryOthersRepos deliveryOthersRepos;
  DeliveryOthersDetailsBloc(this.deliveryOthersRepos)
      : super(DeliveryLoading());

  @override
  Stream<DeliveryOthersDetailsState> mapEventToState(
    DeliveryOthersDetailsEvent event,
  ) async* {
    if (event is DeliveryStarted) {
      try {
        DeliveryOtherDetailsModel details =
            await deliveryOthersRepos.getDetails(event._id);
        yield DeliveryLoaded(details);
      } catch (_) {
        yield DeliveryErrorLoading();
      }
    }
  }
}

//event ---------------------
abstract class DeliveryOthersDetailsEvent extends Equatable {
  const DeliveryOthersDetailsEvent();

  @override
  List<Object> get props => [];
}

class DeliveryStarted extends DeliveryOthersDetailsEvent {
  final _id;
  const DeliveryStarted(this._id);
  @override
  List<Object> get props => [_id];
}

// state ----------------------------------------
abstract class DeliveryOthersDetailsState extends Equatable {
  const DeliveryOthersDetailsState();

  @override
  List<Object> get props => [];
}

class DeliveryLoading extends DeliveryOthersDetailsState {
  @override
  List<Object> get props => [];
}

class DeliveryLoaded extends DeliveryOthersDetailsState {
  final _details;

  const DeliveryLoaded(
    this._details,
  );

  DeliveryOtherDetailsModel get getDetails => _details;
  @override
  List<Object> get props => [_details];
}

class DeliveryErrorLoading extends DeliveryOthersDetailsState {
  @override
  List<Object> get props => [];
}
