# Finanzplaner - Rails Budget Management App

A Ruby on Rails budget management application for tracking expenses, categories, and personal finances.

## Features
- User authentication with role-based access (Admin, User, Viewer)
- Category management with spending limits
- Product/expense tracking
- Expense list and balance calculation
- Dashboard with account overview

## Setup

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Create and seed the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. Start the server:
   ```bash
   rails server
   ```

4. Access the app at http://localhost:3000 and login with test users:
   - Admin: admin@example.com / password123
   - User: user@example.com / password123
   - Viewer: viewer@example.com / password123

## Database
SQLite (development database at `db/development.sqlite3`)

## Priority Features Implemented

### Phase 1 (MVP)
- ✅ Simple login with test users
- ✅ Header navigation
- ✅ User management (CRUD, Admin only)
- ✅ Categories with limits & spending sum
- ✅ Products management
- ✅ Mark products as bought + expense list
- ✅ Account balance calculation

### Phase 2-3 (Future)
- Subscriptions
- Savings goal calculator
- Dashboard home page
- Graphical reporting
- Groups
