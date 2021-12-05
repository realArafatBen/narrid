import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/women_bloc.dart';
import 'package:narrid/dashboard/repositories/store/products/women-repos.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:narrid/utils/widgets/store/products/product-widget-x.dart';

class BuildFashionWomen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WomenBloc(WomenRepos())..add(AppStarted()),
      child: Container(
        child: buildListView(),
      ),
    );
  }

  BlocBuilder buildListView() {
    return BlocBuilder<WomenBloc, WomenState>(
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
