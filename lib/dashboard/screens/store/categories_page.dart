import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/dashboard/bloc/store/categories/categories_bloc.dart';
import 'package:narrid/dashboard/bloc/store/categories/subcategories_bloc.dart';
import 'package:narrid/dashboard/models/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/categories/subcategories.dart';
import 'package:narrid/dashboard/screens/store/categories/category.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:narrid/utils/widgets/store/custom_appbar.dart';

String catId = "0";
var selectedIndex = 0;

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoriesBloc>(
          create: (BuildContext context) => CategoriesBloc(CategoriesRepos())
            ..add(
              CatStarted(),
            ),
        ),
        BlocProvider<SubCategoriesBloc>(
          create: (BuildContext context) =>
              SubCategoriesBloc(SubCategoriesRepos())
                ..add(AppStartedCat(catId)),
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            CustomAppBar(),
            Container(
              margin: const EdgeInsets.only(
                top: 135,
              ),
              child: BuildCategoriesTabs(),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildCategoriesTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Card(
              elevation: 0,
              child: BlocBuilder<CategoriesBloc, CategoriesState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return ShimmerCategories();
                  } else if (state is Loaded) {
                    return CategoryList(state: state);
                  } else if (state is ErrorLoading) {
                    return ShimmerCategories();
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          buildExpandedSubCategories(),
        ],
      ),
    );
  }

  Widget buildExpandedSubCategories() {
    return Expanded(
      flex: 5,
      child: Card(
        elevation: 0,
        child: buildGridView(),
      ),
    );
  }

  Widget buildGridView() {
    return BlocBuilder<SubCategoriesBloc, SubCategoriesState>(
      builder: (context, state) {
        if (state is CatLoading) {
          return ShimmerSubCategories();
        } else if (state is CatLoaded) {
          List<CategoriesModel> subCategory = state.getCategories;
          return GridView.count(
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                for (var subcat in subCategory)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Category(
                              id: subcat.id,
                              cat_name: subcat.name,
                              image: subcat.name.toString(),
                            ),
                          ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          subcat.image.toString(),
                          width: 60,
                          height: 60,
                          fit: BoxFit.scaleDown,
                        ),
                        Text(
                          subcat.name.toString(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
              ]);
        } else if (state is CatErrorLoading) {
          return ShimmerSubCategories();
        } else {
          return null;
        }
      },
    );
  }
}

class CategoryList extends StatefulWidget {
  const CategoryList({
    Key key,
    @required this.state,
  }) : super(key: key);

  final state;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    List<CategoriesModel> categories = widget.state.getCategories;
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ListTile(
          shape: Border(
            left: BorderSide(
              color: index == selectedIndex ? HexColor("F1df00") : Colors.white,
              width: 3,
            ),
          ),
          selected: index == selectedIndex ? true : false,
          selectedTileColor:
              index == selectedIndex ? Colors.grey[100] : Colors.white,
          title: Text(categories[index].name,
              style: TextStyle(fontSize: 13.0, color: Colors.grey[700])),
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            catId = categories[index].id;
            BlocProvider.of<SubCategoriesBloc>(context)
                .add(AppStartedCat(catId));
          },
        );
      },
    );
  }
}
