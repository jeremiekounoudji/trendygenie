# Requirements Document

## Introduction

TrendyGenie Admin Panel is a web-based administration interface for managing the TrendyGenie marketplace platform. The admin panel enables platform administrators to manage users, companies, businesses, services, transactions, and legal content. Built with React, Vite, TypeScript, TailwindCSS, and HeroUI, it provides a responsive two-panel layout with comprehensive CRUD operations and real-time metrics.

## Glossary

- **Admin_Panel**: The web-based administration interface for TrendyGenie platform management
- **Admin**: A user with administrative privileges who can access and manage platform data
- **User**: Any registered account in the system (customer, provider, or admin)
- **Company**: A registered business entity owned by a provider, requiring certification approval
- **Business**: A specific business location or branch belonging to a company
- **Service**: A product or service offering listed by a business
- **Transaction**: A payment record associated with an order
- **Legal_Page**: HTML template content for legal documents (terms, privacy policy, etc.)
- **Status**: The current state of an entity (active, pending, suspended, rejected, deleted)
- **Summary_Card**: A UI component displaying aggregated metrics for a data category
- **Modal**: A dialog overlay for viewing details or creating/editing records
- **Supabase**: The backend service providing authentication, database, and real-time features

## Requirements

### Requirement 1: Admin Authentication

**User Story:** As an admin, I want to securely log in and out of the admin panel, so that I can access administrative functions while maintaining platform security.

#### Acceptance Criteria

1. WHEN an admin navigates to the admin panel URL, THE Admin_Panel SHALL display a login form with email and password fields
2. WHEN an admin submits valid credentials, THE Admin_Panel SHALL authenticate against Supabase and redirect to the dashboard
3. WHEN an admin submits invalid credentials, THE Admin_Panel SHALL display an error message and remain on the login page
4. WHEN an authenticated admin clicks logout, THE Admin_Panel SHALL terminate the session and redirect to the login page
5. WHEN an unauthenticated user attempts to access protected routes, THE Admin_Panel SHALL redirect to the login page
6. WHILE a session is active, THE Admin_Panel SHALL persist authentication state across page refreshes

### Requirement 2: Admin Registration

**User Story:** As a platform owner, I want to register new admin accounts, so that authorized personnel can manage the platform.

#### Acceptance Criteria

1. WHEN an existing admin accesses the admin registration page, THE Admin_Panel SHALL display a registration form with email, password, and full name fields
2. WHEN valid registration data is submitted, THE Admin_Panel SHALL create a new user in Supabase auth with admin role in user_type
3. WHEN registration is successful, THE Admin_Panel SHALL display a success message and redirect to the admin list
4. IF the email already exists, THEN THE Admin_Panel SHALL display an appropriate error message
5. IF password does not meet security requirements, THEN THE Admin_Panel SHALL display validation errors

### Requirement 3: Dashboard Overview

**User Story:** As an admin, I want to see a dashboard with key platform metrics, so that I can quickly understand platform health and activity.

#### Acceptance Criteria

1. WHEN an admin accesses the dashboard, THE Admin_Panel SHALL display summary cards for total users, companies, businesses, services, and transactions
2. WHEN data is loading, THE Admin_Panel SHALL display loading indicators on summary cards
3. WHEN summary cards are displayed, THE Admin_Panel SHALL show count values fetched from Supabase in real-time
4. WHEN an admin clicks a summary card, THE Admin_Panel SHALL navigate to the corresponding management section

### Requirement 4: User Management

**User Story:** As an admin, I want to manage platform users, so that I can maintain user accounts and handle policy violations.

#### Acceptance Criteria

1. WHEN an admin navigates to user management, THE Admin_Panel SHALL display a summary card showing total users, active users, and users by type
2. WHEN the user list loads, THE Admin_Panel SHALL display users in HeroUI cards with name, email, user type, status, and created date
3. WHEN an admin clicks a user card, THE Admin_Panel SHALL open a modal displaying full user details
4. WHEN an admin changes a user's status, THE Admin_Panel SHALL update the is_active field in Supabase and refresh the display
5. WHEN an admin deletes a user, THE Admin_Panel SHALL remove the user record from Supabase after confirmation
6. WHEN the user list is displayed, THE Admin_Panel SHALL support filtering by user type and status
7. WHEN the user list is displayed, THE Admin_Panel SHALL support searching by name or email

### Requirement 5: Company Management

**User Story:** As an admin, I want to manage registered companies, so that I can approve, reject, or suspend company registrations.

#### Acceptance Criteria

1. WHEN an admin navigates to company management, THE Admin_Panel SHALL display a summary card showing total companies, pending approvals, approved, and suspended counts
2. WHEN the company list loads, THE Admin_Panel SHALL display companies in HeroUI cards with name, owner, status, category, and registration date
3. WHEN an admin clicks a company card, THE Admin_Panel SHALL open a modal displaying full company details including verification documents
4. WHEN an admin changes a company's status, THE Admin_Panel SHALL update the status field in Supabase and refresh the display
5. WHEN an admin approves a company, THE Admin_Panel SHALL set status to 'approved' and update approved_at timestamp
6. WHEN an admin deletes a company, THE Admin_Panel SHALL remove the company record from Supabase after confirmation
7. WHEN the company list is displayed, THE Admin_Panel SHALL support filtering by status and category

