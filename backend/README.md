# Solo Leveling System - Backend

NestJS-based backend API for a gamified life management system inspired by Solo Leveling.

## Tech Stack

- **Framework**: NestJS (TypeScript)
- **Database**: PostgreSQL
- **ORM**: TypeORM
- **Authentication**: JWT (Passport)
- **AI Integration**: Google Gemini API
- **External APIs**: LeetCode GraphQL

## Quick Start

### Prerequisites

- Node.js 18+
- PostgreSQL 14+
- npm or yarn

### Installation

```bash
# Install dependencies
npm install

# Configure environment variables
cp .env.example .env
# Edit .env with your database credentials and API keys

# Start PostgreSQL and create database
createdb -U postgres solo_system

# Run in development mode
npm run start:dev
```

The server will start on `http://localhost:3000`

## Project Structure

```
src/
├── auth/              # Authentication module (JWT, Login, Register)
│   ├── dto/          # Data Transfer Objects
│   ├── auth.controller.ts
│   ├── auth.service.ts
│   ├── auth.module.ts
│   └── jwt.strategy.ts
├── users/            # User management
│   ├── entities/     # User entity with stats
│   ├── dto/
│   ├── users.service.ts  # XP/Leveling logic
│   └── users.module.ts
├── quests/           # Quest CRUD and completion
│   ├── entities/     # Quest entity
│   ├── dto/
│   ├── quests.controller.ts
│   ├── quests.service.ts
│   └── quests.module.ts
├── gemini/           # AI quest generation service
│   ├── gemini.service.ts
│   └── gemini.module.ts
├── leetcode/         # LeetCode integration
│   ├── leetcode.service.ts
│   └── leetcode.module.ts
├── seed/             # Database seeding
│   ├── seed.service.ts
│   └── seed.module.ts
├── app.module.ts     # Root module
└── main.ts           # Application entry point
```

## Features

### ✅ Implemented

- User registration and authentication (JWT)
- Player stats system (STR, AGI, INT, VIT, PER)
- Leveling and XP system with automatic stat increases
- Rank progression (E → D → C → B → A → S)
- Quest CRUD operations
- Quest completion with reward distribution
- Database seeding with initial quests
- LeetCode stats integration (service layer)
- Gemini AI integration (service layer)
- Type-safe codebase with strict linting

### 🚧 Planned

- Player Quest tracking (active/completed/failed)
- Penalty quest system
- Health/Fitness API integrations
- ML Kit for exercise verification
- Audit logs for anti-cheat
- Party/Guild system
- Leaderboards

## API Documentation

See [API_DOCUMENTATION.md](./API_DOCUMENTATION.md) for complete API reference.

## Database Schema

### Users Table
- UUID primary key
- Email, username (unique)
- Password hash (bcrypt)
- Rank (E-S)
- Level, XP, stats (JSONB)
- Job class, title

### Quests Table
- UUID primary key
- Title, description
- Type (DAILY, WEEKLY, PENALTY, HIDDEN)
- Difficulty (E-S)
- Requirements (JSONB)
- Rewards (JSONB)

## Scripts

```bash
# Development
npm run start:dev

# Production build
npm run build
npm run start:prod

# Linting
npm run lint

# Testing
npm run test
npm run test:e2e
```

## Environment Variables

```env
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_password
DB_NAME=solo_system
JWT_SECRET=your_secret_key
PORT=3000
GEMINI_API_KEY=your_gemini_api_key
```

## Development Notes

- TypeORM `synchronize: true` is enabled for development (auto-creates tables)
- Database is automatically seeded on first startup
- CORS is enabled for frontend integration
- All code follows strict TypeScript linting rules

## License

MIT
