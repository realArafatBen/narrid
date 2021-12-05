import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/store/banner/slider_bloc.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';
import 'package:narrid/dashboard/screens/food/home_page.dart';
import 'package:narrid/dashboard/screens/grocery/home_page.dart';
import 'package:narrid/dashboard/screens/logistices/home_page.dart';
import 'package:narrid/utils/ui/shimmer.dart';

class Banners extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SliderBannerBloc(BannersRep())..add(AppStarted()),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Center(
          child: SizedBox(
            height: 150.0,
            child: buildCarousel(),
          ),
        ),
      ),
    );
  }

  BlocBuilder buildCarousel() {
    return BlocBuilder<SliderBannerBloc, SliderBannerState>(
        builder: (context, state) {
      if (state is Loading) {
        return ShimmerSlider();
      } else if (state is Loaded) {
        return getCarousel(state, context);
      } else if (state is ErrorLoading) {
        return ErrorLoadingWigdet();
      } else {
        return null;
      }
    });
  }

  Carousel getCarousel(state, context) {
    List<BannersModel> banners = state.getBanners;

    return Carousel(
      boxFit: BoxFit.cover,
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
        for (var item in banners)
          InkWell(
            onTap: () {
              if (item.section == 'store') {
                //do nothing
              } else if (item.section == 'food') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Food(),
                    ));
              } else if (item.section == 'grocery') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Grocery(),
                    ));
              } else if (item.section == 'logistics') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Logistics(),
                    ));
              } else {
                //do nothing
              }
            },
            child: Image.network(
              item.image.toString(),
              fit: BoxFit.cover,
            ),
          )
      ],
    );
  }
}

class ErrorLoadingWigdet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShimmerSlider();
  }
}
