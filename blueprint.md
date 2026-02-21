# FitTrack Mini - Feature Blueprint

## 1. Vision & Philosophy

FitTrack Mini is a modern, clean, and motivational fitness tracking app with a health-focused design. It aims to provide an intuitive and encouraging user experience.

## 2. Color Scheme & Theme

- **Primary:** Teal (`#0EA5A4`)
- **Dark:** Slate (`#0F172A`)
- **Light Background:** Slate (`#F1F5F9`)
- **Accent:** Lime (`#84CC16`)
- **Theme:** A clean, modern, health-focused look with both Light and Dark mode support.

## 3. Home Screen Components

### 3.1. Top App Bar (Sticky)
- **App Logo:** On the left side.
- **App Name:** "FitTrack Mini".
- **Icons (Right):** Notification Icon and a Profile/Settings Icon.
- **Color:** Dark Blue/Teal theme (`#0EA5A4`).
- **Behavior:** The header remains visible (sticky) at the top during scrolling.

### 3.2. Welcome Section
- **Greeting:** Dynamic message, "Good Morning/Afternoon, {User Name}".
- **Quote:** A motivational fitness quote that changes daily.
- **Date:** Displays the current date.

### 3.3. Daily Summary Card
This is the main highlight section of the home screen.
- **Design:** A prominent card with a shadow and a clean white background.
- **Components:**
    - **Circular Progress Ring:** Visual representation of the daily step goal.
    - **Steps Count:** Displayed as a large, animated number.
    - **Other Metrics:** Calories Burned, Distance Covered, and Active Minutes are included within this card.

### 3.4. Quick Start Workout Buttons
- **Buttons:**
    1.  Start Walk
    2.  Start Run
    3.  Start Cycling
    4.  Custom Workout
- **Design:** Large, rounded buttons with both an icon and text. They will feature a gradient or solid teal color.

### 3.5. Weekly Progress Section
- **UI:** A card-based section.
- **Components:**
    - **Mini Graph:** A 7-day graph showing step comparisons.
    - **Call to Action:** A "View Detailed Stats" button.

### 3.6. Ad Placement
- **Strategy:** A banner ad will be placed in a non-intrusive location, such as below the weekly progress section, to support the app.
- **Implementation:** Uses `google_mobile_ads` with a test ID for development.

### 3.7. Health Metrics Section
- **Status:** To be implemented if the required sensors/data are available.
- **Metrics:**
    - Heart Rate
    - BMI
    - Weight Log

### 3.8. Water Intake Tracker
- **Status:** Optional but highly requested feature to be included.
- **Components:**
    - **Progress Bar:** Shows progress towards a daily water intake goal.
    - **Action Button:** An 'Add' button to log water intake (e.g., +250ml).
    - **Reset Option:** To reset the daily count.

### 3.9. Achievements / Badges Section
- **Components:**
    - **Daily Goal Badge:** Awarded when the daily step goal is met.
    - **Weekly Streak Counter:** Tracks consecutive days of meeting goals.
    - **Animation:** A small, rewarding animation for achievements.

### 3.10. Bottom Navigation Bar
- **Tabs:**
    1.  Home
    2.  Activity
    3.  Progress
    4.  Profile
- **Design:** The active tab is highlighted. The navigation bar is fixed at the bottom.

## 4. Technical Requirements
- **Data:** Load user data from Firebase and sync step counter information.
- **Responsiveness:** The UI must be mobile responsive.
- **Error Handling:** Ensure no console errors and that data updates in real-time.
- **Dark Mode:** The app must have a fully functional and visually appealing dark mode.
