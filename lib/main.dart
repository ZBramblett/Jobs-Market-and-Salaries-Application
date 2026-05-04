import 'package:finalexam_salaries/model/ai_job_data.dart';
import 'package:finalexam_salaries/model/salary_model.dart';
import 'package:finalexam_salaries/model/save_jobs.dart';
import 'package:finalexam_salaries/view/riskAnalysisPage.dart';
import 'package:finalexam_salaries/view/login_screen.dart';
import 'package:finalexam_salaries/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:finalexam_salaries/view/homepage.dart';
import 'package:finalexam_salaries/view/searchpage.dart';
import 'package:finalexam_salaries/view/settingspage.dart';
import 'package:finalexam_salaries/view/music_view.dart';
import 'package:finalexam_salaries/view/video_view.dart';
import 'package:finalexam_salaries/view/AICareerPage.dart';
import 'package:finalexam_salaries/view/city_comparer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final allJobs = await AIJobData.instance.loadJobs();
  await SaveJobs.instance.loadSavedJobs(allJobs);
  final allSEJobs = await SalaryModel().loadEntries();
  await SaveJobs.instance.loadSavedSEJobs(allSEJobs);
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
            navigationBarTheme: const NavigationBarThemeData(
              labelTextStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 10, overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
          darkTheme: ThemeData(
            navigationBarTheme: const NavigationBarThemeData(
              labelTextStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 10, overflow: TextOverflow.ellipsis),
              ),
            ),
            colorScheme: ColorScheme(
              primary: Color.fromARGB(255, 175, 255, 175),
              secondary: Color.fromARGB(255, 100, 255, 100),
              surface: Color.fromARGB(255, 20, 22, 20),
              error: Color.fromARGB(255, 255, 0, 0),
              onPrimary: Color.fromARGB(255, 35, 40, 35),
              onSecondary: Color.fromARGB(255, 35, 40, 35),
              onSurface: Color.fromARGB(255, 255, 255, 255),
              onError: Color.fromARGB(255, 10, 20, 10),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: currentMode,
          home: const LoginScreen(),
          routes: {
            '/home': (context) => const MainScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
          },
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
    const AICareerPage(),
    const RiskAnalysisPage(),
    const SearchPage(),
    const MusicView(),
    VideoView(
      onFullScreenChanged: (isFullScreen) {
        fullScreenNotifier.value = isFullScreen;
      },
    ),
    const CityComparerScreen(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: fullScreenNotifier,
      builder: (_, isFullScreen, _) {
        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: _pages),
          bottomNavigationBar: isFullScreen
              ? null
              : NavigationBar(
                  surfaceTintColor: Theme.of(context).colorScheme.primary,
                  indicatorColor: WidgetStateColor.resolveWith((states) {
                    final colorScheme = Theme.of(context).colorScheme;
                    return colorScheme.brightness == Brightness.dark
                        ? colorScheme.primary
                        : colorScheme.primary;
                  }),
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: 'Home',
                      selectedIcon: Icon(
                        Icons.home,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_search),
                      label: 'AI Careers',
                      selectedIcon: Icon(
                        Icons.person_search,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_search),
                      label: 'Risk Analysis',
                      selectedIcon: Icon(
                        Icons.person_search_outlined,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.search),
                      label: 'Search',
                      selectedIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.music_note),
                      label: 'Music',
                      selectedIcon: Icon(
                        Icons.music_note,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.video_library),
                      label: 'Videos',
                      selectedIcon: Icon(
                        Icons.video_library,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.compare_arrows),
                      label: 'City Compare',
                      selectedIcon: Icon(
                        Icons.compare_arrows,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                      selectedIcon: Icon(
                        Icons.settings,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
