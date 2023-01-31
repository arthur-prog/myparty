import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:my_party/src/constants/videos_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(splashVideo)
      ..initialize().then((_) {
        setState(() {});
      })
    ..setVolume(0.0);

    _playVideo();
  }

  void _playVideo() async{
    _controller.play();

    await Future.delayed(const Duration(seconds: 1));

    // Navigator.push(
    //     context,
    //   MaterialPageRoute(builder: (context) => LandingPage())
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(
          color: Colors.black,
        ),
      ),
    );
  }
}
