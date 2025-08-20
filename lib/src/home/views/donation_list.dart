import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/donation_item.dart';

class DonationListScreen extends StatelessWidget {
  const DonationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Donation"),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => const DonationItem(
                title: "Donation Title",
                image:
                    "https://www.shutterstock.com/image-photo/fill-out-donation-box-inside-260nw-1510159472.jpg",
              ),
          separatorBuilder: (context, index) => SizedBox(
                height: 10.h,
              ),
          itemCount: 10),
    );
  }
}
