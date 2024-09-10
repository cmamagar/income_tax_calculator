import 'package:flutter/material.dart';
import 'package:income_tax_calculator/utils/custom_text_style.dart';
import 'package:income_tax_calculator/controller/nepali_numbers.dart';
import 'package:income_tax_calculator/l10n/app_localizations.dart';

class InterestCalculator extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  InterestCalculator({required this.onLocaleChange});

  @override
  _InterestCalculatorState createState() => _InterestCalculatorState();
}

class _InterestCalculatorState extends State<InterestCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _timeController = TextEditingController();

  String _result = '';
  bool _isYearly = true;
  String _timePeriodType = 'Years';
  bool _isNepali = false;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            localization.translate('title'),
            style: CustomTextStyles.f18W600(),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                setState(() {
                  _formKey.currentState?.reset();
                  _principalController.clear();
                  _rateController.clear();
                  _timeController.clear();
                  _result = '';

                  if (value == 'en') {
                    widget.onLocaleChange(Locale('en'));
                    _isNepali = false;
                  } else if (value == 'ne') {
                    widget.onLocaleChange(Locale('ne'));
                    _isNepali = true;
                  }

                  // Reset the time period type to 'Years'
                  _timePeriodType = 'Years';
                  _isYearly = true;
                });
              },
              icon: Icon(Icons.language),
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Principal Amount TextField
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      controller: _principalController,
                      style: CustomTextStyles.f12W600(), // Apply text style
                      decoration: InputDecoration(
                        labelText: localization.translate('principal_amount'),
                        labelStyle:
                            CustomTextStyles.f12W600(color: Colors.black),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        String actualValue = _isNepali
                            ? convertToEnglishNumber(value ?? '')
                            : value ?? '';

                        if (actualValue.isEmpty) {
                          return localization.translate('enter_principal');
                        }
                        if (double.tryParse(actualValue) == null) {
                          return localization.translate('enter_principal');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (_isNepali) {
                          String nepaliNumber = convertToNepaliNumber(value);
                          _principalController.value = TextEditingValue(
                            text: nepaliNumber,
                            selection: TextSelection.collapsed(
                                offset: nepaliNumber.length),
                          );
                        } else {
                          _principalController.value = TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Interest Rate TextField
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      controller: _rateController,
                      style: CustomTextStyles.f12W600(), // Apply text style
                      decoration: InputDecoration(
                        labelText: localization.translate('interest_rate'),
                        labelStyle:
                            CustomTextStyles.f12W600(color: Colors.black),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        String actualValue = _isNepali
                            ? convertToEnglishNumber(value ?? '')
                            : value ?? '';
                        if (actualValue.isEmpty) {
                          return localization.translate('enter_rate');
                        }
                        if (double.tryParse(actualValue) == null) {
                          return localization.translate('enter_rate');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (_isNepali) {
                          String nepaliNumber = convertToNepaliNumber(value);
                          _rateController.value = TextEditingValue(
                            text: nepaliNumber,
                            selection: TextSelection.collapsed(
                                offset: nepaliNumber.length),
                          );
                        } else {
                          _rateController.value = TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Time Period TextField with Dropdown
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            controller: _timeController,
                            style:
                                CustomTextStyles.f12W600(), // Apply text style
                            decoration: InputDecoration(
                              labelText: localization.translate('time_period'),
                              labelStyle:
                                  CustomTextStyles.f12W600(color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              String actualValue = _isNepali
                                  ? convertToEnglishNumber(value ?? '')
                                  : value ?? '';
                              if (actualValue.isEmpty) {
                                return localization.translate('enter_time');
                              }
                              if (double.tryParse(actualValue) == null) {
                                return localization.translate('enter_time');
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (_isNepali) {
                                String nepaliNumber =
                                    convertToNepaliNumber(value);
                                _timeController.value = TextEditingValue(
                                  text: nepaliNumber,
                                  selection: TextSelection.collapsed(
                                      offset: nepaliNumber.length),
                                );
                              } else {
                                _timeController.value = TextEditingValue(
                                  text: value,
                                  selection: TextSelection.collapsed(
                                      offset: value.length),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 110,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _timePeriodType,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(
                                value: 'Years',
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    localization.translate('years'),
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles.f12W600(),
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Months',
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    localization.translate('months'),
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles.f12W600(),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (newValue) {
                              setState(() {
                                _timePeriodType = newValue!;
                                _isYearly = _timePeriodType == 'Years';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Calculate Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() {
                          double principal = double.parse(
                              convertToEnglishNumber(_principalController.text
                                  .replaceAll(',', '')));
                          double rate = double.parse(convertToEnglishNumber(
                              _rateController.text.replaceAll(',', '')));
                          double time = double.parse(convertToEnglishNumber(
                              _timeController.text.replaceAll(',', '')));

                          double interest = (principal * rate * time) / 100;
                          if (!_isYearly) {
                            interest = interest / 12;
                          }

                          // Convert result based on the locale
                          String interestResult = _isNepali
                              ? convertToNepaliNumber(
                                  interest.toStringAsFixed(2))
                              : interest.toStringAsFixed(2);

                          _result = localization
                              .translate('interest_result')
                              .replaceFirst('{0}', interestResult);
                        });
                      }
                    },
                    child: Text(
                      localization.translate('submit'),
                      style: CustomTextStyles.f16W600(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      _result,
                      style: CustomTextStyles.f16W600(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}
