import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  // Assuming these are defined elsewhere in your code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'Privacy Policy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last updated: January 07, 2025', style: styling()),
            SizedBox(height: 16),
            Text(
              'This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. This Privacy Policy has been created with the help of the Privacy Policy Generator.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Interpretation and Definitions', style: headerStyling()),
            SizedBox(height: 8),
            Text('Interpretation', style: headerStyling()),
            SizedBox(height: 8),
            Text(
              'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Definitions', style: headerStyling()),
            SizedBox(height: 8),
            _buildDefinitionList(),
            SizedBox(height: 16),
            Text('Collecting and Using Your Personal Data',
                style: headerStyling()),
            SizedBox(height: 8),
            Text('Types of Data Collected', style: headerStyling()),
            SizedBox(height: 8),
            Text('Personal Data', style: headerStyling()),
            SizedBox(height: 8),
            Text(
              'While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to: Email address, First name and last name, Phone number, Address, State, Province, ZIP/Postal code, City, Usage Data.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Usage Data', style: headerStyling()),
            SizedBox(height: 8),
            Text(
              'Usage Data is collected automatically when using the Service.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Information Collected while Using the Application',
                style: headerStyling()),
            SizedBox(height: 8),
            Text(
              'While using Our Application, in order to provide features of Our Application, We may collect, with Your prior permission: Pictures and other information from your Device\'s camera and photo library.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Use of Your Personal Data', style: headerStyling()),
            SizedBox(height: 8),
            _buildUseOfDataList(),
            SizedBox(height: 16),
            Text('Retention of Your Personal Data', style: headerStyling()),
            SizedBox(height: 8),
            Text(
              'The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Security of Your Personal Data', style: headerStyling()),
            SizedBox(height: 8),
            Text(
              'The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Children\'s Privacy', style: headerStyling()),
            SizedBox(height: 8),
            Text(
              'Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Links to Other Websites', style: headerStyling()),
            SizedBox(height: 8),
            Text(
              'Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party\'s site. We strongly advise You to review the Privacy Policy of every site You visit.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Changes to This Privacy Policy', style: headerStyling()),
            SizedBox(height: 8),
            Text(
              'We may update our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text('Contact Us', style: headerStyling()),
            SizedBox(height: 8),
            Text(
              'If you have any questions about this Privacy Policy, please contact us: By email: support@vesture.com',
              style: styling(),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefinitionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListItem('Account',
            'means a unique account created for You to access our Service or parts of our Service.'),
        _buildListItem('Affiliate',
            'means an entity that controls, is controlled by or is under common control with a party.'),
        _buildListItem('Application',
            'refers to Vesture, the software program provided by the Company.'),
        _buildListItem('Company',
            'refers to Vesture, referred to as "the Company", "We", "Us" or "Our" in this Agreement.'),
        _buildListItem('Country', 'refers to: Kerala, India'),
        _buildListItem('Device',
            'refers to any device that can access the Service such as a computer, a cellphone, or a digital tablet.'),
        _buildListItem('Personal Data',
            'is any information that relates to an identified or identifiable individual.'),
        _buildListItem(
            'Service', 'refers to the Application or the website or both.'),
        _buildListItem('Usage Data',
            'refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself.'),
        // Add more definitions as necessary
      ],
    );
  }

  Widget _buildListItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$title: $description',
        style: styling(),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildUseOfDataList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListItem('To provide and maintain our Service',
            'including to monitor the usage of our Service.'),
        _buildListItem('To manage Your Account',
            'to manage Your registration as a user of the Service.'),
        _buildListItem('For the performance of a contract',
            'the development, compliance and undertaking of the purchase contract for the products and services that You have purchased or of any other contract with Us through the Service.'),
        _buildListItem('To contact You',
            'To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication.'),
        _buildListItem(
            'To provide You with news, special offers and general information about other goods, services and events',
            'we offer that are similar to those that you have already purchased or enquired about, unless You have opted not to receive such information.'),
        _buildListItem('To manage Your requests',
            'To attend and manage Your requests to Us.'),
        _buildListItem('For business transfers',
            'We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding.'),
        _buildListItem('To deliver targeted advertising to You',
            'To analyze Your preferences or behavior to provide tailored advertisements or content for You.'),
        // Add more use cases as necessary
      ],
    );
  }
}
