# GitHub Issue: Review and Improve Login Flow and User Redirection

## Issue Title
Review and Improve Login Flow and User Redirection

## Issue Number
[To be assigned when created on GitHub]

## Branch
`feat/improve-login-flow`

## Description
We need to improve the login flow to properly handle user redirection based on account type and status:

1. When a user signs in:
   - Authenticate the user
   - Fetch the user profile data
   - Check the user type (provider or customer)

2. For provider users:
   - Check if the company status is pending
   - If pending, redirect to the certification pending page
   - If approved, redirect to the provider dashboard

3. For customer users:
   - Redirect to the customer dashboard/home page

## Requirements
- Update the AuthController to handle user type detection
- Integrate with the CompanyController to check company status
- Implement proper redirection logic
- Add error handling for edge cases
- Ensure session persistence across app restarts

## Acceptance Criteria
- [ ] Login successfully authenticates users
- [ ] User type is correctly determined after login
- [ ] Providers with pending status are redirected to the certification pending page
- [ ] Providers with approved status are redirected to the provider dashboard
- [ ] Customers are redirected to the customer homepage
- [ ] User remains logged in when the app restarts until they log out
- [ ] Appropriate error messages are displayed for failed logins

## Technical Notes
- Use GetX for state management and navigation
- Ensure proper loading states during API calls
- Leverage existing UserController and CompanyController