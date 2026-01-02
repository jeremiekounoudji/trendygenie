# Implementation Plan: TrendyGenie Admin Panel

## Overview

This implementation plan breaks down the TrendyGenie Admin Panel into discrete, incremental tasks. Each task builds on previous work, ensuring no orphaned code. The admin panel will be created in the `admin/` directory at the project root, using React + Vite + TypeScript with HeroUI and TailwindCSS.

## Tasks

- [ ] 1. Project Setup and Configuration
  - [x] 1.1 Initialize Vite project with React and TypeScript template in `admin/` directory
    - Run `npm create vite@latest admin -- --template react-ts`
    - Configure `vite.config.ts` with path aliases
    - _Requirements: 10.1_

  - [x] 1.2 Install and configure dependencies
    - Install HeroUI: `@heroui/react`, `framer-motion`
    - Install TailwindCSS and configure with HeroUI plugin
    - Install Supabase client: `@supabase/supabase-js`
    - Install fast-check for property testing
    - Install additional utilities: `react-router-dom`
    - _Requirements: 10.1, 12.1, 12.2_

  - [x] 1.3 Configure TailwindCSS with brand colors and HeroUI toast
    - Create `tailwind.config.js` with primary color `#16C79A` palette
    - Create `src/index.css` with Tailwind directives
    - Configure HeroUI theme provider with ToastProvider
    - _Requirements: 10.1, 12.1, 12.2_

  - [x] 1.4 Set up environment configuration
    - Create `.env.example` with VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY
    - Create `src/services/supabase.ts` with client initialization
    - _Requirements: 1.2, 1.6_

- [x] 2. TypeScript Types and Constants
  - [x] 2.1 Create type definitions
    - Create `src/types/user.ts` with User, UserStats, UserFilters interfaces
    - Create `src/types/company.ts` with Company, CompanyStats, CompanyFilters interfaces
    - Create `src/types/business.ts` with Business, BusinessStats, BusinessFilters interfaces
    - Create `src/types/service.ts` with Service, ServiceStats, ServiceFilters interfaces
    - Create `src/types/legalPage.ts` with LegalPage, CreateLegalPageInput interfaces
    - Create `src/types/transaction.ts` with Transaction, TransactionStats interfaces
    - Create `src/types/common.ts` with PaginationParams, PaginatedResponse, etc.
    - _Requirements: 4.2, 5.2, 6.2, 7.2, 8.1, 9.2_

  - [x] 2.2 Create constants
    - Create `src/constants/routes.ts` with route path constants
    - Create `src/constants/status.ts` with status enums and labels
    - Create `src/constants/config.ts` with pagination defaults
    - _Requirements: 11.1_

- [x] 3. Database Migration for Legal Pages
  - [x] 3.1 Create legal_pages table in Supabase
    - Apply migration to create legal_pages table with RLS policies
    - Verify table structure and policies are working
    - _Requirements: 8.1, 8.3, 8.4, 8.5_

- [x] 4. Service Layer Implementation
  - [x] 4.1 Create authentication service
    - Create `src/services/authService.ts` with login, logout, register, getCurrentUser functions
    - Implement admin role verification on login
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 2.3_

  - [x] 4.2 Create user service
    - Create `src/services/userService.ts` with getUsers, getUserById, updateUserStatus, deleteUser, getUserStats
    - Implement pagination, filtering, and search
    - _Requirements: 4.1, 4.2, 4.4, 4.5, 4.6, 4.7_

  - [x] 4.3 Create company service
    - Create `src/services/companyService.ts` with getCompanies, getCompanyById, updateCompanyStatus, deleteCompany, getCompanyStats
    - Implement approval with approved_at timestamp
    - _Requirements: 5.1, 5.2, 5.4, 5.5, 5.6, 5.7_

  - [x] 4.4 Create business service
    - Create `src/services/businessService.ts` with getBusinesses, getBusinessById, updateBusinessStatus, deleteBusiness, getBusinessStats
    - _Requirements: 6.1, 6.2, 6.4, 6.5, 6.6_

  - [x] 4.5 Create service service
    - Create `src/services/serviceService.ts` with getServices, getServiceById, updateServiceStatus, deleteService, getServiceStats
    - _Requirements: 7.1, 7.2, 7.4, 7.5, 7.6_

  - [x] 4.6 Create legal page service
    - Create `src/services/legalPageService.ts` with getLegalPages, getLegalPageById, createLegalPage, updateLegalPage, deleteLegalPage
    - _Requirements: 8.1, 8.3, 8.4, 8.5_

  - [x] 4.7 Create transaction service
    - Create `src/services/transactionService.ts` with getTransactions, getTransactionById, getTransactionStats
    - _Requirements: 9.1, 9.2, 9.4, 9.5_

