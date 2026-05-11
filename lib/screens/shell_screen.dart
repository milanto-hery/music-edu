// lib/screens/shell_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'theory_screen.dart';
import 'lessons_screen.dart';
import 'progressions_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    TheoryScreen(),
    LessonsScreen(),
    ProgressionsScreen(),
  ];

  static const _navItems = [
    _NavItem(Icons.home_outlined, Icons.home, 'Home'),
    _NavItem(Icons.piano_outlined, Icons.piano, 'Theory'),
    _NavItem(Icons.school_outlined, Icons.school, 'Lessons'),
    _NavItem(Icons.queue_music_outlined, Icons.queue_music, 'Progressions'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    if (isWide) {
      return _WideLayout(
        currentIndex: _currentIndex,
        onNav: (i) => setState(() => _currentIndex = i),
        screen: _screens[_currentIndex],
        navItems: _navItems,
      );
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _BottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: _navItems,
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}

// ── Wide Layout (sidebar nav) ─────────────────────────────────────────────

class _WideLayout extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNav;
  final Widget screen;
  final List<_NavItem> navItems;

  const _WideLayout({
    required this.currentIndex,
    required this.onNav,
    required this.screen,
    required this.navItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 220,
            color: AppTheme.surface,
            child: Column(
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppTheme.cardBorder),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGrad,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.music_note,
                          color: AppTheme.bg,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'MusicEdu',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 22,
                          color: AppTheme.accent,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Nav items
                ...navItems.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  final isSelected = currentIndex == i;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    child: ListTile(
                      selected: isSelected,
                      selectedTileColor: AppTheme.accent.withOpacity(0.1),
                      leading: Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected
                            ? AppTheme.accent
                            : AppTheme.textSecond,
                        size: 22,
                      ),
                      title: Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.accent
                              : AppTheme.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () => onNav(i),
                    ),
                  );
                }),
                const Spacer(),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppTheme.accent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Premium',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: AppTheme.accent,
                              ),
                            ),
                            Text(
                              'Unlock all lessons',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.textSecond,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1, color: AppTheme.cardBorder),
          // Main content
          Expanded(child: screen),
        ],
      ),
    );
  }
}

// ── Bottom Navigation Bar ─────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavItem> items;

  const _BottomBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.cardBorder)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected
                              ? AppTheme.accent
                              : AppTheme.textSecond,
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? AppTheme.accent
                                : AppTheme.textSecond,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
