import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polo/design/constom_texts.dart';
import 'package:polo/design/constrom_image.dart';
import 'package:polo/design/costom_colors.dart';
import 'login_page2.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({super.key});

  @override
  State<LoginPage1> createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        surfaceTintColor: AppColors.whiteColor,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics:  BouncingScrollPhysics(),
          child: Padding(
            padding:  EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppImages.delivery, fit: BoxFit.contain, height: 300),
                SizedBox(height: 10),
                Text(
                  AppTexts.text11,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                    fontSize: 26,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  AppTexts.login2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppTexts.text12,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding:  EdgeInsets.symmetric(vertical: 14),
                    enabledBorder:  UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffE2E2E2), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.lightGreen, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppTexts.text13,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  obscureText: _isObscure,
                  obscuringCharacter: '●',
                  style:  TextStyle(fontSize: 18, letterSpacing: 5),
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "••••••••",
                    hintStyle:  TextStyle(letterSpacing: 5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.lightGreen, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppTexts.login3,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.orangeColor,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: 264,
                  height: 57,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orangeColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Get.to(() =>  LoginPage2());
                    },
                    child: Text(
                      AppTexts.text14,
                      style: GoogleFonts.nunito(
                        color: AppColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                     AppTexts.text15,
                      style: GoogleFonts.nunito(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      AppTexts.text16,
                      style: TextStyle(
                        color: AppColors.orangeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}