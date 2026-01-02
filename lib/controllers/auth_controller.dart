import 'dart:developer';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pages/authentication/forgot_password/forgot_password_page.dart';
import '../pages/authentication/login/login_page.dart';
import '../services/supabase_service.dart';
import 'register_controller.dart';
import 'user_controller.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final isAuthenticated = false.obs;
  final authError = RxString('');
  
  // OTP verification state
  final isOtpSent = false.obs;
  final otpEmail = ''.obs;
  final canResendOtp = true.obs;
  final resendCountdown = 0.obs;

  final registerController = Get.put(RegisterController());
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
        data: {
          'full_name': fullName,
          'phone_number': phoneNumber ?? '',
          // Don't include fields that don't exist in the schema
        },
      );

      if (response.user != null) {
        log('Sign up successful');
        log(response.user!.id);
        currentUser.value = response.user;
        
        // Store email for OTP verification
        otpEmail.value = email;
        isOtpSent.value = true;
        
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
      
      log('Attempting to sign in user: $email');

      // Step 1: Authenticate user
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        log('Authentication failed: Invalid credentials');
        authError.value = 'Invalid email or password';
        return false;
      }
      
      // Step 2: Store authenticated user
      currentUser.value = response.user;
      log('User authenticated successfully: ${currentUser.value?.id}');
      
      try {
        // Step 3: Determine user type and appropriate route
         await userController.determineInitialRoute();
        return true;
      } catch (routeError) {
        log('Error determining route: $routeError');
        authError.value = 'Error loading user profile: $routeError';
        
        // Even if route determination fails, the user is still logged in
        Get.offAllNamed('/home');
        return true;
      }
    } catch (e) {
      log('Login error: $e');
      if (e is AuthException) {
        authError.value = e.message;
      } else {
        authError.value = 'Login failed: $e';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // // Helper method to navigate based on route string
  // void _navigateToInitialRoute(String route) {
  //   switch (route) {
  //     case '/register/type-selection':
  //       Get.offAll(() => TypeSelectionPage());
  //       break;
  //     case '/register/company-details':
  //       Get.offAll(() => CompanyDetailsPage());
  //       break;
  //     case '/certification-pending':
  //       Get.offAll(() => CertificationPendingPage());
  //       break;
  //     case '/certification-rejected':
  //       Get.offAll(() => CertificationRejectedPage());
  //       break;
  //     case '/provider/dashboard':
  //       Get.offAll(() => ProviderDashboardPage());
  //       break;
  //     case '/customer/home':
  //       Get.offAll(() => CustomerHomePage());
  //       break;
  //     case '/home':
  //     default:
  //       Get.offAll(() => HomePage());
  //       break;
  //   }
  // }

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

  // Verify OTP code
  Future<bool> verifyOtp(String otpCode) async {
    try {
      isLoading.value = true;
      authError.value = '';
      
      if (otpEmail.value.isEmpty) {
        authError.value = 'Email not found. Please register again.';
        return false;
      }

      log('Verifying OTP for email: ${otpEmail.value}');
      
      final response = await SupabaseService.client.auth.verifyOTP(
        email: otpEmail.value,
        token: otpCode,
        type: OtpType.signup,
      );

      if (response.user != null) {
        log('OTP verification successful');
        currentUser.value = response.user;
        isAuthenticated.value = true;
        isOtpSent.value = false;
        return true;
      }
      
      authError.value = 'Invalid verification code';
      return false;
    } catch (e) {
      log('OTP verification error: $e');
      if (e is AuthException) {
        authError.value = e.message;
      } else {
        authError.value = 'Verification failed. Please try again.';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP code
  Future<bool> resendOtp() async {
    try {
      isLoading.value = true;
      authError.value = '';
      
      if (otpEmail.value.isEmpty) {
        authError.value = 'Email not found. Please register again.';
        return false;
      }

      log('Resending OTP to: ${otpEmail.value}');
      
      await SupabaseService.client.auth.resend(
        type: OtpType.signup,
        email: otpEmail.value,
      );

      log('OTP resent successfully');
      canResendOtp.value = false;
      
      return true;
    } catch (e) {
      log('Resend OTP error: $e');
      if (e is AuthException) {
        authError.value = e.message;
      } else {
        authError.value = 'Failed to resend code. Please try again.';
      }
      return false;
    } finally {
      isLoading.value = false;
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

  // Logout method that handles both sign out and navigation
  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      // Clear all controller data before logout
      try {
        // Clear register controller if it exists
        if (Get.isRegistered<RegisterController>()) {
          final regController = Get.find<RegisterController>();
          regController.firstNameController.clear();
          regController.lastNameController.clear();
          regController.emailController.clear();
          regController.passwordController.clear();
          regController.confirmPasswordController.clear();
          regController.phoneController.clear();
          regController.dateOfBirthController.clear();
          regController.companyNameController.clear();
          regController.companyAddressController.clear();
          regController.companyRegNumberController.clear();
          regController.shippingAddressController.clear();
        }
        
        // Clear user controller if it exists
        if (Get.isRegistered<UserController>()) {
          final userCtrl = Get.find<UserController>();
          userCtrl.currentUser.value = null;
          userCtrl.userPreferences.value = null;
          userCtrl.userLocation.value = null;
        }
      } catch (e) {
        log('Error clearing controllers: $e');
      }
      
      final success = await signOut();
      if (success) {
        // Clear current user data
        currentUser.value = null;
        isAuthenticated.value = false;
        
        // Navigate to login page
        Get.offAll(() => LoginPage());
      }
    } catch (e) {
      log('Logout error: $e');
      authError.value = 'Logout failed: $e';
    } finally {
      isLoading.value = false;
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
    log('Initializing AuthController...');
    
    // Check initial auth state
    final currentSession = SupabaseService.client.auth.currentSession;
    final user = SupabaseService.client.auth.currentUser;
    
    isAuthenticated.value = user != null && currentSession != null;
    currentUser.value = user;
    
    if (isAuthenticated.value) {
      log('User is already authenticated: ${user?.id}');
      // Use Future.delayed to ensure the widget tree is built before navigation
      Future.delayed(const Duration(milliseconds: 100), () async {
        isLoading.value = true;
        try {
           await userController.determineInitialRoute();
        } catch (e) {
          log('Error determining route for authenticated user: $e');
          Get.offAllNamed('/home');
        } finally {
          isLoading.value = false;
        }
      });
    } else {
      log('No authenticated user found');
    }
    
    // Listen for auth state changes
    SupabaseService.client.auth.onAuthStateChange.listen((data) {
      log('Auth state changed: ${data.event}');
      final AuthChangeEvent event = data.event;
      
      // Update authentication status
      isAuthenticated.value = data.session != null;
      
      // Handle different auth events
      switch (event) {
        case AuthChangeEvent.signedIn:
          log('User signed in: ${data.session?.user.id}');
          currentUser.value = data.session?.user;
          break;
        case AuthChangeEvent.signedOut:
          log('User signed out');
          currentUser.value = null;
          Get.offAll(() => LoginPage());
          break;
        case AuthChangeEvent.userUpdated:
          log('User updated: ${data.session?.user.id}');
          currentUser.value = data.session?.user;
          break;
        case AuthChangeEvent.passwordRecovery:
          log('Password recovery initiated');
          Get.offAll(() => ForgotPasswordPage(),transition: Transition.leftToRightWithFade);
          break;
        default:
          log('Unhandled auth event: $event');
      }
    });
  }
}
