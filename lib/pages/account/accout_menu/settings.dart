import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
      ),
      backgroundColor: Color.fromARGB(255, 244, 241, 241),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 32),
            SettingItem(
              title: 'Notification',
              icon: Icons.notifications,
              onTap: () {
                //
              },
            ),
            SettingItem(
              title: 'Language',
              icon: Icons.language,
              onTap: () {
                //
              },
            ),
            SettingItem(
              title: 'Theme',
              icon: Icons.color_lens,
              onTap: () {
                //
              },
            ),
            SettingItem(
              title: 'Privacy Policy',
              icon: Icons.security,
              onTap: () {
                //
              },
            ),
            SettingItem(
              title: 'Terms & Conditions',
              icon: Icons.description,
              onTap: () {
                //
              },
            ),
            SettingItem(
              title: 'About',
              icon: Icons.info,
              onTap: () {
                //
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
