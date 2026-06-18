# MovieIT

A movie discovery and planning web application that allows users to search for films, apply advanced filters, view streaming sources, and manage personal watchlists and schedules. 

**Live Application:** [https://movieit-2026.web.app/](https://movieit-2026.web.app/)

## Key Features
* **Advanced Filtering:** Multi-select genres and languages, specify runtime ranges, and set minimum ratings using an interactive UI.
* **Movie Discovery:** View trending, popular, and upcoming movies, alongside dynamic recommendations based on user behavior.
* **Streaming Availability:** Integration with external APIs to display where specific movies can be watched or streamed.
* **Personal Planner:** Add movies to a watchlist and schedule future viewing dates. 
* **Local-First Architecture:** User preferences, watchlists, and schedules are stored locally on the device for fast retrieval and offline access.

## Tech Stack
* **Frontend:** Flutter Web (Dart)
* **Backend:** Node.js, Express.js
* **Local Storage:** Hive
* **External APIs:** TMDB API (Movie Metadata), Watchmode API (Streaming Sources)

## Project Architecture
* **Frontend State Management:** Provider (`MovieProvider`)
* **Routing:** GoRouter
* **API Communication:** `http` package for Dart, `axios` for Node.js
* **Backend Responsibilities:** Acts as a proxy for TMDB and Watchmode to secure API keys, format requests (e.g., translating arrays into TMDB syntax), and reduce payload sizes before serving the frontend.
