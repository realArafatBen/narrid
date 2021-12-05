import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        child: Container(
          height: 150,
          width: double.infinity,
          color: Colors.white,
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
      ),
    );
  }
}

class ShimmerCategeory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(5),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 4,
          children: [
            Container(
              width: 70,
              height: 70,
              color: Colors.white,
            ),
            Container(
              width: 70,
              height: 70,
              color: Colors.white,
            ),
            Container(
              width: 70,
              height: 70,
              color: Colors.white,
            ),
            Container(
              width: 70,
              height: 70,
              color: Colors.white,
            ),
            Container(
              width: 70,
              height: 70,
              color: Colors.white,
            ),
            Container(
              width: 70,
              height: 70,
              color: Colors.white,
            ),
            Container(
              width: 70,
              height: 70,
              color: Colors.white,
            ),
            Container(
              width: 70,
              height: 70,
              color: Colors.white,
            ),
          ],
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
      ),
    );
  }
}

class ShimmerSlideProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 120,
                  height: 100,
                  color: Colors.white,
                ),
              );
            }),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
      ),
    );
  }
}

class ShimmerCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListView.builder(
          itemCount: 12,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 60,
                width: 50,
                color: Colors.white,
              ),
            );
          }),
    );
  }
}

class ShimmerSubCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: GridView.count(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: [
          Container(
            width: 70,
            height: 70,
            color: Colors.white,
          ),
          Container(
            width: 70,
            height: 70,
            color: Colors.white,
          ),
          Container(
            width: 70,
            height: 70,
            color: Colors.white,
          ),
          Container(
            width: 70,
            height: 70,
            color: Colors.white,
          ),
          Container(
            width: 70,
            height: 70,
            color: Colors.white,
          ),
          Container(
            width: 70,
            height: 70,
            color: Colors.white,
          ),
          Container(
            width: 70,
            height: 70,
            color: Colors.white,
          ),
          Container(
            width: 70,
            height: 70,
            color: Colors.white,
          ),
        ],
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }
}

class ShimmerProductVariants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 50,
              height: 42,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 50,
              height: 42,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 50,
              height: 42,
              color: Colors.white,
            ),
          ),
        ],
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }
}

class ShimmerProductDetials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              width: double.infinity,
              height: 10,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              width: double.infinity,
              height: 30,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              width: double.infinity,
              height: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }
}

class ShimmerDeliveryDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              color: Colors.white,
              width: double.infinity,
              height: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              color: Colors.white,
              width: double.infinity,
              height: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              color: Colors.white,
              width: double.infinity,
              height: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              color: Colors.white,
              width: double.infinity,
              height: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              color: Colors.white,
              width: double.infinity,
              height: 10,
            ),
          ),
        ],
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }
}

class ShimmerOrderDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 20,
                    height: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    color: Colors.white,
                    width: 300,
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 20,
                    height: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    color: Colors.white,
                    width: 300,
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 20,
                    height: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    color: Colors.white,
                    width: 300,
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }
}

class ShimmerProductDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          margin: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          color: Colors.white,
          width: double.infinity,
          height: 20,
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100]);
  }
}

class ShimmerCheckoutAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                right: 10,
                left: 10,
              ),
              color: Colors.white,
              width: double.infinity,
              height: 20,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.only(
                right: 10,
                left: 10,
              ),
              color: Colors.white,
              width: double.infinity,
              height: 20,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.only(
                right: 10,
                left: 10,
              ),
              color: Colors.white,
              width: double.infinity,
              height: 20,
            ),
          ],
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100]);
  }
}

class ShimmerStores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        child: Column(
          children: [
            for (var i = 0; i < 8; i++)
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 150,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 20,
                          width: 250,
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
          ],
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
      ),
    );
  }
}

class ShimmerFeatureProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
                right: 10,
                left: 10,
              ),
              color: Colors.white,
              width: 250,
              height: 100,
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              margin: const EdgeInsets.only(
                right: 10,
                left: 10,
              ),
              color: Colors.white,
              width: 50,
              height: 100,
            ),
          ],
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100]);
  }
}
