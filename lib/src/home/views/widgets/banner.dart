import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';

// ignore: must_be_immutable
class CustomBannerSlider extends StatefulWidget {
  CustomBannerSlider({
    super.key,
  });

  @override
  _CustomBannerSliderState createState() => _CustomBannerSliderState();
}

class _CustomBannerSliderState extends State<CustomBannerSlider> {
  int _currentIndex = 0;
  List<String> list = [
    "https://images.pexels.com/photos/337904/pexels-photo-337904.jpeg?cs=srgb&dl=pexels-pashal-337904.jpg&fm=jpg",
    "https://storage.needpix.com/rsynced_images/al-aqsa-mosque-3911093_1280.jpg",
    "https://st.depositphotos.com/1007905/1312/i/950/depositphotos_13129284-stock-photo-inside-manavgat-mosque.jpg"
        "https://www.shutterstock.com/image-photo/dome-rock-alaqsa-mosque-600nw-1703179267.jpg",
    "https://st2.depositphotos.com/1007905/6234/i/450/depositphotos_62346979-stock-photo-warm-mosque-interior.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          aspectRatio: 300 / 140,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          autoPlayCurve: Curves.easeInExpo,
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          }),
      items: list.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                  child: SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.jpg',
                            image: i,
                            height: 200,
                            fit: BoxFit.fill,
                          ))),
                ),
                Positioned(
                  bottom: 20,
                  right: 50,
                  left: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: list.map((url) {
                      int index = list.indexOf(url);
                      return Container(
                        width: 7.0,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? AppColors.primaryColor
                              : Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        );
      }).toList(),
    );
  }
}
