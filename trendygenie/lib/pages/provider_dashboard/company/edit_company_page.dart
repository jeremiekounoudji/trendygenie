import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/company_controller.dart';
import '../../../utils/globalVariable.dart';
import '../../../models/company_model.dart';

class EditCompanyPage extends StatelessWidget {
  final CompanyModel company;
  
  EditCompanyPage({super.key, required this.company});

  final _formKey = GlobalKey<FormState>();
  final CompanyController controller = Get.find<CompanyController>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _registrationController = TextEditingController();

  void _initializeControllers() {
    _nameController.text = company.name;
    _emailController.text = company.email ?? '';
    _phoneController.text = company.phone ?? '';
    _addressController.text = company.address;
    _registrationController.text = company.registrationNumber;
  }

  Future<void> _pickImage() async {
    try {
      final success = await controller.pickLogo();
      if (success) {
        Get.snackbar(
          'Success',
          'Company logo updated successfully',
          backgroundColor: Colors.green,
          colorText: whiteColor,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update company logo',
          backgroundColor: Colors.red,
          colorText: whiteColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update company logo: $e',
        backgroundColor: Colors.red,
        colorText: whiteColor,
      );
    }
  }

  Future<void> _updateCompany() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      bool success = true;
      
      if (_nameController.text != company.name) {
        success = await controller.updateField('name', _nameController.text);
      }
      
      if (_emailController.text != company.email) {
        success = await controller.updateField('email', _emailController.text);
      }
      
      if (_phoneController.text != company.phone) {
        success = await controller.updateField('phone', _phoneController.text);
      }
      
      if (_addressController.text != company.address) {
        success = await controller.updateField('address', _addressController.text);
      }
      
      if (_registrationController.text != company.registrationNumber) {
        success = await controller.updateField('registration_number', _registrationController.text);
      }

      if (success) {
        Get.back();
        Get.snackbar(
          'Success',
          'Company details updated successfully',
          backgroundColor: Colors.green,
          colorText: whiteColor,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update company details',
          backgroundColor: Colors.red,
          colorText: whiteColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update company details: $e',
        backgroundColor: Colors.red,
        colorText: whiteColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeControllers();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: firstColor,
        title: const CustomText(
          text: 'Edit Company Profile',
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: greyColor,
                        backgroundImage: company.companyLogo != null
                            ? NetworkImage(company.companyLogo!)
                            : null,
                        child: company.companyLogo == null
                            ? Icon(Icons.business, size: 50, color: firstColor)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: firstColor,
                          radius: 20,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _nameController,
                  label: 'Company Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !value.isEmail) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !value.isPhoneNumber) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _registrationController,
                  label: 'Registration Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter registration number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updateCompany,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: firstColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const CustomText(
                          text: 'Save Changes',
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: firstColor.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: firstColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
} 