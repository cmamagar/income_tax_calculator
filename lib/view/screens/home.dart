import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income_tax_calculator/l10n/app_localizations.dart';
import 'package:income_tax_calculator/utils/custom_text_style.dart';
import 'package:income_tax_calculator/view/screens/income_tax_calculator.dart';
import 'package:income_tax_calculator/view/screens/interest_calculator.dart';
import 'package:income_tax_calculator/view/screens/prouduct_billing_with_tax_calculator.dart';

class HomePage extends StatelessWidget {
  final void Function(Locale locale) onLocaleChange;

  HomePage({required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(localizations.welcome, style: CustomTextStyles.f18W600()),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language),
            onSelected: (String value) {
              if (value == 'en') {
                onLocaleChange(Locale('en'));
              } else if (value == 'ne') {
                onLocaleChange(Locale('ne'));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'en',
                child: Text('English', style: CustomTextStyles.f12W600()),
              ),
              PopupMenuItem<String>(
                value: 'ne',
                child: Text('नेपाली', style: CustomTextStyles.f12W600()),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(context, localizations.incomeTaxCalculator, Icons.calculate),
            _buildCard(context, localizations.interestCalculator, Icons.monetization_on),
            _buildCard(context, localizations.productBillingWithTaxCalculator, Icons.receipt),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          if (title == AppLocalizations.of(context).incomeTaxCalculator) {
            Get.to(IncomeTaxCalculator(onLocaleChange: (Locale locale) {
              // Handle locale change here
            }));
          } else if (title == AppLocalizations.of(context).interestCalculator) {
            Get.to(InterestCalculator(onLocaleChange: (Locale locale) {
              // Handle locale change here
            }));
          } else if (title == AppLocalizations.of(context).productBillingWithTaxCalculator) {
            Get.to(ProductBillingWithTaxCalculator());
          }
        },
        child: Container(
          width: double.infinity,
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Colors.blue),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: CustomTextStyles.f16W600(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