- [x] 5. Custom Hooks Implementation
  - [x] 5.1 Create authentication hook
    - Create `src/hooks/useAuth.ts` with login, logout, register, isAuthenticated, user state
    - Implement session persistence across refreshes
    - _Requirements: 1.2, 1.4, 1.6, 2.2_

  - [x] 5.2 Create data hooks
    - Create `src/hooks/useUsers.ts` with users, stats, pagination, filters, mutations
    - Create `src/hooks/useCompanies.ts` with companies, stats, pagination, filters, mutations
    - Create `src/hooks/useBusinesses.ts` with businesses, stats, pagination, filters, mutations
    - Create `src/hooks/useServices.ts` with services, stats, pagination, filters, mutations
    - Create `src/hooks/useLegalPages.ts` with legalPages, mutations
    - Create `src/hooks/useTransactions.ts` with transactions, stats, pagination, filters
    - _Requirements: 4.1-4.7, 5.1-5.7, 6.1-6.6, 7.1-7.6, 8.1-8.5, 9.1-9.5_

  - [x] 5.3 Create utility hooks
    - Create `src/hooks/usePagination.ts` for pagination state management
    - _Requirements: 11.1, 11.3, 11.4_

- [ ] 6. Checkpoint - Core Infrastructure
  - Ensure all services and hooks compile without errors
  - Verify Supabase connection works
  - Ask the user if questions arise

- [x] 7. Common UI Components
  - [x] 7.1 Create layout components
    - Create `src/components/layout/Sidebar.tsx` with navigation links and icons
    - Create `src/components/layout/Header.tsx` with user info and logout
    - Create `src/components/layout/MainLayout.tsx` combining sidebar and content area
    - Create `src/components/layout/MobileNav.tsx` with hamburger menu overlay
    - _Requirements: 10.1, 10.2, 10.3, 10.4_

  - [x] 7.2 Create common components
    - Create `src/components/common/SummaryCard.tsx` with title, value, icon, onClick
    - Create `src/components/common/DataCard.tsx` base component for entity cards
    - Create `src/components/common/ConfirmModal.tsx` for destructive action confirmation
    - Create `src/components/common/DetailModal.tsx` base modal for viewing details
    - Create `src/components/common/Pagination.tsx` with page controls
    - Create `src/components/common/SearchInput.tsx` with debounced search
    - Create `src/components/common/FilterDropdown.tsx` for filter selection
    - Create `src/components/common/LoadingSpinner.tsx` for loading states
    - _Requirements: 3.2, 10.5, 11.1, 11.5, 12.5_

- [x] 8. Authentication Pages
  - [x] 8.1 Create login page
    - Create `src/pages/LoginPage.tsx` with email/password form
    - Implement form validation and error display
    - Handle successful login redirect to dashboard
    - _Requirements: 1.1, 1.2, 1.3_

  - [x] 8.2 Create register page
    - Create `src/pages/RegisterPage.tsx` with email/password/name form
    - Implement password validation rules
    - Handle successful registration redirect
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5_

  - [x] 8.3 Create protected route wrapper
    - Create `src/components/common/ProtectedRoute.tsx` to guard admin routes
    - Redirect unauthenticated users to login
    - _Requirements: 1.5_

  - [ ]* 8.4 Write property tests for authentication
    - **Property 1: Protected Route Access Control**
    - **Property 2: Invalid Credentials Rejection**
    - **Property 3: Password Validation**
    - **Validates: Requirements 1.3, 1.5, 2.5**

