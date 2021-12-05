import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/store/banner/brands_bloc.dart';
import 'package:narrid/dashboard/bloc/store/banner/exclusive_deal_bloc.dart';
import 'package:narrid/dashboard/bloc/store/banner/grocery_store_banner_bloc.dart';
import 'package:narrid/dashboard/bloc/store/banner/mega_deal_bloc.dart';
import 'package:narrid/dashboard/bloc/store/banner/men_fashion_bloc.dart';
import 'package:narrid/dashboard/bloc/store/banner/women_fashion_bloc.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';
import 'package:narrid/dashboard/screens/grocery/home_page.dart';
import 'package:narrid/dashboard/screens/store/brands.dart';
import 'package:narrid/dashboard/screens/store/categories/category.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleBanners {
  final myContext;
  SingleBanners({@required this.myContext});
  Widget banner1() {
    return BlocProvider(
      create: (context) =>
          MegaDealsBannerBloc(BannersRep())..add(MegaStarted()),
      child: Column(
        children: [
          Center(
            child: Image.network(
                "https://narrid.com/template/assets/img/en_mega-title.gif"),
          ),
          BlocBuilder<MegaDealsBannerBloc, MegaDealsBannerState>(
            builder: (context, state) {
              if (state is MegaLoading) {
                return ShimmerSlider();
              } else if (state is MegaError) {
                return ShimmerSlider();
              } else if (state is MegaLoaded) {
                List<BannersModel> banners = state.getBanners;

                return Row(
                  children: [
                    for (var item in banners)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                myContext,
                                MaterialPageRoute(
                                    builder: (context) => Category(
                                          id: item.catId,
                                          cat_name: "Mega Deals",
                                        )));
                          },
                          child: Image.network(
                            item.image,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget topBanner() {
    return Column(
      children: [
        Image.network(
            "https://k.nooncdn.com/cms/pages/20201118/95de085f371ce5edb523904d42ff3a4f/en_main.png"),
        Image.network(
            "https://k.nooncdn.com/cms/pages/20201217/50b3d6f0058ffbdc1fdc8f75991af989/en_uae.gif"),
      ],
    );
  }

  //banner2
  Widget banner2() {
    return Column(
      children: [
        Center(
          child: Image.network(
              "https://narrid.com/template/assets/img/en_title-exclusssive.png"),
        ),
        BlocProvider(
          create: (context) =>
              ExclusiveDealsBannerBloc(BannersRep())..add(ExclusiveStarted()),
          child: Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: BlocBuilder<ExclusiveDealsBannerBloc,
                ExclusiveDealsBannerState>(
              builder: (context, state) {
                if (state is ExclusiveLoading) {
                  return ShimmerSlider();
                } else if (state is ExclusiveError) {
                  return ShimmerSlider();
                } else if (state is ExclusiveLoaded) {
                  List<BannersModel> banners = state.getBanners;
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 3 / 2,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      for (var item in banners)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                myContext,
                                MaterialPageRoute(
                                    builder: (context) => Category(
                                          id: item.catId,
                                          cat_name: "Exclusive Deals",
                                        )));
                          },
                          child: Image.network(
                            item.image,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  //banner3
  Widget banner3() {
    return BlocProvider(
      create: (context) =>
          GroceryStoreBannerBloc(BannersRep())..add(GroceryStoreStarted()),
      child: Column(
        children: [
          Center(
            child: Image.network(
                "https://narrid.com/template/assets/img/en_title-daily.png"),
          ),
          BlocBuilder<GroceryStoreBannerBloc, GroceryStoreBannerState>(
            builder: (context, state) {
              if (state is GroceryStoreLoading) {
                return ShimmerSlider();
              } else if (state is GroceryStoreLoaded) {
                List<BannersModel> banners = state.getBanners;

                return Row(
                  children: [
                    for (var item in banners)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                myContext,
                                MaterialPageRoute(
                                    builder: (context) => Grocery()));
                          },
                          child: Image.network(
                            item.image,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                );
              } else if (state is GroceryStoreError) {
                return ShimmerSlider();
              }
            },
          ),
        ],
      ),
    );
  }

  //banner4
  Widget banner4() {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          image: NetworkImage(
            "https://narrid.com/uploads/store/m-b-4.jpg",
          ),
        ),
      ),
    );
  }

  //banner5
  Widget banner5() {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          image: NetworkImage(
            "https://narrid.com/uploads/store/m-b-5.jpg",
          ),
        ),
      ),
    );
  }

  Widget banner6() {
    return BlocProvider(
      create: (context) =>
          MenFashionBannerBloc(BannersRep())..add(MenStarted()),
      child: Column(
        children: [
          BlocBuilder<MenFashionBannerBloc, MenFashionBannerState>(
            builder: (context, state) {
              if (state is MenLoading) {
                return ShimmerSlider();
              } else if (state is MenLoaded) {
                List<BannersModel> banners = state.getBanners;
                return Row(
                  children: [
                    for (var item in banners)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                myContext,
                                MaterialPageRoute(
                                    builder: (context) => Category(
                                          id: item.catId,
                                          cat_name: "For Men",
                                        )));
                          },
                          child: Image.network(
                            item.image,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                );
              } else if (state is MenError) {
                return ShimmerSlider();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget banner7() {
    return BlocProvider(
      create: (context) =>
          WomenFashionBannerBloc(BannersRep())..add(WomenStarted()),
      child: Column(
        children: [
          BlocBuilder<WomenFashionBannerBloc, WomenFashionBannerState>(
            builder: (context, state) {
              if (state is WomenLoading) {
                return ShimmerSlider();
              } else if (state is WomenLoaded) {
                List<BannersModel> banners = state.getBanners;

                return Row(
                  children: [
                    for (var item in banners)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                myContext,
                                MaterialPageRoute(
                                    builder: (context) => Category(
                                          id: item.catId,
                                          cat_name: "For Women",
                                        )));
                          },
                          child: Image.network(
                            item.image,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                );
              } else if (state is WomenError) {
                return ShimmerSlider();
              }
            },
          ),
        ],
      ),
    );
  }

  //banner7
  Widget banner8() {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          image: NetworkImage(
            "https://narrid.com/uploads/store/m-b-7.jpg",
          ),
        ),
      ),
    );
  }

  //paidAds
  Widget paidAds(url, image) {
    return InkWell(
      onTap: () {
        _lunchURL(url);
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: NetworkImage(
              image,
            ),
          ),
        ),
      ),
    );
  }

  _lunchURL(url) async {
    if (!url.contains('http')) url = 'https://$url';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget bannerBrands() {
    return BlocProvider(
      create: (context) => BrandsBannerBloc(bannersRep: BannersRep())
        ..add(BrandsBannerStarted()),
      child: BlocBuilder<BrandsBannerBloc, BrandsBannerState>(
        builder: (context, state) {
          if (state is BrandsBannerLoading) {
            return ShimmerSlider();
          } else if (state is BrandsBannerError) {
            return ShimmerSlider();
          } else if (state is BrandsBannerLoaded) {
            List<dynamic> brands = state.getBrandsBanner;
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 3 / 2,
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < brands.length; i++)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          myContext,
                          MaterialPageRoute(
                              builder: (context) => Brands(
                                    brand: brands[i],
                                  )));
                    },
                    child: Image.network(
                      brands[i]['image'],
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            );
          }
          return Container(
            child: GridView.count(crossAxisCount: 2),
          );
        },
      ),
    );
  }
}
