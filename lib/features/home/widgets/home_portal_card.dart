import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';

const Color _cardBg = Color(0xFF161628);
const Color _accentGreen = Color(0xFF4ECFB5);
const Color _white = Colors.white;
const Color _subtleText = Color(0xFF8888AA);
const Color _buttonPurple = Color(0xFF7B6EF6);

class HomePortalCard extends StatelessWidget {
  const HomePortalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF22223A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LAST NIGHT\'S PORTAL',
            style: TextStyle(
              color: _accentGreen,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'What shadows\ndanced in your\nmind?',
            style: TextStyle(
              color: _white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 28),
          const HomeLogButton(),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              '"The dream is a little hidden door..."',
              style: TextStyle(
                color: _subtleText,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeLogButton extends StatelessWidget {
  const HomeLogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          NavigationService.navigateTo(Routes.newDrimeEnterScreen);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonPurple,
          foregroundColor: _white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.notes_rounded, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Log & Interpret',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
