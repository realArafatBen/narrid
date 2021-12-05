import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:narrid/core/HtmlString.dart';
import 'package:narrid/dashboard/bloc/store/banner/ads_bloc.dart';
import 'package:narrid/dashboard/bloc/store/cart/cart_bloc.dart';
import 'package:narrid/dashboard/bloc/store/cart/checkout_cart_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/customer_view_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/deliveryother_details_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/product_color_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/product_details_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/product_images_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/product_overview_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/product_variants_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/wishlist_bloc.dart';
import 'package:narrid/dashboard/models/db/cart_db_model.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/models/store/products/deliveryothers-details.dart';
import 'package:narrid/dashboard/models/store/products/product-details.dart';
import 'package:narrid/dashboard/models/store/products/product-overview.dart';
import 'package:narrid/dashboard/models/store/products/product-variants.dart';
import 'package:narrid/dashboard/repositories/activities/user_activities.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';
import 'package:narrid/dashboard/repositories/store/checkout_cart_repository.dart';
import 'package:narrid/dashboard/repositories/store/products/customerview-repos.dart';
import 'package:narrid/dashboard/repositories/store/products/deliveryothers-details-repos.dart';
import 'package:narrid/dashboard/repositories/store/products/product-details-repos.dart';
import 'package:narrid/dashboard/repositories/store/products/product-images.dart';
import 'package:narrid/dashboard/repositories/store/products/product-overview-repos.dart';
import 'package:narrid/dashboard/repositories/store/products/product-variants-repos.dart';
import 'package:narrid/dashboard/repositories/store/products/wishlist_repostory.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/store/checkout.dart';
import 'package:narrid/dashboard/screens/store/products/product_overview.dart';
import 'package:narrid/dashboard/screens/store/search-view.dart';
import 'package:narrid/dashboard/screens/store/vendor.dart';
import 'package:narrid/dashboard/screens/user/auth/login.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:narrid/utils/widgets/store/banners/single-banner.dart';
import 'package:narrid/utils/widgets/store/products/customer-view.dart';
import 'package:share/share.dart';

var variantId = '0';
var variantName = '';
var variantPrice = '';
int _selected = 0;
int _selectedColor = 0;
var pickedColor = "";

