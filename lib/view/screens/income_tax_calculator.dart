import 'package:flutter/material.dart';
import 'package:income_tax_calculator/controller/nepali_numbers.dart';
import 'package:income_tax_calculator/utils/custom_text_style.dart';
import 'package:income_tax_calculator/l10n/app_localizations.dart';

class IncomeTaxCalculator extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  IncomeTaxCalculator({required this.onLocaleChange});

  @override
  _IncomeTaxCalculatorState createState() => _IncomeTaxCalculatorState();
}

class _IncomeTaxCalculatorState extends State<IncomeTaxCalculator> {
  final _formKey = GlobalKey<FormState>();
  String? selectedYear;
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _deductionController = TextEditingController();
  String? selectedTaxStatus;

  String _result = '';
  bool _isYearly = true;
  bool _isNepali = false;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.translate('appTitle'),
          style: CustomTextStyles.f18W600(),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                // Reset form
                _formKey.currentState?.reset();
                _incomeController.clear();
                _bonusController.clear();
                _deductionController.clear();
                selectedYear = null;
                selectedTaxStatus = null;
                _result = "";

                // Update language and handle number conversion
                if (value == 'en') {
                  widget.onLocaleChange(Locale('en'));
                  _isNepali = false;
                } else if (value == 'ne') {
                  widget.onLocaleChange(Locale('ne'));
                  _isNepali = true;
      
                }
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
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedYear,
                        decoration: InputDecoration(
                          labelText: localization.translate('selectYear'),
                          labelStyle:
                              CustomTextStyles.f12W600(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                        ),
                        items: <String>[
                          localization.translate('year1'),
                          localization.translate('year2'),
                          localization.translate('year3'),
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedYear = newValue;
                          });
                        },
                        validator: (value) => value == null
                            ? localization.translate('selectYearAndStatus')
                            : null,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedTaxStatus,
                        decoration: InputDecoration(
                          labelText: localization.translate('selectStatus'),
                          labelStyle:
                              CustomTextStyles.f12W600(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                        ),
                        items: <String>[
                          localization.translate('single'),
                          localization.translate('married'),
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyles.f12W600(),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTaxStatus = newValue;
                          });
                        },
                        validator: (value) => value == null
                            ? localization.translate('selectYearAndStatus')
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: _incomeController,
                          style: CustomTextStyles.f12W600(),
                          decoration: InputDecoration(
                            labelText: localization.translate('enterIncome'),
                            labelStyle:
                                CustomTextStyles.f12W600(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            String actualValue = _isNepali
                                ? convertToEnglishNumber(value ??
                                    '') // convert Nepali input to English for validation
                                : value ?? '';

                            if (actualValue.isEmpty) {
                              return localization.translate('enterIncome');
                            }
                            if (double.tryParse(actualValue) == null) {
                              return localization.translate('enterIncome');
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (_isNepali && value.isNotEmpty) {
                              // Convert to Nepali numbers for display
                              String nepaliNumber =
                                  convertToNepaliNumber(value);
                              if (nepaliNumber != _incomeController.text) {
                                _incomeController.value = TextEditingValue(
                                  text: nepaliNumber,
                                  selection: TextSelection.collapsed(
                                    offset: nepaliNumber.length,
                                  ),
                                );
                              }
                            } else if (!_isNepali && value.isNotEmpty) {
                              // Convert to English numbers for display when not in Nepali mode
                              String englishNumber =
                                  convertToEnglishNumber(value);
                              if (englishNumber != _incomeController.text) {
                                _incomeController.value = TextEditingValue(
                                  text: englishNumber,
                                  selection: TextSelection.collapsed(
                                    offset: englishNumber.length,
                                  ),
                                );
                              }
                            }
                          }),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        style: CustomTextStyles.f12W600(),
                        value: _isYearly
                            ? localization.translate('years')
                            : localization.translate('months'),
                        decoration: InputDecoration(
                          labelStyle:
                              CustomTextStyles.f12W600(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                        items: <String>[
                          localization.translate('months'),
                          localization.translate('years')
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _isYearly =
                                newValue == localization.translate('years');
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Additional Bonus TextField
                TextFormField(
                  controller: _bonusController,
                  style: CustomTextStyles.f12W600(),
                  decoration: InputDecoration(
                    labelText: localization.translate('additionalBonus'),
                    labelStyle: CustomTextStyles.f12W600(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    String actualValue = _isNepali
                        ? convertToEnglishNumber(value ?? '')
                        : value ?? '';
                    if (actualValue.isEmpty) {
                      return localization.translate('invalidInput');
                    }
                    if (double.tryParse(actualValue) == null) {
                      return localization.translate('invalidInput');
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (_isNepali && value.isNotEmpty) {
                      String nepaliNumber = convertToNepaliNumber(value);
                      if (nepaliNumber != value) {
                        // Check to avoid unnecessary updates
                        _bonusController.value = TextEditingValue(
                          text: nepaliNumber,
                          selection: TextSelection.collapsed(
                              offset: nepaliNumber.length),
                        );
                      }
                    } else if (!_isNepali && value.isNotEmpty) {
                      String englishNumber = convertToEnglishNumber(value);
                      if (englishNumber != value) {
                        // Check to avoid unnecessary updates
                        _bonusController.value = TextEditingValue(
                          text: englishNumber,
                          selection: TextSelection.collapsed(
                              offset: englishNumber.length),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 8),
                // Deduction TextField
                TextFormField(
                  controller: _deductionController,
                  style: CustomTextStyles.f12W600(),
                  decoration: InputDecoration(
                    labelText: localization.translate('deductions'),
                    labelStyle: CustomTextStyles.f12W600(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    String actualValue = _isNepali
                        ? convertToEnglishNumber(value ?? '')
                        : value ?? '';

                    if (actualValue.isEmpty) {
                      return localization.translate('invalidInput');
                    }
                    if (double.tryParse(actualValue) == null) {
                      return localization.translate('invalidInput');
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (_isNepali && value.isNotEmpty) {
                      String nepaliNumber = convertToNepaliNumber(value);
                      if (nepaliNumber != value) {
                        // Check to avoid unnecessary updates
                        _deductionController.value = TextEditingValue(
                          text: nepaliNumber,
                          selection: TextSelection.collapsed(
                              offset: nepaliNumber.length),
                        );
                      }
                    } else if (!_isNepali && value.isNotEmpty) {
                      String englishNumber = convertToEnglishNumber(value);
                      if (englishNumber != value) {
                        // Check to avoid unnecessary updates
                        _deductionController.value = TextEditingValue(
                          text: englishNumber,
                          selection: TextSelection.collapsed(
                              offset: englishNumber.length),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final double income = double.tryParse(
                          convertToEnglishNumber(_incomeController.text))!;
                      final double bonus = double.tryParse(
                              convertToEnglishNumber(_bonusController.text)) ??
                          0;
                      final double deductions = double.tryParse(
                              convertToEnglishNumber(
                                  _deductionController.text)) ??
                          0;

                      final double totalIncome = income + bonus - deductions;

                      double taxAmount = 0;

                      if (_isYearly) {
                        taxAmount = totalIncome * 0.13;
                      } else {
                        taxAmount = totalIncome * 0.13 * 12;
                      }

                      if (_isNepali) {
                        _result =
                            '${localization.translate('taxAmount')}: ${convertToNepaliNumber(taxAmount.toStringAsFixed(2))}';
                      } else {
                        _result =
                            '${localization.translate('taxAmount')}: Rs ${taxAmount.toStringAsFixed(2)}';
                      }
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    localization.translate('submit1'),
                    style: CustomTextStyles.f16W600(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _result,
                  style: CustomTextStyles.f16W600(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
