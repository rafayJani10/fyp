
import 'package:fyp/profile/editprofilepage.dart';
import 'package:fyp/profile/widget/appbar_widget.dart';
import 'package:fyp/profile/widget/button_widget.dart';
import 'package:fyp/profile/widget/numbers_widget.dart';
import 'package:fyp/profile/widget/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "User Profile ",
      home: userprofile(),
    ),
  );
}

class userprofile extends StatefulWidget {
  const userprofile({super.key});

  // This widget is the root of your application.
  @override
  State<userprofile> createState() => _userprofilestate();
}

class _userprofilestate extends State<userprofile>{
  get user => 'null';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
               imagePath: 'my_pic',
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              const SizedBox(height: 24),
              buildName(user),
              const SizedBox(height: 24),
              Center(child: buildUpgradeButton()),
              const SizedBox(height: 24),
              NumbersWidget(),
              const SizedBox(height: 48),
              buildAbout(user),
            ],
          ),
        ),
      ),
    );

    // return SafeArea(child: Scaffold (
    //   backgroundColor: Color(0xFF163ABB),
    // ));
  }
  Widget buildName(User user) => Column(
    children: [
      Text(
        user.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        user.email,
        style: TextStyle(color: Colors.grey),
      )
    ],
  );

  Widget buildUpgradeButton() => ButtonWidget(
    text: 'Upgrade To PRO',
    onClicked: () {},
  );

  Widget buildAbout(User user) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          user.about,
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );
}

class User {
  String get about => 'null';

  String get email => 'null';

  String get name => 'null';
}