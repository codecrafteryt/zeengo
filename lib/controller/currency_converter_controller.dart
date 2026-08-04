import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Static demo FX rates (relative to 1 USD).
class CurrencyConverterController extends GetxController {
  static const List<String> currencies = ['USD', 'SAR', 'RUB'];

  /// Units of each currency equal to 1 USD.
  static const Map<String, double> perUsd = {
    'USD': 1.0,
    'SAR': 3.75,
    'RUB': 89.5,
  };

  final amountText = '100'.obs;
  final baseCurrency = 'USD'.obs;
  final amountController = TextEditingController(text: '100');

  @override
  void onInit() {
    super.onInit();
    amountController.addListener(_onAmountChanged);
  }

  @override
  void onClose() {
    amountController.removeListener(_onAmountChanged);
    amountController.dispose();
    super.onClose();
  }

  void reset() {
    baseCurrency.value = 'USD';
    amountText.value = '100';
    if (amountController.text != '100') {
      amountController.text = '100';
    }
  }

  void setBaseCurrency(String code) {
    if (!currencies.contains(code) || baseCurrency.value == code) return;
    baseCurrency.value = code;
  }

  void _onAmountChanged() {
    amountText.value = amountController.text;
  }

  double get amount {
    final raw = amountText.value.replaceAll(',', '').trim();
    return double.tryParse(raw) ?? 0;
  }

  /// Converted values for every currency except the selected base.
  List<CurrencyQuote> get quotes {
    final from = baseCurrency.value;
    final usd = amount / (perUsd[from] ?? 1);
    return currencies
        .where((code) => code != from)
        .map(
          (code) => CurrencyQuote(
            code: code,
            amount: usd * (perUsd[code] ?? 1),
          ),
        )
        .toList();
  }

  String formatAmount(double value) {
    if (value == 0) return '0';
    if (value >= 1000) {
      return _withCommas(value.round());
    }
    if ((value - value.round()).abs() < 0.005) {
      return value.round().toString();
    }
    return value.toStringAsFixed(2);
  }

  String _withCommas(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}

class CurrencyQuote {
  const CurrencyQuote({required this.code, required this.amount});

  final String code;
  final double amount;
}
