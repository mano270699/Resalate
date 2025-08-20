import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/item_for_donation.dart';

class FromMosqueToMosqueScreen extends StatelessWidget {
  const FromMosqueToMosqueScreen({super.key});
  static const String routeName = 'FromMosqueToMosque Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("From Mosque To Mosque"),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) => const ItemForDonation(
                  image:
                      "https://dsbooks.com.au/cdn/shop/products/al-quran-A4-21x29cmx3cm-uthmani-darussalam-islamic-bookstore-australia-dsbooks-1.jpg",
                  subtitle: "مصاحف زائدة في مسجد الرحمة ",
                  title: "مصاحف زائدة",
                  whatsAppNumber: "+201069103550",
                ),
            separatorBuilder: (context, index) => 10.h.verticalSpace,
            itemCount: 10));
  }
}
