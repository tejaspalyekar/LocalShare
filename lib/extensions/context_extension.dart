import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

extension ContextExtension on BuildContext {
  showSnackBar(String msg) {
    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(msg)));
  }


  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  showLoading(){
    this.loaderOverlay.show();
  }

  dismissLoading(){
    this.loaderOverlay.hide();
  }

}
