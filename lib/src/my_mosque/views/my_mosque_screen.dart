// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../core/common/app_colors/app_colors.dart';
// import '../../../core/common/app_font_style/app_font_style_global.dart';
// import '../../../core/shared_components/app_text/app_text.dart';
// import '../../../core/shared_components/app_text/models/app_text_model.dart';
// import '../../../core/util/localization/app_localizations.dart';
// import 'widgets/donation_item.dart';
// // import 'widgets/expantion_till.dart';
// import 'widgets/funerals_item.dart';
// import 'widgets/live_feed.dart';

// class MyMosqueScreen extends StatefulWidget {
//   const MyMosqueScreen({super.key});

//   @override
//   State<MyMosqueScreen> createState() => _MyMosqueScreenState();
// }

// class _MyMosqueScreenState extends State<MyMosqueScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _scrollController = ScrollController();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         controller: _scrollController,
//         slivers: [
//           SliverToBoxAdapter(
//             child: Image.network(
//               "https://images.pexels.com/photos/337904/pexels-photo-337904.jpeg",
//               height: 250.h,
//               fit: BoxFit.cover,
//               width: MediaQuery.of(context).size.width,
//             ),
//           ),
//           SliverPadding(
//             padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppText(
//                     text: "Mosque Name",
//                     model: AppTextModel(
//                       style: AppFontStyleGlobal(
//                               AppLocalizations.of(context)!.locale)
//                           .headingMedium2
//                           .copyWith(
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.black,
//                           ),
//                     ),
//                   ),
//                   5.h.verticalSpace,
//                   AppText(
//                     text: "Mosque full location",
//                     model: AppTextModel(
//                       style: AppFontStyleGlobal(
//                               AppLocalizations.of(context)!.locale)
//                           .subTitle2
//                           .copyWith(
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.gray,
//                           ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
//             sliver: SliverToBoxAdapter(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 60.h,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             color: AppColors.white,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               AppText(
//                                 text: "Friday Sermon: ",
//                                 model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .subTitle1
//                                       .copyWith(
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: AppColors.black,
//                                       ),
//                                 ),
//                               ),
//                               AppText(
//                                 text: "No",
//                                 model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .subTitle1
//                                       .copyWith(
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: AppColors.primaryColor,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         5.h.verticalSpace,
//                         Container(
//                           height: 60.h,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             color: AppColors.white,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               AppText(
//                                 text: "Washing the deceased: ",
//                                 model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .subTitle1
//                                       .copyWith(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: AppColors.black,
//                                       ),
//                                 ),
//                               ),
//                               AppText(
//                                 text: "No",
//                                 model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .subTitle1
//                                       .copyWith(
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: AppColors.primaryColor,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         5.h.verticalSpace,
//                         Container(
//                           height: 60.h,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             color: AppColors.white,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               AppText(
//                                 text: "Prayer for women: ",
//                                 model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .subTitle1
//                                       .copyWith(
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: AppColors.black,
//                                       ),
//                                 ),
//                               ),
//                               AppText(
//                                 text: "Yes",
//                                 model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .subTitle1
//                                       .copyWith(
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: AppColors.primaryColor,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   5.w.horizontalSpace,
//                   Expanded(
//                     child: Container(
//                       height: 190.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.r),
//                         color: AppColors.white,
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 20.h),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             AppText(
//                               text: "Types of lessons: ",
//                               model: AppTextModel(
//                                 style: AppFontStyleGlobal(
//                                         AppLocalizations.of(context)!.locale)
//                                     .subTitle1
//                                     .copyWith(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.black,
//                                     ),
//                               ),
//                             ),
//                             5.h.verticalSpace,
//                             AppText(
//                               text: "-Lessons1",
//                               model: AppTextModel(
//                                 style: AppFontStyleGlobal(
//                                         AppLocalizations.of(context)!.locale)
//                                     .subTitle1
//                                     .copyWith(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.primaryColor,
//                                     ),
//                               ),
//                             ),
//                             5.h.verticalSpace,
//                             AppText(
//                               text: "-Lessons2",
//                               model: AppTextModel(
//                                 style: AppFontStyleGlobal(
//                                         AppLocalizations.of(context)!.locale)
//                                     .subTitle1
//                                     .copyWith(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.primaryColor,
//                                     ),
//                               ),
//                             ),
//                             AppText(
//                               text: "-Lessons3",
//                               model: AppTextModel(
//                                 style: AppFontStyleGlobal(
//                                         AppLocalizations.of(context)!.locale)
//                                     .subTitle1
//                                     .copyWith(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.primaryColor,
//                                     ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Center(
//               child: TabBar(
//                 isScrollable: true,
//                 controller: _tabController,
//                 tabs: const [
//                   Tab(text: "حالات التبرع"),
//                   Tab(text: "الجنازات"),
//                   Tab(text: "البث المباشر"),
//                   Tab(text: "الدروس"),
//                 ],
//               ),
//             ),
//           ),
//           SliverFillRemaining(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//                   child: GridView.builder(
//                     padding: EdgeInsets.zero,
//                     itemCount: 10,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                             childAspectRatio: 0.99,
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 0,
//                             mainAxisSpacing: 10),
//                     itemBuilder: (BuildContext context, int index) {
//                       return const DonationItem(
//                           image:
//                               "https://t4.ftcdn.net/jpg/05/73/50/41/360_F_573504195_W4F7DYZo34RU1mXDiS1L3jGtW1KJlJFJ.jpg",
//                           title: "Donation title");
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//                   child: GridView.builder(
//                     padding: EdgeInsets.zero,
//                     itemCount: 10,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                             childAspectRatio: 0.99,
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 0,
//                             mainAxisSpacing: 10),
//                     itemBuilder: (BuildContext context, int index) {
//                       return const FuneralsItem(
//                         title: "صلاة الظهر",
//                         time: "12:00 pm",
//                         subTitle:
//                             "انا لله وأنا اليه راجعون توفي الي رحمة الله تعالي المرحوم..... والدفنة عقب صلاة الظهر",
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//                   child: GridView.builder(
//                     padding: EdgeInsets.zero,
//                     itemCount: 10,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                             childAspectRatio: 1.8,
//                             crossAxisCount: 1,
//                             crossAxisSpacing: 0,
//                             mainAxisSpacing: 10),
//                     itemBuilder: (BuildContext context, int index) {
//                       return const LiveFeedItem(
//                         title: "تبرع لبناء جامع",
//                         image:
//                             "https://cdn.pixabay.com/photo/2021/06/26/18/11/live-6366830_1280.png",
//                         desc: "بث مباشر لجمع تبرعات كذا كذا",
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         10.h.verticalSpace,
//                         Card(
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           clipBehavior: Clip.antiAlias,
//                           margin: EdgeInsets.zero,
//                           child: ExpansionTile(
//                             childrenPadding: EdgeInsets.symmetric(
//                                 horizontal: 20.w, vertical: 10.h),
//                             collapsedBackgroundColor: Colors.white,
//                             collapsedShape: const Border(),
//                             shape: const Border(),
//                             backgroundColor: Colors.white,
//                             title: AppText(
//                               text: "●	حلقات تحفيظ القرأن الكريم للصغار ",
//                               model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .bodyMedium2
//                                       .copyWith(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 18,
//                                         color: AppColors.primaryColor,
//                                       )),
//                             ),
//                             children: [
//                               AppText(
//                                 text:
//                                     "المواعيد من 12/7 الي 20/8 من الساعه 6 ص الي 10 ص من كل يوم -",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .subTitle1
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.scondaryColor,
//                                         )),
//                               ),
//                             ],
//                           ),
//                         ),
//                         20.h.verticalSpace,
//                         Card(
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           clipBehavior: Clip.antiAlias,
//                           margin: EdgeInsets.zero,
//                           child: ExpansionTile(
//                             expandedCrossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             collapsedBackgroundColor: Colors.white,
//                             collapsedShape: const Border(),
//                             shape: const Border(),
//                             backgroundColor: Colors.white,
//                             title: AppText(
//                               text: "●	محاضرات عن الاسلام ",
//                               model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .bodyMedium2
//                                       .copyWith(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 18,
//                                         color: AppColors.primaryColor,
//                                       )),
//                             ),
//                             childrenPadding: EdgeInsets.symmetric(
//                                 horizontal: 20.w, vertical: 10.h),
//                             children: [
//                               AppText(
//                                 text: "رجال",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .bodyMedium2
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 18,
//                                           color: AppColors.primaryColor,
//                                         )),
//                               ),
//                               10.h.verticalSpace,
//                               AppText(
//                                 text:
//                                     "المواعيد من 12/7 الي 20/8 من الساعه 6 ص الي 10 ص من كل يوم -",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .subTitle1
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.scondaryColor,
//                                         )),
//                               ),
//                               20.h.verticalSpace,
//                               AppText(
//                                 text: "نساء",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .bodyMedium2
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 18,
//                                           color: AppColors.primaryColor,
//                                         )),
//                               ),
//                               10.h.verticalSpace,
//                               AppText(
//                                 text:
//                                     "المواعيد من 12/7 الي 20/8 من الساعه 6 ص الي 10 ص من كل يوم -",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .subTitle1
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.scondaryColor,
//                                         )),
//                               ),
//                             ],
//                           ),
//                         ),
//                         20.h.verticalSpace,
//                         Card(
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           clipBehavior: Clip.antiAlias,
//                           margin: EdgeInsets.zero,
//                           child: ExpansionTile(
//                             expandedCrossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             collapsedBackgroundColor: Colors.white,
//                             collapsedShape: const Border(),
//                             shape: const Border(),
//                             backgroundColor: Colors.white,
//                             title: AppText(
//                               text: "●	دروس تعليميه ",
//                               model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .bodyMedium2
//                                       .copyWith(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 18,
//                                         color: AppColors.primaryColor,
//                                       )),
//                             ),
//                             childrenPadding: EdgeInsets.symmetric(
//                                 horizontal: 20.w, vertical: 10.h),
//                             children: [
//                               AppText(
//                                 text: "عربي ",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .bodyMedium2
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 18,
//                                           color: AppColors.primaryColor,
//                                         )),
//                               ),
//                               10.h.verticalSpace,
//                               AppText(
//                                 text:
//                                     "المواعيد من 12/7 الي 20/8 من الساعه 6 ص الي 10 ص من كل يوم -",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .subTitle1
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.scondaryColor,
//                                         )),
//                               ),
//                               20.h.verticalSpace,
//                               AppText(
//                                 text: "سويدي ",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .bodyMedium2
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 18,
//                                           color: AppColors.primaryColor,
//                                         )),
//                               ),
//                               10.h.verticalSpace,
//                               AppText(
//                                 text:
//                                     "المواعيد من 12/7 الي 20/8 من الساعه 6 ص الي 10 ص من كل يوم -",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .subTitle1
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.scondaryColor,
//                                         )),
//                               ),
//                               20.h.verticalSpace,
//                               AppText(
//                                 text: "أخري",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .bodyMedium2
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 18,
//                                           color: AppColors.primaryColor,
//                                         )),
//                               ),
//                               10.h.verticalSpace,
//                               AppText(
//                                 text:
//                                     "المواعيد من 12/7 الي 20/8 من الساعه 6 ص الي 10 ص من كل يوم -",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .subTitle1
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.scondaryColor,
//                                         )),
//                               ),
//                             ],
//                           ),
//                         ),
//                         20.h.verticalSpace,
//                         Card(
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           clipBehavior: Clip.antiAlias,
//                           margin: EdgeInsets.zero,
//                           child: ExpansionTile(
//                             expandedCrossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             collapsedBackgroundColor: Colors.white,
//                             collapsedShape: const Border(),
//                             shape: const Border(),
//                             backgroundColor: Colors.white,
//                             title: AppText(
//                               text: "●	المسابقات الثقافيه والموسميه ",
//                               model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .bodyMedium2
//                                       .copyWith(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 18,
//                                         color: AppColors.primaryColor,
//                                       )),
//                             ),
//                             childrenPadding: EdgeInsets.symmetric(
//                                 horizontal: 20.w, vertical: 10.h),
//                             children: [
//                               AppText(
//                                 text:
//                                     "المواعيد من 12/7 الي 20/8 من الساعه 6 ص الي 10 ص من كل يوم -",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .subTitle1
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.scondaryColor,
//                                         )),
//                               ),
//                             ],
//                           ),
//                         ),
//                         20.h.verticalSpace,
//                         Card(
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           clipBehavior: Clip.antiAlias,
//                           margin: EdgeInsets.zero,
//                           child: ExpansionTile(
//                             expandedCrossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             collapsedBackgroundColor: Colors.white,
//                             collapsedShape: const Border(),
//                             shape: const Border(),
//                             backgroundColor: Colors.white,
//                             title: AppText(
//                               text: "●	المخيم الصيفي ",
//                               model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .bodyMedium2
//                                       .copyWith(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 18,
//                                         color: AppColors.primaryColor,
//                                       )),
//                             ),
//                             childrenPadding: EdgeInsets.symmetric(
//                                 horizontal: 20.w, vertical: 10.h),
//                             children: [
//                               AppText(
//                                 text:
//                                     "المواعيد من 12/7 الي 20/8 من الساعه 6 ص الي 10 ص من كل يوم -",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .subTitle1
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.scondaryColor,
//                                         )),
//                               ),
//                             ],
//                           ),
//                         ),
//                         20.h.verticalSpace,
//                         Card(
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           clipBehavior: Clip.antiAlias,
//                           margin: EdgeInsets.zero,
//                           child: ExpansionTile(
//                             expandedCrossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             collapsedBackgroundColor: Colors.white,
//                             collapsedShape: const Border(),
//                             shape: const Border(),
//                             backgroundColor: Colors.white,
//                             title: AppText(
//                               text: "●	دوره تعليميه ",
//                               model: AppTextModel(
//                                   style: AppFontStyleGlobal(
//                                           AppLocalizations.of(context)!.locale)
//                                       .bodyMedium2
//                                       .copyWith(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 18,
//                                         color: AppColors.primaryColor,
//                                       )),
//                             ),
//                             childrenPadding: EdgeInsets.symmetric(
//                                 horizontal: 20.w, vertical: 10.h),
//                             children: [
//                               AppText(
//                                 text:
//                                     "المواعيد من 12/7 الي 20/8 من الساعه 6 ص الي 10 ص من كل يوم -",
//                                 model: AppTextModel(
//                                     style: AppFontStyleGlobal(
//                                             AppLocalizations.of(context)!
//                                                 .locale)
//                                         .subTitle1
//                                         .copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.scondaryColor,
//                                         )),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard(String label, String value) {
//     return Container(
//       height: 60.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.r),
//         color: AppColors.white,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           AppText(
//             text: label,
//             model: AppTextModel(
//               style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
//                   .subTitle1
//                   .copyWith(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.black,
//                   ),
//             ),
//           ),
//           AppText(
//             text: value,
//             model: AppTextModel(
//               style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
//                   .subTitle1
//                   .copyWith(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.primaryColor,
//                   ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGrid(int crossAxisCount, Widget item) {
//     return GridView.builder(
//       padding: EdgeInsets.zero,
//       itemCount: 10,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         childAspectRatio: 0.99,
//         crossAxisCount: crossAxisCount,
//         crossAxisSpacing: 0,
//         mainAxisSpacing: 10,
//       ),
//       itemBuilder: (BuildContext context, int index) {
//         return item;
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import 'widgets/donation_item.dart';
import 'widgets/funerals_item.dart';
import 'widgets/live_feed.dart';

class MyMosqueScreen extends StatefulWidget {
  const MyMosqueScreen({super.key});

  @override
  State<MyMosqueScreen> createState() => _MyMosqueScreenState();
}

class _MyMosqueScreenState extends State<MyMosqueScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            /// Image + flexible app bar
            SliverAppBar(
              pinned: true,
              expandedHeight: 250.h,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  "https://images.pexels.com/photos/337904/pexels-photo-337904.jpeg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            /// Mosque name + location
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Mosque Name",
                      model: AppTextModel(
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .headingMedium2
                            .copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                      ),
                    ),
                    5.h.verticalSpace,
                    AppText(
                      text: "Mosque full location",
                      model: AppTextModel(
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .subTitle2
                            .copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Services cards
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(child: _buildInfoCard("Friday Sermon: ", "No")),
                    10.w.horizontalSpace,
                    Expanded(
                        child: _buildInfoCard("Prayer for women: ", "Yes")),
                  ],
                ),
              ),
            ),

            /// Sticky TabBar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: AppColors.primaryColor,
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: "حالات التبرع"),
                    Tab(text: "الجنازات"),
                    Tab(text: "البث المباشر"),
                    Tab(text: "الدروس"),
                  ],
                ),
              ),
            ),
          ];
        },

        /// Tab content (scrollable independently)
        body: TabBarView(
          controller: _tabController,
          children: [
            /// Donations
            GridView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, __) => const DonationItem(
                image:
                    "https://t4.ftcdn.net/jpg/05/73/50/41/360_F_573504195_W4F7DYZo34RU1mXDiS1L3jGtW1KJlJFJ.jpg",
                title: "Donation title",
              ),
            ),

            /// Funerals
            GridView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, __) => const FuneralsItem(
                title: "صلاة الظهر",
                time: "12:00 pm",
                subTitle:
                    "انا لله وأنا اليه راجعون توفي المرحوم..... والدفنة عقب صلاة الظهر",
              ),
            ),

            /// Live feed
            ListView.separated(
              padding: EdgeInsets.all(12.w),
              itemCount: 10,
              itemBuilder: (_, __) => const LiveFeedItem(
                title: "تبرع لبناء جامع",
                image:
                    "https://cdn.pixabay.com/photo/2021/06/26/18/11/live-6366830_1280.png",
                desc: "بث مباشر لجمع تبرعات كذا كذا",
              ),
              separatorBuilder: (_, __) => 20.h.verticalSpace,
            ),

            /// Lessons (your expansion tiles)
            ListView(
              padding: EdgeInsets.all(12.w),
              children: [
                _buildLessonTile("● حلقات تحفيظ القرأن الكريم للصغار",
                    "المواعيد من 12/7 الي 20/8 من 6 ص الي 10 ص"),
                20.h.verticalSpace,
                _buildLessonTile(
                    "● محاضرات عن الاسلام", "رجال ونساء - مواعيد ..."),
                20.h.verticalSpace,
                _buildLessonTile("● دروس تعليميه", "عربي - سويدي - ..."),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.white,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              text: label,
              model: AppTextModel(
                style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                    .subTitle1
                    .copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
              ),
            ),
            AppText(
              text: value,
              model: AppTextModel(
                style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                    .subTitle1
                    .copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonTile(String title, String desc) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        title: AppText(
          text: title,
          model: AppTextModel(
            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                .bodyMedium2
                .copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.primaryColor,
                ),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: AppText(
              text: desc,
              model: AppTextModel(
                style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                    .subTitle1
                    .copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.scondaryColor,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate old) => false;
}
