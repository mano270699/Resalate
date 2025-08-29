import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/masjed_details_model.dart';

class SocialMediaItem extends StatelessWidget {
  final SocialMedia socialMedia;

  const SocialMediaItem({super.key, required this.socialMedia});

  Future<void> _launchUrl(String url) async {
    if (url.isNotEmpty && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    void addItem(IconData icon, String? url, {Color? color}) {
      if (url != null && url.isNotEmpty) {
        items.add(
          IconButton(
            icon: Icon(icon, color: color ?? Colors.blue),
            onPressed: () => _launchUrl(url),
          ),
        );
      }
    }

    addItem(FontAwesomeIcons.facebook, socialMedia.facebookUrl,
        color: Colors.blue);
    addItem(FontAwesomeIcons.xTwitter, socialMedia.xUrl, color: Colors.black);
    addItem(FontAwesomeIcons.instagram, socialMedia.instagramUrl,
        color: Colors.purple);
    addItem(FontAwesomeIcons.youtube, socialMedia.youtubeUrl,
        color: Colors.red);
    addItem(FontAwesomeIcons.tiktok, socialMedia.tiktokUrl,
        color: Colors.black);
    addItem(FontAwesomeIcons.linkedin, socialMedia.linkedinUrl,
        color: Colors.blue[700]);
    addItem(FontAwesomeIcons.telegram, socialMedia.telegramUrl,
        color: Colors.blueAccent);
    addItem(FontAwesomeIcons.whatsapp, socialMedia.whatsappUrl,
        color: Colors.green);
    addItem(FontAwesomeIcons.snapchat, socialMedia.snapchatUrl,
        color: Colors.yellow[700]);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items,
    );
  }
}
