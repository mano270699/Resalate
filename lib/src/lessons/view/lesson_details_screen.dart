import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/base/dependency_injection.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/lessons/data/models/lesson_details.dart';
import 'package:resalate/src/lessons/logic/lesson_viewmodel.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/push_notification/notification_helper.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../layout/screens/user_bottom_navigation_screen.dart';

class LessonDetailsScreen extends StatefulWidget {
  const LessonDetailsScreen({super.key, required this.id});
  final int id;
  static const String routeName = 'LessonDetailsScreen';

  @override
  State<LessonDetailsScreen> createState() => _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
  final viewModel = sl<LessonViewModel>();
  @override
  void initState() {
    viewModel.getLessonDetails(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(AppLocalizations.of(context)!.translate("lesson_details")),
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                if (NotificationHelper.isFromNotifiction) {
                  Navigator.pushNamed(
                    context,
                    MainBottomNavigationScreen.routeName,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.black,
                size: 30,
              )),
        ),
        body: BlocBuilder<GenericCubit<LessonDetailsModel>,
                GenericCubitState<LessonDetailsModel>>(
            bloc: viewModel.lessonDetailsRes,
            builder: (context, state) {
              return Skeletonizer(
                enabled: state is GenericLoadingState,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((state.data.lesson?.image ?? "").isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            state.data.lesson!.image!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              state.data.lesson?.masjid?.photo ?? "",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.data.lesson?.masjid?.name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(state.data.lesson?.masjid?.email ?? "",
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Post Title
                      Text(
                        state.data.lesson?.title ?? "",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),

                      /// Post Content (HTML)

                      Html(
                        data: state.data.lesson?.content ??
                            "", // render HTML content
                        style: {
                          "body": Style(
                            fontSize: FontSize(14),
                            color: Colors.grey[700],
                          ),
                        },
                      ),
                      const SizedBox(height: 20),

                      /// Date
                      Text(
                        "${AppLocalizations.of(context)!.translate("Published")} ${state.data.lesson?.date ?? ""}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      10.h.verticalSpace,
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children:
                            (state.data.lesson?.categories?.isNotEmpty ?? false)
                                ? state.data.lesson!.categories!
                                    .map((cat) => Chip(
                                          label: Text(cat.name ?? ""),
                                          backgroundColor: Colors.blue.shade50,
                                        ))
                                    .toList()
                                : [
                                    const Text("No categories available"),
                                  ], // 👈 fallback
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
