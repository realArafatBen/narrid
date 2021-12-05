import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/dashboard/bloc/store/brands/brands_cat_bloc.dart';
import 'package:narrid/dashboard/bloc/store/brands/brands_categories_bloc.dart';
import 'package:narrid/dashboard/bloc/store/categories/categories_bloc.dart';
import 'package:narrid/dashboard/models/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/brands/brands_repository.dart';
import 'package:narrid/dashboard/repositories/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/store/products/product-repository.dart';
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

class Brands extends StatelessWidget {
  final brand;

  Brands({Key key, @required this.brand}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    brandId = brand['id'];
    return MultiBlocProvider(
      providers: [
        BlocProvider<BrandsCategoriesBloc>(
          create: (BuildContext context) =>
              BrandsCategoriesBloc(ProductRepository())
                ..add(
                  BrandsCatStarted(
                    brandId,
                    productType,
                    categoryId,
                    shipping_type,
                    min_price,
                    max_price,
                  ),
                ),
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [],
          title: Text(
            "${brand['name']}",
            style: TextStyle(color: Colors.grey[800]),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                _buildBrandImageHeader(),
                BuildProduct(scaffoldKey: _scaffoldKey, context: context),
                BlocBuilder<BrandsCategoriesBloc, BrandsCategoriesState>(
                  builder: (context, state) {
                    if (state is BrandsCatLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is BrandsCatLoaded) {
                      return ProductWidget(state: state, context: context);
                    } else if (state is BrandsCatErrorLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        drawer: FilterDrawer(context: context),
      ),
    );
  }

  Widget _buildBrandImageHeader() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
        maxWidth: double.infinity,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            brand['image'],
          ),
          fit: BoxFit.contain,
        ),
      ),
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
      create: (context) => CategoriesBloc(CategoriesRepos())
        ..add(
          CatStarted(),
        ),
      child: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state is Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is Loaded) {
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
          } else if (state is ErrorLoading) {
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
              BlocProvider.of<BrandsCategoriesBloc>(context).add(
                BrandsCatStarted(
                  brandId,
                  productType,
                  categoryId,
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
                      BlocProvider.of<BrandsCategoriesBloc>(context).add(
                        BrandsCatStarted(
                          brandId,
                          productType,
                          categoryId,
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
