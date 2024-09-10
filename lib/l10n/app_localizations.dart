import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);
  

  // Helper method to keep the code in the widget concise
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Load the language JSON file from the "assets/lang" folder
  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key, {Map<String, String>? params}) {
    String translatedString = _localizedStrings[key] ?? '** $key not found';

    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translatedString = translatedString.replaceAll('{$paramKey}', paramValue);
      });
    }

    return translatedString;
  }

  String get welcome => translate('welcome');
  String get incomeTaxCalculator => translate('incomeTaxCalculator');
  String get interestCalculator => translate('interestCalculator');
  String get productBillingWithTaxCalculator => translate('productBillingWithTaxCalculator');
  String get selectYear => translate('selectYear');
  String get selectStatus => translate('selectStatus');
  String get enterIncome => translate('enterIncome');
  String get additionalBonus => translate('additionalBonus');
  String get selectBonusType => translate('selectBonusType');
  String get deductions => translate('deductions');
  String get calculate => translate('calculate');
  String get reset => translate('reset');
  String get taxAmount => translate('taxAmount');
  String get amountInHand => translate('amountInHand');
  String get invalidInput => translate('invalidInput');
  String get selectYearAndStatus => translate('selectYearAndStatus');
  String get confirmLogout => translate('confirmLogout');
  String get no => translate('no');
  String get yes => translate('yes');

  // Static member to have a list of supported locales
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ne'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
