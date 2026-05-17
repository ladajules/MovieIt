import 'package:flutter/material.dart';
import 'package:movieit/utils/notification_engine.dart';
import 'package:movieit/widgets/layout/custom_footer.dart';
import 'package:movieit/widgets/layout/custom_navbar.dart';
import 'package:go_router/go_router.dart';

class MainAppShell extends StatefulWidget {
  final Widget child;
  final String activeCategory;

  const MainAppShell({super.key, required this.child, required this.activeCategory});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  @override
  void initState() {
    super.initState();
    // The timer now lives at the very top of your app!
    NotificationEngine.start(context); 
  }

  @override
  void dispose() {
    NotificationEngine.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: CustomNavBar(
        activeCategory: widget.activeCategory,
        onTap: (category) {
           if (category == 'Home') context.go('/');
           if (category == 'Search') context.go('/search');
           if (category == 'Planner') context.go('/planner');
        },
      ),
      body: widget.child,

    );
  }
}