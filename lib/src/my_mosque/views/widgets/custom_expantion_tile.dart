import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/common/app_colors/app_colors.dart';

import '../../../../core/util/localization/app_localizations.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final Widget content;
  final bool initiallyExpanded;
  final Duration animationDuration;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Column(
          children: [
            // HEADER (title + expand icon)
            GestureDetector(
              onTap: _toggleExpand,
              child: Row(
                textDirection:
                    AppLocalizations.of(context)!.locale.languageCode == 'en'
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: widget.title,
                    ),
                  ),
                  AnimatedRotation(
                    duration: widget.animationDuration,
                    turns: _isExpanded ? 0.5 : 0.0,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(end: 10.w),
                      child: const Icon(
                        Icons.expand_more,
                        color: AppColors.scondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // EXPANDABLE CONTENT
            AnimatedCrossFade(
              duration: widget.animationDuration,
              crossFadeState: _isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.content,
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
