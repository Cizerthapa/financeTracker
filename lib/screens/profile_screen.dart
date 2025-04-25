import 'package:finance_track/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final percentageSpent = provider.totalSpent / provider.budget;

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
                backgroundImage: NetworkImage(provider.profileImage),
              ),
              const SizedBox(height: 12),
              Text(
                provider.name,
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
                            text: '\$${provider.totalSpent.toStringAsFixed(0)}',
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
                                '\$${provider.budget.toStringAsFixed(0)} Spent',
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
                          provider.expenses.entries.map((entry) {
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
                onTap: () {},
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
                onTap: provider.logout,
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
