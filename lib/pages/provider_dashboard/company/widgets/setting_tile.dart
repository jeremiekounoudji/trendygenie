import 'package:flutter/material.dart';
import '../../../../utils/globalVariable.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      leading: Icon(icon, color: firstColor),
      title: Text(
        title, 
        style: TextStyle(
          color: blackColor, 
          fontSize: 16, 
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: greyColor),
    );
  }
}
