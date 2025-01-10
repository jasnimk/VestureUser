import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'About Us'),
      body: SingleChildScrollView(
        // Make it scrollable in case content overflows
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Logo (if you have one)
              Center(
                child: Image.asset('assets/Images/lg.png',
                    width: 150), // Replace with your logo image
              ),
              SizedBox(height: 16),

              // Company Introduction
              Text('Welcome to Vesture', style: headerStyling()),
              SizedBox(height: 8),
              Text(
                'At Vesture, we provide high-quality clothing to cater to your fashion needs. We aim to deliver the best shopping experience with a focus on convenience, style, and customer satisfaction. Our wide variety of products ensures there is something for everyone.',
                style: styling(),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),

              // Mission Section
              Text('Our Mission', style: headerStyling()),
              SizedBox(height: 8),
              Text(
                'Our mission is to revolutionize fashion shopping by providing a platform that makes finding trendy clothes as easy as possible. Through innovative features like visual search and voice search, we aim to make your shopping experience smoother and more efficient.',
                style: styling(),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),

              Text('Our Vision', style: headerStyling()),
              SizedBox(height: 8),
              Text(
                'We envision a world where fashion is accessible to everyone, no matter where they are. Our vision is to be the leading online platform for trendy, affordable, and sustainable fashion choices.',
                style: styling(),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),

              // Contact Us Section
              Text('Contact Us', style: headerStyling()),
              SizedBox(height: 8),
              Text(
                'For any inquiries, feedback, or support, please contact us at:',
                style: styling(),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 8),
              Text(
                'Email: support@vesture.com\nPhone: +91 9995 343-268\nAddress: ABC Street, Tirur, Kerala',
                style: styling(),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),

              // Footer or Extra Information
              Text('Follow us on Social Media:', style: headerStyling()),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(FontAwesomeIcons.linkedin),
                    onPressed: () {},
                    iconSize: 30,
                    color: const Color.fromARGB(255, 176, 39, 39),
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.facebook),
                    onPressed: () {},
                    iconSize: 30,
                    color: const Color.fromARGB(255, 176, 39, 39),
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.instagram),
                    onPressed: () {},
                    iconSize: 30,
                    color: const Color.fromARGB(255, 176, 39, 39),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
