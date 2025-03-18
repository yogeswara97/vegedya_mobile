import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 244, 241, 241),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Effective Date: 04 June 2024',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Welcome to Vegedya Cafe mobile app. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our App.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('1. Information We Collect'),
                    Divider(),
                    _buildRichText(
                      'Personal Information: ',
                      'When you register or place an order, we may collect personal information such as your name, email address, phone number, and payment details.',
                    ),
                    Divider(),
                    _buildRichText(
                      'Usage Data: ',
                      'We automatically collect information about your interactions with the App, such as the pages you visit, the time and date of your visit, and other diagnostic data.',
                    ),
                    Divider(),
                    _buildRichText(
                      'Location Data: ',
                      'With your permission, we may collect and use your device’s precise location to provide location-based services.',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('2. How We Use Your Information'),
                    Divider(),
                    _buildRichText(
                      'To Provide and Maintain Our Services: ',
                      'We use your personal information to process your orders, manage your account, and provide customer support.',
                    ),
                    Divider(),
                    _buildRichText(
                      'To Improve Our Services: ',
                      'We analyze usage data to enhance the functionality and user experience of our App.',
                    ),
                    Divider(),
                    _buildRichText(
                      'Marketing and Promotions: ',
                      'With your consent, we may use your information to send you promotional materials and special offers. You can opt out at any time.',
                    ),
                    Divider(),
                    _buildRichText(
                      'Security and Compliance: ',
                      'We use your information to monitor and improve the security of our App and to comply with legal obligations.',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('3. Sharing Your Information'),
                    Divider(),
                    _buildRichText(
                      'Service Providers: ',
                      'We may share your information with third-party service providers who assist us in operating our App and delivering services to you. These providers are obligated to keep your information confidential.',
                    ),
                    Divider(),
                    _buildRichText(
                      'Business Transfers: ',
                      'In the event of a merger, acquisition, or sale of all or a portion of our assets, your information may be transferred as part of the transaction.',
                    ),
                    Divider(),
                    _buildRichText(
                      'Legal Requirements: ',
                      'We may disclose your information if required to do so by law or in response to valid requests by public authorities.',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('4. Security of Your Information'),
                    Divider(),
                    Text(
                      'We implement reasonable security measures to protect your information from unauthorized access, disclosure, alteration, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure. Therefore, we cannot guarantee absolute security.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('5. Your Privacy Rights'),
                    Divider(),
                    _buildRichText(
                      'Access and Update: ',
                      'You have the right to access and update your personal information by logging into your account settings.',
                    ),
                    Divider(),
                    _buildRichText(
                      'Deletion: ',
                      'You can request the deletion of your personal information, subject to certain legal obligations.',
                    ),
                    Divider(),
                    _buildRichText(
                      'Opt-Out: ',
                      'You may opt out of receiving marketing communications by following the unsubscribe instructions in our emails or contacting us directly.',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('6. Children’s Privacy'),
                    Divider(),
                    Text(
                      'Our App is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have inadvertently received personal information from a child under 13, we will delete such information from our records.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('7. Changes to This Privacy Policy'),
                    Divider(),
                    Text(
                      'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('8. Contact Us'),
                    Divider(),
                    Text(
                      'If you have any questions about this Privacy Policy, please contact us at:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Vegedya Cafe\nEmail: vegedya@gmail.com\nAddress: Denpasar, 80013',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Text(
                      'By using our App, you consent to the collection and use of your information as described in this Privacy Policy. Thank you for trusting Vegedya Cafe with your personal information.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 111, 78, 55),
      ),
    );
  }

  Widget _buildRichText(String boldText, String normalText) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(
            text: boldText,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: normalText,
          ),
        ],
      ),
    );
  }
}
