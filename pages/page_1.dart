import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:  Color(0xFF1E1E1E),
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 120,
          title: Text("My \nNotes", style: GoogleFonts.nunito(fontSize: 36, color: Colors.white, height: 1.1)),
          actions:  [
            Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(radius:26,backgroundColor: Colors.white, child: Text("Logo",style: GoogleFonts.nunito(fontWeight: FontWeight.w600,fontSize: 15),)),
            )
          ],
          bottom:  TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "All Notes"),
              Tab(text: "Important"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding:  EdgeInsets.all(16),
              children: [
                Container(
                  padding:  EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Title Here', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 8),
                      Text('30 dec. 2021, 10:11 am.', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            Center(child: Text("Important Notes", style: TextStyle(color: Colors.white))),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.grey,
          child:  Icon(Icons.add, size: 40, color: Colors.black),
        ),
      ),
    );
  }
}
