# PlayGround Buddy - 놀이터 커뮤니티 프로젝트 사양서

## 프로젝트 개요
PlayGround Buddy는 아이들이 놀이터에서 함께 놀 친구를 찾을 수 있도록 돕는 서비스입니다. 부모들이 주변 놀이터를 검색하고, 리뷰를 남기며, 다른 가족들과 놀이 약속을 잡을 수 있는 플랫폼입니다.

## 아키텍처
- **API**: Supabase (PostgreSQL + Realtime + Auth + Storage)
- **Web Admin**: Next.js 14 (관리자 대시보드)
- **Mobile App**: React Native + Expo (사용자 앱)

## GitHub 구조
```
TheMagicTower/
├── playground-buddy-project/  # 메타 리포지터리 (서브모듈 포함)
├── playground-buddy-api/      # API 서버
├── playground-buddy-web/      # 웹 관리자
└── playground-buddy-app/      # 모바일 앱
```

## 프로젝트 초기 설정

### 1. GitHub 리포지터리 생성
```bash
# Organization: TheMagicTower
# 메타 리포지터리
gh repo create TheMagicTower/playground-buddy-project --public \
  --description "PlayGround Buddy - 놀이터 커뮤니티 메타 프로젝트"

# API 리포지터리
gh repo create TheMagicTower/playground-buddy-api --public \
  --description "PlayGround Buddy API Server (Supabase)"

# 웹 리포지터리
gh repo create TheMagicTower/playground-buddy-web --public \
  --description "PlayGround Buddy Web Admin (Next.js)"

# 앱 리포지터리
gh repo create TheMagicTower/playground-buddy-app --public \
  --description "PlayGround Buddy Mobile App (React Native)"
```

### 2. 메타 프로젝트 설정
```bash
# 메타 프로젝트 클론
git clone https://github.com/TheMagicTower/playground-buddy-project.git
cd playground-buddy-project

# 서브모듈 추가
git submodule add https://github.com/TheMagicTower/playground-buddy-api.git api
git submodule add https://github.com/TheMagicTower/playground-buddy-web.git web
git submodule add https://github.com/TheMagicTower/playground-buddy-app.git app

# 기본 파일 생성
touch README.md .gitignore
mkdir scripts
```

### 3. 루트 디렉토리 파일 구조
```
playground-buddy-project/
├── .gitmodules              # 서브모듈 설정
├── .gitignore              # Git 무시 파일
├── README.md               # 프로젝트 전체 설명
├── CLAUDE.md               # Claude Code 가이드
├── docker-compose.yml      # 로컬 개발 환경
├── scripts/               
│   ├── dev.sh             # 모든 서비스 실행
│   └── setup.sh           # 의존성 설치
├── docs/                  # 프로젝트 문서
│   └── PROJECT_SPEC.md    # 이 파일
├── api/                   # [서브모듈] Supabase API
├── web/                   # [서브모듈] Next.js Admin
└── app/                   # [서브모듈] React Native App
```

## API 프로젝트 (Supabase)

### 디렉토리 구조
```
api/
├── supabase/
│   ├── migrations/        # DB 마이그레이션
│   ├── functions/        # Edge Functions
│   └── seed.sql         # 초기 데이터
├── .env.example
├── config.toml           # Supabase 설정
└── README.md
```

### 데이터베이스 스키마
```sql
-- 사용자 프로필
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  nickname VARCHAR(50) NOT NULL UNIQUE,
  region VARCHAR(100),
  introduction TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 아이 정보
CREATE TABLE children (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  age_group VARCHAR(20) CHECK (age_group IN ('toddler', 'preschool', 'elementary_low', 'elementary_high')),
  gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
  interests TEXT[],
  created_at TIMESTAMP DEFAULT NOW()
);

-- 놀이터 정보
CREATE TABLE playgrounds (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(200) NOT NULL,
  address TEXT NOT NULL,
  lat DECIMAL(10, 8) NOT NULL,
  lng DECIMAL(11, 8) NOT NULL,
  operating_hours VARCHAR(100),
  has_parking BOOLEAN DEFAULT FALSE,
  has_restroom BOOLEAN DEFAULT FALSE,
  facilities JSONB DEFAULT '{}',
  images TEXT[],
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 위치 기반 검색을 위한 인덱스
CREATE INDEX idx_playgrounds_location ON playgrounds USING GIST (
  geography(ST_MakePoint(lng, lat))
);

-- 놀이터 리뷰
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  playground_id UUID REFERENCES playgrounds(id) ON DELETE CASCADE,
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  rating INTEGER CHECK (rating BETWEEN 1 AND 5),
  cleanliness INTEGER CHECK (cleanliness BETWEEN 1 AND 5),
  safety INTEGER CHECK (safety BETWEEN 1 AND 5),
  facilities INTEGER CHECK (facilities BETWEEN 1 AND 5),
  content TEXT,
  images TEXT[],
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 플레이메이트 약속
CREATE TABLE playdates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  playground_id UUID REFERENCES playgrounds(id) ON DELETE CASCADE,
  host_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  date_time TIMESTAMP NOT NULL,
  age_group VARCHAR(20),
  description TEXT,
  max_participants INTEGER DEFAULT 5,
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'cancelled', 'completed')),
  created_at TIMESTAMP DEFAULT NOW()
);

-- 플레이메이트 참가자
CREATE TABLE playdate_participants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  playdate_id UUID REFERENCES playdates(id) ON DELETE CASCADE,
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(playdate_id, profile_id)
);

-- RLS (Row Level Security) 정책
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE children ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE playdates ENABLE ROW LEVEL SECURITY;
ALTER TABLE playdate_participants ENABLE ROW LEVEL SECURITY;

-- 프로필은 본인만 수정 가능
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- 리뷰는 작성자만 수정/삭제 가능
CREATE POLICY "Users can update own reviews" ON reviews
  FOR UPDATE USING (auth.uid() = profile_id);
```

