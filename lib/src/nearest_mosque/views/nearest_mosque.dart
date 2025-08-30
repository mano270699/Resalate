import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_component_style/component_style.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/shared_components/text_form_field/app_text_field.dart';
import '../../../core/shared_components/text_form_field/models/app_text_field_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import 'widget/mosque_item.dart';

class NearestMosque extends StatefulWidget {
  const NearestMosque({super.key});
  static const String routeName = 'Nearest Mosque Screen';

  @override
  State<NearestMosque> createState() => _NearestMosqueState();
}

class _NearestMosqueState extends State<NearestMosque> {
  int showItem = 1;

  List<Map<String, dynamic>> mosquesList = [
    {
      "name": "مسجد أدهم باي",
      "address": "ألبانيا",
      "image":
          "https://www.yasmina.com/tachyon/sites/5/2022/01/96fde973b5fc40b8d4ab8631976f3d252b453f2a.jpg"
    },
    {
      "name": "المسجد الغربي",
      "address": "أمستردام",
      "image":
          "https://www.yasmina.com/tachyon/sites/5/2022/01/e0b7c7811a25d609e794d2f161cb34a30550b44d.jpg"
    },
    {
      "name": "مسجد ريجنت بارك",
      "address": "لندن",
      "image":
          "https://www.yasmina.com/tachyon/sites/5/2022/01/36b6d9b7e01fa8ab8cfa0e2273590a6f56d15ca1.jpg"
    },
    {
      "name": "المنستير لا ريال",
      "address": "إسبانيا",
      "image":
          "https://assets.raya.com/wp-content/uploads/2020/07/12000039/%D9%85%D8%B3%D8%AC%D8%B1-%D8%A7%D9%84%D9%85%D9%86%D8%B3%D8%AA%D9%8A%D8%B1.jpg"
    },
    {
      "name": "باريس الكبير",
      "address": "فرنسا",
      "image":
          "https://assets.raya.com/wp-content/uploads/2020/07/12000101/%D9%85%D8%B3%D8%AC%D8%AF-%D8%A8%D8%A7%D8%B1%D9%8A%D8%B3-%D8%A7%D9%84%D9%83%D8%A8%D9%8A%D8%B1.jpg"
    },
    {
      "name": "فينبسبري بارك",
      "address": "بريطانيا",
      "image":
          "https://assets.raya.com/wp-content/uploads/2020/07/12000118/%D9%85%D8%B3%D8%AC%D8%AF-%D9%81%D9%8A%D9%86%D8%A8%D8%B3%D8%A8%D8%B1%D9%8A-%D8%A8%D8%A7%D8%B1%D9%83.jpg"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(AppLocalizations.of(context)!.translate("nearest_mosques")),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: AppTextField(
                          model: AppTextFieldModel(
                            appTextModel: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .bodyRegular1
                                    .copyWith(
                                      color: AppColors.primaryColor,
                                    )),
                            controller: TextEditingController(),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,

                            onChangeInput: (value) {
                              if (value.length <= 1) {
                                setState(() {});
                              }
                            },
                            // label: "Search..",
                            borderRadius: BorderRadius.circular(12.r),
                            decoration: ComponentStyle.inputDecoration(
                              AppLocalizations.of(context)!.locale,
                            ).copyWith(
                              fillColor: AppColors.white,
                              contentPadding:
                                  EdgeInsetsDirectional.only(start: 10.w),
                              filled: true,

                              //   floatingLabelBehavior: viewModel.password.text.isEmpty
                              //       ? FloatingLabelBehavior.never
                              //       : FloatingLabelBehavior.always,
                              // labelText: "Search..",
                              //  viewModel.password.text.isEmpty
                              //     ? null
                              //     :
                              // AppLocalizations.of(context)!.translate('password'),
                              hintText: "Search..",
                              //  AppLocalizations.of(context)!.translate('password'),
                            ),
                            errorText: "",

                            // validation.data.isNotEmpty
                            //     ? AppLocalizations.of(context)!.translate(validation.data)
                            //     : null,
                          ),
                        ),
                      ),
                    ),
                    10.w.horizontalSpace,
                    Container(
                      height: 47.h,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: const Center(
                        child: Icon(
                          Icons.filter_alt_sharp,
                          color: AppColors.scondaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showItem = 1;
                        });
                      },
                      child: Icon(
                        Icons.all_inbox,
                        color: showItem == 1
                            ? AppColors.scondaryColor
                            : AppColors.gray,
                      ),
                    ),
                    10.w.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showItem = 2;
                        });
                      },
                      child: Icon(
                        Icons.window,
                        color: showItem == 2
                            ? AppColors.scondaryColor
                            : AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: mosquesList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: showItem == 2 ? 0.83 : 1.45,
                      crossAxisCount: showItem,
                      crossAxisSpacing: 5.w,
                      mainAxisSpacing: 5.h),
                  itemBuilder: (BuildContext context, int index) {
                    return MosqueItem(
                        address: mosquesList[index]["address"],
                        lat: "31.2001",
                        long: "29.9187",
                        image: mosquesList[index]["image"],
                        title: mosquesList[index]["name"]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
