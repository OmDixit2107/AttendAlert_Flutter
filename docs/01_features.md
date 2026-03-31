# AttendAlert - Core Features & Ideas

## Overview
AttendAlert is a smart attendance tracking application. It allows students to track their class attendance (Present, Bunked, Cancelled, Holiday) based on their specific academic profile (Year, Branch, Batch) and provides actionable insights and recommendations.

## Core Features
1. **User Authentication & Profile**
   - Secure login via Custom Spring Boot REST API (JWT Authentication).
   - Profile setup choosing: Degree, Year, Branch, and Section/Batch.

2. **Automated Course Fetching**
   - Based on the user's profile (Year, Branch), automatically fetch the enrolled courses/subjects for the current semester.

3. **Smart Attendance Tracking**
   - Mark a class as:
     - **Attended** (Present)
     - **Bunked** (Absent)
     - **Cancelled** (Teacher did not take the class - does not affect total working days)
     - **Holiday/Leave** (Excused absence - does not affect total working days)

4. **Statistics & Analytics (Dashboard)**
   - Overall attendance percentage pie chart/progress bar.
   - Subject-wise breakdown showing attendance percentage per course.
   - History timeline of recently marked classes.

5. **Clever Recommendations (The "Smart" Aspect)**
   - **Safe to Bunk:** "You can bunk the next 2 classes of Mathematics and still stay above 75%."
   - **Critical Alert:** "You need to attend the next 4 classes of Physics to reach the 75% threshold."
   - **Bunk Planner:** If a user wants to plan a trip, they input the dates, and the app calculates the impact on their attendance.

6. **Timetable Integration (Optional but highly recommended)**
   - View daily classes linearly.
   - Swipe actions (Swipe right for Attended, Swipe left for Bunked).

7. **Gamification & Goals**
   - Set a personal target attendance (e.g., 80%).
   - Streaks for attending classes continuously.
