import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class VideoView extends StatefulWidget {
  const VideoView({super.key, this.onFullScreenChanged});

  final ValueChanged<bool>? onFullScreenChanged;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  static const String apiKey = String.fromEnvironment('YOUTUBE_API_KEY');
  List<Map<String, String>> videos = [];

  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;

  final List<String> presetSearches = [
    "Software Engineering Jobs and Salaries",
    "Coding interview prep",
    "Coding interview mock interview",
    "Top tech companies",
    "Coding interview questions and answers",
    "Software engineering career development",
  ];

  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: "ft0owvS5tQA",
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
    controller.setVolume(100);
  }

  Future<void> searchYouTube(String query) async {
    FocusScope.of(context).unfocus();

    if (query.isEmpty) return;

    setState(() => isLoading = true);

    searchController.text = query;

    final url = Uri.parse(
      "https://www.googleapis.com/youtube/v3/search"
      "?part=snippet&type=video&maxResults=10&q=$query jobs salaries&key=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;

      setState(() {
        videos = items
            .where((item) => item['id']?['videoId'] != null)
            .map<Map<String, String>>((item) {
              final snippet = item['snippet'] as Map<String, dynamic>;
              final idMap = item['id'] as Map<String, dynamic>;

              return {
                "title": snippet['title'].toString(),
                "id": idMap['videoId'].toString(),
              };
            })
            .toList();
      });
    }

    setState(() => isLoading = false);
  }

  void loadVideo(String id) {
    controller.load(id);
  }

  @override
  void dispose() {
    widget.onFullScreenChanged?.call(false);
    controller.dispose();
    searchController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        widget.onFullScreenChanged?.call(true);
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.immersiveSticky,
        );
      },
      onExitFullScreen: () {
        widget.onFullScreenChanged?.call(false);
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge,
        );
      },
      player: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        onReady: () {
          controller.addListener(() {
            if (controller.value.isFullScreen) {
              SystemChrome.setEnabledSystemUIMode(
                SystemUiMode.immersiveSticky,
              );
            } else {
              SystemChrome.setEnabledSystemUIMode(
                SystemUiMode.edgeToEdge,
              );
            }
          });
        },
        bottomActions: const [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Video Browser"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: player,
                ),

                const SizedBox(height: 15),

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

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: "Search Jobs and Salaries",
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: searchYouTube,
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

                const SizedBox(height: 10),

                if (isLoading) const LinearProgressIndicator(),

                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final v = videos[index];

                      return Card(
                        child: ListTile(
                          title: Text(v["title"]!),
                          trailing: const Icon(Icons.play_arrow),
                          onTap: () {
                            loadVideo(v["id"]!);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}