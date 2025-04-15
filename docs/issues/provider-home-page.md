# Provider Home Page Implementation

## Overview
This issue covers the implementation of the provider's home page in the TrendyGenie application. This page will serve as the main dashboard for service providers to monitor their business metrics, recent activities, and manage their businesses.

## Requirements

### Dashboard Metrics (Grid Layout)
- Display the following metrics in a grid format:
  - Total number of businesses
  - Total number of sales
  - Total amount generated
  - Total number of clients

### Recent Activities
- Show a list of the 10 most recent orders received
- Each activity should display key information (order details, customer, date, status)

### Business Management
- Display a list of all businesses under the provider's company
- Include a prominent button to create a new business
- Each business in the list should have:
  - Basic information (name, category, status)
  - An edit icon that redirects to the business edit page
  - Clickable rows that navigate to business detail page
- **Note**: Each business can have multiple services associated with it (see related issue: business-services-management.md)

### Business Detail Page
- When a business is clicked, redirect to its detail page showing:
  - Paginated list of orders for that business
  - Paginated list of services offered by this business
  - Ability to sort orders by status
  - Options to accept or reject orders
  - When rejecting an order, a form must appear to specify the reason for rejection
- **Note**: The services management functionality is detailed in the business-services-management.md issue

### Categories Management
- After loading dashboard data, fetch the list of business categories from the database
- Use the existing `CategoryController` (category_controller.dart) to manage categories
- These categories will be used in selection fields when creating or editing businesses

## Design Specifications
- All interfaces should be colorful and aesthetically pleasing
- Use the application's color scheme (firstColor, secondColor, etc.)
- Ensure responsive design for all screen sizes
- Use CustomText widget for text elements
- Use CommonButton for all buttons
- **Loading states must use the shimmer effect from `shimmer.dart`**
  - Implement appropriate skeleton loaders for all data-dependent UI components
  - Use the `LoadingShimmer` widget for consistent loading appearance

## Implementation Notes
- Follow MVC pattern
- Create models for all data structures
- Use GetX for state management
- Implement proper loading states and error handling
- Ensure all UI components follow the established design system
- When implementing business creation/editing forms:
  - Use categories fetched from CategoryController
  - Display them as selectable options
  - Handle category loading states with shimmer effect
- **UI Component Changes**:
  - Rename `ServicesSection` to `BusinessSection` in the provider dashboard
  - Ensure proper navigation between business list and business detail views

## Business Logic Flow
1. Company creates profile on the platform
2. Company can create multiple businesses under their profile
3. Each business can have multiple services
4. Each business can receive and manage orders
5. Provider can accept or reject orders with appropriate feedback

## Data Flow
1. Load dashboard metrics and display with shimmer effect while loading
2. Load recent activities with appropriate loading states
3. Fetch business categories using CategoryController
4. Load list of provider's businesses
5. Make all data available for business creation/editing forms
6. When a business is selected, load both orders and services for that business

## Screens to Implement
1. Provider Dashboard (Home)
2. Business List View
3. Business Detail View with Orders and Services tabs
4. Order Action Interface (Accept/Reject)

## Additional Notes
- Pay special attention to performance when loading orders and services
- Implement efficient pagination for orders and services lists
- Ensure clear visual feedback for all user actions
- Use consistent loading states throughout the application 