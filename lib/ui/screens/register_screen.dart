import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../utils/constants.dart';
import '../../providers/auth_provider.dart';
import '../../main.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final authNotifier = ref.read(authStateProvider.notifier);
    final success = await authNotifier.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      setState(() => _error = 'Error al registrarse');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.btnRegister),
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
                controller: _nameController,
                decoration: InputDecoration(labelText: AppStrings.lblName),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Teléfono (opcional)'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),
              SignInButton(
                Buttons.Google,
                text: 'Registrarse con Google',
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
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : const Text(AppStrings.btnRegister),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}