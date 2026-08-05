/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: Home pages
*/

import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class HomePages extends StatelessWidget {
  const HomePages({super.key});

  @override
  Widget build(BuildContext context) {
    // NavBar pins its own bar to the physical bottom and applies the IME inset
    // itself. This host must not shrink the body or strip viewInsets, or the
    // pinned bar would land on top of the keyboard.
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: NavBar(),
    );
  }
}
