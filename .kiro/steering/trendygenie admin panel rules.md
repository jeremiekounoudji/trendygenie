---
inclusion: fileMatch
fileMatchPattern: ['**/admin/**', '**/dashboard/**', '**/management/**']
---

# TrendyGenie Admin Panel Development Guide

## Tech Stack
- **Frontend**: React + Vite + TypeScript
- **Styling**: TailwindCSS + HeroUI component library
- **Backend**: Supabase (database, auth, real-time)
- **State Management**: React hooks + custom hooks

## Project Setup
When creating the admin panel:
1. Use Vite with React + TypeScript template
2. Install HeroUI following their official documentation
3. Configure TailwindCSS with HeroUI integration
4. Set up Supabase client with environment variables

## Project Structure
```
src/
├── assets/
│   ├── images/          # Static images and icons
│   └── styles/          # Global CSS and theme files
├── components/
│   ├── common/          # Reusable UI components
│   ├── layout/          # Layout components (sidebar, header)
│   └── pages/           # Page-specific components
├── constants/           # App constants and configuration
├── hooks/              # Custom React hooks for data fetching
├── pages/              # Main page components
├── services/           # API service functions
├── store/              # State management (if needed)
├── types/              # TypeScript type definitions
└── utils/              # Utility functions
```

## Layout Architecture
- **Two-panel layout**: Responsive left sidebar + main content area
- **Sidebar**: Navigation with icons and labels, independently scrollable
- **Main content**: Right side content area, scrollable but not the entire page
- **Responsive**: Sidebar collapses on mobile, hamburger menu for navigation

## API Integration Guidelines
- **Supabase Client**: All API calls through Supabase client
- **MCP Supabase Tool**: Use `mcp_supabase_*` tools to inspect database schema, constraints, and data
- **Service Layer**: Create dedicated service functions for each API operation
- **Custom Hooks**: Wrap API calls in custom hooks for data fetching and mutations
- **TypeScript Interfaces**: Define strict types for all API responses and requests
- **Error Handling**: Consistent error handling across all API calls

## UI/UX Standards
- **Component Library**: Use HeroUI components exclusively
- **Notifications**: Use HeroUI toast for success/error messages
- **Loading States**: Implement loading spinners for async operations
- **Form Validation**: Client-side validation with clear error messages
- **Responsive Design**: Mobile-first approach with breakpoint considerations

## Admin Panel Features
- **User Management**: View, edit, suspend user accounts
- **Business Management**: Approve/reject business registrations
- **Service Management**: Monitor and moderate service listings
- **Analytics Dashboard**: Key metrics and performance indicators
- **Content Moderation**: Review and manage user-generated content

## Code Quality Standards
- **TypeScript**: Strict typing, no `any` types
- **Component Structure**: Small, focused components with single responsibility
- **Custom Hooks**: Extract data fetching logic into reusable hooks
- **Error Boundaries**: Implement error boundaries for graceful error handling
- **Accessibility**: Follow WCAG guidelines, proper ARIA labels

## Data Management
- **Real-time Updates**: Use Supabase real-time subscriptions where appropriate
- **Caching**: Implement proper data caching strategies
- **Pagination**: Handle large datasets with pagination
- **Filtering/Sorting**: Provide robust filtering and sorting capabilities

## Security Considerations
- **Role-based Access**: Implement proper admin role verification
- **Data Validation**: Server-side validation for all admin operations
- **Audit Logging**: Track admin actions for accountability
- **Secure Routes**: Protect admin routes with authentication checks
