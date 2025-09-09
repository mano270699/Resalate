import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/base/dependency_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/common/app_icon_svg.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../donation/view/donation_list.dart';
import '../../home/views/home_screen.dart';
import '../../my_mosque/views/mosque_screen.dart';
import '../../profile/views/profile_screen.dart';
import '../data/model/bottom_bar_model.dart';
import 'main_screen_view_model.dart';

class MainBottomNavigationScreen extends StatefulWidget {
  const MainBottomNavigationScreen({super.key});
  static const String routeName = 'Main Screen';

  @override
  State<MainBottomNavigationScreen> createState() =>
      _MainBottomNavigationScreenState();
}

class _MainBottomNavigationScreenState
    extends State<MainBottomNavigationScreen> {
  final viewModel = sl<MainScreenViewModel>();
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomePage(),
      DonationListScreen(),
      MasjedListScreen(),
      ProfileScreen()
    ];
    List<BottomBarItem> bottomBarItems = [
      BottomBarItem(
          icon: AppIconSvg.home,
          title: AppLocalizations.of(context)!.translate('home')),
      BottomBarItem(
          icon: AppIconSvg.donate,
          title: AppLocalizations.of(context)!.translate('donate')),
      BottomBarItem(
          icon: AppIconSvg.mosque,
          title: AppLocalizations.of(context)!.translate('my_mosque')),
      BottomBarItem(
          icon: AppIconSvg.profile,
          title: AppLocalizations.of(context)!.translate('profile')),
    ];
    return BlocBuilder<GenericCubit<int>, GenericCubitState<int>>(
      bloc: viewModel.screenIndex,
      builder: (context, indexState) {
        return Directionality(
          textDirection:
              AppLocalizations.of(context)!.locale.languageCode == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
          child: Scaffold(
            body: screens[indexState.data],
            bottomNavigationBar: Container(
              height: 86.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r))),
              child: BottomNavigationBar(
                  selectedItemColor: AppColors.primaryColor,
                  selectedLabelStyle:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .subTitle2
                          .copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                  unselectedFontSize: 14,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: indexState.data,
                  onTap: (value) {
                    viewModel.screenIndexChanged(index: value);
                  },
                  unselectedLabelStyle:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .subTitle2
                          .copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.gray,
                          ),
                  items: List.generate(bottomBarItems.length, (index) {
                    return BottomNavigationBarItem(
                        label: bottomBarItems[index].title,
                        icon: SvgPicture.asset(
                          bottomBarItems[index].icon,
                          height: 25,
                          width: 25,
                          allowDrawingOutsideViewBox: true,
                          // color: indexState.data == index
                          //     ? AppColors.primaryColor
                          //     : AppColors.lightBlack,
                        ));
                  })),
            ),
          ),
        );
      },
    );
  }
}
