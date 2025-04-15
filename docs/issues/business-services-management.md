# Business Services Management

## Overview
This issue covers the implementation of the service management functionality for businesses in the TrendyGenie application. Providers will be able to create, edit, and manage services under their specific businesses. Each business will have its own set of services that can be managed independently.

## Requirements

### Service Listing
- On the business detail page, display a paginated list of services belonging to that specific business
- Each service should display:
  - Service name and description
  - Price and other key details
  - Current status (pending, approved, etc.)
  - Creation/modification date
- Implement proper pagination with loading states for better performance

### Service Management
- Provide CRUD operations for services:
  - **Create**: Add new services to a business
  - **Read**: View service details
  - **Update**: Edit existing services
  - **Delete**: Mark services as deleted (status change)
- All new services should have a default status of "pending"
- When a service is edited, its status should revert to "pending"
- Service deletion should not physically remove the record from the database but update its status accordingly

### Status Workflow
- Implement the following service statuses:
  - Pending (default for new or edited services)
  - Approved (admin approval required)
  - Rejected (with reason)
  - Deleted (soft delete)
- Only admin users can approve services
- Status changes should be clearly reflected in the UI

## Controller Modifications
- Update the existing `ServicesController` (services_controller.dart) to:
  - Link services to both business and company
  - Filter services by business ID
  - Include status management functionality
  - Support pagination for service listing

## UI Component Changes
- Rename `ServicesSection` to `BusinessSection`
- Update business detail page to include:
  - Service listing component
  - Service management buttons
  - Status indicators for each service

## Design Specifications
- All interfaces should be colorful and aesthetically pleasing
- Use the application's color scheme (firstColor, secondColor, etc.)
- Ensure responsive design for all screen sizes
- Use CustomText widget for text elements
- Use CommonButton for all buttons
- Loading states must use the shimmer effect from `shimmer.dart`
  - Implement appropriate skeleton loaders for all data-dependent UI components
  - Use the `LoadingShimmer` widget for consistent loading appearance

## Implementation Notes
- Follow MVC pattern
- Update existing models or create new ones as needed
- Use GetX for state management
- Implement proper loading states and error handling
- Ensure all UI components follow the established design system
- When implementing service forms:
  - Include validation for required fields
  - Handle image uploads if applicable
  - Display appropriate feedback on status changes

## Data Flow
1. Load business details
2. Fetch services for the current business with pagination
3. Display services with appropriate status indicators
4. Allow CRUD operations with proper validation
5. Update service status based on actions

## Additional Notes
- When a service status changes to "pending", notify the admin
- Implement efficient pagination for the service list
- Ensure clear visual feedback for all user actions
- Use consistent loading states throughout the application
- Consider adding filters to allow sorting services by status, date, etc. 