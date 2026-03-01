import 'package:flutter/material.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';

class MainScreenViewModel {
  MainScreenViewModel();
  GenericCubit<int> screenIndex = GenericCubit<int>(0);

  PageController pageController = PageController();

  Future<void> screenIndexChanged({required int index}) async {
    screenIndex.onUpdateData(index);

    if (!pageController.hasClients) return;

    await pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  pageControllerIndexChanged({required int index}) {
    pageController = PageController(initialPage: index);
  }
}
