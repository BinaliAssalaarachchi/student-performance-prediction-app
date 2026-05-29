import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import '../models/schedule_model.dart';
import '../providers/performance_provider.dart';

class StudyScheduleScreen extends StatefulWidget {
  const StudyScheduleScreen({Key? key}) : super(key: key);

  @override
  State<StudyScheduleScreen> createState() => _StudyScheduleScreenState();
}

class _StudyScheduleScreenState extends State<StudyScheduleScreen> {
  final PageController _pageController = PageController();
  int _currentCalendarDayIndex = 0;

  // Configuration forms
  final TextEditingController _hoursController = TextEditingController(text: '6.0');
  final TextEditingController _newSubjectController = TextEditingController();
  String _selectedDifficulty = 'Medium';
  String _selectedGoal = 'General grade maintenance';

  // Configured local subjects list
  final List<Map<String, String>> _configuredSubjects = [
    {'name': 'Math', 'difficulty': 'Hard'},
    {'name': 'Physics', 'difficulty': 'Medium'},
    {'name': 'History', 'difficulty': 'Easy'},
  ];

  bool _isSavedMode = false;
  String? _scheduleError;

  final List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    // Fetch saved schedule on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PerformanceProvider>(context, listen: false).fetchSavedSchedule();
    });
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _newSubjectController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _addSubject() {
    final name = _newSubjectController.text.trim();
    if (name.isNotEmpty) {
      // Check if duplicate
      if (_configuredSubjects.any((sub) => sub['name']!.toLowerCase() == name.toLowerCase())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subject already added.')),
        );
        return;
      }
      setState(() {
        _configuredSubjects.add({'name': name, 'difficulty': _selectedDifficulty});
        _newSubjectController.clear();
      });
    }
  }

  void _removeSubject(int index) {
    setState(() {
      _configuredSubjects.removeAt(index);
    });
  }

  void _triggerGenerate() {
    if (_configuredSubjects.isEmpty) {
      setState(() {
        _scheduleError = 'Add at least one subject first.';
      });
      return;
    }
    final hoursPerDay = double.tryParse(_hoursController.text) ?? 6.0;
    if (hoursPerDay <= 0) {
      setState(() {
        _scheduleError = 'Enter valid study hours per day.';
      });
      return;
    }

    // Convert difficulty levels into study hour weights for the generation API
    // Hard = 8h base task hours, Medium = 5h base, Easy = 3h base
    final scheduleTasks = _configuredSubjects.map((sub) {
      double baseHours = 5.0;
      if (sub['difficulty'] == 'Hard') baseHours = 8.0;
      if (sub['difficulty'] == 'Easy') baseHours = 3.0;

      return ScheduleTask(
        subject: sub['name']!,
        hours: baseHours,
      );
    }).toList();

    final provider = Provider.of<PerformanceProvider>(context, listen: false);
    provider
        .generateSchedule(
      scheduleTasks,
      goalType: _selectedGoal,
      availableHours: hoursPerDay,
    )
        .then((success) {
      setState(() {
        _isSavedMode = false;
        _scheduleError = success ? null : 'Unable to generate schedule. Make sure Flask server is active.';
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Study schedule generated and synced to DB!'),
            backgroundColor: Color(0xFF0D9488),
          ),
        );
      }
    });
  }

  void _toggleScheduleSource(bool savedMode) {
    final provider = Provider.of<PerformanceProvider>(context, listen: false);
    if (savedMode) {
      provider.fetchSavedSchedule().then((_) {
        setState(() {
          _isSavedMode = true;
        });
      });
    } else {
      setState(() {
        _isSavedMode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final provider = Provider.of<PerformanceProvider>(context);

    // Pick active list of schedules
    final scheduleList = provider.schedules;

    // Group tasks by weekday
    final groupedTasks = <String, List<ScheduleTask>>{};
    for (final dayName in _weekdays) {
      groupedTasks[dayName] = [];
    }
    for (final task in scheduleList) {
      final tDay = task.day ?? 'Monday';
      groupedTasks.putIfAbsent(tDay, () => []).add(task);
    }

    final configurationCard = _buildConfigCard(provider);
    final calendarCard = _buildCalendarPreviewCard(groupedTasks);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'Study Schedule Planner',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 16, 20, isDesktop ? 40 : 110),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: configurationCard),
                  const SizedBox(width: 28),
                  Expanded(flex: 5, child: calendarCard),
                ],
              )
            : Column(
                children: [
                  configurationCard,
                  const SizedBox(height: 24),
                  calendarCard,
                ],
              ),
      ),
    );
  }

  Widget _buildConfigCard(PerformanceProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule Configuration',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'Configure daily available hours and subjects with difficulty weights.',
            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4)),
          ),
          const SizedBox(height: 20),

          // Available Study Hours
          const Text(
            'Available Study Hours / Day',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131B2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: TextFormField(
              controller: _hoursController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'e.g. 6.0',
                prefixIcon: Icon(Icons.access_time_rounded, color: AppColors.textSecondary, size: 18),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Add Subjects Difficulty builder
          const Text(
            'Add Subjects with Difficulty',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2C),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                  ),
                  child: TextFormField(
                    controller: _newSubjectController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Subject (e.g. Math)',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2C),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDifficulty,
                      dropdownColor: AppColors.cardBackground,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      isExpanded: true,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedDifficulty = val);
                      },
                      items: ['Easy', 'Medium', 'Hard'].map((String val) {
                        return DropdownMenuItem<String>(value: val, child: Text(val));
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _addSubject,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accentTeal,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.add_rounded, color: AppColors.darkBackground, size: 24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Configured Subjects List
          if (_configuredSubjects.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _configuredSubjects.asMap().entries.map((entry) {
                final idx = entry.key;
                final sub = entry.value;
                final diff = sub['difficulty']!;
                Color diffColor = Colors.greenAccent;
                if (diff == 'Medium') diffColor = Colors.orangeAccent;
                if (diff == 'Hard') diffColor = Colors.redAccent;

                return Container(
                  padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C101D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${sub['name']} ',
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: diffColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          diff,
                          style: TextStyle(fontSize: 8, color: diffColor, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _removeSubject(idx),
                        child: Icon(Icons.close_rounded, color: Colors.white.withOpacity(0.4), size: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Goal Type Dropdown
          const Text(
            'Objective Goal Type',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGoal,
                dropdownColor: AppColors.cardBackground,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                isExpanded: true,
                onChanged: (val) {
                  if (val != null) setState(() => _selectedGoal = val);
                },
                items: [
                  'Develop capabilities and learning',
                  'General grade maintenance',
                  'High pressure exam preparation',
                ].map((String item) {
                  return DropdownMenuItem<String>(value: item, child: Text(item));
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: provider.isLoading ? null : _triggerGenerate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentTeal,
                foregroundColor: AppColors.darkBackground,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: provider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkBackground),
                      ),
                    )
                  : const Text(
                      'Generate Study Plan',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    ),
            ),
          ),
          if (_scheduleError != null) ...[
            const SizedBox(height: 12),
            Text(
              _scheduleError!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCalendarPreviewCard(Map<String, List<ScheduleTask>> groupedTasks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Schedule Output',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              // Cloud Toggle to load saved schedule from server
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.cloud_download_rounded,
                      color: _isSavedMode ? AppColors.accentTeal : Colors.white24,
                    ),
                    tooltip: 'Load Saved Schedule',
                    onPressed: () => _toggleScheduleSource(!_isSavedMode),
                  ),
                  Text(
                    _isSavedMode ? 'Cloud' : 'Active',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _isSavedMode ? AppColors.accentTeal : Colors.white30,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Swipe left/right to page days. Click tags to skip.',
            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4)),
          ),
          const SizedBox(height: 20),

          // Horizontal weekday select tags
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _weekdays.asMap().entries.map((entry) {
                final idx = entry.key;
                final day = entry.value;
                final isSelected = _currentCalendarDayIndex == idx;

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(day.substring(0, 3)),
                    selected: isSelected,
                    selectedColor: AppColors.accentTeal,
                    backgroundColor: const Color(0xFF0C101D),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      color: isSelected ? AppColors.darkBackground : Colors.white60,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _currentCalendarDayIndex = idx;
                        });
                        _pageController.animateToPage(
                          idx,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Calendar Swipe PageView
          SizedBox(
            height: 230,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _weekdays.length,
              onPageChanged: (idx) {
                setState(() {
                  _currentCalendarDayIndex = idx;
                });
              },
              itemBuilder: (context, idx) {
                final dayName = _weekdays[idx];
                final tasks = groupedTasks[dayName] ?? [];

                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C101D),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.03)),
                      ),
                      child: child,
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dayName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.accentTeal,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Icon(
                            Icons.swipe_rounded,
                            size: 16,
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (tasks.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.nightlight_round_sharp, size: 36, color: Colors.white.withOpacity(0.08)),
                                const SizedBox(height: 10),
                                Text(
                                  'Rest Day. Relax and recharge!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.3),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: tasks.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, tIdx) {
                              final task = tasks[tIdx];
                              return Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: AppColors.accentTeal,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      task.subject,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${task.hours.toStringAsFixed(1)} hours',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              );
                            },
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
    );
  }
}
