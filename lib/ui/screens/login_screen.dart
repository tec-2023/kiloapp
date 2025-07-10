import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../utils/constants.dart';
import '../../providers/auth_provider.dart';
import '../../main.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final authNotifier = ref.read(authStateProvider.notifier);
    final success = await authNotifier.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      setState(() => _error = 'Credenciales inválidas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.btnLogin),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: AppStrings.lblEmail),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu correo';
                  }
                  if (!value.contains('@')) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: AppStrings.lblPassword),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu contraseña';
                  }
                  if (value.length < 6) {
                    return 'Mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : const Text(AppStrings.btnLogin),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Routes.register);
                },
                child: const Text(AppStrings.btnRegister),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(authStateProvider.notifier).signInAsGuest();
                  Navigator.of(context).pushReplacementNamed(Routes.home);
                },
                child: const Text('Ingresar como invitado'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              SignInButton(
                Buttons.Google,
                text: 'Continuar con Google',
                onPressed: () async {
                  setState(() => _isLoading = true);
                  try {
                    await Supabase.instance.client.auth.signInWithOAuth(
                      OAuthProvider.google,
                    );
                  } catch (e) {
                    setState(() => _error = 'Error con Google: $e');
                  }
                  setState(() => _isLoading = false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}