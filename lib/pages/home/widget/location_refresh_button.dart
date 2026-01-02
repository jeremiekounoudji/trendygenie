import 'package:flutter/material.dart';

class LocationRefreshButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LocationRefreshButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'refresh_location',
      backgroundColor: Colors.white,
      onPressed: onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.my_location, color: Colors.blue),
    );
  }
}
