import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class FaqExpansionTile extends StatelessWidget {
  final String question;
  final String answer;

  const FaqExpansionTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          children: [
            Html(
              data: answer, // render HTML content
              style: {
                "body": Style(
                  fontSize: FontSize(14),
                  color: Colors.grey[700],
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