- [-] 9. Dashboard Page
  - [x] 9.1 Create dashboard page
    - Create `src/pages/DashboardPage.tsx` with summary cards grid
    - Display total counts for users, companies, businesses, services, transactions
    - Implement loading states for each card
    - Handle card clicks to navigate to management sections
    - _Requirements: 3.1, 3.2, 3.3, 3.4_

  - [ ]* 9.2 Write property tests for summary cards
    - **Property 4: Summary Card Accuracy**
    - **Validates: Requirements 3.3, 4.1, 5.1, 6.1, 7.1, 9.1**

- [x] 10. User Management
  - [x] 10.1 Create user page components
    - Create `src/components/pages/users/UserCard.tsx` displaying user info in HeroUI card
    - Create `src/components/pages/users/UserDetailModal.tsx` with full user details
    - Create `src/components/pages/users/UserFilters.tsx` with type and status filters
    - _Requirements: 4.2, 4.3, 4.6, 4.7_

  - [x] 10.2 Create users page
    - Create `src/pages/UsersPage.tsx` with summary card, filters, search, and user cards grid
    - Implement status change and delete actions
    - Implement pagination
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7_

  - [ ]* 10.3 Write property tests for user management
    - **Property 5: Data Card Display Completeness** (users)
    - **Property 6: Status Update Persistence** (users)
    - **Property 7: Delete Operation Completeness** (users)
    - **Property 8: Filter Result Accuracy** (users)
    - **Validates: Requirements 4.2, 4.4, 4.5, 4.6, 4.7**

- [x] 11. Company Management
  - [x] 11.1 Create company page components
    - Create `src/components/pages/companies/CompanyCard.tsx` displaying company info
    - Create `src/components/pages/companies/CompanyDetailModal.tsx` with verification docs
    - Create `src/components/pages/companies/CompanyFilters.tsx` with status and category filters
    - _Requirements: 5.2, 5.3, 5.7_

  - [x] 11.2 Create companies page
    - Create `src/pages/CompaniesPage.tsx` with summary card, filters, and company cards
    - Implement approval, rejection, suspension, and delete actions
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7_

  - [ ]* 11.3 Write property tests for company management
    - **Property 6: Status Update Persistence** (companies with approved_at)
    - **Property 7: Delete Operation Completeness** (companies)
    - **Property 8: Filter Result Accuracy** (companies)
    - **Validates: Requirements 5.4, 5.5, 5.6, 5.7**

- [x] 12. Business Management
  - [x] 12.1 Create business page components
    - Create `src/components/pages/businesses/BusinessCard.tsx` displaying business info
    - Create `src/components/pages/businesses/BusinessDetailModal.tsx` with hours and contact
    - Create `src/components/pages/businesses/BusinessFilters.tsx` with status, category, company filters
    - _Requirements: 6.2, 6.3, 6.6_

  - [x] 12.2 Create businesses page
    - Create `src/pages/BusinessesPage.tsx` with summary card, filters, and business cards
    - Implement status change and delete actions
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6_

  - [ ]* 12.3 Write property tests for business management
    - **Property 6: Status Update Persistence** (businesses)
    - **Property 7: Delete Operation Completeness** (businesses)
    - **Property 8: Filter Result Accuracy** (businesses)
    - **Validates: Requirements 6.4, 6.5, 6.6**

- [x] 13. Service Management
  - [x] 13.1 Create service page components
    - Create `src/components/pages/services/ServiceCard.tsx` displaying service info with price
    - Create `src/components/pages/services/ServiceDetailModal.tsx` with images and characteristics
    - Create `src/components/pages/services/ServiceFilters.tsx` with status, category, business filters
    - _Requirements: 7.2, 7.3, 7.6_

  - [x] 13.2 Create services page
    - Create `src/pages/ServicesPage.tsx` with summary card, filters, and service cards
    - Implement status change and delete actions
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5, 7.6_

  - [ ]* 13.3 Write property tests for service management
    - **Property 6: Status Update Persistence** (services)
    - **Property 7: Delete Operation Completeness** (services)
    - **Property 8: Filter Result Accuracy** (services)
    - **Validates: Requirements 7.4, 7.5, 7.6**

