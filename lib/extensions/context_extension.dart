import 'package:flutter/material.dart';

extension context on BuildContext {
  showSnackBar(String msg) {
    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(msg)));
  }
}
