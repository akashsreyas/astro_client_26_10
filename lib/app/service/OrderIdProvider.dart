import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderIdProvider {
  final int orderId;

  OrderIdProvider(this.orderId);

  Future<void> saveOrderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('order_id', orderId);
  }

  static Future<int?> getSavedOrderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('order_id');
  }
}
