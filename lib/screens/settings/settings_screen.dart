import 'package:beatbox/custom_class/custom_widget.dart';
import 'package:beatbox/screens/settings/about.dart';
import 'package:beatbox/screens/settings/privacy_policy.dart';
import 'package:beatbox/screens/settings/terms_and_condition.dart';
import 'package:beatbox/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen ({
     super.key,  // Add the named key parameter
  });
  

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool istrue = false;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Search',
          gradientColors:const  [Colors.blue, Colors.purple],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: MixPrimary,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  'Share The App',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  onPressed: () {
                    _shareApp(); // Call the share method when the button is pressed
                  },
                  icon: const Icon(Icons.share),
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.privacy_tip),
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: const Text(
                  'Terms & Conditions',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TermsAndConditions(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: const Text(
                  'About Us',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AboutUs(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.white,
                ),
              ),
              
              //  SizedBox(height: 300.0),// Add a Container to display the version number
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 20.0),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         'Version',
              //         style: TextStyle(fontSize: 14.0, color: Colors.white),
              //       ),
              //        SizedBox(height: 14.0),
              //       // Add some space between the lines
              //       Text(
              //         '1.0.0',
              //         style: TextStyle(fontSize: 16.0, color:Colors.white),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        backgroundColor: KPprimary,
      ),
    );
  }

  // Method to show the share dialog with a predefined text
  void _shareApp() {
     const String text = 'http://www.amazon.com/gp/mas/dl/android?p=com.beatbox.music';
    Share.share(text);
    
  }
}























// const String text = 'https://www.amazon.com/dp/B0CVMY5X61/ref=apps_sf_sta';
    // Share.share(text);