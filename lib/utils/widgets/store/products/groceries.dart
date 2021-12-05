import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/groceries_bloc.dart';
import 'package:narrid/dashboard/repositories/store/products/groceries-repos.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:narrid/utils/widgets/store/products/product-widget-x.dart';

class BuildGroceries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroceriesBloc(GroceriesRepos())..add(AppStarted()),
      child: Container(
        child: buildListView(),
      ),
    );
  }

  BlocBuilder buildListView() {
    return BlocBuilder<GroceriesBloc, GroceriesState>(
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
