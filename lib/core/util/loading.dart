import 'package:flutter/material.dart' hide FontWeight;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resalate/core/common/app_colors/app_colors.dart';
// import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: AppColors.scondaryColor,
            size: 60,
          ),
        ),
      ),
    );
  }
}

class LoadingScreen {
  LoadingScreen._();

  static Future<void> show(BuildContext context, {bool isDismissible = true}) {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, _) {},
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[LoadingWidget()],
          ),
        );
      },
    );
  }
}
