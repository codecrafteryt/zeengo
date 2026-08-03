import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// Full page loading
class FullPageLoadingIndicator extends StatelessWidget {
  const FullPageLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        alignment: Alignment.center,
        child: LoadingAnimationWidget.hexagonDots(
          color: const Color(0xFF8B2FE0), // AppColors.purple
          size: 50,
        ),
      ),
    );
  }
}

