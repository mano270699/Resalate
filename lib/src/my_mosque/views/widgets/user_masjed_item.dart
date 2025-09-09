import 'package:flutter/material.dart';

import '../../data/models/user_masjeds_model.dart';

class UserMasjidItem extends StatelessWidget {
  final Masjids masjid;
  final VoidCallback? onTap;

  const UserMasjidItem({
    super.key,
    required this.masjid,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Cover Image
            Stack(
              clipBehavior: Clip.none, // 🔥 allow overflow

              alignment: Alignment.center,
              fit: StackFit.passthrough,
              children: [
                Image.network(
                  masjid.photo ??
                      "https://praysalat.com/assets/images/placeholder-2.jpg",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // Profile Image
                Positioned(
                  bottom: -30,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(masjid.profileUrl ??
                          "https://praysalat.com/assets/images/placeholder-2.jpg"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40), // push content below profile

            // Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    masjid.name ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    masjid.email ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   "${masjid.city}, ${masjid.province}, ${masjid.country}",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.grey[600],
                  //   ),
                  // ),
                  // const SizedBox(height: 6),
                  // Wrap(
                  //   spacing: 6,
                  //   runSpacing: 6,
                  //   children: (masjid.languages?.isNotEmpty ?? false)
                  //       ? masjid.languages!
                  //           .map((lang) => Chip(
                  //                 label: Text(lang.title),
                  //                 backgroundColor: Colors.blue.shade50,
                  //               ))
                  //           .toList()
                  //       : [const Text("No languages available")], // 👈 fallback
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
