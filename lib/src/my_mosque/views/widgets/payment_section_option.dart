import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/masjed_details_model.dart';

class PaymentOptionsSection extends StatelessWidget {
  final PaymentInfo paymentInfo;

  const PaymentOptionsSection({super.key, required this.paymentInfo});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildTile({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paypalUser = paymentInfo.paypalUser;
    final switchInfo = paymentInfo.switchData;
    final bankInfo = paymentInfo.bankAccount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // PayPal Section
        if (paypalUser != null && paypalUser.toString().isNotEmpty)
          _buildTile(
            title: "PayPal",
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.blue),
                const SizedBox(width: 8),
                Text(paypalUser),
              ],
            ),
          ),

        // Switch Section
        if (switchInfo != null)
          _buildTile(
            title: "Switch",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.numbers, color: Colors.green),
                  const SizedBox(width: 8),
                  Text("Number: ${switchInfo.number}"),
                ]),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => _launchUrl(switchInfo.url ?? ""),
                  child: Row(
                    children: [
                      const Icon(Icons.link, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        switchInfo.url ?? "",
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (switchInfo.qrCode != null && switchInfo.qrCode?.url != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      switchInfo.qrCode?.url ?? "",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),

        // Bank Account Section
        if (bankInfo != null)
          _buildTile(
            title: "Bank Account",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${bankInfo.name}"),
                Text("Account Number: ${bankInfo.accountNumber}"),
                Text("IBAN: ${bankInfo.iban}"),
                Text("Swift Code: ${bankInfo.swiftCode}"),
              ],
            ),
          ),
      ],
    );
  }
}
