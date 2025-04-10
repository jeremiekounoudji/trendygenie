import 'dart:developer';

import 'package:get/get.dart';
import 'package:trendygenie/models/user_model.dart';
import 'package:trendygenie/services/supabase_service.dart';

class UserController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  Future<bool> createUser(UserModel user) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await SupabaseService.client
          .from('users')
          .insert(user.toJson())
          .select()
          .single();
      
      if (response != null) {
        currentUser.value = UserModel.fromJson(response);
        return true;
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

  Future<bool> updateUserType(String userId, String userType) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await SupabaseService.client
          .from('users')
          .update({'user_type': userType})
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

  Future<bool> getCurrentUser() async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await SupabaseService.client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      if (response != null) {
        currentUser.value = null;
        currentUser.value = UserModel.fromJson(response);
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

  Future<String> determineInitialRoute() async {
    try {
      final user = await getCurrentUser();
      
      // If no user data in users table
      if (!user) {
        return '/register/type-selection';
      }

      // If user is provider
      if (currentUser.value!.userType == 'provider') {
        // Check if provider has company
        final companyResponse = await SupabaseService.client
            .from('companies')
            .select()
            .eq('owner_id', currentUser.value!.id)
            .single();
        
        if (companyResponse == null) {
          return '/register/company-details';
        }
      }
      
      // Default route for customers or providers with company
      return '/home';
    } catch (e) {
      log('Error determining route: $e');
      return '/register/type-selection';
    }
  }
} 