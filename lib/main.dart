import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  AudioPlayer? audioPlayer;

  Duration? totalDuration = Duration.zero; // it store only zero in duration

  Duration? CurrentPostion = Duration.zero;
  Duration? BufferedPostion = Duration.zero;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setupMyAudioPlayer();
  }

  void setupMyAudioPlayer() async {
    String audioSrc =
        "https://raag.fm/files/mp3/128/Hindi-Singles/23303/Kesariya%20(Brahmastra)%20-%20(Raag.Fm).mp3";

    audioPlayer = AudioPlayer();

    totalDuration = await audioPlayer!.setUrl(audioSrc);

    audioPlayer!.positionStream.listen((event) {
      CurrentPostion = event;

      setState(() {});
    });

    audioPlayer!.bufferedPositionStream.listen((event) {
      BufferedPostion = event;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgressBar(
            bufferedBarColor: Colors.green,
            baseBarColor: Colors.grey,
            thumbColor: Colors.pink,
            onSeek: (seekToValue) {
              audioPlayer!.seek(seekToValue);
            },
            progress: CurrentPostion!,
            total: totalDuration!,
            buffered: BufferedPostion,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber.shade100),
                child: Center(
                  child: IconButton(
                      onPressed: () {}, icon: Icon(Icons.skip_previous)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber.shade100),
                child: Center(
                  child: IconButton(
                      onPressed: () {
                        if (audioPlayer!.playing) {
                          audioPlayer!.pause();
                        } else {
                          audioPlayer!.play();
                        }
                      },
                      icon: Icon(audioPlayer!.playing
                          ? Icons.push_pin
                          : Icons.play_arrow)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber.shade100),
                child: Center(
                  child:
                      IconButton(onPressed: () {}, icon: Icon(Icons.skip_next)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
