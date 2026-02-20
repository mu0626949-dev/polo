import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polo/design/constom_texts.dart';
import 'package:polo/design/constrom_image.dart';
import 'package:polo/design/costom_colors.dart';
import 'login_page2.dart';

class LoginPage2 extends StatefulWidget {

  const LoginPage2({super.key});
  @override
  State<LoginPage2> createState() => _LoginPage2State();
}
class _LoginPage2State extends State<LoginPage2> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.whiteColor,
      ),
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics:  BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppImages.delivery2, fit: BoxFit.contain),
                SizedBox(height: 10),
                Text(
                  AppTexts.singUp,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                    fontSize: 26,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  AppTexts.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    color: AppColors.greyColor,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppTexts.text17,
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
                    contentPadding:  EdgeInsets.symmetric(vertical: 8),
                    enabledBorder:  UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffE2E2E2), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.lightGreen, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 5),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppTexts.text18,
                      style: GoogleFonts.nunito(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      AppTexts.text19,
                      style: TextStyle(
                        color: AppColors.greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
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
                    onPressed: () {},
                    child: Text(
                      AppTexts.text20,
                      style: GoogleFonts.nunito(
                        color: AppColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