class Product extends StatelessWidget {
  final String id, product_name, image;
  Product(
      {Key key,
      @required this.id,
      @required this.product_name,
      @required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    variantId = '0';
    variantName = '';
    variantPrice = '';
    _selected = 0;
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductDetailsBloc>(
          create: (BuildContext context) =>
              ProductDetailsBloc(ProductDetailsRepos())
                ..add(DetailsStarted(id)),
        ),
        BlocProvider<ProductVariantsBloc>(
          create: (BuildContext context) =>
              ProductVariantsBloc(ProductVariantsRepos())
                ..add(VariantStarted(id)),
        ),
        BlocProvider(
          create: (context) =>
              WishListBloc(wishListRepository: WishListRepository())
                ..add(WishListStarted(id)),
        ),
        BlocProvider(
          create: (context) => AdsBannerBloc(BannersRep())..add(AdsStarted()),
        ),
        BlocProvider<CheckoutCartBloc>(
          create: (context) =>
              CheckoutCartBloc(cartRepository: CheckoutCartRepository())
                ..add(CheckoutCartClearAll()),
        ),
        BlocProvider<ProductColorBloc>(
          create: (BuildContext context) =>
              ProductColorBloc(ProductVariantsRepos())..add(ColorStarted(id)),
        ),
        BlocProvider<DeliveryOthersDetailsBloc>(
          create: (BuildContext context) =>
              DeliveryOthersDetailsBloc(DeliveryOthersRepos())
                ..add(DeliveryStarted(id)),
        ),
        BlocProvider<CartBloc>(
          create: (BuildContext context) =>
              CartBloc(cartRepository: CartRepository())
                ..add(CartStarted(id: id)),
        ),
        BlocProvider<ProductOverviewBloc>(
          create: (BuildContext context) =>
              ProductOverviewBloc(ProductOverviewRepos())
                ..add(OverviewStarted(id)),
        ),
        BlocProvider<CustomerViewBloc>(
          create: (BuildContext context) =>
              CustomerViewBloc(CustomerViewRepos())..add(CustomerStarted(id)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchView()));
              },
              child: Icon(Icons.search),
            ),
            SizedBox(
              width: 15.0,
            ),
            SizedBox(
              width: 15.0,
            ),
          ],
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          title: Text(
            "Product",
            style: TextStyle(color: Colors.grey[800]),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Product Slider
              ProductImageSlide(id: id),
              //Product Details
              ProductDetails(id: id, product_name: product_name, image: image),
              //Delivery Details
              ProductDelivery(id: id),
              //Delivery Details
              ProductOrderDetails(id: id),
              //Product Description
              ProductDescription(id: id),
              //Customer review
              CustomerReview(id: id),
              //Customer also viewed
              CustomerViewed(id: id),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoading) {
                  return LoadingCart();
                } else if (state is CartLoaded) {
                  return _loadedCart(context, state);
                } else if (state is CartNotInserted) {
                  return _notInsert(context);
                } else if (state is CartError) {
                  return LoadError();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _notInsert(context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0.0),
            child: Card(
              elevation: 0,
              color: Colors.red,
              child: TextButton(
                onPressed: () async {
                  UserRepository userRepository = UserRepository();
                  bool isAuth = await userRepository.hasToken();
                  if (isAuth) {
                    //clear all if there is any store in the checkout cart
                    BlocProvider.of<CheckoutCartBloc>(context)
                      ..add(CheckoutCartClearAll());
                    BlocProvider.of<CheckoutCartBloc>(context)
                      ..add(AddSingleToCheckoutChart(
                        id: id,
                        product_name: product_name,
                        qty: '1',
                        variant: variantId,
                        variantName: variantName,
                        variantPrice: variantPrice,
                        image: image,
                        color: pickedColor,
                      ));
                    //go to checkout check dialog
                    loadingDialog(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(
                                  userRepository: UserRepository(),
                                  route: "product",
                                )));
                  }
                },
                child: Text(
                  "BUY NOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0.0),
            child: Card(
              color: Colors.black,
              elevation: 0,
              child: TextButton(
                onPressed: () {
                  print(variantName);
                  BlocProvider.of<CartBloc>(context)
                    ..add(CartInsertCart(
                      id: id,
                      product_name: product_name,
                      qty: '1',
                      variant: variantId,
                      variantName: variantName,
                      variantPrice: variantPrice,
                      image: image,
                      color: pickedColor,
                    ));
                },
                child: Text(
                  "ADD TO CART",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loadedCart(context, state) {
    List<CartHelper> cart = state.getCart;
    var qty = cart[0].quantity;
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10,
        bottom: 20,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                BlocProvider.of<CartBloc>(context)..add(CartRemove(id: id));
              },
              child: Container(
                child: Icon(Icons.delete),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                BlocProvider.of<CartBloc>(context)
                  ..add(CartMinus(id: id, qty: qty));
              },
              child: Container(
                child: Icon(Icons.remove),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              qty,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                BlocProvider.of<CartBloc>(context)
                  ..add(CartAdd(id: id, qty: qty));
              },
              child: Container(
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void loadingDialog(context) {
    Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CheckOut()));
    });
  }
}

class ProductImageSlide extends StatelessWidget {
  final id;
  ProductImageSlide({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductImagesBloc(ProductImageRep())..add(ImageStarted(id)),
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: Center(
          child: SizedBox(
            height: 250.0,
            child: buildCarousel(),
          ),
        ),
      ),
    );
  }

  BlocBuilder buildCarousel() {
    return BlocBuilder<ProductImagesBloc, ProductImagesState>(
        builder: (context, state) {
      if (state is Loading) {
        return ShimmerSlider();
      } else if (state is Loaded) {
        return getCarousel(state, context);
      } else if (state is ErrorLoading) {
        return ShimmerSlider();
      } else {
        return null;
      }
    });
  }

  Carousel getCarousel(state, context) {
    List<dynamic> images = state.getImages;

    return Carousel(
      boxFit: BoxFit.contain,
      autoplay: true,
      autoplayDuration: const Duration(seconds: 5),
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
      dotSize: 6.0,
      dotIncreasedColor: Colors.yellow[100],
      dotBgColor: Colors.transparent,
      dotPosition: DotPosition.bottomCenter,
      dotVerticalPadding: 10.0,
      showIndicator: true,
      indicatorBgPadding: 7.0,
      borderRadius: true,
      moveIndicatorFromBottom: 180.0,
      noRadiusForIndicator: true,
      images: [
        for (var item in images)
          InkWell(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (_) => ImageDialog(img: item.toString()));
            },
            child: Image.network(item.toString()),
          ),
      ],
    );
  }
}

