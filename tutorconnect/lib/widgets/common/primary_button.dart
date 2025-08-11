import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isLoading ? null : onPressed,
      color: const Color.fromRGBO(49, 39, 79, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      height: 50,
      minWidth: double.infinity, // Make button take full width
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }
}
