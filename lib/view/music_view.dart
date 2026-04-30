import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicView extends StatefulWidget {
  const MusicView({super.key});

  @override
  State<MusicView> createState() => _MusicViewState();
}

class _MusicViewState extends State<MusicView> {
  final AudioPlayer player = AudioPlayer();

  double volume = 1.0;

  final TextEditingController timerController =
      TextEditingController();

  Timer? countdownTimer;
  int secondsLeft = 0;
  String status = "";

  final List<Map<String, String>> tracks = [
    {
      "title": "Interview Calm",
      "url":
          "https://raw.githubusercontent.com/M-dot21/MP3_audio/main/themediaguy-soft-soothing-deep-white-noise-378857.mp3",
    },
    {
      "title": "Ocean Focus",
      "url":
          "https://raw.githubusercontent.com/M-dot21/MP3_audio/main/rmultimediaeu-ocean-waves-sound-01-321570.mp3",
    },
    {
      "title": "Rain Reset",
      "url":
          "https://raw.githubusercontent.com/M-dot21/MP3_audio/main/dragon-studio-copyright-free-rain-sounds-331497.mp3",
    },
    {
      "title": "Deep Work",
      "url":
          "https://raw.githubusercontent.com/M-dot21/MP3_audio/main/themediaguy-soft-soothing-deep-white-noise-378857.mp3",
    },
  ];

  Future<void> playSong(String url) async {
    await player.stop();
    await player.setReleaseMode(
      ReleaseMode.loop,
    );
    await player.play(
      UrlSource(url),
    );
  }

  Future<void> stopSong() async {
    await player.stop();
  }

  Future<void> setSound(double v) async {
    volume = v;
    await player.setVolume(v);
  }

  void startTimer() {
    final minutes =
        int.tryParse(timerController.text);

    if (minutes == null || minutes <= 0) {
      setState(() {
        status = "Enter valid minutes";
      });
      return;
    }

    countdownTimer?.cancel();

    secondsLeft = minutes * 60;

    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (secondsLeft <= 0) {
          timer.cancel();
          await stopSong();

          setState(() {
            status = "Stopped";
          });
        } else {
          setState(() {
            secondsLeft--;
            status =
                formatTime(secondsLeft);
          });
        }
      },
    );
  }

  String formatTime(int total) {
    final mins = total ~/ 60;
    final secs = total % 60;

    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')} remaining";
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    timerController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Focus Music"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const Text(
              "Playlists",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount:
                    tracks.length,
                itemBuilder:
                    (context, i) {
                  final item =
                      tracks[i];

                  return Card(
                    child:
                        ListTile(
                      leading:
                          const Icon(
                        Icons
                            .music_note,
                      ),
                      title: Text(
                        item["title"]!,
                      ),
                      onTap:
                          () {
                        playSong(
                          item["url"]!,
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            const Text("Volume"),

            Slider(
              value: volume,
              min: 0,
              max: 1,
              onChanged: (v) {
                setState(() {
                  volume = v;
                });
                setSound(v);
              },
            ),

            TextField(
              controller:
                  timerController,
              keyboardType:
                  TextInputType
                      .number,
              decoration:
                  const InputDecoration(
                labelText:
                    "Timer Minutes",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child:
                      ElevatedButton(
                    onPressed:
                        startTimer,
                    child:
                        const Text(
                      "Start Timer",
                    ),
                  ),
                ),
                const SizedBox(
                    width: 8),
                Expanded(
                  child:
                      ElevatedButton(
                    onPressed:
                        () async {
                      countdownTimer
                          ?.cancel();
                      await stopSong();

                      setState(() {
                        status =
                            "Stopped";
                      });
                    },
                    child:
                        const Text(
                      "Stop",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(status),
          ],
        ),
      ),
    );
  }
}