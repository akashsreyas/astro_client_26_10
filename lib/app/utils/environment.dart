import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get stripePublishableKey {
    return dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  }

  static String get agoraAppId {
    return dotenv.env['AGORA_APP_ID'] ?? '';
  }

  static String get razorpayKeyId {
    return dotenv.env['RAZORPAY_KEY_ID'] ?? '';
  }

  static String get razorpaySecretKey {
    return dotenv.env['RAZORPAY_KEY_SECRET'] ?? '';
  }
}
