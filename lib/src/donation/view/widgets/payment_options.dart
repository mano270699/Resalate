import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resalate/core/util/localization/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/donation_details_model.dart';

class PaymentOptionsSection extends StatelessWidget {
  final PaymentInfo paymentInfo;

  const PaymentOptionsSection({super.key, required this.paymentInfo});

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("${AppLocalizations.of(context)!.translate("Copied")} $text"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildTile({required String title, required List<Widget> children}) {
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
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context,
      {required IconData icon,
      required String label,
      required String value,
      bool isLink = false}) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: isLink
                ? InkWell(
                    onTap: () => _launchUrl(value),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : Text("$label: $value"),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
            onPressed: () => _copyToClipboard(context, value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paypalUser = paymentInfo.paypalUser ?? "";
    final switchInfo = paymentInfo.switchPayment;
    final bankInfo = paymentInfo.bankAccount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // PayPal Section
        if (paypalUser.isNotEmpty)
          _buildTile(
            title: AppLocalizations.of(context)!.translate("paypal"),
            children: [
              _buildRow(context,
                  icon: Icons.account_balance_wallet,
                  label: AppLocalizations.of(context)!.translate("user"),
                  value: paypalUser),
            ],
          ),

        // Switch Section
        if (switchInfo != null)
          _buildTile(
            title: AppLocalizations.of(context)!.translate("switch"),
            children: [
              _buildRow(context,
                  icon: Icons.numbers,
                  label:
                      AppLocalizations.of(context)!.translate("switch_number"),
                  value: switchInfo.number ?? ""),
              if (switchInfo.url != null && switchInfo.url!.isNotEmpty)
                _buildRow(context,
                    icon: Icons.link,
                    label: AppLocalizations.of(context)!.translate("link"),
                    value: switchInfo.url!,
                    isLink: true),
              if (switchInfo.qrCode?.url != null &&
                  switchInfo.qrCode!.url!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      switchInfo.qrCode!.url!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),

        // Bank Account Section
        if (bankInfo != null)
          _buildTile(
            title: AppLocalizations.of(context)!.translate("bank_account"),
            children: [
              _buildRow(context,
                  icon: Icons.person,
                  label: AppLocalizations.of(context)!.translate("Name"),
                  value: bankInfo.name ?? ""),
              _buildRow(context,
                  icon: Icons.confirmation_number,
                  label: AppLocalizations.of(context)!.translate("Account_No"),
                  value: bankInfo.accountNumber ?? ""),
              _buildRow(context,
                  icon: Icons.credit_card,
                  label: AppLocalizations.of(context)!.translate("IBAN"),
                  value: bankInfo.iban ?? ""),
              _buildRow(context,
                  icon: Icons.swap_horiz,
                  label: AppLocalizations.of(context)!.translate("Swift_Code"),
                  value: bankInfo.swiftCode ?? ""),
            ],
          ),
      ],
    );
  }
}
