import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var _autovalidateMode = AutovalidateMode.disabled;
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pole e-mail jest wymagane';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Wprowadź poprawny adres e-mail';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pole hasło jest wymagane';
    }
    if (value.length < 8) {
      return 'Hasło musi mieć co najmniej 8 znaków';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Proszę potwierdzić hasło';
    }
    if (value != _passwordController.text) {
      return 'Hasła nie są zgodne';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Stwórz konto',
                textAlign: TextAlign.center,
                style: ShadTheme.of(context).textTheme.h2,
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                controller: _emailController,
                placeholder: const Text('E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                trailing: const SizedBox(
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                controller: _passwordController,
                placeholder: const Text('Hasło'),
                obscureText: _isPasswordObscure,
                validator: _validatePassword,
                trailing: IconButton(
                  iconSize: 20,
                  onPressed: () =>
                      setState(() => _isPasswordObscure = !_isPasswordObscure),
                  icon: Icon(
                    _isPasswordObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                controller: _confirmPasswordController,
                placeholder: const Text('Potwierdź hasło'),
                obscureText: _isConfirmPasswordObscure,
                validator: _validateConfirmPassword,
                trailing: IconButton(
                  iconSize: 20,
                  onPressed: () => setState(() =>
                      _isConfirmPasswordObscure = !_isConfirmPasswordObscure),
                  icon: Icon(
                    _isConfirmPasswordObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ShadButton(
                onPressed: isLoading ? null : _submitForm,
                leading: isLoading
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                width: double.infinity,
                child: isLoading
                    ? const Text('Tworzenie konta...')
                    : const Text('Zarejestruj się'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Masz już konto? Zaloguj się'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
