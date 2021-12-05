import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/electroncies_bloc.dart';
import 'package:narrid/dashboard/repositories/store/products/electronics-repos.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:narrid/utils/widgets/store/products/product-widget-x.dart';

class BuildElectronics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ElectronicsBloc(ElectroniesRepos())..add(AppStarted()),
      child: Container(
        child: buildListView(),
      ),
    );
  }

  BlocBuilder buildListView() {
    return BlocBuilder<ElectronicsBloc, ElectronicsState>(
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
