import 'package:flutter/material.dart';

import '../../../../core/widgets/assistant_mascot.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;
  static const _labels = [
    'Beranda',
    'Tugas',
    'Asisten',
    'Jadwal',
    'Notifikasi',
  ];
  static const _icons = [
    Icons.home_rounded,
    Icons.task_alt_rounded,
    Icons.smart_toy_rounded,
    Icons.calendar_month_rounded,
    Icons.notifications_rounded,
  ];

  void _selectTab(int index) => setState(() => _selectedTab = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2A44),
        foregroundColor: Colors.white,
        title: const Text('AI Personal Assistant'),
        centerTitle: true,
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        elevation: 14,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(5, (index) {
                final selected = _selectedTab == index;
                final center = index == 2;
                return Expanded(
                  child: Semantics(
                    selected: selected,
                    button: true,
                    label: _labels[index],
                    child: Tooltip(
                      message: _labels[index],
                      child: InkWell(
                        key: ValueKey('home-tab-$index'),
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => _selectTab(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: Duration(
                                  milliseconds:
                                      MediaQuery.disableAnimationsOf(context)
                                      ? 0
                                      : 220,
                                ),
                                curve: Curves.easeOutCubic,
                                width: center ? 60 : 44,
                                height: center ? 60 : 36,
                                decoration: BoxDecoration(
                                  gradient: center
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF123C69),
                                            Color(0xFF398E96),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  color: center
                                      ? null
                                      : selected
                                      ? const Color(0xFFDDF5F1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    center ? 22 : 14,
                                  ),
                                  border: center
                                      ? Border.all(
                                          color: selected
                                              ? const Color(0xFFF6BE55)
                                              : Colors.white,
                                          width: 3,
                                        )
                                      : null,
                                  boxShadow: center
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF123C69)
                                                .withValues(alpha: 0.22),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Icon(
                                  _icons[index],
                                  size: center ? 32 : 24,
                                  color: center
                                      ? Colors.white
                                      : selected
                                      ? const Color(0xFF123C69)
                                      : const Color(0xFF6C7A89),
                                ),
                              ),
                              const SizedBox(height: 5),
                              ExcludeSemantics(
                                child: Text(
                                  _labels[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: selected
                                        ? const Color(0xFF123C69)
                                        : const Color(0xFF6C7A89),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: _selectedTab != 0
          ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedTab == 2)
                      const AssistantMascot()
                    else
                      Icon(
                        _icons[_selectedTab],
                        size: 56,
                        color: const Color(0xFF398E96),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      _labels[_selectedTab],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Fitur ini sedang disiapkan. Nantikan di sini, ya!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => _selectTab(0),
                      child: const Text('Kembali ke Beranda'),
                    ),
                  ],
                ),
              ),
            )
          : TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(
                milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 700,
              ),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF061826), Color(0xFF123C69)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: AssistantMascot()),
                          SizedBox(height: 12),
                          Text(
                            'Selamat Datang',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Apa yang ingin kamu kerjakan hari ini?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Menu Utama',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _HomeMenuItem(
                      icon: Icons.task_alt,
                      title: 'Tasks',
                      subtitle: 'Kelola tugas dan deadline',
                      onTap: () => _selectTab(1),
                    ),

                    const SizedBox(height: 12),

                    _HomeMenuItem(
                      icon: Icons.calendar_month,
                      title: 'Calendar',
                      subtitle: 'Lihat jadwal dan reminder',
                      onTap: () => _selectTab(3),
                    ),

                    const SizedBox(height: 12),

                    _HomeMenuItem(
                      icon: Icons.notifications_active,
                      title: 'Notifications',
                      subtitle: 'Lihat notifikasi terbaru',
                      onTap: () => _selectTab(4),
                    ),

                    const SizedBox(height: 12),

                    _HomeMenuItem(
                      icon: Icons.smart_toy_outlined,
                      title: 'AI Assistant',
                      subtitle: 'Asisten pintar untuk bantu aktivitas',
                      onTap: () => _selectTab(2),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4F3F0),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFCBE5DF)),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.local_florist_rounded,
                            color: Color(0xFF408879),
                            size: 30,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Langkah kecil, hari yang berarti.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF123C69),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Tarik napas. Kamu tidak harus menyelesaikan semuanya sekaligus.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF47645D),
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Ditemani AI • Dibuat untuk harimu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF47645D),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.paddingOf(context).bottom),
                  ],
                ),
              ),
            ),
    );
  }
}

class _HomeMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF123C69).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF123C69)),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}
