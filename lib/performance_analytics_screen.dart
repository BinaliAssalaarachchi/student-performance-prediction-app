import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/performance_model.dart';
import '../providers/performance_provider.dart';
import 'theme.dart';

class PerformanceAnalyticsScreen extends StatefulWidget {
  const PerformanceAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<PerformanceAnalyticsScreen> createState() =>
      _PerformanceAnalyticsScreenState();
}

class _PerformanceAnalyticsScreenState extends State<PerformanceAnalyticsScreen> {
  bool _isSimpleMode = true;

  // Simple Form controllers
  final TextEditingController _studyHoursController = TextEditingController(text: '6.0');
  final TextEditingController _previousGradeController = TextEditingController(text: '80');

  // Extended Form controllers
  String _selectedGender = 'male';
  String _selectedEthnicity = 'group B';
  String _selectedParentalEd = 'some college';
  String _selectedLunch = 'standard';
  String _selectedTestPrep = 'none';

  final TextEditingController _mathController = TextEditingController(text: '85');
  final TextEditingController _readingController = TextEditingController(text: '78');
  final TextEditingController _writingController = TextEditingController(text: '80');

  @override
  void dispose() {
    _studyHoursController.dispose();
    _previousGradeController.dispose();
    _mathController.dispose();
    _readingController.dispose();
    _writingController.dispose();
    super.dispose();
  }