### Supabase 초기화
```bash
cd api
npx supabase init

# .env 파일 생성
cp .env.example .env
# SUPABASE_URL과 SUPABASE_ANON_KEY 설정

# 로컬 개발 시작
npx supabase start

# 마이그레이션 실행
npx supabase db push
```

## Web Admin 프로젝트 (Next.js)

### 프로젝트 생성
```bash
cd web
pnpm create next-app@latest . --typescript --tailwind --app --src-dir --import-alias "@/*"

# 추가 패키지 설치
pnpm add @supabase/supabase-js @supabase/auth-helpers-nextjs
pnpm add @tanstack/react-query zustand
pnpm add recharts lucide-react
pnpm add -D @types/node
```

### 디렉토리 구조
```
web/
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   │   └── login/
│   │   ├── (dashboard)/
│   │   │   ├── layout.tsx
│   │   │   ├── page.tsx
│   │   │   ├── playgrounds/
│   │   │   ├── users/
│   │   │   └── reviews/
│   │   └── api/
│   ├── components/
│   │   ├── dashboard/
│   │   └── ui/
│   ├── lib/
│   │   └── supabase/
│   └── hooks/
├── public/
└── package.json
```

### 주요 기능
- 놀이터 관리 (CRUD)
- 사용자 관리
- 리뷰 모니터링
- 통계 대시보드
- 신고 관리

## Mobile App 프로젝트 (React Native + Expo)

### 프로젝트 생성
```bash
cd app
npx create-expo-app . --template blank-typescript

# 추가 패키지 설치
npx expo install expo-location expo-camera expo-image-picker
npx expo install @react-navigation/native @react-navigation/bottom-tabs @react-navigation/stack
npx expo install react-native-screens react-native-safe-area-context
npx expo install @supabase/supabase-js
npx expo install react-native-async-storage/async-storage
npx expo install react-native-maps
```

### 디렉토리 구조
```
app/
├── src/
│   ├── screens/
│   │   ├── auth/
│   │   ├── map/
│   │   ├── playground/
│   │   ├── playmate/
│   │   └── profile/
│   ├── components/
│   ├── navigation/
│   ├── services/
│   │   └── supabase.ts
│   ├── stores/
│   └── utils/
├── assets/
├── app.json
└── App.tsx
```

### 주요 화면
1. **지도 화면**: 주변 놀이터 검색
2. **놀이터 상세**: 정보, 리뷰, 사진
3. **플레이메이트**: 약속 생성/참여
4. **프로필**: 내 정보, 아이 정보 관리

## 통합 개발 환경

### Docker Compose 설정
```yaml
version: '3.8'

services:
  # Supabase 로컬 환경
  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: playground_buddy
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  # Redis for 캐싱
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

### 개발 스크립트 (scripts/dev.sh)
```bash
#!/bin/bash
echo "🚀 Starting all services..."

# API 서버
cd api && npx supabase start &

# Web Admin
cd ../web && pnpm dev &

# Mobile App
cd ../app && npx expo start &

echo "Services running:"
echo "  - Supabase Studio: http://localhost:54323"
echo "  - Web Admin: http://localhost:3000"
echo "  - Expo: http://localhost:8081"

wait
```

## 환경 변수

### API (.env)
```
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_KEY=your_service_key
```

### Web (.env.local)
```
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
```

### App (.env)
```
EXPO_PUBLIC_SUPABASE_URL=http://localhost:54321
EXPO_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
EXPO_PUBLIC_GOOGLE_MAPS_API_KEY=your_google_maps_key
```

## 작업 플로우

### 기능 개발 시
1. API에서 데이터베이스 스키마 및 함수 작성
2. Web Admin에서 관리 기능 구현
3. Mobile App에서 사용자 기능 구현

### 브랜치 전략
- `main`: 프로덕션 배포
- `develop`: 개발 통합
- `feature/*`: 기능 개발
- `hotfix/*`: 긴급 수정

## 배포

### API (Supabase)
```bash
cd api
npx supabase link --project-ref your-project-ref
npx supabase db push
npx supabase functions deploy
```

### Web (Vercel)
```bash
cd web
vercel --prod
```

### App (EAS Build)
```bash
cd app
eas build --platform all
eas submit --platform all
```

## 핵심 기능 우선순위

### Phase 1 (MVP)
1. 사용자 인증 (Supabase Auth)
2. 놀이터 지도 검색
3. 놀이터 상세 정보
4. 리뷰 작성/조회

### Phase 2
1. 플레이메이트 매칭
2. 푸시 알림
3. 즐겨찾기

### Phase 3
1. 커뮤니티 게시판
2. 날씨 연동
3. AI 놀이터 추천