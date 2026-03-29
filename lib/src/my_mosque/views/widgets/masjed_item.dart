import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resalate/core/base/dependency_injection.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/core/common/app_colors/app_colors.dart';
import 'package:resalate/core/common/app_font_style/app_font_style_global.dart';
import 'package:resalate/core/shared_components/app_snack_bar/app_snack_bar.dart';
import 'package:resalate/core/shared_components/app_text/app_text.dart';
import 'package:resalate/core/shared_components/app_text/models/app_text_model.dart';
import 'package:resalate/core/shared_components/app_cached_network_image.dart';
import 'package:resalate/core/util/localization/app_localizations.dart';
import 'package:resalate/src/my_mosque/data/models/masjed_list_model.dart';
import 'package:resalate/src/my_mosque/data/models/follow_masjed_model.dart';
import 'package:resalate/src/my_mosque/logic/masjed_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MasjidItem extends StatefulWidget {
  final Masjid masjid;
  final VoidCallback? onTap;
  final MasjedViewModel viewModel;

  const MasjidItem({
    super.key,
    required this.masjid,
    this.onTap,
    required this.viewModel,
  });

  @override
  State<MasjidItem> createState() => _MasjidItemState();
}

class _MasjidItemState extends State<MasjidItem> {
  double? _distanceKm;

  @override
  void initState() {
    super.initState();
    _calculateDistance();
  }

  Future<void> _calculateDistance() async {
    if (widget.masjid.lat == null || widget.masjid.lng == null) return;

    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      final distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        widget.masjid.lat!,
        widget.masjid.lng!,
      );

      if (mounted) {
        setState(() {
          _distanceKm = distanceInMeters / 1000;
        });
      }
    } catch (_) {
      // Location not available — silently skip
    }
  }

  Future<void> _openDirections() async {
    if (widget.masjid.lat == null || widget.masjid.lng == null) return;

    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${widget.masjid.lat},${widget.masjid.lng}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).toInt()} m';
    } else if (km < 10) {
      return '${km.toStringAsFixed(1)} km';
    } else {
      return '${km.toInt()} km';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Cover Image
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              fit: StackFit.passthrough,
              children: [
                AppCachedNetworkImage(
                  image: widget.masjid.cover ??
                      "https://praysalat.com/assets/images/placeholder-2.jpg",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // Distance badge (top-right)
                if (_distanceKm != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.scondaryColor.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.white, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            _formatDistance(_distanceKm!),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Profile Image
                Positioned(
                  bottom: -30,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(widget.masjid.image ??
                          "https://praysalat.com/assets/images/placeholder-2.jpg"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.masjid.name ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 8.w),
                      BlocConsumer<GenericCubit<FollowMasjedResponse>,
                          GenericCubitState<FollowMasjedResponse>>(
                        bloc: sl<MasjedViewModel>().followActionRes,
                        listener: (context, state) {
                          if (state is GenericUpdatedState) {
                            showAppSnackBar(
                              context: context,
                              message: state.data.action,
                              color: AppColors.success,
                            );
                          } else if (state is GenericErrorState) {
                            showAppSnackBar(
                              context: context,
                              message: state.responseError?.errorMessage,
                              color: AppColors.error,
                            );
                          }
                        },
                        builder: (context, actionState) {
                          bool isFollowing = widget.masjid.isFollowing == 1;
                          if (actionState is GenericUpdatedState &&
                              actionState.data.masjidId == widget.masjid.id) {
                            isFollowing = actionState.data.action == "followed";
                            widget.masjid.isFollowing = isFollowing ? 1 : 0;
                          }

                          return InkWell(
                            onTap: () {
                              debugPrint("isFollowing::$isFollowing");
                              if (isFollowing) {
                                widget.viewModel.unfollowMasjed(context,
                                    masjedId: widget.masjid.id ?? 0);
                              } else {
                                widget.viewModel.followMasjed(context,
                                    masjedId: widget.masjid.id ?? 0);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: AppColors.error),
                              child: actionState is GenericLoadingState
                                  ? SizedBox(
                                      width: 14.w,
                                      height: 14.h,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : AppText(
                                      text: isFollowing
                                          ? AppLocalizations.of(context)!
                                              .translate("unfollow")
                                          : AppLocalizations.of(context)!
                                              .translate("follow"),
                                      model: AppTextModel(
                                        style: AppFontStyleGlobal(
                                                AppLocalizations.of(context)!
                                                    .locale)
                                            .subTitle2
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.white,
                                              fontSize: 12.sp,
                                            ),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.masjid.city}, ${widget.masjid.province}, ${widget.masjid.country}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  // Distance and Directions row
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_distanceKm != null)
                        Row(
                          children: [
                            Icon(Icons.near_me_rounded,
                                color: AppColors.primaryColor, size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(
                              _formatDistance(_distanceKm!),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        )
                      else
                        const SizedBox.shrink(),
                      if (widget.masjid.lat != null &&
                          widget.masjid.lng != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _openDirections,
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.directions_rounded,
                                        color: AppColors.primaryColor,
                                        size: 18.sp),
                                    SizedBox(width: 4.w),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate("directions"),
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Languages row
                  if (widget.masjid.languages?.isNotEmpty ?? false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.masjid.languages!
                              .map((lang) => Chip(
                                    label: Text(lang.title),
                                    backgroundColor: Colors.blue.shade50,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
