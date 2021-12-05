import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/dashboard/bloc/food/store/categories_bloc.dart';
import 'package:narrid/dashboard/bloc/store/banner/ads_bloc.dart';
import 'package:narrid/dashboard/bloc/store/brands/brands_cat_bloc.dart';
import 'package:narrid/dashboard/bloc/store/categories/categories_bloc.dart'
    as cat;
import 'package:narrid/dashboard/bloc/store/categories/subcategories_bloc.dart'
    as subcat;

import 'package:narrid/dashboard/bloc/store/categories/trending_bloc.dart';
import 'package:narrid/dashboard/bloc/store/categories/trending_category_bloc.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/models/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/brands/brands_repository.dart';
import 'package:narrid/dashboard/repositories/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/categories/subcategories.dart';
import 'package:narrid/dashboard/repositories/store/categories/trending-repos.dart';
import 'package:narrid/dashboard/screens/store/categories/category.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:narrid/utils/widgets/store/banners/single-banner.dart';
import 'package:narrid/utils/widgets/store/custom_appbar.dart';
import 'package:narrid/utils/widgets/store/products/product-widget.dart';

var productType = "best-match";
var productTypeText = "Best match";
var categoryId = "";
var shipping_type = "";
var min_price = "";
var max_price = "";
var brandId = "";

int catSelectedIndex = 0;
int brandSelectedIndex = 0;
int selectTypeIndex = 0;
int selectedShippingTypeIndex = 0;

