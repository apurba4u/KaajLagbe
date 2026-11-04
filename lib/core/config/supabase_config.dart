import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'env_config.dart';

/// Initializes the Supabase client safely with environment variables.
Future<void> initializeSupabase() async {
  await EnvConfig.init();
  if (EnvConfig.hasValidSupabaseCredentials) {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey, // ignore: deprecated_member_use
    );
  }
}

/// Riverpod provider exposing the global Supabase client instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Riverpod provider streaming authentication state changes
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
});

/// Riverpod provider returning the current authenticated user (or null)
final currentUserProvider = Provider<User?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.currentUser;
});
