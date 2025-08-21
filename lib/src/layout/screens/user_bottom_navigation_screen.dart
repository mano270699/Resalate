import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_icon_svg.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../home/views/donation_list.dart';
import '../../home/views/home_screen.dart';
import '../../my_mosque/views/my_mosque_screen.dart';
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
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = sl<MainScreenViewModel>();
    List<Widget> screens = const [
      HomePage(),
      DonationListScreen(),
      MyMosqueScreen(),
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
      buildWhen: (previous, current) => current is GenericUpdatedState,
      builder: (context, indexState) {
        return Scaffold(
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
                selectedLabelStyle: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
                unselectedFontSize: 14,
                type: BottomNavigationBarType.fixed,
                currentIndex: indexState.data,
                onTap: (value) {
                  viewModel.isOpenFromHome = false;
                  viewModel.screenIndexChanged(index: value);
                },
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
        );
      },
    );
  }
}
