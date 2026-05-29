import 'package:flutter/material.dart';
import 'theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reminders = [
      'Review algebra formulas at 8:00 AM',
      'Complete physics practice set before noon',
      'Take a 15-minute reading break after 5 PM',
      'Check weekly progress summary tomorrow',
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Study reminders and alerts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'This is a placeholder for scheduled reminders, study alerts, and notification settings.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: reminders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.accentTeal.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_active_rounded, color: AppColors.accentTeal, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reminders[index],
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Reminder for your smart study routine.',
                                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.56)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
