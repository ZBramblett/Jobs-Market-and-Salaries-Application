import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  @override
  State<VideoView> createState() =>
      _VideoViewState();
}

class _VideoViewState
    extends State<VideoView> {
  final TextEditingController
      searchController =
      TextEditingController();

  bool showSavedOnly = false;

  String selectedCategory =
      "All";

  final List<String> categories = [
    "All",
    "Interview",
    "Resume",
    "Finance",
    "Coding",
    "Stress",
  ];

  final List<Map<String, String>>
      videos = [
    {
      "title":
          "Tell Me About Yourself",
      "url":
          "https://www.youtube.com/watch?v=HG68Ymazo18",
      "category":
          "Interview",
    },
    {
      "title":
          "Best Resume Tips",
      "url":
          "https://www.youtube.com/watch?v=Tt08KmFfIYQ",
      "category":
          "Resume",
    },
    {
      "title":
          "Finance Career Guide",
      "url":
          "https://www.youtube.com/watch?v=ws9Xsl0Y0CQ",
      "category":
          "Finance",
    },
    {
      "title":
          "Coding Interview Prep",
      "url":
          "https://www.youtube.com/watch?v=1qw5ITr3k9E",
      "category":
          "Coding",
    },
  ];

  final List<Map<String, String>>
      saved = [];

  Future<void> openVideo(
    String url,
  ) async {
    await launchUrl(
      Uri.parse(url),
    );
  }

  bool isSaved(
    Map<String, String> v,
  ) {
    return saved.any(
      (item) =>
          item["title"] ==
          v["title"],
    );
  }

  void toggleSave(
    Map<String, String> v,
  ) {
    setState(() {
      if (isSaved(v)) {
        saved.removeWhere(
          (item) =>
              item["title"] ==
              v["title"],
        );
      } else {
        saved.add(v);
      }
    });
  }

  List<Map<String, String>>
      get displayList {
    List<Map<String, String>>
        list =
        showSavedOnly
            ? saved
            : videos;

    if (selectedCategory !=
        "All") {
      list = list
          .where(
            (item) =>
                item[
                    "category"] ==
                selectedCategory,
          )
          .toList();
    }

    if (searchController
        .text
        .isNotEmpty) {
      list = list
          .where(
            (item) => item[
                    "title"]!
                .toLowerCase()
                .contains(
                  searchController
                      .text
                      .toLowerCase(),
                ),
          )
          .toList();
    }

    return list;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Career Videos",
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showSavedOnly =
                    !showSavedOnly;
              });
            },
            icon: Icon(
              showSavedOnly
                  ? Icons.list
                  : Icons.bookmark,
            ),
          ),
        ],
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
          14,
        ),
        child: Column(
          children: [
            TextField(
              controller:
                  searchController,
              onChanged: (v) {
                setState(() {});
              },
              decoration:
                  const InputDecoration(
                hintText:
                    "Search videos",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
                height: 10),

            DropdownButton<String>(
              value:
                  selectedCategory,
              isExpanded: true,
              items: categories
                  .map(
                    (item) =>
                        DropdownMenuItem(
                      value:
                          item,
                      child:
                          Text(
                        item,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  selectedCategory =
                      v!;
                });
              },
            ),

            const SizedBox(
                height: 10),

            Expanded(
              child:
                  ListView.builder(
                itemCount:
                    displayList
                        .length,
                itemBuilder:
                    (context,
                        i) {
                  final item =
                      displayList[
                          i];

                  return Card(
                    child:
                        ListTile(
                      leading:
                          const Icon(
                        Icons
                            .play_circle,
                      ),
                      title: Text(
                        item["title"]!,
                      ),
                      subtitle:
                          Text(
                        item[
                            "category"]!,
                      ),
                      trailing:
                          IconButton(
                        icon: Icon(
                          isSaved(
                                item,
                              )
                              ? Icons
                                  .bookmark
                              : Icons
                                  .bookmark_border,
                        ),
                        onPressed:
                            () {
                          toggleSave(
                            item,
                          );
                        },
                      ),
                      onTap:
                          () {
                        openVideo(
                          item["url"]!,
                        );
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
  }
}