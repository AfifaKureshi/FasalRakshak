import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/localization/app_localizations.dart';
import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/admin_dashboard.dart';
import 'features/alerts/alerts_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/splash_screen.dart';
import 'features/crop_health/check_crop_health_screen.dart';
import 'features/crop_health/diagnosis_result_screen.dart';
import 'features/expert/expert_dashboard.dart';
import 'features/farmer/farmer_dashboard.dart';
import 'features/farmer/history_screen.dart';
import 'features/farmer/my_farm_screen.dart';
import 'features/monitoring/continuous_monitoring_screen.dart';
import 'features/officer/officer_dashboard.dart';
import 'features/pest_trap/pest_trap_screen.dart';
import 'features/risk/risk_details_screen.dart';
import 'features/weather/weather_screen.dart';
import 'services/sync/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SyncService.instance.init();
  runApp(const FasalRakshakApp());
}

class FasalRakshakApp extends StatelessWidget {
  const FasalRakshakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<SyncService>.value(value: SyncService.instance),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: appState.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('gu'),
              Locale('mr'),
            ],
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/farmer-dashboard': (context) => const FarmerDashboard(),
              '/my-farm': (context) => const MyFarmScreen(),
              '/check-crop-health': (context) => const CheckCropHealthScreen(),
              '/diagnosis-result': (context) => const DiagnosisResultScreen(),
              '/risk-details': (context) => const RiskDetailsScreen(),
              '/pest-trap': (context) => const PestTrapScreen(),
              '/weather': (context) => const WeatherScreen(),
              '/monitoring': (context) => const ContinuousMonitoringScreen(),
              '/alerts': (context) => const AlertsScreen(),
              '/history': (context) => const HistoryScreen(),
              '/expert-dashboard': (context) => const ExpertDashboard(),
              '/officer-dashboard': (context) => const OfficerDashboard(),
              '/admin-dashboard': (context) => const AdminDashboard(),
            },
          );
        },
      ),
    );
  }
}
