import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: VideoScreen());
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        loop: false,
      ),
    );

    _controller.loadVideoById(videoId: 'SnUBb-FAlCY');
  }

  String? extractVideoId(String url) {
    RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  void _loadNewVideo() {
    String url = _urlController.text.trim();
    String? videoId = extractVideoId(url);

    if (videoId != null) {
      _controller.loadVideoById(videoId: videoId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Video yuklandi!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Noto\'g\'ri YouTube link!')));
    }
  }

  @override
  void dispose() {
    _controller.close();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Video Player'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
        // Video Player
        Padding(
        padding: const EdgeInsets.all(16.0),
        child: YoutubePlayer(
          controller: _controller,
          aspectRatio: 16 / 9,
        ),
      ),

      // URL kiritish qismi
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'YouTube link kiriting',
                hintText: 'https://www.youtube.com/watch?v=...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _loadNewVideo,
              icon: Icon(Icons.play_arrow),
              label: Text('Videoni yuklash'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
              /// Misol videolar
              Padding(
                padding:  EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tez yuklash uchun:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildQuickVideoButton(
                      'Abdukarim Mirzayev',
                      'https://www.youtube.com/watch?v=jR98Qn8zYXI',
                      'assets/images/a.mirzayev.png',
                    ),
                    _buildQuickVideoButton(
                      'Flutter Tutorial',
                      'https://www.youtube.com/watch?v=1xipg02Wu8s',
                      'assets/images/flutter.learn.png',

                    ),
                    _buildQuickVideoButton(
                      'Dart Tutorial',
                      'https://www.youtube.com/watch?v=Ej_Pcr4uC2Q',
                      'assets/images/dart.png',

                    ),
                    _buildQuickVideoButton(
                      'Flutter Animate',
                      'https://www.youtube.com/watch?v=JSqUZFkRLr8',
                      'assets/images/fl.png',
                    ),

                    _buildQuickVideoButton(
                      'Alohida Mavzu!',
                      'https://www.youtube.com/watch?v=VWzAwURxUs4',
                      'assets/images/mavzu.png',
                    ),
                  ],
                ),
              ),
            ],
        ),
      ),
    );
  }

  Widget _buildQuickVideoButton(String title, String url, String image) {
    return Container(
      child: Column(
        children: [
          Image.asset(image),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ElevatedButton(
              onPressed: () {
                String? videoId = extractVideoId(url);
                if (videoId != null) {
                  _controller.loadVideoById(videoId: videoId);
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 45)),
              child: Text(title),
            ),
          ),
        ],
      ),
    );
  }
}
