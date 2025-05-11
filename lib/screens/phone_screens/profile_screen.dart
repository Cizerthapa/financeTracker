import 'package:finance_track/providers/login_provider.dart';
import 'package:finance_track/screens/phone_screens/settings_screen.dart';
import 'package:finance_track/screens/phone_screens/transaction_history.dart';
import 'package:finance_track/screens/watch_screens/transaction_history.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';
import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider_profile = Provider.of<ProfileProvider>(context);
    final provider_log = Provider.of<LoginProvider>(context);
    final percentageSpent =
        provider_profile.totalSpent / provider_profile.budget;

    return Scaffold(
      backgroundColor: const Color(0xFF1389B2), // Deep blue full bg
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Account',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),

              // Profile Picture & Name
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(provider_profile.profileImage),
              ),
              const SizedBox(height: 12),
              Text(
                provider_profile.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // Spending Overview Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Spending overview',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '\$${provider_profile.totalSpent.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const TextSpan(
                            text: '   of   ',
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextSpan(
                            text:
                                '\$${provider_profile.budget.toStringAsFixed(0)} Spent',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: percentageSpent,
                      backgroundColor: Colors.white24,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(height: 16),
                    // Legend (simplified)
                    Column(
                      children:
                          provider_profile.expenses.entries.map((entry) {
                            final color = _getColor(entry.key);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    entry.key,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '\$${entry.value}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              _buildCardButton(
                icon: Icons.history,
                text: 'Transaction History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TransactionHistoryPage()),
                  );
                },
              ),
              _buildCardButton(
                icon: Icons.settings,
                text: 'General Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              _buildCardButton(
                icon: Icons.logout,
                text: 'Logout',
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () async {
                  await provider_log.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),


              const SizedBox(height: 12),
              const Text(
                "Let’s track your expenses.",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor(String key) {
    switch (key) {
      case 'Food':
        return Colors.orange;
      case 'Rent':
        return Colors.green;
      case 'Other':
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildCardButton({
    required IconData icon,
    required String text,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(text, style: TextStyle(color: textColor)),
        onTap: onTap,
      ),
    );
  }
}
