# CareerLens — Job Market & Salary Explorer

A Flutter application for exploring AI and software engineering job markets, tracking job applications, and visualizing salary data and AI risk trends.

---

## Features

### Job Search & Discovery
- **AI Careers Search** — Search jobs from a dataset of AI-related roles (2015–2035) with AI risk scores, skill demand rankings, and skill investment recommendations
- **Software Engineering Job Search** — Browse SWE roles with salary ranges sourced from a 2024 industry dataset
- **City Salary Comparison** — Compare average, minimum, and maximum salaries across multiple cities side by side

### Risk & Analytics
- **AI Risk Analysis** — Select a job title and view AI displacement risk scores grouped by global region (Americas, Europe, Asia, etc.), categorized as Low / Medium / High
- **Advanced Analytics** — Interactive charts (pie, line, bar) filterable by dataset (AI careers, SWE jobs, or your own tracked applications) and metric (experience level, salary bucket, AI risk category, year-over-year trends, application confidence distribution, and more)

### Job Tracking
- **Save Jobs** — Bookmark AI and SWE roles for later review
- **Application Tracker** — Mark jobs as applied, log interview dates on a built-in calendar, and rate your confidence (1–5 stars)
- **Home Dashboard** — At-a-glance summary of saved jobs, applied count, and upcoming interviews

### Resources
- **Video Search** — Search YouTube for job prep content (mock interviews, résumé tips, etc.) with an embedded player
- **Music / Audio Search** — Search YouTube for study music or motivational content with volume control and a session timer

### Account & Settings
- Firebase authentication (email/password, Google Sign-In, guest/anonymous mode)
- Password reset via email
- Dark / light mode toggle with automatic time-based theming (sunrise, day, sunset, night)

---

## Tech Stack

| Layer | Libraries |
|---|---|
| Framework | Flutter (Dart) |
| Auth | Firebase Auth, Google Sign-In |
| Local storage | SharedPreferences |
| Charts | fl_chart |
| Calendar | table_calendar |
| Video / Audio | youtube_player_flutter, audioplayers |
| Networking | http |
| Data | CSV (two Kaggle datasets bundled as assets) |

---

## Architecture

The app follows the **MVP (Model-View-Presenter)** pattern:

```
lib/
├── data/          # Bundled CSV datasets
├── model/         # Data classes and data-loading singletons
├── presenter/     # Business logic, search, filtering, chart data prep
├── view/          # Screens and navigation
└── widgets/       # Reusable chart and calendar widgets
```

Key singletons: `AIJobData`, `SaveJobs`, `AuthPresenter`, `ThemePresenter`.  
`SaveJobs` extends `ChangeNotifier` so the UI reactively updates when jobs are saved or tracking data changes.

---

## Data Sources

- **Software Engineer Jobs & Salaries 2024** — Emre Öksüz (Kaggle)
- **AI Job Impact & Salary Dataset (2015–2035)** — Shreyash Gade (Kaggle)

Both datasets are bundled as CSV assets in `lib/data/` and parsed at app startup.

---

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.x
- A Firebase project with **Authentication** enabled (Email/Password and Google Sign-In providers)
- A YouTube Data API v3 key (for video/music search)

### Setup

1. **Clone the repo**
   ```bash
   git clone <repo-url>
   cd FinalExam_Salaries
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**  
   Add your `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS/macOS) to the appropriate platform directories. Make sure Firebase Auth is enabled in your Firebase console.

4. **Run the app**  
   Pass your YouTube API key via `--dart-define`:
   ```bash
   flutter run --dart-define=YOUTUBE_API_KEY=your_key_here
   ```
   Video and music search will be unavailable without a valid key; all other features work without it.

---


## Contributing

This project was built as a final exam project and is not my own exclusive work.

---