class ImageDialog extends StatelessWidget {
  final img;
  ImageDialog({@required this.img});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.infinity,
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            img,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// Product Details
class ProductDetails extends StatelessWidget {
  final id;
  final product_name;
  final image;
  ProductDetails(
      {Key key,
      @required this.id,
      @required this.product_name,
      @required this.image})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Product Details
          buildProductDetails(),
          buildAdsBanner(context),
          //Product Variants
          buildProductVariants(id),
          SizedBox(
            height: 8,
          ),
          buildProductColor(id),
          buildAdsBanner(context),
          SizedBox(
            height: 10.0,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0.0),
                    child: Card(
                      child: IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          Share.share(
                              "Narrid Product https://www.narrid.com/?route=product&id=$id",
                              subject: product_name);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0.0),
                    child: _buildWishList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAdsBanner(BuildContext context) {
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
        }
      },
    );
  }

  Widget _buildWishList() {
    return BlocBuilder<WishListBloc, WishListState>(
      builder: (context, state) {
        if (state is WishListLoading) {
          return _notListWishList(state, context);
        } else if (state is NotListed) {
          return _notListWishList(state, context);
        } else if (state is Listed) {
          return _listWishList(state, context);
        } else if (state is WishListError) {
          return _notListWishList(state, context);
        } else {
          return null;
        }
      },
    );
  }

  Widget _notListWishList(state, context) {
    return Card(
      child: IconButton(
        icon: Icon(
          FontAwesomeIcons.heart,
        ),
        onPressed: () async {
          UserRepository userRepository = UserRepository();
          bool isAuth = await userRepository.hasToken();
          if (isAuth) {
            BlocProvider.of<WishListBloc>(context).add(WishListAdd(id));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Login(
                          userRepository: UserRepository(),
                          route: "product",
                        )));
          }
        },
      ),
    );
  }

  Widget _listWishList(state, context) {
    return Card(
      child: IconButton(
        icon: FaIcon(
          FontAwesomeIcons.solidHeart,
          color: Colors.red,
        ),
        onPressed: () async {
          UserRepository userRepository = UserRepository();
          bool isAuth = await userRepository.hasToken();
          if (isAuth) {
            BlocProvider.of<WishListBloc>(context).add(WishListRemove(id));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Login(
                          userRepository: UserRepository(),
                          route: 'product',
                        )));
          }
        },
      ),
    );
  }

  Widget buildProductColor(id) {
    return BlocBuilder<ProductColorBloc, ProductColorState>(
      builder: (context, state) {
        if (state is ColorLoading) {
          return ShimmerProductVariants();
        } else if (state is ColorLoaded) {
          Map<String, dynamic> colors = state.getColors;

          if (colors['status'] == 'empty') {
            return Container();
          } else {
            List<dynamic> names = colors['names'] as List;
            List<dynamic> images = colors['images'] as List;
            int colorx = names.length;

            return buildColorsList(names, images, colorx, context, id);
          }
        } else if (state is ColorError) {
          return ShimmerProductVariants();
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildColorsList(names, images, colorx, context, id) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Colours:"),
        SizedBox(
          height: 120,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < colorx; i++)
                InkWell(
                  onTap: () {
                    pickedColor = names[i];
                    BlocProvider.of<ProductColorBloc>(context)
                      ..add(ColorSelected(id));
                    _selectedColor = i;
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedColor == i
                            ? Colors.yellow[200]
                            : Colors.grey[200],
                        width: 3,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            images[i],
                            width: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          names[i],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  BlocBuilder buildProductVariants(id) {
    return BlocBuilder<ProductVariantsBloc, ProductVariantsState>(
      builder: (context, state) {
        if (state is VariantLoading) {
          return ShimmerProductVariants();
        } else if (state is VariantLoaded) {
          return _buildVariantsWidget(state, context, id);
        } else if (state is VariantErrorLoading) {
          return ShimmerProductVariants();
        } else {
          return null;
        }
      },
    );
  }

  BlocBuilder buildProductDetails() {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        if (state is DetailsLoading) {
          return ShimmerProductDetials();
        } else if (state is DetailsLoaded) {
          return buildDetailsLoaded(state);
        } else if (state is DetailsErrorLoading) {
          return ShimmerProductDetials();
        } else {
          return null;
        }
      },
    );
  }

  Column buildDetailsLoaded(state) {
    ProductDetailsModel product_details = state.getDetails;
    String store_name = product_details.store_name.toString();
    String product_name = product_details.product_name.toString();
    String brand_name = product_details.brand_name.toString();
    String price = product_details.price.toString();
    String discount = product_details.discount_price.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: TextButton.icon(
            icon: Icon(
              Icons.store,
              color: Colors.red,
            ),
            label: Text(
              "Store: $store_name",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10.0,
                color: Colors.black,
              ),
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(
          height: 2.0,
        ),
        //Product Name
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product_name,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
              ),
              SizedBox(height: 5.0),
              Text(
                "Brand - $brand_name",
                style: TextStyle(fontWeight: FontWeight.w100, fontSize: 12.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 13.0,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: price,
                shrinkToFit: true,
                defaultTextStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Html(
                data: discount,
                shrinkToFit: true,
                defaultTextStyle: TextStyle(
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}

class LoadError extends StatelessWidget {
  const LoadError({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0.0),
        child: Card(
          color: Colors.black,
          child: TextButton(
            onPressed: () {},
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Oops, there was an error",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingCart extends StatelessWidget {
  const LoadingCart({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

Widget _buildVariantsWidget(state, context, id) {
  List<ProductVariantsModel> variants = state.getVariants;
  variantId = variants[_selected].id;
  variantPrice = variants[_selected].price;
  variantName = variants[_selected].size;

  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (variants.length > 0)
          Text(
            "Variant:",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.0,
            ),
          ),
        SizedBox(
          height: 3.0,
        ),
        Row(
          children: [
            for (var i = 0; i < variants.length; i++)
              if (variants[i].size != "")
                InkWell(
                  onTap: () {
                    variantId = variants[i].id;
                    variantPrice = variants[i].price;
                    variantName = variants[i].size;

                    BlocProvider.of<ProductVariantsBloc>(context)
                      ..add(VariantSelected(id));
                    _selected = i;
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 80,
                    ),
                    padding: EdgeInsets.all(4),
                    height: 42.0,
                    decoration: BoxDecoration(
                      color: _selected == i
                          ? Colors.yellow[200]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                    child: Text(
                      variants[i].size,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                )
          ],
        ),
      ],
    ),
  );
}

class ProductDelivery extends StatelessWidget {
  final id;
  const ProductDelivery({
    Key key,
    @required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeliveryOthersDetailsBloc(DeliveryOthersRepos())
        ..add(DeliveryStarted(id)),
      child: Container(
        padding: EdgeInsets.fromLTRB(4.0, 8.0, 0.0, 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 5.0),
              child: Text(
                "DELIVERY DETAILS",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[900],
                ),
              ),
            ),
            BlocBuilder<DeliveryOthersDetailsBloc, DeliveryOthersDetailsState>(
              builder: (context, state) {
                if (state is DeliveryLoading) {
                  return ShimmerDeliveryDetails();
                } else if (state is DeliveryLoaded) {
                  return buildDeliveryDetails(state);
                } else if (state is DeliveryErrorLoading) {
                  return ShimmerDeliveryDetails();
                } else {
                  return null;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Container buildDeliveryDetails(state) {
    DeliveryOtherDetailsModel details = state.getDetails;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(5, 12, 0, 14),
      child: Html(
          data: details.details.toString(),
          shrinkToFit: true,
          linkStyle: TextStyle(
            color: Colors.grey[900],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          )),
    );
  }
}

class ProductOrderDetails extends StatelessWidget {
  final id;
  const ProductOrderDetails({
    Key key,
    @required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.0, 8.0, 0.0, 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 5.0),
            child: Text(
              "ORDER DETAILS",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.grey[900],
              ),
            ),
          ),
          buildOrderDetails(),
        ],
      ),
    );
  }

  BlocBuilder buildOrderDetails() {
    return BlocBuilder<DeliveryOthersDetailsBloc, DeliveryOthersDetailsState>(
      builder: (context, state) {
        if (state is DeliveryLoading) {
          return ShimmerOrderDetails();
        } else if (state is DeliveryLoaded) {
          return buildAllDeliveryDetails(state, context);
        } else if (state is DeliveryErrorLoading) {
          return ShimmerOrderDetails();
        } else {
          return null;
        }
      },
    );
  }

  Container buildAllDeliveryDetails(state, context) {
    DeliveryOtherDetailsModel returns = state.getDetails;
    DeliveryOtherDetailsModel warranty = state.getDetails;
    DeliveryOtherDetailsModel store = state.getDetails;
    String store_name = store.store_name.toString();
    String storeId = store.storeId.toString();
    String __store = "Sold by $store_name";
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(5, 12, 0, 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  "assets/images/icons/non_returnable.svg",
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  returns.returns.toString(),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  "assets/images/icons/warranty.svg",
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  warranty.warranty.toString(),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  "assets/images/icons/seller.svg",
                ),
              ),
              Expanded(
                flex: 6,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Vendor(
                                  vendorId: storeId,
                                  vendorName: store_name,
                                )));
                  },
                  child: Text(
                    __store,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          const Divider(
            height: 2,
            thickness: 1,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  "assets/images/icons/trusted_shipping_usp_v2.svg",
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TRUSTED SHIPPING",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Free shipping when you spend NGN100,00 and above on express items",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  "assets/images/icons/non_returnable.svg",
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FREE RETURNS",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Get free returns on eligible items",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  "assets/images/icons/constactless_delivery_usp.svg",
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CONSTACTLESS DELIVERY",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Your delivery will be left at your door, valid on prepaid orders only",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  "assets/images/icons/vip_shipping.svg",
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FREE EXCLUSIVE MEMBER SHIPPING",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "As a narrid exclusive member, you get free next day delivery on express items",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  "assets/images/icons/seller.svg",
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FREE GROCERIES DELIVERY",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Get free delivery on groceries when you order items above NGN10,000",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ProductDescription extends StatelessWidget {
  final id;
  const ProductDescription({
    Key key,
    @required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(4.0, 10.0, 0.0, 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 5.0),
            child: Text(
              "PRODUCT DESCRIPTION",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.grey[900],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          const Divider(
            height: 2,
            thickness: 1,
          ),
          SizedBox(
            height: 5.0,
          ),
          buildOverview(),
        ],
      ),
    );
  }

  BlocBuilder buildOverview() {
    return BlocBuilder<ProductOverviewBloc, ProductOverviewState>(
        builder: (context, state) {
      if (state is OverviewLoading) {
        return ShimmerProductDescription();
      } else if (state is OverviewLoaded) {
        ProductOverviewModel overview = state.getOverviews;
        String specifications =
            HtmlString().parseHtmlString(overview.specifications.toString());

        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductOverview(
                        product_details: overview.product_details,
                        specifications: overview.specifications)));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 5, 5, 5.0),
            child: Text(
              specifications,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
          ),
        );
      } else if (state is OverviewErrorLoading) {
        return ShimmerProductDescription();
      } else {
        return null;
      }
    });
  }
}

class CustomerViewed extends StatelessWidget {
  final id;
  const CustomerViewed({
    Key key,
    @required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.0, 10.0, 0.0, 12.0),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 5.0),
            child: Text(
              "CUSTOMER ALSO VIEWED",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.grey[900],
              ),
            ),
          ),
          Container(
            height: 350,
            color: Colors.white,
            child: BuildCustomerView(),
          ),
        ],
      ),
    );
  }
}

class CustomerReview extends StatelessWidget {
  final id;
  const CustomerReview({
    Key key,
    @required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.0, 10.0, 0.0, 12.0),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 5.0),
            child: Text(
              "CUSTOMER FEEDBACK",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.grey[900],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 100,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.feedback,
                  ),
                  Text(
                    "No feed back on this product yet",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewProduct() async {
    UserActivities userActivities = new UserActivities();
    await userActivities.productViewed(id);
  }
}
