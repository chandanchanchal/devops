# Capline Backend Services - Codebase Explanation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Core Infrastructure](#core-infrastructure)
4. [Authentication & Authorization Flow](#authentication--authorization-flow)
5. [Main Business Modules & Flows](#main-business-modules--flows)
6. [Event & Mail System](#event--mail-system)
7. [Database Structure](#database-structure)
8. [Key Services & Utilities](#key-services--utilities)

---

## Overview

*Capline Backend Services* is a comprehensive NestJS-based backend application for managing healthcare credentialing, patient management, insurance lookups, appointments, and various administrative tasks. The application uses:

- *Framework*: NestJS (TypeScript)
- *Database*: PostgreSQL (Prisma ORM)
- *Authentication*: JWT + Google OAuth
- *Queue System*: Redis-based queue (@squareboat/nest-queue)
- *Storage*: AWS S3
- *Email*: Custom mailman service
- *AI Integration*: OpenAI GPT for chat functionality

---

## Architecture

### Application Structure


src/
├── _common/          # Shared utilities, decorators, interfaces
├── _services/        # Core services (cache, S3, OpenAI, Google Sheets)
├── auth/             # Authentication module
├── rbac/             # Role-Based Access Control
├── user/             # User management
├── credentialing/    # Credentialing workflow
├── ext-credentialing/# External credentialing
├── ev-dashboard/     # EV client dashboard
├── patient/          # Patient management
├── insurance-lookup/ # Insurance lookup services
├── schedule-appointment/ # Appointment scheduling
├── ai-chat/          # AI chat functionality
├── mail-man/         # Email event system
├── queue/            # Background job processing
└── [other modules]


### Module Pattern

Each business module follows a consistent structure:
- module.ts - NestJS module definition
- controller/ - HTTP request handlers (Admin, User, etc.)
- services/ - Business logic
- db/ - Repository pattern for database access
- dtos/ - Data Transfer Objects for validation
- constants.ts - Module-specific constants
- commands/ - CLI commands for seeding/updates

---

## Core Infrastructure

### 1. Application Bootstrap (main.ts)

*Flow:*

main.ts → RestServer.make(AppModule) → CoreModule initialization


- Uses custom RestServer from @libs/core
- Initializes all modules defined in AppModule
- Sets up global configurations (validation, CORS, etc.)

### 2. Configuration System (config/)

Configuration files:
- app.ts - Application settings
- auth.ts - JWT and OAuth settings
- database.ts - Database connections
- cache.ts - Redis cache configuration
- queue.ts - Queue configuration
- services.ts - External service configurations
- storage.ts - S3 storage settings

### 3. Core Library (libs/core/)

Custom core library providing:
- RestServer - Custom server setup
- RestController - Base controller with response handling
- Prisma - Database connector
- Decorators for validation and permissions
- Transformers for response formatting

---

## Authentication & Authorization Flow

### Why Both JWT and Google OAuth?

*Important: JWT and Google OAuth are **NOT competing* authentication methods - they work *together*:

1. *Google OAuth* = *Initial Authentication Method* (Login)
   - User clicks "Login with Google"
   - Google verifies user identity
   - Returns user profile (email, name, picture)

2. *JWT* = *Session Token* (After Login)
   - After Google OAuth succeeds, system generates a *JWT token*
   - This JWT token is used for *all subsequent API requests*
   - JWT contains: { sub: userUuid, username: email, type: userType }

*Flow:*

User → Google OAuth → Verify Identity → Generate JWT → Use JWT for API calls


### Authentication Types

The system supports multiple authentication methods:

#### Password-Based Login (JWT Only)
1. *Admin Login* (POST /admin/auth/login) - Username + Password → JWT
2. *User Login* (POST /user/auth/login) - Username + Password → JWT
3. *Credentialing Client Login* (POST /admin/auth/credentialing/login) - Username + Password → JWT
4. *EV Client Login* (POST /admin/auth/ev/login) - Username + Password → JWT
5. *External Credentialing Login* (POST /admin/auth/credentialing/ext/login) - Username + Password → JWT

#### Google OAuth Login (OAuth → JWT)
6. *Admin Google OAuth* (GET /admin/auth/google) - Google OAuth → JWT
7. *EV Client Google OAuth* (GET /ev/auth/google) - Google OAuth → JWT
8. *Credentialing Google OAuth* (GET /credentialing/auth/google) - Google OAuth → JWT
9. *Insurance Lookup Google OAuth* (GET /insurance-lookup/auth/google) - Google OAuth → JWT
10. *External Credentialing Google OAuth* (GET /admin/auth/google/ext-credentialing) - Google OAuth → JWT

### Authentication Flow Steps

#### 1. Password-Based Login Flow


Client Request → Controller → Service → Repository → Database
                                    ↓
                            Password Validation
                                    ↓
                            JWT Token Generation
                                    ↓
                            Response with Token + User Data


*Example: Admin Login*

1. *Request*: POST /admin/auth/login with { username, password }
2. *Controller* (auth/controller/admin.ts):
   - Validates DTO using @ValidateRequest
   - Calls AuthAdminService.login()
3. *Service* (auth/service/admin.ts):
   - Finds AdminLogin by username
   - Validates password using bcryptjs
   - Fetches AdminDetails and Role with permissions
   - Generates JWT token with payload: { sub: uuid, username, type: 'admin' }
   - Returns token + user details
4. *Response*: Transformed using AuthDetailsTransformer

#### 2. Google OAuth Login Flow


User clicks "Login with Google"
        ↓
GET /admin/auth/google (redirects to Google)
        ↓
User authenticates with Google
        ↓
Google redirects to /admin/auth/google/callback
        ↓
GoogleStrategy validates user profile
        ↓
AuthGoogleService.googleLogin()
        ↓
Check if user exists in database
        ↓
If exists: Update profile picture
If new: Create admin account (provider: 'GOOGLE')
        ↓
Generate JWT Token (same as password login!)
        ↓
Redirect to frontend with JWT token


*Key Points:*
- Google OAuth is only for *initial authentication* (proving who you are)
- After Google OAuth, the system *still generates a JWT token*
- The JWT token is what's used for *all API requests* afterward
- Both password and OAuth login result in the *same JWT token format*

*Example: Admin Google OAuth*

1. *Request*: GET /admin/auth/google
2. *Google OAuth Flow*: User redirected to Google, authenticates
3. *Callback*: GET /admin/auth/google/callback with Google profile
4. *Service* (auth/service/auth.service.ts):
   - Validates email domain (must be in allowed domains)
   - Checks if admin exists by email
   - If exists: Updates profile picture, generates JWT
   - If new: Creates admin account with provider: 'GOOGLE', assigns default role, generates JWT
5. *Response*: Redirects to frontend with JWT token in URL params

*Why This Design?*

✅ *User Experience*: Google OAuth = No password to remember
✅ *Security*: Google handles password security
✅ *Consistency*: All API calls use JWT (same format regardless of login method)
✅ *Flexibility*: Users can choose password or OAuth
✅ *Domain Control*: Google OAuth validates email domain (only company emails allowed)

#### 3. Visual Comparison

*Password Login:*

User → Enter username/password → Validate → Generate JWT → Use JWT


*Google OAuth Login:*

User → Click "Login with Google" → Google verifies → Generate JWT → Use JWT


*After Login (Both Methods):*

All API Requests → JWT Token in Header → JwtAuthGuard validates → Access granted/denied


*Key Insight: Both authentication methods end up with the **same JWT token. The difference is only in **how the user proves their identity initially*.

#### 2. JWT Guard Flow


Request with Bearer Token → JwtAuthGuard.canActivate()
                                    ↓
                            Extract & Decode JWT
                                    ↓
                            Get User Permissions
                                    ↓
                            Check Route Permission
                                    ↓
                            Allow/Deny Access


*JWT Guard* (guards/jwt-auth.guard.ts):

1. Extracts token from Authorization header
2. Decodes JWT to get user info
3. Fetches user permissions based on:
   - *Role permissions* (from Role table)
   - *Team-Role permissions* (if user has team)
   - *Permission Aliases* (custom permissions per user)
4. Checks if user has required permission for the route
5. Allows or denies access

#### 3. Permission System (RBAC)

*Permission Hierarchy:*

Role → Permissions (many-to-many)
Team + Role → TeamRolePermission → Permissions
User → PermissionAlias → Permissions


*Permission Check Flow:*
1. Route decorator: @Allow('permission.scope')
2. Guard extracts permission from route
3. Guard fetches all user permissions (role + team + alias)
4. Checks if user has matching permission

---

## Main Business Modules & Flows

### 1. Credentialing Module

*Purpose*: Manage credentialing clients and their workflows

*Key Entities:*
- CredentialingClientDetails - Client information
- Multiple email recipients (to, cc, bcc)
- Google Sheets integration for data sync

*Flows:*

#### A. Create Credentialing Client

*Steps:*
1. *Request*: POST /admin/credentialing/clients
2. *Controller* → CredentialingAdminService.createClient()
3. *Service Logic*:
   - Validates client doesn't already exist
   - Processes email recipients (to, cc, bcc)
   - Creates client record with:
     - Client name, ID, office name
     - Email recipients (stored as JSON array)
     - Role assignment
     - Google Sheets URL
   - Generates password setup tokens for each recipient
   - Emits SEND_CREDENTIALING_CLIENT_WELCOME_EMAIL event
4. *Email Event* → Queue → Email sent with password setup link

#### B. Credentialing Client Login

*Steps:*
1. *Request*: POST /admin/auth/credentialing/login
2. *Service*: AuthAdminService.credentialingLogin()
3. Validates credentials
4. Returns JWT token with type: credentialingClient
5. Token includes client permissions

#### C. Get Credentialing Data

*Steps:*
1. *Request*: GET /credentialing/data?userId=xxx
2. *Service*: CredentialingUserService.getDetailsData()
3. Fetches client data from Google Sheets (if configured)
4. Returns formatted credentialing data

### 2. External Credentialing Module

*Purpose*: Manage external credentialing applications and insurance companies

*Key Features:*
- Insurance company management
- Application tracking
- Status updates
- Follow-up reminders
- Email notifications

*Flows:*

#### A. Create External Credentialing Application

*Steps:*
1. Create application record
2. Assign to admin user (POC)
3. Set initial status
4. Emit assignment email event

#### B. Status Update Flow

*Steps:*
1. Update application status
2. Create status history record
3. Emit status update email event
4. If status requires follow-up, schedule reminder

### 3. Patient Module

*Purpose*: Manage patient information and access logs

*Key Entities:*
- PatientDetails - Patient information
- Office - Office/location information
- PatientDetailsAccessLog - Audit trail

*Flows:*

#### A. Create/Update Patient

*Steps:*
1. *Request*: POST /admin/patient or PUT /admin/patient/:id
2. *Service*: PatientDetailsServices.create() or update()
3. Validates patient data
4. Creates/updates patient record
5. Logs access if viewing existing patient

#### B. Patient Access Logging

*Steps:*
1. When patient data is accessed
2. Creates PatientDetailsAccessLog record
3. Tracks: admin user, patient, timestamp, action type

### 4. Insurance Lookup Module

*Purpose*: Provide insurance plan lookup and validation

*Key Entities:*
- InsuranceName - Insurance companies
- PlanDetails - Insurance plans
- PlanCodeMap - Plan code mappings
- HmoInsuranceName - HMO insurance companies
- HmoPcsName - HMO PCS codes
- HmoPcsCodeMap - HMO code mappings

*Flows:*

#### A. Insurance Lookup

*Steps:*
1. *Request*: GET /insurance/lookup?planCode=xxx
2. *Service*: InsuranceServices.lookup()
3. Searches PlanCodeMap for matching code
4. Returns plan details with insurance company info

#### B. HMO Lookup

*Steps:*
1. Similar to insurance lookup
2. Searches HMO-specific tables
3. Returns HMO plan information

### 5. Appointment Scheduling Module

*Purpose*: Manage appointment scheduling for different teams

*Key Entities:*
- EsAppointmentDetails - ES team appointments
- IvAppointmentDetails - IV team appointments
- PitAppointmentDetails - PIT team appointments
- AuditAppointmentDetails - Audit team appointments

*Flows:*

#### A. Create Appointment

*Steps:*
1. *Request*: POST /admin/appointment
2. *Service*: AppointmentServices.create()
3. Determines appointment type (ES/IV/PIT/Audit)
4. Creates appointment in appropriate table
5. Links to patient and office

#### B. Appointment Management

- Update appointment details
- Cancel appointments
- Reschedule appointments
- Query appointments by filters (date, patient, office, team)

### 6. AI Chat Module

*Purpose*: Provide AI-powered chat functionality using OpenAI

*Key Entities:*
- Conversations - Chat conversations
- Messages - Individual messages
- GptApiLogs - API call logs

*Flows:*

#### A. Create Conversation

*Steps:*
1. *Request*: POST /admin/ai-chat/conversations
2. *Service*: Creates conversation record
3. Returns conversation ID

#### B. Send Message

*Steps:*
1. *Request*: POST /admin/ai-chat/messages
2. *Service*: AIChatUserService.sendMessage()
3. Saves user message
4. Calls OpenAI API with conversation history
5. Saves AI response
6. Logs API call details
7. Returns message thread

### 7. EV Dashboard Module

*Purpose*: Dashboard for EV (External Verification) clients

*Key Features:*
- Client management
- Report generation
- Monthly reports
- Account creation requests

### 8. HMO Form Module

*Purpose*: Manage HMO form submissions and data

### 9. Questionnaire Module

*Purpose*: Manage questionnaires and responses

### 10. PIT Guided Tool Module

*Purpose*: Interactive guided tool for appointment scheduling

*Key Feature:*
- Question flow system with branching logic
- Defined in constants.ts as QuestionFlow
- Supports: Appointment, Reschedule/Cancel, Confirmation, Spanish, Inquiry

### 11. Analytics Module

*Purpose*: Generate analytics and reports

*Features:*
- Capline GPT usage reports
- Scheduled report generation
- Email report distribution

---

## Event & Mail System

### Architecture


Business Logic → Event Emitter → Event Listener → Queue → Job Worker → Email Service


### Event Flow

1. *Event Emission*: Service emits event using EventEmitter2
   typescript
   this.eventEmitter.emit('send-otp-email', new SendOTPEmailEvent(...));
   

2. *Event Listener*: Listener catches event and dispatches to queue
   typescript
   @OnEvent('send-otp-email')
   async handle(event: SendOTPEmailEvent) {
     Queue.dispatch({
       job: 'send-otp-job',
       data: { ... }
     });
   }
   

3. *Queue Processing*: Background worker processes job
   typescript
   @Process('send-otp-job')
   async handle(job: Job) {
     // Send email
   }
   

### Email Events

Common email events:
- SEND_OTP_EMAIL - OTP verification
- SEND_WELCOME_EMAIL - User welcome
- SEND_CREDENTIALING_CLIENT_WELCOME_EMAIL - Credentialing client welcome
- SEND_CREDENTIALING_SUBMISSION_EMAIL - Credentialing submission notification
- SEND_EXT_CREDENTIALING_STATUS_UPDATE_ALERT - Status update alerts
- SEND_EV_MONTHLY_REPORT_EMAIL - Monthly reports
- And many more...

### Mail Service

*Location*: src/mail-man/services.ts

*Features:*
- Template-based email rendering (MJML/React)
- Multiple email templates
- Scheduled email sending
- Email tracking

---

## Database Structure

### Key Models

#### User Management
- AdminLogin - Admin authentication
- AdminDetails - Admin profile information
- UserLogin - Regular user authentication
- UserDetails - User profile information
- Role - Roles (admin, user, credentialingClient, etc.)
- Permission - Permissions (scoped)
- TeamRolePermission - Team-specific role permissions
- PermissionAlias - Custom user permissions

#### Credentialing
- CredentialingClientDetails - Credentialing clients
- ExtClient - External credentialing clients
- ExtInsuranceApplication - External credentialing applications
- ExtStatusHistory - Application status history
- ExtInsuranceCompany - Insurance companies

#### Patient & Appointments
- PatientDetails - Patient information
- Office - Office locations
- EsAppointmentDetails - ES appointments
- IvAppointmentDetails - IV appointments
- PitAppointmentDetails - PIT appointments
- AuditAppointmentDetails - Audit appointments

#### Insurance
- InsuranceName - Insurance companies
- PlanDetails - Insurance plans
- PlanCodeMap - Plan code mappings
- HmoInsuranceName - HMO insurance
- HmoPcsName - HMO PCS codes
- HmoPcsCodeMap - HMO code mappings

#### AI Chat
- Conversations - Chat conversations
- Messages - Chat messages
- GptApiLogs - API usage logs

#### Mail
- Email - Email records
- Mail - Mail queue/tracking

### Relationships

- *AdminLogin* → *AdminDetails* (1:1)
- *AdminDetails* → *TeamDetails* (many:1)
- *Role* → *Permission* (many:many)
- *AdminDetails* → *PermissionAlias* (1:many)
- *CredentialingClientDetails* → *Role* (many:1)
- *PatientDetails* → *Office* (many:1)
- *Appointments* → *PatientDetails* (many:1)
- *Appointments* → *AdminDetails* (many:1)

---

## Key Services & Utilities

### 1. Cache Service (_services/cache.ts)

Redis-based caching for:
- User permissions
- Frequently accessed data
- Session management

### 2. S3 Service (_services/s3.ts)

AWS S3 integration for:
- Document storage
- File uploads
- Media management

### 3. Google Sheets Service (_services/google-sheets-service.ts)

Google Sheets integration for:
- Credentialing data sync
- Data import/export
- Real-time data updates

### 4. OpenAI Service (_services/open-ai-servies.ts)

OpenAI integration for:
- AI chat functionality
- Token counting
- Conversation management

### 5. Transformers (transformer/)

Response transformation layer:
- Formats API responses
- Hides sensitive data
- Standardizes output format

### 6. Repository Pattern (db/)

Each module uses repository pattern:
- Abstract database operations
- Type-safe queries
- Reusable database logic

---

## Request Flow Example

### Complete Flow: Create Credentialing Client


1. HTTP Request
   POST /admin/credentialing/clients
   Headers: { Authorization: "Bearer <token>" }
   Body: { clientName, clientId, officeName, to: [...], ... }

2. JWT Guard
   - Validates token
   - Checks permission: "credentialing.create"
   - Attaches user to request

3. Controller
   - Validates DTO
   - Calls service method

4. Service
   - Business logic validation
   - Creates database record
   - Emits email event

5. Event System
   - Listener catches event
   - Dispatches to queue

6. Queue Worker
   - Processes email job
   - Sends welcome email

7. Response
   - Transforms data
   - Returns success response


---

## CLI Commands

The application includes CLI commands for:
- Seeding data (seed:credentialingClients, etc.)
- Database migrations
- Data updates
- Report generation

*Usage*: npm run cli:dev <command>

---

## Configuration

### Environment Variables

Key environment variables:
- POSTGRESQL_DATABASE_URL - Database connection
- JWT_SECRET - JWT signing secret
- AWS_S3_DOCS_BUCKET - S3 bucket name
- OPENAI_API_KEY - OpenAI API key
- GOOGLE_CLIENT_ID - Google OAuth client ID
- REDIS_URL - Redis connection for queue/cache

---

## Testing

- Unit tests: npm run test
- E2E tests: npm run test:e2e
- Schema validation: npm run test:schema

---

## Deployment

1. *Build*: npm run build
2. *Run Migrations*: npm run migrate:deploy
3. *Start*: npm run start:prod

---

## Summary

This codebase is a comprehensive healthcare management system with:

✅ *Multi-tenant architecture* with role-based access
✅ *Multiple authentication methods* (JWT, Google OAuth)
✅ *Complex business workflows* (credentialing, appointments, insurance)
✅ *Event-driven architecture* for async operations
✅ *AI integration* for chat functionality
✅ *Email notification system* with templates
✅ *Background job processing* for heavy tasks
✅ *Comprehensive audit logging*

The architecture follows NestJS best practices with clear separation of concerns, repository pattern, and modular design.
