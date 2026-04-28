import 'package:flutter/material.dart';
import 'package:movieit/providers/movie_provider.dart';
import 'package:movieit/screens/home_screen.dart';
import 'package:movieit/screens/search_screen.dart';
import 'package:movieit/screens/movie_detail_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:movieit/widgets/layout/custom_navbar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        String activeCategory = 'Home';
        if (state.fullPath == '/search') activeCategory = 'Search';
        if (state.fullPath == '/watchlist') activeCategory = 'Watchlist';

        return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: CustomNavBar(
            activeCategory: activeCategory,
            onTap: (category) {
               if (category == 'Home') context.go('/');
               if (category == 'Search') context.go('/search');
               if (category == 'Watchlist') context.go('/watchlist');
            },
          ),
          body: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/watchlist',
          builder: (context, state) => const Center(
            child: Text("Watchlist coming soon...", style: TextStyle(color: Colors.white))
          ),
        ),
      ],
    ),

    GoRoute(
      path: '/movie/:id',
      builder: (context, state) {
        final movieId = state.pathParameters['id']!;
        return MovieDetailScreen(movieId: movieId);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'MovieIT',
      debugShowCheckedModeBanner: false,
    );
  }
}
