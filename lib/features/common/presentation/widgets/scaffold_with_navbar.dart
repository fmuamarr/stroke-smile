import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:pohps_app/core/constants/app_colors.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar>
    with WidgetsBindingObserver {
  DateTime? _lastBackPressTime;
  String? _lastPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reset when app is resumed from background
    if (state == AppLifecycleState.resumed) {
      _lastBackPressTime = null;
    }
  }

  bool _isRootPath(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    // Handle potential trailing slashes or sub-paths
    return location.startsWith('/home') ||
        location.startsWith('/checklist') ||
        location.startsWith('/videos') ||
        location.startsWith('/education');
  }

  Future<void> _handleBackPress(BuildContext context) async {
    final isRoot = _isRootPath(context);

    // For root paths, always show the exit confirmation
    if (isRoot) {
      final now = DateTime.now();
      final lastPress = _lastBackPressTime;

      // Check if this is a "double press" event
      if (lastPress == null || now.difference(lastPress).inSeconds >= 2) {
        // First press or timeout expired - show toast and update time
        _lastBackPressTime = now;
        Fluttertoast.showToast(
          msg: "Tekan kembali sekali lagi untuk keluar aplikasi",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Second press within 2 seconds - exit app
        _lastBackPressTime = null;
        SystemNavigator.pop();
      }
      return;
    }

    // Not on root path - allow normal back navigation
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reset timer when location changes (user navigated to a different tab)
    final String location = GoRouterState.of(context).uri.path;
    if (_lastPath != location) {
      _lastPath = location;
      _lastBackPressTime = null;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        _handleBackPress(context);
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _calculateSelectedIndex(context),
            onTap: (int idx) => _onItemTapped(idx, context),
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.greenHealth,
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 28),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist_rtl_rounded, size: 28),
                label: 'Checklist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_circle_outline_rounded, size: 28),
                label: 'Video',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school_outlined, size: 28),
                label: 'Edukasi',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/checklist')) return 1;
    if (location.startsWith('/videos')) return 2;
    if (location.startsWith('/education')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/checklist');
        break;
      case 2:
        context.go('/videos');
        break;
      case 3:
        context.go('/education');
        break;
    }
  }
}
