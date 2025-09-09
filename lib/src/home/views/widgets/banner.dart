import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../data/models/home_data_model.dart';

// ignore: must_be_immutable
class CustomBannerSlider extends StatefulWidget {
  const CustomBannerSlider({
    super.key,
    required this.images,
  });
  final List<MediaItem> images;
  @override
  CustomBannerSliderState createState() => CustomBannerSliderState();
}

class CustomBannerSliderState extends State<CustomBannerSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: MediaQuery.of(context).size.width * (140 / 300),
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
      items: widget.images.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: <Widget>[
                SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(0)),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.jpg',
                          image: i.url,
                          height: 200,
                          fit: BoxFit.fill,
                        ))),
                Positioned(
                  bottom: 20,
                  right: 50,
                  left: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.images.map((url) {
                      int index = widget.images.indexOf(url);
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
