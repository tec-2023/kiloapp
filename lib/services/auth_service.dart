// Asegúrate de tener supabase_flutter en pubspec.yaml
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Registra un usuario con email y contraseña.
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'phoneNumber': phoneNumber,
      },
    );

    final user = response.user;
    if (user != null) {
      // Crear perfil en tabla "profiles"
      await _client.from('profiles').insert({
        'id': user.id,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'photoUrl': '',
        'role': 'user',
      });
      return UserModel(
        id: user.id,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        photoUrl: '',
        role: 'user',
        token: response.session?.accessToken ?? '',
        isEmailVerified: user.confirmedAt != null,
        createdAt: DateTime.parse(user.createdAt),
        lastLogin: user.lastSignInAt != null ? DateTime.parse(user.lastSignInAt!) : DateTime.parse(user.createdAt),
      );
    }
    return null;
  }

  /// Inicia sesión con email y contraseña.
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user != null) {
      // Obtener datos de perfil
      final profileRes = await _client.from('profiles').select().eq('id', user.id).single();
      final profile = profileRes;
      return UserModel(
        id: user.id,
        name: profile['name'] ?? '',
        email: user.email ?? '',
        phoneNumber: profile['phoneNumber'],
        photoUrl: profile['photoUrl'] ?? '',
        role: profile['role'] ?? 'user',
        token: response.session?.accessToken ?? '',
        isEmailVerified: user.confirmedAt != null,
        createdAt: DateTime.parse(user.createdAt),
        lastLogin: user.lastSignInAt != null ? DateTime.parse(user.lastSignInAt!) : DateTime.parse(user.createdAt),
      );
    }
    return null;
  }

  /// Cierra la sesión actual.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Obtiene el usuario actualmente autenticado.
  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user != null) {
      final profileRes = await _client.from('profiles').select().eq('id', user.id).single();
      final profile = profileRes;
      return UserModel(
        id: user.id,
        name: profile['name'] ?? '',
        email: user.email ?? '',
        phoneNumber: profile['phoneNumber'],
        photoUrl: profile['photoUrl'] ?? '',
        role: profile['role'] ?? 'user',
        token: _client.auth.currentSession?.accessToken ?? '',
        isEmailVerified: user.confirmedAt != null,
        createdAt: DateTime.parse(user.createdAt),
        lastLogin: user.lastSignInAt != null ? DateTime.parse(user.lastSignInAt!) : DateTime.parse(user.createdAt),
      );
    }
    return null;
  }

  /// Actualiza el perfil del usuario.
  Future<bool> updateProfile({
    required String id,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
    if (photoUrl != null) updates['photoUrl'] = photoUrl;

    final res = await _client
        .from('profiles')
        .update(updates)
        .eq('id', id);

    return res.error == null;
  }
}