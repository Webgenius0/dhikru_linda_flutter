import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/features/home/presentation/Interpretation_scren.dart';

class NewDrimeEnterScreen extends StatefulWidget {
  const NewDrimeEnterScreen({super.key});

  @override
  State<NewDrimeEnterScreen> createState() => _NewDrimeEnterScreenState();
}

class _NewDrimeEnterScreenState extends State<NewDrimeEnterScreen> {
  // ─── Colors ─────────────────────────────────────────────────────────────────
  static const Color _bgColor = Color(0xFF0D0D1A);
  static const Color _cardBg = Color(0xFF131325);
  static const Color _inputBg = Color(0xFF131325);
  static const Color _borderColor = Color(0xFF252545);
  static const Color _accentPurple = Color(0xFF7B6EF6);
  static const Color _white = Colors.white;
  static const Color _subtleText = Color(0xFF8888AA);
  static const Color _labelText = Color(0xFF6666AA);
  static const Color _tagBg = Color(0xFF1A1A35);
  static const Color _tagBorder = Color(0xFF2A2A55);
  static const Color _tagText = Color(0xFF9999CC);
  static const Color _voiceBg = Color(0xFF1E1A45);
  static const Color _dateBg = Color(0xFF131325);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final Set<String> _selectedTags = {'#Water'};

  final List<String> _quickTags = [
    '#Water',
    '#flying',
    '#chased',
    '#falling',
    '#people',
    '#work',
    '#past',
    '#surreal',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable body ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildAppBar(context),
                    const SizedBox(height: 24),
                    _buildDatePicker(),
                    const SizedBox(height: 24),
                    _buildDreamTitleField(),
                    const SizedBox(height: 24),
                    _buildDescribeField(),
                    const SizedBox(height: 26),
                    _buildQuickTags(),
                    const SizedBox(height: 100), // space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ── Floating bottom button ──
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 45),
        child: _buildInterpretButton(),
      ),
    );
  }

  // ─── App Bar ────────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: _white,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Text(
          'New Dream Entry',
          style: TextStyle(
            color: _white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ─── Date Picker ────────────────────────────────────────────────────────────

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2026, 4, 28),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 1)),
          builder: (context, child) => Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: _accentPurple,
                surface: Color(0xFF1A1A30),
              ),
            ),
            child: child!,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _dateBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor, width: 1),
        ),
        child: Row(
          children: const [
            Icon(Icons.calendar_today_rounded, color: _accentPurple, size: 16),
            SizedBox(width: 10),
            Text(
              'Tuesday, April 28, 2026',
              style: TextStyle(
                color: _white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Dream Title ────────────────────────────────────────────────────────────

  Widget _buildDreamTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DREAM TITLE',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: TextField(
            controller: _titleController,
            style: const TextStyle(color: _white, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Give your dream a name...',
              hintStyle: TextStyle(color: _subtleText, fontSize: 14),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Describe Your Dream ────────────────────────────────────────────────────

  Widget _buildDescribeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row with Voice button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'DESCRIBE YOUR DREAM',
              style: TextStyle(
                color: _labelText,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
              ),
            ),
            _buildVoiceButton(),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: TextField(
            controller: _descController,
            maxLines: 6,
            style: const TextStyle(color: _white, fontSize: 14, height: 1.55),
            decoration: const InputDecoration(
              hintText:
                  'I was flying over a vast violet ocean, when suddenly...',
              hintStyle: TextStyle(
                color: _subtleText,
                fontSize: 14,
                height: 1.55,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _voiceBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _accentPurple.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.mic_rounded, color: _accentPurple, size: 14),
          SizedBox(width: 5),
          Text(
            'Voice',
            style: TextStyle(
              color: _accentPurple,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Quick Tags ─────────────────────────────────────────────────────────────

  Widget _buildQuickTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK TAGS',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _quickTags.map((tag) {
            final bool selected = _selectedTags.contains(tag);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selected) {
                    _selectedTags.remove(tag);
                  } else {
                    _selectedTags.add(tag);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? _accentPurple.withOpacity(0.18) : _tagBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? _accentPurple : _tagBorder,
                    width: 1,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: selected ? _accentPurple : _tagText,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── Bottom Interpret Button ─────────────────────────────────────────────────

  Widget _buildInterpretButton() {
    return Container(
      color: _bgColor,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () {
            NavigationService.navigateTo(Routes.interpretationScren);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentPurple,
            foregroundColor: _white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('✦', style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(width: 8),
              Text(
                'Interpret My Dream',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
