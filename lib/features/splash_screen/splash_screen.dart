import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/global/variables.dart';
import '../../theme/pallete.dart';
import '../branch/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      body:  Center(
          child: Padding(
            padding: EdgeInsets.all(w*0.2),
            child: Image.asset(Constants.logoPath),
          )
      ),
    );
  }
}
