# Business Management Implementation

## Overview
This issue covers the implementation of complete business management functionality in the TrendyGenie application. This system will be separate from the current company implementation but linked to companies, requiring a new database table and corresponding functionality to manage businesses properly.

## Requirements

### Database Structure
- Create a new 'businesses' table with the following fields:
  - id (uuid, primary key)
  - name (text)
  - description (text)
  - logo_url (text)
  - address (text)
  - contact_email (text)
  - contact_phone (text)
  - company_id (uuid, foreign key to companies) - Link to company
  - category_id (uuid, foreign key to categories)
  - subcategory_id (uuid, foreign key to subcategories)
  - status (text) - Can be 'pending', 'active', 'rejected', 'suspended', 'removed', or 'deleted'
  - created_at (timestamp)
  - updated_at (timestamp)

### Business Controller
Implement a new `BusinessController` with the following functions:
- `fetchBusinesses()` - Get all businesses for the current company
- `fetchBusinessById(id)` - Get a specific business by ID
- `createBusiness(data)` - Create a new business (default status: 'pending')
- `updateBusiness(id, data)` - Update business details
- `deleteBusiness(id)` - Delete a business (sets status to 'deleted')
- `changeBusinessStatus(id, status)` - Change business status to one of:
  - 'pending' (default for new businesses)
  - 'active' (approved business)
  - 'rejected' (rejected by admin)
  - 'suspended' (temporarily disabled)
  - 'removed' (soft delete by owner)
  - 'deleted' (hard delete, only for admins)
- `fetchBusinessesByStatus(status)` - Get businesses by status
- `fetchBusinessesByCategory(categoryId)` - Get businesses by category
- `fetchBusinessesByCompany(companyId)` - Get all businesses for a specific company

### Business Management UI
- **Business Listing**:
  - Display all businesses owned by the current company
  - Show business name, category, status, and creation date
  - Filter businesses by status
  - Include options to edit, delete, and view details
  - Empty state with call-to-action for creating first business
  
- **Business Creation**:
  - Form with fields for all necessary business information
  - Category/subcategory selection using data from CategoryController
  - Logo upload functionality
  - Form validation for required fields
  - Business will be created with 'pending' status by default
  
- **Business Editing**:
  - Pre-populated form with current business data
  - Ability to update all fields
  - Status controls based on user permissions
  
- **Business Detail View**:
  - Business profile information
  - Prominently display current status
  - Analytics section (orders, revenue, etc.)
  - Services list associated with this business
  - Recent orders for this business

### Business Section in Provider Dashboard
- Update the provider dashboard to display businesses linked to the user's company
- Show business metrics (total businesses by status: active/pending/rejected/suspended)
- Display a list of recent businesses created
- Include a prominent button to create a new business
- Show status indicators with appropriate colors for each status

## Design Specifications
- All interfaces should be colorful and aesthetically pleasing
- Use the application's color scheme (firstColor, secondColor, etc.)
- Use distinct colors to represent different business statuses:
  - Pending: Yellow
  - Active: Green
  - Rejected: Red
  - Suspended: Orange
  - Removed: Gray
  - Deleted: Dark Gray
- Ensure responsive design for all screen sizes
- Use CustomText widget for text elements
- Use CommonButton for all buttons
- **Loading states must use the shimmer effect from `shimmer.dart`**
  - Implement appropriate skeleton loaders for all data-dependent UI components
  - Use the `LoadingShimmer` widget for consistent loading appearance

## Implementation Notes
- Follow MVC pattern strictly
- Create a new `BusinessModel` class to represent business data
- Use GetX for state management
- Implement proper loading states and error handling
- Ensure all UI components follow the established design system
- When implementing business creation/editing forms:
  - Use categories fetched from CategoryController
  - Display them as selectable options
  - Handle category loading states with shimmer effect
- Business status updates should trigger appropriate notifications and UI updates

## Business Logic Flow
1. Company is created in the system
2. Company can create multiple businesses, each starting with 'pending' status
3. Each business belongs to a specific category and subcategory
4. Admin/system can approve businesses, changing status to 'active'
5. Businesses can be suspended, rejected, removed, or deleted based on rules
6. Each business can have multiple services (only when status is 'active')
7. Each business can receive and manage orders independently

## Data Flow
1. Company initiates business creation
2. Categories and subcategories are loaded from CategoryController
3. Business data is submitted and stored with 'pending' status
4. Business list is updated to reflect changes
5. Status changes trigger appropriate UI updates
6. When selected, business details are loaded including associated services and orders

## Screens to Implement
1. Business List View with status filters
2. Business Creation Form
3. Business Edit Form with status controls
4. Business Detail View with status indicator

## Additional Notes
- Ensure proper relationship between companies and businesses in the codebase
- Status changes may require different permissions based on user role
- Consider implementing a review process for businesses with 'pending' status
- Follow existing Flutter coding guidelines and GetX patterns
- Implement comprehensive error handling for all database operations