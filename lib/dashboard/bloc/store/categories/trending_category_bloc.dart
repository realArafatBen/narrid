import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/repositories/store/categories/trending-repos.dart';

class TrendCategoryBloc extends Bloc<TrendCategoryEvent, TrendCategoryState> {
  TrendingRepos trendingRepos;
  TrendCategoryBloc({@required this.trendingRepos})
      : super(TrendCategoryLoading());
  @override
  Stream<TrendCategoryState> mapEventToState(
    TrendCategoryEvent event,
  ) async* {
    if (event is TrendCategoryStarted) {
      try {
        List<dynamic> data = await trendingRepos.getTrendCategory();
        yield TrendCategoryLoaded(data: data);
      } catch (_) {
        yield TrendCategoryError();
      }
    }
  }
}

// ---- state
class TrendCategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class TrendCategoryLoading extends TrendCategoryState {}

class TrendCategoryLoaded extends TrendCategoryState {
  final data;
  TrendCategoryLoaded({@required this.data});
  List<dynamic> get getData => data;

  @override
  List<Object> get props => [data];
}

class TrendCategoryError extends TrendCategoryState {}

//--- event
class TrendCategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TrendCategoryStarted extends TrendCategoryEvent {}
