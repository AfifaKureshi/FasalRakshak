import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'farmer@fasalrakshak.com');
  final _passwordCtrl = TextEditingController(text: 'farmer123');
  bool _isLoading = false;

  void _handleLogin(UserRole role) {
    setState(() => _isLoading = true);
    final appState = Provider.of<AppState>(context, listen: false);
    appState.switchRole(role);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      switch (role) {
        case UserRole.farmer:
          Navigator.of(context).pushReplacementNamed('/farmer-dashboard');
          break;
        case UserRole.expert:
          Navigator.of(context).pushReplacementNamed('/expert-dashboard');
          break;
        case UserRole.officer:
          Navigator.of(context).pushReplacementNamed('/officer-dashboard');
          break;
        case UserRole.admin:
          Navigator.of(context).pushReplacementNamed('/admin-dashboard');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.warmSand,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // App Brand Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.deepPine,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.eco, color: AppColors.softLime, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.tr('app_name'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.charcoal,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        loc.tr('tagline'),
                        style: const TextStyle(fontSize: 11, color: AppColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),

              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sign in to access crop health intelligence & risk advisories',
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              const SizedBox(height: 28),

              // Form fields
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email / Mobile Number',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : () => _handleLogin(UserRole.farmer),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Login'),
              ),
              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account registration available in production rollout.')),
                  );
                },
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 36),

              // Hackathon Demo 1-Click Login Section
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.ivory,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.stone),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.touch_app, size: 18, color: AppColors.deepPine),
                        SizedBox(width: 8),
                        Text(
                          '1-Click Demo Personas (Hackathon Presentation)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepPine,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDemoAccountTile(
                      role: UserRole.farmer,
                      title: 'Demo Farmer (Ramesh Patel)',
                      subtitle: 'Sihor, Bhavnagar • Tomato & Cotton',
                      icon: Icons.agriculture,
                      color: AppColors.healthy,
                    ),
                    const SizedBox(height: 8),
                    _buildDemoAccountTile(
                      role: UserRole.expert,
                      title: 'Demo Agricultural Expert (Dr. Sharma)',
                      subtitle: 'Plant Pathologist • Validations Queue',
                      icon: Icons.biotech,
                      color: AppColors.ai,
                    ),
                    const SizedBox(height: 8),
                    _buildDemoAccountTile(
                      role: UserRole.officer,
                      title: 'Demo Agriculture Officer (K. V. Joshi)',
                      subtitle: 'Regional Intelligence • Hotspots & Trends',
                      icon: Icons.insights,
                      color: AppColors.weather,
                    ),
                    const SizedBox(height: 8),
                    _buildDemoAccountTile(
                      role: UserRole.admin,
                      title: 'Demo Administrator',
                      subtitle: 'System Health • User & Audit Logs',
                      icon: Icons.admin_panel_settings,
                      color: AppColors.charcoal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoAccountTile({
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _handleLogin(role),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.warmSand.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.stone.withOpacity(0.6)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.charcoal),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
