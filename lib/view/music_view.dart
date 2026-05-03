import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MusicView extends StatefulWidget {
  const MusicView({super.key});

  @override
  State<MusicView> createState() => _MusicViewState();
}

class _MusicViewState extends State<MusicView> {
  static const String apiKey = String.fromEnvironment('YOUTUBE_API_KEY');

  final TextEditingController searchController = TextEditingController();
  final TextEditingController timerController = TextEditingController();

  List<Map<String, String>> sounds = [];
  bool isLoading = false;

  Timer? countdownTimer;
  int remainingSeconds = 0;
  String timerStatus = "";

  double volume = 100;

  final List<String> presetSearches = [
    "Interview Pep Talk",
    "Ocean Waves",
    "Study Music",
    "Sleep Music",
    "White Noise",
    "Rain Sounds",
  ];

  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: true,
        hideThumbnail: true,
        controlsVisibleAtStart: false,
      ),
    );

    controller.setVolume(volume.toInt());
  }

  Future<void> searchYouTube(String query) async {
    FocusScope.of(context).unfocus();

    query = query.trim();

    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    searchController.text = query;

    final url = Uri.parse(
      "https://www.googleapis.com/youtube/v3/search"
      "?part=snippet&type=video&maxResults=10&q=$query audio&key=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;

      setState(() {
        sounds = items
            .where((item) => item['id']?['videoId'] != null)
            .map<Map<String, String>>((item) {
          final snippet = item['snippet'];
          final idMap = item['id'];

          return {
            "title": snippet['title'].toString(),
            "id": idMap['videoId'].toString(),
          };
        }).toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void playAudio(String id) {
    controller.load(id);
    controller.unMute();
    controller.setVolume(volume.toInt());
  }

  void startTimer() {
    final minutes = int.tryParse(timerController.text);

    if (minutes == null || minutes <= 0) {
      setState(() {
        timerStatus = "Enter valid minutes";
      });
      return;
    }

    countdownTimer?.cancel();

    remainingSeconds = minutes * 60;

    setState(() {
      timerStatus = formatTime(remainingSeconds);
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 1) {
        timer.cancel();
        controller.pause();

        setState(() {
          remainingSeconds = 0;
          timerStatus = "Stopped";
        });
      } else {
        setState(() {
          remainingSeconds--;
          timerStatus = formatTime(remainingSeconds);
        });
      }
    });
  }

  String formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;

    final m = mins.toString().padLeft(2, '0');
    final s = secs.toString().padLeft(2, '0');

    return "$m:$s remaining";
  }

  void stopAudio() {
    countdownTimer?.cancel();
    controller.pause();

    setState(() {
      timerStatus = "Stopped";
      remainingSeconds = 0;
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    searchController.dispose();
    timerController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Audio Search"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 0,
                width: 0,
                child: YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: false,
                ),
              ),
              const Icon(
                Icons.headphones,
                size: 70,
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: presetSearches.length,
                  itemBuilder: (context, index) {
                    final term = presetSearches[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          searchYouTube(term);
                        },
                        child: Text(term),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: "Search audio on YouTube",
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        searchYouTube(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      searchYouTube(searchController.text);
                    },
                    child: const Text("Search"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (isLoading) const LinearProgressIndicator(),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  itemCount: sounds.length,
                  itemBuilder: (context, index) {
                    final s = sounds[index];

                    return Card(
                      child: ListTile(
                        title: Text(s["title"]!),
                        trailing: const Icon(Icons.play_arrow),
                        onTap: () {
                          playAudio(s["id"]!);
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text("Volume"),
              Slider(
                value: volume,
                min: 0,
                max: 100,
                onChanged: (v) {
                  setState(() {
                    volume = v;
                  });

                  controller.setVolume(v.toInt());
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: timerController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Minutes",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: startTimer,
                    child: const Text("Timer"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(timerStatus),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: stopAudio,
                child: const Text("Stop"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}