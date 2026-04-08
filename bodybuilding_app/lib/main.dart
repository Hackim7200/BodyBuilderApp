import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bodybuilding_app/app/app.dart';
import 'package:bodybuilding_app/app/navigation/app_router.dart';
import 'package:bodybuilding_app/feature/auth/data/onboarding_prefs.dart';
import 'package:bodybuilding_app/models/ModelProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await _configureAmplifyOffline();
  final onboardingComplete = await OnboardingPrefs.isComplete();
  final router = createAppRouter(onboardingComplete: onboardingComplete);
  runApp(OverloadTrackerApp(router: router));
}

/// Initialises Amplify DataStore in **offline-only** mode.
///
/// DataStore persists to a local SQLite database. Cloud sync only activates
/// when the API plugin is also added and a real backend config is provided.
/// Pass an empty config to [Amplify.configure] for now; swap in the real
/// `amplify_outputs` / `amplifyconfiguration` when the backend is ready.
Future<void> _configureAmplifyOffline() async {
  try {
    final datastorePlugin = AmplifyDataStore(
      modelProvider: ModelProvider.instance,
    );
    await Amplify.addPlugin(datastorePlugin);
    await Amplify.configure('{}');
    safePrint('Amplify DataStore configured (offline-only)');
  } on AmplifyAlreadyConfiguredException {
    safePrint(
      'Tried to reconfigure Amplify; '
      'this can occur when your app restarts on Android.',
    );
  } on Exception catch (e) {
    safePrint('Error configuring Amplify DataStore: $e');
  }
}
