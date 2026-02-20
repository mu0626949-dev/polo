import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyRefreshPage extends StatefulWidget {
  @override
  _MyRefreshPageState createState() => _MyRefreshPageState();
}

class _MyRefreshPageState extends State<MyRefreshPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: true);

  List<String> data = ["Eski ma'lumot 1", "Eski ma'lumot 2"];

  void _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        data.insert(0, "YANGI MA'LUMOT (Yangi keldi!)");
      });
    }
    //  yopish uchun:
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Refresh Dizayni"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        header: WaterDropHeader(
          waterDropColor: Colors.blueAccent,
          refresh: CircularProgressIndicator(strokeWidth: 2),
          complete: Icon(Icons.check, color: Colors.green),
        ),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text(data[index]),
                subtitle: Text("Hozirgina yangilandi"),
              ),
            );
          },
        ),
      ),
    );
  }
}