- [ ] 14. Checkpoint - Entity Management
  - Ensure all entity management pages work correctly
  - Verify CRUD operations persist to Supabase
  - Ask the user if questions arise

- [x] 15. Legal Pages Management
  - [x] 15.1 Create legal page components
    - Create `src/components/pages/legal/LegalPageCard.tsx` displaying page info
    - Create `src/components/pages/legal/LegalPageEditor.tsx` with HTML editor
    - Create `src/components/pages/legal/LegalPageModal.tsx` for create/edit
    - _Requirements: 8.1, 8.2, 8.4_

  - [x] 15.2 Create legal pages page
    - Create `src/pages/LegalPagesPage.tsx` with list and CRUD actions
    - Implement create, edit, and delete functionality
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5_

  - [ ]* 15.3 Write property tests for legal pages
    - **Property 9: Legal Page Content Persistence** (round-trip)
    - **Property 7: Delete Operation Completeness** (legal pages)
    - **Validates: Requirements 8.3, 8.5**

- [x] 16. Transaction Management
  - [x] 16.1 Create transaction page components
    - Create `src/components/pages/transactions/TransactionCard.tsx` displaying transaction info
    - Create `src/components/pages/transactions/TransactionDetailModal.tsx` with metadata
    - Create `src/components/pages/transactions/TransactionFilters.tsx` with status, method, date filters
    - _Requirements: 9.2, 9.3, 9.4_

  - [x] 16.2 Create transactions page
    - Create `src/pages/TransactionsPage.tsx` with summary cards and transaction list
    - Implement filtering and search (view-only, no mutations)
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_

  - [ ]* 16.3 Write property tests for transactions
    - **Property 8: Filter Result Accuracy** (transactions)
    - **Validates: Requirements 9.4, 9.5**

- [x] 17. Pagination and Sorting
  - [x] 17.1 Implement pagination across all list pages
    - Add pagination controls to UsersPage, CompaniesPage, BusinessesPage, ServicesPage, TransactionsPage
    - Implement page size configuration
    - _Requirements: 11.1, 11.3_

  - [x] 17.2 Implement sorting
    - Add sortable column headers to list views
    - Implement sort state management in hooks
    - _Requirements: 11.2_

  - [ ]* 17.3 Write property tests for pagination and sorting
    - **Property 10: Pagination Data Integrity**
    - **Property 11: Sort Order Consistency**
    - **Property 12: Filter Pagination Reset**
    - **Validates: Requirements 11.1, 11.2, 11.3, 11.4**

- [x] 18. Error Handling and Notifications
  - [x] 18.1 Implement HeroUI toast notifications
    - Configure HeroUI ToastProvider in App.tsx (already done in 1.3)
    - Create utility functions for success/error toasts using `addToast`
    - Add success/error toasts to all mutation operations
    - _Requirements: 12.1, 12.2_

  - [x] 18.2 Implement error handling
    - Add error boundaries to main sections
    - Implement network error handling with retry
    - Add form validation error display
    - _Requirements: 12.3, 12.4_

  - [ ]* 18.3 Write property tests for notifications and validation
    - **Property 13: Operation Feedback**
    - **Property 14: Form Validation Feedback**
    - **Property 15: Destructive Action Confirmation**
    - **Validates: Requirements 12.1, 12.2, 12.4, 12.5**

- [-] 19. Router and App Integration
  - [x] 19.1 Configure React Router
    - Create `src/App.tsx` with route definitions
    - Set up protected routes for all admin pages
    - Configure redirect logic for unauthenticated users
    - _Requirements: 1.5, 3.4_

  - [ ] 19.2 Final integration
    - Wire all pages into the main layout
    - Ensure navigation works correctly
    - Test responsive behavior
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5_

- [ ] 20. Final Checkpoint
  - Ensure all tests pass
  - Verify all CRUD operations work end-to-end
  - Test responsive layout on mobile and desktop
  - Ask the user if questions arise

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties
- Unit tests validate specific examples and edge cases
- The admin panel is created in a separate `admin/` directory to keep it isolated from the Flutter app
