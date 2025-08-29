import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resalate/src/notification/data/models/notification_model.dart';
import 'package:resalate/src/notification/logic/notification_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import 'widgets/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final viewModel = sl<NotificationViewModel>()..getNotifications();

  static const String routeName = 'NotificationScreen';

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: AppText(
                text: AppLocalizations.of(context)!.translate("notifications"),
                model: AppTextModel(
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .bodyMedium1
                          .copyWith(
                            color: AppColors.black,
                          ),
                ),
              ),
            ),
            body: BlocBuilder<GenericCubit<NotificationModel>,
                GenericCubitState<NotificationModel>>(
              bloc: viewModel.notifcationRes,
              builder: (context, state) {
                if (state is GenericErrorState) {
                  return Center(
                      child:
                          Text(state.responseError?.errorMessage ?? "Error"));
                }

                // Show loading skeleton
                if (state is GenericLoadingState) {
                  return Skeletonizer(
                    enabled: true,
                    child: ListView.builder(
                      itemCount: 6, // Fake items while loading
                      itemBuilder: (_, __) =>
                          NotificationItem(notification: Notifications()),
                    ),
                  );
                }

                // Get notifications list
                final notifications = state.data.notifications ?? [];

                if (notifications.isEmpty) {
                  // Empty state UI
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_off,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 12),
                        AppText(
                          text: AppLocalizations.of(context)!
                              .translate("no_notifications"),
                          model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .bodyMedium1
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Normal list
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return NotificationItem(notification: notification);
                  },
                );
              },
            )));
  }
}
