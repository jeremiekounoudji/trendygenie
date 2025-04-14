import 'dart:developer';

import 'package:get/get.dart';
import 'package:trendygenie/models/user_model.dart';
import 'package:trendygenie/models/company_model.dart';
import 'package:trendygenie/models/enums.dart' hide CompanyStatus;
import 'package:trendygenie/pages/authentication/register/register_step_four.dart';
import 'package:trendygenie/pages/home/home_page.dart';
import 'package:trendygenie/services/supabase_service.dart';

import '../pages/authentication/certification_pending_page.dart';
import '../pages/authentication/certification_rejected_page.dart';
import '../pages/authentication/register/register_step_three.dart';
import '../pages/provider_dashboard/provider_dashboard_screen.dart';
import 'register_controller.dart';
import 'company_controller.dart';
import '../pages/authentication/certification_suspended_page.dart';

class UserController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final Rx<UserPreferences?> userPreferences = Rx<UserPreferences?>(null);
  final Rx<UserLocation?> userLocation = Rx<UserLocation?>(null);

  final registerController = Get.put(RegisterController());

  Future<bool> createUser(UserModel user) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // First check if user already exists
      final existingUser = await SupabaseService.client
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();
          
      if (existingUser != null) {
        // User already exists, update instead of insert
        final response = await SupabaseService.client
            .from('users')
            .update(user.toJson())
            .eq('id', user.id)
            .select()
            .single();
            
        if (response != null) {
          currentUser.value = UserModel.fromJson(response);
          
          // Make sure preferences exist - wait for completion and check for errors
          final prefsSuccess = await _ensureUserPreferences(user);
          if (!prefsSuccess) {
            errorMessage.value = 'Failed to create user preferences';
            return false;
          }
          
          // Make sure location exists if provided
          if (user.location != null) {
            final locationSuccess = await _ensureUserLocation(user);
            if (!locationSuccess) {
              errorMessage.value = 'Failed to create user location';
              return false;
            }
          }
          
          return true;
        }
      } else {
        // User doesn't exist, create new user
        final response = await SupabaseService.client
            .from('users')
            .insert(user.toJson())
          .select()
          .single();
      
      if (response != null) {
        currentUser.value = UserModel.fromJson(response);
          
          // Create default preferences if we have them - wait for completion and check for errors
          final prefsSuccess = await _ensureUserPreferences(user);
          if (!prefsSuccess) {
            errorMessage.value = 'Failed to create user preferences';
            return false;
          }
          
          // Create location if we have it
          if (user.location != null) {
            final locationSuccess = await _ensureUserLocation(user);
            if (!locationSuccess) {
              errorMessage.value = 'Failed to create user location';
              return false;
            }
          }
          
        return true;
        }
      }
      
      errorMessage.value = 'Failed to create user';
      return false;
    } catch (e) {
      log(e.toString());
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to ensure user preferences exist
  Future<bool> _ensureUserPreferences(UserModel user) async {
    try {
      // Check if preferences already exist
      final existingPrefs = await SupabaseService.client
          .from('user_preferences')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();
          
      if (existingPrefs != null) {
        // Preferences exist, update if needed
        if (user.preferences != null) {
          final preferences = user.preferences!;
          preferences.userId = user.id;
          
          await SupabaseService.client
              .from('user_preferences')
              .update(preferences.toJson())
              .eq('user_id', user.id);
              
          userPreferences.value = preferences;
        } else {
          userPreferences.value = UserPreferences.fromJson(existingPrefs);
        }
      } else {
        // Create new preferences
        if (user.preferences != null) {
          final preferences = user.preferences!;
          preferences.userId = user.id;
          
          await SupabaseService.client
              .from('user_preferences')
              .insert({...preferences.toJson(), 'user_id': user.id});
              
          userPreferences.value = preferences;
        } else {
          // Create default preferences using the model
          final defaultPreferences = UserPreferences(
            userId: user.id,
            language: 'en',
            currency: 'USD',
            pushNotifications: true,
            emailNotifications: true,
            smsNotifications: true,
          );
          
          await SupabaseService.client
              .from('user_preferences')
              .insert({...defaultPreferences.toJson(), 'user_id': user.id});
              
          userPreferences.value = defaultPreferences;
        }
      }
      return true;
    } catch (e) {
      log('Error ensuring user preferences: $e');
      return false;
    }
  }
  
  // Helper method to ensure user location exists
  Future<bool> _ensureUserLocation(UserModel user) async {
    if (user.location == null) return true;
    
    try {
      // Check if location already exists
      final existingLocation = await SupabaseService.client
          .from('user_locations')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();
          
      final location = user.location!;
      location.userId = user.id;
      
      if (existingLocation != null) {
        // Location exists, update
        await SupabaseService.client
            .from('user_locations')
            .update(location.toJson())
            .eq('user_id', user.id);
      } else {
        // Create new location
        await SupabaseService.client
            .from('user_locations')
            .insert({...location.toJson(), 'user_id': user.id});
      }
      
      userLocation.value = location;
      return true;
    } catch (e) {
      log('Error ensuring user location: $e');
      return false;
    }
  }

  Future<bool> updateUserType(String userId, UserType userType) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await SupabaseService.client
          .from('users')
          .update({'user_type': userType.name})
          .eq('id', userId)
          .select()
          .single();
      
      if (response != null) {
        currentUser.value = UserModel.fromJson(response);
        return true;
      }
      
      errorMessage.value = 'Failed to update user type';
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> determineInitialRoute() async {
    try {
      log('Determining initial route...');
      final user = await getCurrentUser();
      
      // If no user data in users table
      if (!user) {
        log('No user data found, redirecting to type selection');
        return Get.offAll(() => RegisterStepThree(),transition: Transition.leftToRightWithFade);
      }

      // If user is provider
      if (currentUser.value?.userType == UserType.provider.name) {
        log('User is a provider, checking company status');
        // set the user type to provider
        registerController.accountType.value = 'provider';
        try {
          final companyController = Get.find<CompanyController>();
          final companies = await companyController.getCompanyByOwner(currentUser.value!.id);
          
          log('Companies fetched: ${companies.length}');
          
          if (companies.isEmpty) {
            log('Provider has no company, redirecting to company details');
            return Get.offAll(() => const RegisterStepFour(),transition: Transition.leftToRightWithFade);
          }
          
          // Get the first company (most recent, due to ordering in the query)
          final company = companies.first;
          
          // Check company status
          try {
            final status = company.status;
            
            switch (status) {
              case CompanyStatus.pending:
                return Get.offAll(() => const CertificationPendingPage(),transition: Transition.leftToRightWithFade);
              case CompanyStatus.approved:
                return Get.offAll(() => ProviderDashboardScreen(),transition: Transition.leftToRightWithFade);
              case CompanyStatus.rejected:
                return Get.offAll(() => CertificationRejectedPage(),transition: Transition.leftToRightWithFade);
              case CompanyStatus.suspended:
                return Get.offAll(() => CertificationSuspendedPage(),transition: Transition.leftToRightWithFade);
              default:
                return Get.offAll(() => const CertificationPendingPage(),transition: Transition.leftToRightWithFade);
            }
          } catch (statusError) {
            log('Error processing company status: $statusError');
            return Get.offAll(() => const CertificationPendingPage(),transition: Transition.leftToRightWithFade);
          }
        } catch (e) {
          log('Error checking company: $e');
          return Get.offAll(() => const RegisterStepFour(),transition: Transition.leftToRightWithFade);
        }
      }
      
      // Default route for customers
      log('User is a customer, redirecting to customer home');
      return Get.offAll(() => const HomePage(),transition: Transition.leftToRightWithFade);
    } catch (e) {
      log('Error determining route: $e');
      return Get.offAll(() => RegisterStepThree(),transition: Transition.leftToRightWithFade);
    }
  }

  // Improved version of getCurrentUser with better error handling for location/preferences
  Future<bool> getCurrentUser() async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) return false;

      // Get user data
      final response = await SupabaseService.client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      
      if (response == null) {
        log('No user found with ID: $userId');
        return false;
      }
      
      currentUser.value = UserModel.fromJson(response);
      
      // Get user preferences
      try {
        final preferencesResponse = await SupabaseService.client
            .from('user_preferences')
            .select()
            .eq('user_id', userId)
            .maybeSingle();
            
        if (preferencesResponse != null) {
          userPreferences.value = UserPreferences.fromJson(preferencesResponse);
        } else {
          log('No preferences found for user, using defaults');
          userPreferences.value = UserPreferences(userId: userId);
        }
      } catch (e) {
        log('Error fetching user preferences: $e');
        userPreferences.value = UserPreferences(userId: userId);
      }
      
      // Get user location
      try {
        final locationResponse = await SupabaseService.client
            .from('user_locations')
            .select()
            .eq('user_id', userId)
            .maybeSingle();
            
        if (locationResponse != null) {
          userLocation.value = UserLocation.fromJson(locationResponse);
        } else {
          log('No location found for user, using null');
          userLocation.value = null;
        }
      } catch (e) {
        log('Error fetching user location: $e');
        userLocation.value = null;
      }
      
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      log('Error in getCurrentUser: $e');
      return false;
    }
  }

  Future<bool> updateUserPreferences(UserPreferences preferences) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) return false;
      
      preferences.userId = userId;
      
      // Check if preferences exist
      try {
        await SupabaseService.client
            .from('user_preferences')
            .select()
            .eq('user_id', userId)
            .single();
            
        // Update existing preferences
        await SupabaseService.client
            .from('user_preferences')
            .update(preferences.toJson())
            .eq('user_id', userId);
      } catch (e) {
        // Create new preferences
        await SupabaseService.client
            .from('user_preferences')
            .insert(preferences.toJson());
      }
      
      userPreferences.value = preferences;
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<bool> updateUserLocation(UserLocation location) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) return false;
      
      location.userId = userId;
      
      // Check if location exists
      try {
        await SupabaseService.client
            .from('user_locations')
            .select()
            .eq('user_id', userId)
            .single();
            
        // Update existing location
        await SupabaseService.client
            .from('user_locations')
            .update(location.toJson())
            .eq('user_id', userId);
      } catch (e) {
        // Create new location
        await SupabaseService.client
            .from('user_locations')
            .insert(location.toJson());
      }
      
      userLocation.value = location;
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
} 