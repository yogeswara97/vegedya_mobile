import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Condition',
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
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Effective Date: 04 June 2024',
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Welcome to Vegedya Cafe mobile app. These Terms and Conditions govern your use of our App. By accessing or using the App, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use the App.',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('1. Use of the App'),
                      Divider(),
                      _buildRichText('Eligibility: ', 'You must be at least 18 years old to use the App. By using the App, you represent and warrant that you meet this age requirement.'),
                      Divider(),
                      _buildRichText('License: ', 'We grant you a limited, non-exclusive, non-transferable, and revocable license to use the App for personal, non-commercial purposes in accordance with these Terms.'),
                      Divider(),
                      _buildRichText('Account: ', 'To access certain features of the App, you may be required to create an account. You agree to provide accurate and complete information and to keep your account information up to date. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('2. Orders and Payments'),
                      Divider(),
                      _buildRichText('Order Acceptance: ', 'All orders placed through the App are subject to acceptance by Vegedya Cafe. We reserve the right to refuse or cancel any order for any reason.'),
                      Divider(),
                      _buildRichText('Pricing: ', 'Prices for products and services offered through the App are subject to change without notice. We are not responsible for typographical errors or inaccuracies in pricing.'),
                      Divider(),
                      _buildRichText('Payment: ', 'By placing an order, you agree to pay the specified amount for the products and services, including any applicable taxes and fees. Payments are processed through secure third-party payment providers.'),
                      Divider(),
                      _buildRichText('Cancellation and Refunds: ', 'Orders may be canceled or refunded in accordance with our cancellation and refund policy, which is available on the App.'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('3. User Conduct'),
                      Divider(),
                      _buildRichText('Prohibited Activities: ', 'You agree not to use the App for any unlawful or prohibited activities, including but not limited to:'),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBulletPoint('Posting or transmitting any harmful, offensive, or infringing content.'),
                            _buildBulletPoint('Impersonating any person or entity or misrepresenting your affiliation with any person or entity.'),
                            _buildBulletPoint('Interfering with or disrupting the operation of the App or its servers.'),
                            _buildBulletPoint('Attempting to gain unauthorized access to the App or other accounts, systems, or networks.'),
                          ],
                        ),
                      ),
                      Divider(),
                      _buildRichText('Content: ', 'You are solely responsible for any content you post or submit through the App. By posting content, you grant us a non-exclusive, royalty-free, perpetual, and worldwide license to use, reproduce, modify, and distribute your content.'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('4. Intellectual Property'),
                      Divider(),
                      _buildRichText('Ownership: ', 'All intellectual property rights in the App and its content, including but not limited to text, graphics, logos, and software, are owned by Vegedya Cafe or its licensors. You may not use, reproduce, or distribute any content from the App without our prior written permission.'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('5. Disclaimers and Limitation of Liability'),
                      Divider(),
                      _buildRichText('Disclaimer: ', 'The App is provided "as is" and "as available" without warranties of any kind, either express or implied. We do not warrant that the App will be uninterrupted or error-free.'),
                      Divider(),
                      _buildRichText('Limitation of Liability: ', 'To the fullest extent permitted by law, Vegedya Cafe and its affiliates, officers, directors, employees, and agents shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or related to your use of the App.'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('6. Indemnification'),
                      Divider(),
                      Text(
                        'You agree to indemnify, defend, and hold harmless Vegedya Cafe and its affiliates, officers, directors, employees, and agents from and against any claims, liabilities, damages, losses, and expenses arising out of or related to your use of the App or violation of these Terms.',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('7. Changes to These Terms'),
                      Divider(),
                      Text(
                        'We may update these Terms from time to time. We will notify you of any changes by posting the new Terms on this page. Your continued use of the App after the changes take effect constitutes your acceptance of the new Terms.',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('8. Governing Law'),
                      Divider(),
                      Text(
                        'These Terms and your use of the App are governed by and construed in accordance with the laws of [Your Jurisdiction], without regard to its conflict of law principles.',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('9. Contact Us'),
                      Divider(),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
                          children: [
                            TextSpan(
                              text: 'Vegedya Cafe\n',
                              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Email: vegedya@gmail.com\n',
                              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Address: Denpasar, 80013',
                              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Text(
                        'By using our App, you agree to these Terms and Conditions. Thank you for choosing Vegedya Cafe.',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Widget _buildRichText(String title, String content) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
        children: [
          TextSpan(
            text: title,
            style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: content,
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        '- $text',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }
}