### Requirement 6: Business Management

**User Story:** As an admin, I want to manage businesses, so that I can oversee business listings and handle compliance issues.

#### Acceptance Criteria

1. WHEN an admin navigates to business management, THE Admin_Panel SHALL display a summary card showing total businesses, active, pending, and suspended counts
2. WHEN the business list loads, THE Admin_Panel SHALL display businesses in HeroUI cards with name, company, category, status, and rating
3. WHEN an admin clicks a business card, THE Admin_Panel SHALL open a modal displaying full business details including hours and contact info
4. WHEN an admin changes a business's status, THE Admin_Panel SHALL update the status field in Supabase and refresh the display
5. WHEN an admin deletes a business, THE Admin_Panel SHALL remove the business record from Supabase after confirmation
6. WHEN the business list is displayed, THE Admin_Panel SHALL support filtering by status, category, and company

### Requirement 7: Service Management

**User Story:** As an admin, I want to manage services, so that I can moderate service listings and ensure quality standards.

#### Acceptance Criteria

1. WHEN an admin navigates to service management, THE Admin_Panel SHALL display a summary card showing total services, active, pending, and suspended counts
2. WHEN the service list loads, THE Admin_Panel SHALL display services in HeroUI cards with title, business, category, price, status, and rating
3. WHEN an admin clicks a service card, THE Admin_Panel SHALL open a modal displaying full service details including images and characteristics
4. WHEN an admin changes a service's status, THE Admin_Panel SHALL update the status field in Supabase and refresh the display
5. WHEN an admin deletes a service, THE Admin_Panel SHALL remove the service record from Supabase after confirmation
6. WHEN the service list is displayed, THE Admin_Panel SHALL support filtering by status, category, and business

### Requirement 8: Legal Pages Management

**User Story:** As an admin, I want to manage legal page content, so that I can maintain up-to-date terms of service, privacy policy, and other legal documents.

#### Acceptance Criteria

1. WHEN an admin navigates to legal pages management, THE Admin_Panel SHALL display a list of legal pages with title, type, and last updated date
2. WHEN an admin clicks a legal page, THE Admin_Panel SHALL open a modal with an HTML editor for the page content
3. WHEN an admin saves legal page changes, THE Admin_Panel SHALL update the content in Supabase and display a success message
4. WHEN an admin creates a new legal page, THE Admin_Panel SHALL open a modal with fields for title, type, and HTML content
5. WHEN an admin deletes a legal page, THE Admin_Panel SHALL remove the record from Supabase after confirmation

### Requirement 9: Transaction Management

**User Story:** As an admin, I want to view and monitor transactions, so that I can track platform revenue and investigate payment issues.

#### Acceptance Criteria

1. WHEN an admin navigates to transaction management, THE Admin_Panel SHALL display summary cards showing total transactions, total revenue, pending payments, and completed payments
2. WHEN the transaction list loads, THE Admin_Panel SHALL display transactions with order ID, customer, amount, status, payment method, and date
3. WHEN an admin clicks a transaction, THE Admin_Panel SHALL open a modal displaying full transaction details including metadata
4. WHEN the transaction list is displayed, THE Admin_Panel SHALL support filtering by status, payment method, and date range
5. WHEN the transaction list is displayed, THE Admin_Panel SHALL support searching by order ID or customer name

### Requirement 10: Responsive Layout

**User Story:** As an admin, I want the admin panel to work on different screen sizes, so that I can manage the platform from various devices.

#### Acceptance Criteria

1. THE Admin_Panel SHALL display a two-panel layout with a left sidebar and main content area on desktop
2. WHEN the viewport width is below 768px, THE Admin_Panel SHALL collapse the sidebar into a hamburger menu
3. WHEN the hamburger menu is clicked on mobile, THE Admin_Panel SHALL display the navigation as an overlay
4. WHILE scrolling the main content, THE Admin_Panel SHALL keep the sidebar fixed and independently scrollable
5. WHEN displaying cards on mobile, THE Admin_Panel SHALL stack them vertically in a single column

### Requirement 11: Data Table Features

**User Story:** As an admin, I want to sort and paginate data lists, so that I can efficiently navigate large datasets.

#### Acceptance Criteria

1. WHEN displaying list data, THE Admin_Panel SHALL implement pagination with configurable page size
2. WHEN an admin clicks a column header, THE Admin_Panel SHALL sort the data by that column
3. WHEN pagination controls are used, THE Admin_Panel SHALL fetch the appropriate page of data from Supabase
4. WHEN filters are applied, THE Admin_Panel SHALL reset pagination to the first page
5. WHEN no data matches the current filters, THE Admin_Panel SHALL display an empty state message

### Requirement 12: Error Handling and Notifications

**User Story:** As an admin, I want clear feedback on my actions, so that I know when operations succeed or fail.

#### Acceptance Criteria

1. WHEN an operation succeeds, THE Admin_Panel SHALL display a success toast notification using HeroUI
2. WHEN an operation fails, THE Admin_Panel SHALL display an error toast notification with a descriptive message
3. WHEN a network error occurs, THE Admin_Panel SHALL display a connection error message and retry option
4. WHEN form validation fails, THE Admin_Panel SHALL display inline error messages for invalid fields
5. WHEN a destructive action is requested, THE Admin_Panel SHALL display a confirmation dialog before proceeding
