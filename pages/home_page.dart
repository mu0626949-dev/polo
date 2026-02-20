import 'package:flutter/material.dart';
import 'package:polo/design/costom_style.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  Color? colorOff = Colors.grey;
  Color? colorOn = Colors.yellowAccent;



  void bosildi() {
    count++;
    print("$count");
    setState(() {});
  }

  /// jarayon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.yellow),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: bosildi,
              child: Text("+", style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }
}
