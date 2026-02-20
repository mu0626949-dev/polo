import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:polo/design/constom_texts.dart';
import 'package:polo/design/constrom_image.dart';
import 'package:polo/design/costom_colors.dart';
import 'package:polo/pages/home_page3.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final phoneMask = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  AppImages.vegetables,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 12),
              Text(
               AppTexts.text1,
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              SizedBox(height: 18),
              TextField(
                inputFormatters: [phoneMask],
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "(222) 222-2222",
                  hintStyle: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 12, right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇺🇸', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 6),
                        Text(
                          '+1',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage3(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.orangeColor,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  AppTexts.text5,
                  style: TextStyle(fontSize: 13, color: AppColors.greyColor),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Image.asset(AppImages.google, height: 20),
                label: Text(AppTexts.text6),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: AppColors.whiteColor,
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(side: BorderSide(),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: BorderSide(color: AppColors.blackColor),
                  elevation: 0,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.facebook, size: 20),
                label: Text(AppTexts.text7),
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.whiteColor,
                  backgroundColor: AppColors.blueColor,
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
