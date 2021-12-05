import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/store/popularCategories_bloc.dart';
import 'package:narrid/dashboard/models/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/categories/popular-categories.dart';
import 'package:narrid/dashboard/screens/store/categories/category.dart';
import 'package:narrid/utils/ui/shimmer.dart';

class BuildTopCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PopularCategoriesBloc(PopularCategories())..add(AppStarted()),
      child: buildGridView(),
    );
  }

  BlocBuilder buildGridView() {
    return BlocBuilder<PopularCategoriesBloc, PopularCategoriesState>(
        builder: (context, state) {
      if (state is Loading) {
        return ShimmerCategeory();
      } else if (state is Loaded) {
        return loadGridCategories(state, context);
      } else if (state is ErrorLoading) {
        return ShimmerCategeory();
      } else {
        return null;
      }
    });
  }

  GridView loadGridCategories(state, context) {
    List<CategoriesModel> categories = state.getCategories;
    return GridView.count(
      shrinkWrap: true,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 4,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        for (var category in categories)
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Category(
                      id: category.id,
                      cat_name: category.name,
                      image: category.image.toString(),
                    ),
                  ));
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    category.image.toString(),
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  Flexible(
                    child: AutoSizeText(
                      category.name.toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
