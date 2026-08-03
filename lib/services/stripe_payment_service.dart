import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../utils/values/env.dart';

class StripePayResult {
  const StripePayResult({required this.success, required this.message});

  final bool success;
  final String message;
}

/// Handles Stripe init + card PaymentMethod / PaymentIntent confirm.
class StripePaymentService {
  StripePaymentService._();
  static final instance = StripePaymentService._();

  bool _ready = false;

  bool get isConfigured => Env.stripePublishableKey.isNotEmpty;

  Future<void> init() async {
    if (!isConfigured || _ready) return;
    Stripe.publishableKey = Env.stripePublishableKey;
    Stripe.merchantIdentifier = 'merchant.com.zeengo';
    await Stripe.instance.applySettings();
    _ready = true;
  }

  Future<StripePayResult> payWithCard({
    required String amountLabel,
    required String billingCountry,
    required String billingPostalCode,
  }) async {
    if (!isConfigured) {
      return const StripePayResult(
        success: false,
        message: 'Add STRIPE_PUBLISHABLE_KEY in .env',
      );
    }

    await init();

    final billing = BillingDetails(
      address: Address(
        city: null,
        country: billingCountry,
        line1: null,
        line2: null,
        postalCode: billingPostalCode.isEmpty ? null : billingPostalCode,
        state: null,
      ),
    );

    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(billingDetails: billing),
      ),
    );

    final intentUrl = Env.stripePaymentIntentUrl;
    if (intentUrl.isEmpty) {
      // Card tokenized safely with Stripe; backend PaymentIntent can be wired later.
      return StripePayResult(
        success: true,
        message:
            'Card saved (${paymentMethod.id}). Add STRIPE_PAYMENT_INTENT_URL to charge $amountLabel.',
      );
    }

    final response = await http.post(
      Uri.parse(intentUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'payment_method_id': paymentMethod.id,
        'amount_label': amountLabel,
        'currency': 'usd',
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return StripePayResult(
        success: false,
        message: 'Payment server error (${response.statusCode})',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final clientSecret = body['client_secret'] as String?;
    if (clientSecret == null || clientSecret.isEmpty) {
      return const StripePayResult(
        success: false,
        message: 'Missing client_secret from payment server',
      );
    }

    await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret,
      data: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(billingDetails: billing),
      ),
    );

    return StripePayResult(
      success: true,
      message: 'Payment of $amountLabel completed',
    );
  }
}
