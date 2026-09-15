import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: SingleChildScrollView(
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
                  Text(
                    'Selamat Datang',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _HomeMenuItem(
              icon: Icons.task_alt,
              title: 'Tasks',
              subtitle: 'Kelola tugas dan deadline',
              onTap: () {
                // Nanti masuk ke Task Page
              },
            ),

            const SizedBox(height: 12),

            _HomeMenuItem(
              icon: Icons.calendar_month,
              title: 'Calendar',
              subtitle: 'Lihat jadwal dan reminder',
              onTap: () {},
            ),

            const SizedBox(height: 12),

            _HomeMenuItem(
              icon: Icons.notifications_active,
              title: 'Notifications',
              subtitle: 'Lihat notifikasi terbaru',
              onTap: () {},
            ),

            const SizedBox(height: 12),

            _HomeMenuItem(
              icon: Icons.smart_toy_outlined,
              title: 'AI Assistant',
              subtitle: 'Asisten pintar untuk bantu aktivitas',
              onTap: () {},
            ),
          ],
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
