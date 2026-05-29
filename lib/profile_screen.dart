import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'theme.dart';

class ProfileScreen extends StatefulWidget {
  final int subTabIndex;
  final ValueChanged<int> onSubTabChanged;

  const ProfileScreen({
    Key? key,
    required this.subTabIndex,
    required this.onSubTabChanged,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Editable Profile state variables
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _majorController;

  String _targetGPA = '85%';
  bool _isNightOwl = false;
  double _dailyLimit = 6.0;

  @override
  void initState() {
    super.initState();
    // Initialize with mock profile default details
    _nameController = TextEditingController(text: 'Alex Johnson');
    _emailController = TextEditingController(text: 'alex.johnson@smartstudy.edu');
    _ageController = TextEditingController(text: '21');
    _majorController = TextEditingController(text: 'Computer Science');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  void _saveProfileChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Study preferences and profile objectives updated!'),
        backgroundColor: Color(0xFF0D9488),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final currentName = authProvider.user?.name.isNotEmpty == true ? authProvider.user!.name : 'Alex Johnson';
        final currentEmail = authProvider.user?.email.isNotEmpty == true ? authProvider.user!.email : 'alex.johnson@smartstudy.edu';

        // Update controllers once if backend authentication changes values
        if (authProvider.user != null && _nameController.text == 'Alex Johnson' && currentName != 'Alex Johnson') {
          _nameController.text = currentName;
          _emailController.text = currentEmail;
        }

        final detailsCard = _buildUserInfoCard();
        final preferencesCard = _buildStudyPreferencesCard();

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            title: const Text(
              'Profile & Preferences',
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
                      Expanded(flex: 5, child: detailsCard),
                      const SizedBox(width: 28),
                      Expanded(flex: 5, child: Column(
                        children: [
                          preferencesCard,
                          const SizedBox(height: 24),
                          _buildLogoutCard(authProvider),
                        ],
                      )),
                    ],
                  )
                : Column(
                    children: [
                      detailsCard,
                      const SizedBox(height: 24),
                      preferencesCard,
                      const SizedBox(height: 24),
                      _buildLogoutCard(authProvider),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Avatar with neon cyan glow
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentTeal.withOpacity(0.08),
              border: Border.all(color: AppColors.accentTeal, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentTeal.withOpacity(0.35),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.person_outline_rounded, size: 50, color: AppColors.accentTeal),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Personal Student Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 24),
          _buildInputLabel('Full Name'),
          _buildTextField(_nameController, 'e.g. Alex Johnson', Icons.person_rounded),
          const SizedBox(height: 14),
          _buildInputLabel('Academic Email Address'),
          _buildTextField(_emailController, 'e.g. alex@smartstudy.edu', Icons.email_rounded, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 14),
          _buildInputLabel('Age (Years)'),
          _buildTextField(_ageController, 'e.g. 21', Icons.cake_rounded, keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  Widget _buildStudyPreferencesCard() {
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
            'Study Objectives & Preferences',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'Update targets and objectives generated profiles study routines.',
            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4)),
          ),
          const SizedBox(height: 20),

          // Objective GPA
          const Text(
            'Target GPA / Grade Goal',
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
                value: _targetGPA,
                dropdownColor: AppColors.cardBackground,
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                isExpanded: true,
                onChanged: (val) {
                  if (val != null) setState(() => _targetGPA = val);
                },
                items: ['70%', '75%', '80%', '85%', '90%', '95%'].map((String val) {
                  return DropdownMenuItem<String>(value: val, child: Text(val));
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Major / Track
          const Text(
            'Major / Track Focus',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          _buildTextField(_majorController, 'e.g. Computer Science', Icons.school_rounded),
          const SizedBox(height: 20),

          // Night Owl study pref toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Study Hours Preference',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isNightOwl ? 'Night Owl Mode Active' : 'Morning Owl Mode Active',
                    style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4)),
                  ),
                ],
              ),
              Switch(
                value: _isNightOwl,
                onChanged: (val) => setState(() => _isNightOwl = val),
                activeColor: AppColors.accentTeal,
                activeTrackColor: AppColors.accentTeal.withOpacity(0.3),
                inactiveThumbColor: AppColors.textSecondary,
                inactiveTrackColor: Colors.white.withOpacity(0.05),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Slider for daily max studies
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Study hours limit:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                '${_dailyLimit.toInt()} Hours',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accentTeal),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: AppColors.accentTeal,
              inactiveTrackColor: Colors.white.withOpacity(0.06),
              thumbColor: AppColors.accentTeal,
              overlayColor: AppColors.accentTeal.withOpacity(0.12),
            ),
            child: Slider(
              value: _dailyLimit,
              min: 1.0,
              max: 12.0,
              divisions: 11,
              onChanged: (val) => setState(() => _dailyLimit = val),
            ),
          ),
          const SizedBox(height: 24),

          // Save preferences buttons
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _saveProfileChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentTeal,
                foregroundColor: AppColors.darkBackground,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save Objectives & Preferences', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () async {
            await authProvider.logout();
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            }
          },
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: const Text('Logout Session', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.redAccent,
            side: const BorderSide(color: Colors.redAccent, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
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
          prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