class Trending extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TrendingBloc(TrendingRepos())
              ..add(
                TrendStarted(
                  categoryId,
                  brandId,
                  productType,
                  shipping_type,
                  min_price,
                  max_price,
                ),
              ),
          ),
          BlocProvider(
            create: (context) =>
                TrendCategoryBloc(trendingRepos: TrendingRepos())
                  ..add(TrendCategoryStarted()),
          ),
          BlocProvider(
            create: (context) => subcat.SubCategoriesBloc(SubCategoriesRepos())
              ..add(subcat.AppStartedCat(8)),
          ),
          BlocProvider(
            create: (context) => AdsBannerBloc(BannersRep())..add(AdsStarted()),
          ),
        ],
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBar(),
                BannerSection(),
                BannerWidth(),
                BannerSubSection(),
                BuildAdsBanner(),
                BuildProduct(scaffoldKey: _scaffoldKey, context: context),
                buildTrending(),
              ],
            ),
          ),
        ),
      ),
      drawer: FilterDrawer(context: context),
    );
  }

  buildTrending() {
    return BlocBuilder<TrendingBloc, TrendingState>(
      builder: (context, state) {
        if (state is TrendLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TrendLoaded) {
          return ProductWidget(state: state, context: context);
        } else if (state is TrendErrorLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  TextEditingController min_price_controller = new TextEditingController();
  TextEditingController max_price_controller = new TextEditingController();

  ScrollController _scroll;
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    _scroll = new ScrollController();
    _focus.addListener(() {
      _scroll.jumpTo(-1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scroll,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      top: 10,
                      bottom: 10,
                      right: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        buildCategories(context),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Brands",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        buildBrands(context),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Shipping",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        buildShippingType(context),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Price",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        buidPrice(),
                      ],
                    ),
                  ),
                ),
              ),
              fixedActionDrawer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategories(context) {
    return BlocProvider(
      create: (context) => cat.CategoriesBloc(CategoriesRepos())
        ..add(
          cat.CatStarted(),
        ),
      child: BlocBuilder<cat.CategoriesBloc, cat.CategoriesState>(
        builder: (context, state) {
          if (state is cat.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is cat.Loaded) {
            List<CategoriesModel> categories = state.getCategories;
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 4.0,
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < categories.length; i++)
                  TextButton(
                    onPressed: () {
                      categoryId = categories[i].id;
                      setState(() {
                        catSelectedIndex = i;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        i == catSelectedIndex
                            ? HexColor("FFB344")
                            : HexColor("FDF6F0"),
                      ),
                    ),
                    child: Text(
                      "${categories[i].name}",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            );
          } else if (state is cat.ErrorLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget buildShippingType(context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      childAspectRatio: 4.0,
      physics: NeverScrollableScrollPhysics(),
      children: [
        TextButton(
          onPressed: () {
            shipping_type = "free";
            setState(() {
              selectedShippingTypeIndex = 1;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              1 == selectedShippingTypeIndex
                  ? HexColor("FFB344")
                  : HexColor("FDF6F0"),
            ),
          ),
          child: Text(
            "Free Shipping",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            shipping_type = "express";
            setState(() {
              selectedShippingTypeIndex = 2;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              2 == selectedShippingTypeIndex
                  ? HexColor("FFB344")
                  : HexColor("FDF6F0"),
            ),
          ),
          child: Text(
            "Express Shipping",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            shipping_type = "normal";
            setState(() {
              selectedShippingTypeIndex = 3;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              3 == selectedShippingTypeIndex
                  ? HexColor("FFB344")
                  : HexColor("FDF6F0"),
            ),
          ),
          child: Text(
            "Normal Shipping",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget fixedActionDrawer(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: InkWell(
            onTap: () {
              BlocProvider.of<TrendingBloc>(context).add(
                TrendStarted(
                  categoryId,
                  brandId,
                  productType,
                  shipping_type,
                  min_price,
                  max_price,
                ),
              );
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width / 2,
              color: Colors.red,
              child: Text(
                "DONE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: InkWell(
            onTap: () {
              setState(() {
                categoryId = "";
                shipping_type = "";
                min_price = "";
                max_price = "";
                catSelectedIndex = 0;
                brandSelectedIndex = 0;
                selectTypeIndex = 0;
                selectedShippingTypeIndex = 0;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                "RESET",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBrands(context) {
    return BlocProvider(
      create: (context) => BrandCatBloc(brandsRepository: BrandsRepository())
        ..add(BrandCatStarted(id: categoryId)),
      child: BlocBuilder<BrandCatBloc, BrandCatState>(
        builder: (context, state) {
          if (state is BrandCatLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BrandCatLoaded) {
            List<dynamic> brands = state.getBrand;
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 4.0,
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < brands.length; i++)
                  TextButton(
                    onPressed: () {
                      brandId = brands[i]['id'];
                      setState(() {
                        brandSelectedIndex = i;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        i == brandSelectedIndex
                            ? HexColor("FFB344")
                            : HexColor("FDF6F0"),
                      ),
                    ),
                    child: Text(
                      "${brands[i]['name']}",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            );
          } else if (state is BrandCatError) {
            return Center(child: CircularProgressIndicator());
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget buidPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: TextField(
            focusNode: _focus,
            controller: min_price_controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Min.",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
            ),
            onChanged: (text) {
              min_price = text;
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(child: Text("-")),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: max_price_controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Max.",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
            ),
            onChanged: (text) {
              max_price = text;
            },
          ),
        ),
      ],
    );
  }
}

class BuildProduct extends StatefulWidget {
  const BuildProduct({
    Key key,
    @required GlobalKey<ScaffoldState> scaffoldKey,
    @required this.context,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final context;

  @override
  _BuildProductState createState() => _BuildProductState();
}

class _BuildProductState extends State<BuildProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  bottomSheetModal(context).then((value) {
                    setState(() {
                      BlocProvider.of<TrendingBloc>(context).add(
                        TrendStarted(
                          categoryId,
                          brandId,
                          productType,
                          shipping_type,
                          min_price,
                          max_price,
                        ),
                      );
                    });
                  });
                },
                child: Row(
                  children: [
                    Text(
                      productTypeText,
                      style: TextStyle(
                        color: HexColor("F1df00"),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    FaIcon(
                      FontAwesomeIcons.chevronDown,
                      size: 12,
                      color: HexColor("F1df00"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "Orders",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.thLarge,
                size: 16,
              ),
              SizedBox(
                width: 8,
              ),
              FaIcon(
                FontAwesomeIcons.ellipsisV,
                size: 15,
                color: Colors.grey,
              ),
              SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () {
                  widget._scaffoldKey.currentState.openDrawer();
                },
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.filter,
                      size: 16,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Filter",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> bottomSheetModal(context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.5,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                trailing: selectTypeIndex == 0
                    ? new Icon(
                        Icons.check,
                        color: HexColor("F1df00"),
                      )
                    : null,
                title: new Text(
                  'Best match',
                  style: TextStyle(
                    color: selectTypeIndex == 0
                        ? HexColor("F1df00")
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  productType = "best-match";
                  setState(() {
                    productTypeText = "Best match";
                    selectTypeIndex = 0;
                  });

                  Navigator.pop(context, productType);
                },
              ),
              ListTile(
                trailing: selectTypeIndex == 1
                    ? new Icon(
                        Icons.check,
                        color: HexColor("F1df00"),
                      )
                    : null,
                title: new Text(
                  'Date added (New to Old)',
                  style: TextStyle(
                    color: selectTypeIndex == 1
                        ? HexColor("F1df00")
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  productType = "date-added";
                  setState(() {
                    productTypeText = "Date added (New to Old)";
                    selectTypeIndex = 1;
                  });

                  Navigator.pop(context, productType);
                },
              ),
              ListTile(
                trailing: selectTypeIndex == 2
                    ? new Icon(
                        Icons.check,
                        color: HexColor("F1df00"),
                      )
                    : null,
                title: new Text(
                  'Price (High to Low)',
                  style: TextStyle(
                    color: selectTypeIndex == 2
                        ? HexColor("F1df00")
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  productType = "price-high";
                  setState(() {
                    productTypeText = "Price (High to Low)";
                    selectTypeIndex = 2;
                  });
                  Navigator.pop(context, productType);
                },
              ),
              ListTile(
                trailing: selectTypeIndex == 3
                    ? new Icon(
                        Icons.check,
                        color: HexColor("F1df00"),
                      )
                    : null,
                title: new Text(
                  'Price (Low to High)',
                  style: TextStyle(
                    color: selectTypeIndex == 3
                        ? HexColor("F1df00")
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  productType = "price-low";
                  setState(() {
                    productTypeText = "Price (Low to High)";
                    selectTypeIndex = 3;
                  });
                  Navigator.pop(context, productType);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class BannerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrendCategoryBloc, TrendCategoryState>(
      builder: (context, state) {
        if (state is TrendCategoryLoading) {
          return Container();
        } else if (state is TrendCategoryLoaded) {
          List<dynamic> data = state.getData;
          return _categories(data);
        } else if (state is TrendCategoryError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _categories(data) {
    return Container(
      height: 100,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<subcat.SubCategoriesBloc>(context)
                    .add(subcat.AppStartedCat(data[index]['id']));
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 50.0,
                width: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      data[index]['image'],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class BannerSubSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<subcat.SubCategoriesBloc, subcat.SubCategoriesState>(
      builder: (context, state) {
        if (state is subcat.CatLoading) {
          return Container();
        } else if (state is subcat.CatLoaded) {
          List<CategoriesModel> data = state.getCategories;
          return Container(
            child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1.0,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 0; i < data.length; i++)
                    _subTrendContent(context, data[i])
                ]),
          );
        } else if (state is subcat.CatErrorLoading) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _subTrendContent(BuildContext context, data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Category(
                id: data.id,
                cat_name: data.name,
                image: data.image.toString(),
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(data.image),
          ),
        ),
      ),
    );
  }
}

class BannerWidth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleBanners(myContext: context).topBanner();
  }
}

class BuildAdsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsBannerBloc, AdsBannerState>(
      builder: (context, state) {
        if (state is AdsLoading) {
          return ShimmerProductDescription();
        } else if (state is AdsLoaded) {
          List<BannersModel> banners = state.getBanners;
          return SingleBanners(myContext: context).paidAds(
            banners[0].url,
            banners[0].image,
          );
        } else if (state is AdsError) {
          return ShimmerProductDescription();
        } else {
          return Container();
        }
      },
    );
  }
}
