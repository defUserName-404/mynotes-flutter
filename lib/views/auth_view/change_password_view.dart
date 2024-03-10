import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_validation.dart';
import 'package:mynotes/views/custom_widgets/button.dart';

import '../custom_widgets/icon.dart';
import '../custom_widgets/textfield.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  late bool _isPasswordVisible;
  late bool _isNewPasswordVisible;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _isPasswordVisible = false;
    _isNewPasswordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 10,
      title: Text(
        'Change Password',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _oldPasswordController,
                hintText: 'Enter your password here',
                labelText: 'Old Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                    icon: AppIcon(
                        icon: _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    }),
                validator: (password) =>
                    AppAuthenticationValidator.validatePassword(password!),
                obscureText: !_isPasswordVisible,
                enableSuggestions: false,
                autoCorrect: false,
              ),
              const SizedBox(height: 4.0),
              AppTextField(
                controller: _newPasswordController,
                hintText: 'Enter your new password here',
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                    icon: AppIcon(
                        icon: _isNewPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    }),
                validator: (password) =>
                    AppAuthenticationValidator.validatePassword(password!),
                obscureText: !_isNewPasswordVisible,
                enableSuggestions: false,
                autoCorrect: false,
              ),
              const SizedBox(height: 4.0),
              AppTextField(
                controller: _confirmPasswordController,
                hintText: 'Enter your password again',
                labelText: 'Confirm New Password',
                validator: (retypedPassword) =>
                    AppAuthenticationValidator.validateConfirmPassword(
                        _newPasswordController.text, retypedPassword!),
                prefixIcon: const Icon(Icons.lock),
                obscureText: true,
                enableSuggestions: false,
                autoCorrect: false,
              ),
              const SizedBox(height: 16.0),
              AppButton(
                  text: 'Submit Password Change',
                  icon: const Icon(Icons.outbond_rounded),
                  onPressed: _handleSubmit)
            ],
          ),
        ),
      ),
    );
  }
}
