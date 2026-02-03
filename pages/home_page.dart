import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polocha/design/costom_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset("assets/images/deliver.png"),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                fixedSize: Size(350, 57),
              ),
              onPressed: () {},
              child: Text(
                "Get Started",
                style: GoogleFonts.nunito(color: Colors.white),
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenColor,
                fixedSize: Size(350, 57),
              ),
              onPressed: () {},
              child: Text(
                "Log In",
                style: GoogleFonts.nunito(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
