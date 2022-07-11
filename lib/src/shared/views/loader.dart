import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key, this.value, this.loadingText = 'Loading...'})
      : super(key: key);

  final double? value;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          value: value,
        ),
        const SizedBox(height: 16),
        if (loadingText != null) Text(loadingText!),
      ],
    );
  }
}
