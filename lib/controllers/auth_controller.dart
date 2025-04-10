import 'dart:developer';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'register_controller.dart';
import 'user_controller.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final isAuthenticated = false.obs;
  final authError = RxString('');

  final registerController = Get.put(RegisterController());
  // Determine and navigate to appropriate route
  final userController = Get.put(UserController());

  Rx<User?> currentUser = Rx<User?>(null);

  // Sign Up
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      registerController.isLoading.value = true;

      // First check if email exists
      // final emailResponse = await SupabaseService.client.auth.signInWithPassword(
      //   email: email,
      //   password: password,
      // );

      // if (emailResponse.user != null) {
      //   _authError.value = 'Email already exists';
      //   return false;
      // }

      // Create new user
      final response = await SupabaseService.client.auth.signUp(
        email: email,
        password: password,

        // data: {
        //   'email': email,
        //   'full_name': fullName,
        //   'phone_number': phoneNumber,
        // },
      );

      if (response.user != null) {
        log('Sign up successful');
        log(response.user!.id);
        currentUser.value = response.user;
        return true;
      }
      authError.value = 'Sign up failed';
      return false;
    } catch (e) {
      log(e.toString());
      if (e is AuthException) {
        authError.value = e.message;
      } else {
        authError.value = e.toString();
      }
      return false;
    } finally {
      registerController.isLoading.value = false;
    }
  }

  // Sign In
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      authError.value = '';

      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        currentUser.value = response.user;

        final initialRoute = await userController.determineInitialRoute();
        Get.offAllNamed(initialRoute);

        return true;
      }

      authError.value = 'Invalid credentials';
      return false;
    } catch (e) {
      authError.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Send Password Reset Email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      registerController.isLoading.value = true;
      authError.value = '';

      await SupabaseService.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-callback/',
      );

      return true;
    } catch (e) {
      authError.value = e.toString();
      return false;
    } finally {
      registerController.isLoading.value = false;
    }
  }

  // Send Email Confirmation
  Future<bool> sendEmailConfirmation() async {
    try {
      registerController.isLoading.value = true;
      authError.value = '';

      final user = SupabaseService.client.auth.currentUser;
      if (user == null) {
        authError.value = 'No user logged in';
        return false;
      }

      await SupabaseService.client.auth.resend(
        type: OtpType.signup,
        email: user.email,
      );

      return true;
    } catch (e) {
      authError.value = e.toString();
      return false;
    } finally {
      registerController.isLoading.value = false;
    }
  }

  // Sign Out
  Future<bool> signOut() async {
    try {
      registerController.isLoading.value = true;
      await SupabaseService.client.auth.signOut();
      registerController.isLoading.value = false;
      return true;
    } catch (e) {
      authError.value = e.toString();
      return false;
    } finally {
      registerController.isLoading.value = false;
    }
  }

  // Check Auth State
  void checkAuth() {
    final user = SupabaseService.client.auth.currentUser;
    registerController.isLoading.value = false;
    isAuthenticated.value = user != null;
  }

  @override
  void onInit() {
    super.onInit();
    checkAuth();
    SupabaseService.client.auth.onAuthStateChange.listen((data) {
      registerController.isLoading.value = false;
      isAuthenticated.value = data.session != null;
    });
  }
}
