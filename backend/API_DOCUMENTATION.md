# Solo Leveling System - Backend API Documentation

## Overview
NestJS-based REST API for the Solo Leveling-inspired life gamification system.

**Base URL**: `http://localhost:3000`

---

## Authentication

All protected endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <token>
```

### Register
**POST** `/auth/register`

Create a new user account.

**Request Body**:
```json
{
  "email": "hunter@example.com",
  "username": "ShadowMonarch",
  "password": "strongPassword123"
}
```

**Response** (201):
```json
{
  "id": "uuid",
  "email": "hunter@example.com",
  "username": "ShadowMonarch",
  "rank": "E",
  "level": 1,
  "currentXp": 0,
  "xpToNextLevel": 100,
  "stats": {
    "str": 10,
    "agi": 10,
    "vit": 10,
    "int": 10,
    "per": 10
  }
}
```

### Login
**POST** `/auth/login`

Authenticate and receive JWT token.

**Request Body**:
```json
{
  "email": "hunter@example.com",
  "password": "strongPassword123"
}
```

**Response** (200):
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "hunter@example.com",
    "username": "ShadowMonarch",
    "level": 1,
    "rank": "E"
  }
}
```

### Get Profile
**GET** `/auth/profile` 🔒

Get current user profile.

**Response** (200):
```json
{
  "userId": "uuid",
  "username": "ShadowMonarch",
  "email": "hunter@example.com"
}
```

---

## Quests

### List All Quests
**GET** `/quests`

Retrieve all available quests.

**Response** (200):
```json
[
  {
    "id": "uuid",
    "title": "Pushup Mastery I",
    "description": "Complete 50 Pushups. Failure to complete will result in a penalty.",
    "type": "DAILY",
    "difficulty": "E",
    "requirements": {
      "type": "pushups",
      "count": 50,
      "verificationMethod": "manual"
    },
    "rewards": {
      "xp": 50,
      "stats": { "str": 1 }
    }
  }
]
```

### Get Quest by ID
**GET** `/quests/:id`

Retrieve a specific quest.

**Response** (200): Single quest object

### Create Quest
**POST** `/quests`

Create a new quest (admin functionality).

**Request Body**:
```json
{
  "title": "Morning Run",
  "description": "Run 5km before sunrise",
  "type": "DAILY",
  "difficulty": "D",
  "requirements": {
    "type": "running",
    "count": 5000,
    "verificationMethod": "api"
  },
  "rewards": {
    "xp": 100,
    "stats": { "agi": 2 }
  }
}
```

### Complete Quest
**POST** `/quests/:id/complete` 🔒

Mark a quest as completed and receive rewards.

**Response** (200):
```json
{
  "message": "Quest Completed",
  "rewards": {
    "xp": 50,
    "stats": { "str": 1 }
  },
  "userUpdates": {
    "level": 2,
    "xp": 25,
    "stats": {
      "str": 12,
      "agi": 11,
      "int": 11,
      "vit": 11,
      "per": 11
    }
  }
}
```

### Update Quest
**PATCH** `/quests/:id`

Update quest details.

### Delete Quest
**DELETE** `/quests/:id`

Remove a quest.

---

## Data Models

### User
```typescript
{
  id: string;              // UUID
  email: string;           // Unique
  username: string;        // Unique
  passwordHash: string;    // Bcrypt hashed
  rank: 'E' | 'D' | 'C' | 'B' | 'A' | 'S';
  level: number;           // Default: 1
  currentXp: number;       // Default: 0
  xpToNextLevel: number;   // Default: 100
  stats: {
    str: number;           // Strength
    agi: number;           // Agility
    vit: number;           // Vitality
    int: number;           // Intelligence
    per: number;           // Perception
  };
  jobClass: string | null;
  title: string | null;
  createdAt: Date;
  updatedAt: Date;
}
```

### Quest
```typescript
{
  id: string;
  title: string;
  description: string;
  type: 'DAILY' | 'WEEKLY' | 'PENALTY' | 'HIDDEN';
  difficulty: 'E' | 'D' | 'C' | 'B' | 'A' | 'S';
  requirements: {
    type: 'pushups' | 'running' | 'coding' | 'manual';
    count: number;
    verificationMethod: 'manual' | 'api' | 'ml_kit';
    metadata?: any;
  };
  rewards: {
    xp: number;
    stats?: {
      str?: number;
      agi?: number;
      int?: number;
      vit?: number;
    };
  };
  createdAt: Date;
  updatedAt: Date;
}
```

---

## Leveling System

### XP Calculation
- **Base XP per level**: 100
- **Scaling**: Each level requires 20% more XP than the previous
- **Formula**: `xpToNextLevel = floor(previousXpRequired * 1.2)`

### Level Up Rewards
- **Stats**: +1 to all stats (STR, AGI, INT, VIT, PER)
- **Rank Progression**:
  - Level 10: E → D
  - Level 20: D → C
  - (Future: Level 30: C → B, etc.)

---

## External Integrations

### LeetCode Service
**Internal Service** - Not exposed as API endpoint

Fetches user statistics from LeetCode GraphQL API.

```typescript
getUserStats(username: string): Promise<LeetCodeUserStats>
```

### Gemini AI Service
**Internal Service** - Not exposed as API endpoint

Generates quest descriptions using Google's Gemini AI.

```typescript
generateDailyQuestDescription(topic: string): Promise<string>
```

---

## Environment Variables

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_password
DB_NAME=solo_system

# JWT
JWT_SECRET=your_secret_key

# Server
PORT=3000

# AI
GEMINI_API_KEY=your_gemini_api_key
```

---

## Error Responses

### 400 Bad Request
```json
{
  "statusCode": 400,
  "message": ["email must be an email"],
  "error": "Bad Request"
}
```

### 401 Unauthorized
```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

### 404 Not Found
```json
{
  "statusCode": 404,
  "message": "Quest not found"
}
```

### 500 Internal Server Error
```json
{
  "statusCode": 500,
  "message": "Internal server error"
}
```

---

## Development

### Running the Server
```bash
npm run start:dev
```

### Linting
```bash
npm run lint
```

### Building for Production
```bash
npm run build
npm run start:prod
```

---

## Database Seeding

The application automatically seeds the database with initial quests on first startup:

1. **Pushup Mastery I** (E-Rank, 50 XP)
2. **Running: The First 5k** (D-Rank, 100 XP)
3. **Algorithm Proficiency** (E-Rank, 75 XP)
4. **SURVIVAL** (A-Rank Penalty Quest, 0 XP)

---

## Security Notes

- Passwords are hashed using bcrypt with auto-generated salts
- JWT tokens expire after 60 minutes
- CORS is enabled for frontend integration
- Database synchronization is enabled in development (disable in production)
- All sensitive endpoints require JWT authentication

---

## Future Enhancements

- [ ] Player Quest tracking (active/completed/failed)
- [ ] Audit logs for anti-cheat
- [ ] Health/Fitness API integrations
- [ ] ML Kit for exercise verification
- [ ] Party/Guild system
- [ ] Leaderboards
- [ ] Daily quest generation via Gemini AI
