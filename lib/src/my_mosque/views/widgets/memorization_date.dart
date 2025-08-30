import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/util/localization/app_localizations.dart';
import '../../data/models/masjed_details_model.dart';

class MemorizationLessonDates extends StatelessWidget {
  final List<MemorizationDate> memorizationDates;

  const MemorizationLessonDates({super.key, required this.memorizationDates});

  String _getDayName(String dateString) {
    try {
      final date = intl.DateFormat("MMMM d, yyyy").parse(dateString);
      return intl.DateFormat("EEEE").format(date); // e.g. Tuesday
    } catch (e) {
      return "";
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = intl.DateFormat("MMMM d, yyyy").parse(dateString);
      // Example: "Aug 12, 2025"
      return intl.DateFormat("MMM d, yyyy").format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon + title
              Row(
                children: [
                  Icon(Icons.calendar_month, color: Colors.green),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate("Memorization_Lesson_Dates"),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ...memorizationDates.map((item) {
                final day = _getDayName(item.date ?? "");
                final formattedDate = _formatDate(item.date ?? "");
                final description = item.description ?? "";

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Day
                      Expanded(
                        flex: 2,
                        child: Text(
                          day,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Date (short month)
                      Expanded(
                        flex: 3,
                        child: Text(formattedDate),
                      ),

                      // Description (render HTML)
                      Expanded(
                        flex: 5,
                        child: Html(data: description),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