  void _showResultDialog(BuildContext context, PerformancePrediction result) {
    final isPass = result.isPass;
    final alertColor = isPass ? Colors.greenAccent : Colors.redAccent;
    final score = result.predictedScore ?? (isPass ? 82 : 45);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: alertColor.withOpacity(0.2), width: 1.5),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Pulse glowing circle for result visual indicator
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: alertColor.withOpacity(0.08),
                  border: Border.all(color: alertColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: alertColor.withOpacity(0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  isPass ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: alertColor,
                  size: 56,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isPass ? 'PASS PREDICTION' : 'FAIL PREDICTION',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: alertColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Predicted Exam Score: $score%',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Text(
                isPass
                    ? 'The machine learning model projects a successful exam result based on your active study hours.'
                    : 'The model projects an academic warning status. Expand your schedule hours to recover performance.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5), height: 1.45),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: alertColor,
                    foregroundColor: const Color(0xFF090E1A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Confirm & Close',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _runPrediction() async {
    final provider = Provider.of<PerformanceProvider>(context, listen: false);
    
    StudentPerformanceData data;

    if (_isSimpleMode) {
      final double hours = double.tryParse(_studyHoursController.text) ?? 5.0;
      final int grade = int.tryParse(_previousGradeController.text) ?? 80;
      data = StudentPerformanceData(
        gender: 'male',
        ethnicity: 'group B',
        parentalLevelOfEducation: 'some college',
        lunch: 'standard',
        testPreparationCourse: 'none',
        mathScore: grade,
        readingScore: grade,
        writingScore: grade,
        studyHours: hours,
      );
    } else {
      final int mathVal = int.tryParse(_mathController.text) ?? 80;
      final int readVal = int.tryParse(_readingController.text) ?? 80;
      final int writeVal = int.tryParse(_writingController.text) ?? 80;
      data = StudentPerformanceData(
        gender: _selectedGender,
        ethnicity: _selectedEthnicity,
        parentalLevelOfEducation: _selectedParentalEd,
        lunch: _selectedLunch,
        testPreparationCourse: _selectedTestPrep,
        mathScore: mathVal,
        readingScore: readVal,
        writingScore: writeVal,
      );
    }

    final success = await provider.predictPerformance(data);

    if (success && mounted) {
      if (provider.prediction != null) {
        _showResultDialog(context, provider.prediction!);
      }
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Prediction request failed.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final provider = Provider.of<PerformanceProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'AI Performance Prediction',
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
                  Expanded(flex: 5, child: _buildFormCard(provider)),
                  const SizedBox(width: 28),
                  Expanded(flex: 5, child: _buildMetricsInfoCard()),
                ],
              )
            : Column(
                children: [
                  _buildFormCard(provider),
                  const SizedBox(height: 24),
                  _buildMetricsInfoCard(),
                ],
              ),
      ),
    );
  }

  Widget _buildFormCard(PerformanceProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Predictive Analytics Form',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'Select input mode, enter metrics, and run model.',
            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4)),
          ),
          const SizedBox(height: 20),
          // Simple / Extended Selector Switch
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Simple Form')),
                  selected: _isSimpleMode,
                  onSelected: (val) {
                    if (val) setState(() => _isSimpleMode = true);
                  },
                  selectedColor: AppColors.accentTeal,
                  backgroundColor: const Color(0xFF0C101D),
                  labelStyle: TextStyle(
                    color: _isSimpleMode ? AppColors.darkBackground : Colors.white60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Extended Form')),
                  selected: !_isSimpleMode,
                  onSelected: (val) {
                    if (val) setState(() => _isSimpleMode = false);
                  },
                  selectedColor: AppColors.accentTeal,
                  backgroundColor: const Color(0xFF0C101D),
                  labelStyle: TextStyle(
                    color: !_isSimpleMode ? AppColors.darkBackground : Colors.white60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          if (_isSimpleMode) ...[
            // Simple mode forms
            _buildTextField(
              label: 'Available Weekly Study Hours (1.0 to 10.0)',
              controller: _studyHoursController,
              hint: 'e.g. 6.5',
              icon: Icons.access_time_filled_rounded,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Previous Exam Grade Target (0 to 100)',
              controller: _previousGradeController,
              hint: 'e.g. 80',
              icon: Icons.grade_rounded,
              keyboardType: TextInputType.number,
            ),
          ] else ...[
            // Extended mode dropdowns
            _buildLabel('Gender'),
            _buildDropdown(
              value: _selectedGender,
              items: ['male', 'female'],
              onChanged: (val) => setState(() => _selectedGender = val!),
            ),
            const SizedBox(height: 14),
            _buildLabel('Race / Ethnicity group'),
            _buildDropdown(
              value: _selectedEthnicity,
              items: ['group A', 'group B', 'group C', 'group D', 'group E'],
              onChanged: (val) => setState(() => _selectedEthnicity = val!),
            ),
            const SizedBox(height: 14),
            _buildLabel('Parental Level of Education'),
            _buildDropdown(
              value: _selectedParentalEd,
              items: [
                'some college',
                "associate's degree",
                'high school',
                'some high school',
                "bachelor's degree",
                "master's degree"
              ],
              onChanged: (val) => setState(() => _selectedParentalEd = val!),
            ),
            const SizedBox(height: 14),
            _buildLabel('Lunch Program type'),
            _buildDropdown(
              value: _selectedLunch,
              items: ['standard', 'free/reduced'],
              onChanged: (val) => setState(() => _selectedLunch = val!),
            ),
            const SizedBox(height: 14),
            _buildLabel('Test Preparation Course'),
            _buildDropdown(
              value: _selectedTestPrep,
              items: ['none', 'completed'],
              onChanged: (val) => setState(() => _selectedTestPrep = val!),
            ),
            const SizedBox(height: 16),
            const Text(
              'Target Academic Scores',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Math',
                    controller: _mathController,
                    hint: '85',
                    icon: null,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    label: 'Reading',
                    controller: _readingController,
                    hint: '78',
                    icon: null,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    label: 'Writing',
                    controller: _writingController,
                    hint: '80',
                    icon: null,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 28),
          
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: provider.isLoading ? null : _runPrediction,
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
                      'Submit and Run ML Model',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData? icon,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131B2C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null ? Icon(icon, color: AppColors.textSecondary, size: 18) : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.cardBackground,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMetricsInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Forecast Baseline Rules',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.query_stats_rounded,
            'Simple Prediction Form',
            'Evaluates score based solely on weekly study hours limit and previous grade standing parameters.',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.school_rounded,
            'Extended Student Profile Model',
            'Analyzes test preparation course completion, demographics, standard lunch access, and targeted scores across Math, Reading, and Writing.',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.check_circle_rounded,
            'Pass / Fail Outputs',
            'ML output categorizes classification results strictly: Pass threshold (>60% calculated overall average); Fail threshold (<60%).',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accentTeal.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.accentTeal, size: 16),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4), height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
