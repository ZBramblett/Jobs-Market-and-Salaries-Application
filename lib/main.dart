import 'package:flutter/material.dart';
import 'package:finalexam_salaries/view/homepage.dart';
import 'package:finalexam_salaries/view/searchpage.dart';
import 'package:finalexam_salaries/view/settingspage.dart';
import 'package:finalexam_salaries/view/music_view.dart';
import 'package:finalexam_salaries/view/video_view.dart';

void main() {
  runApp(const MyApp());
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
final ValueNotifier<bool> fullScreenNotifier = ValueNotifier(false);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 35, 82, 45),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 35, 82, 45),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: currentMode,
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MyHomePage(title: 'FinalExamSalaries'),
    const SearchPage(),
    const MusicView(),
    VideoView(
      onFullScreenChanged: (isFullScreen) {
        fullScreenNotifier.value = isFullScreen;
      },
    ),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: fullScreenNotifier,
      builder: (_, isFullScreen, _) {
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: isFullScreen
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home), label: 'Home',),
                    NavigationDestination(icon: Icon(Icons.search), label: 'Search',),
                    NavigationDestination(icon: Icon(Icons.music_note), label: 'Music',),
                    NavigationDestination(icon: Icon(Icons.video_library), label: 'Videos',),
                    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings',),
                  ],
                ),
        );
      },
    );
  }
}
