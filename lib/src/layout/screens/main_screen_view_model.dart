import '../../../core/blocs/generic_cubit/generic_cubit.dart';

class MainScreenViewModel {
  MainScreenViewModel();
  GenericCubit<int> screenIndex = GenericCubit<int>(0);

  screenIndexChanged({required int index}) {
    screenIndex.onUpdateData(index);
  }
}
