import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/recommendation_bloc.dart';
import 'package:narrid/dashboard/repositories/store/products/recommendation-repos.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:narrid/utils/widgets/store/products/product-widget-x.dart';

class BuildRecommendation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RecommendationBloc(RecommdationRepos())..add(AppStarted()),
      child: Container(
        child: buildListView(),
      ),
    );
  }

  BlocBuilder buildListView() {
    return BlocBuilder<RecommendationBloc, RecommendationState>(
      builder: (context, state) {
        if (state is Loading) {
          return ShimmerSlideProduct();
        } else if (state is Loaded) {
          return ProductWidgetX(state: state, context: context);
        } else if (state is ErrorLoading) {
          return ShimmerSlideProduct();
        } else {
          return null;
        }
      },
    );
  }
}
