# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요
PlayGround Buddy - 놀이터 커뮤니티 플랫폼 (Supabase + Next.js + React Native)

## 아키텍처
- **api/**: Supabase 백엔드 (PostgreSQL, Auth, Storage)
- **web/**: Next.js 14 관리자 대시보드
- **app/**: React Native + Expo 모바일 앱

## 필수 개발 명령어

### API (Supabase)
```bash
cd api
npx supabase start          # 로컬 Supabase 시작
npx supabase db push        # 마이그레이션 적용
npx supabase functions serve # Edge Functions 실행
npx supabase stop           # 로컬 Supabase 중지
```

### Web Admin (Next.js)
```bash
cd web
pnpm install               # 의존성 설치
pnpm dev                   # 개발 서버 실행 (localhost:3000)
pnpm build                 # 프로덕션 빌드
pnpm lint                  # ESLint 실행
pnpm type-check            # TypeScript 타입 체크
```

### Mobile App (React Native)
```bash
cd app
npm install                # 의존성 설치
npx expo start            # 개발 서버 실행
npx expo run:ios          # iOS 시뮬레이터 실행
npx expo run:android      # Android 에뮬레이터 실행
npm run test              # 테스트 실행
```

### 통합 개발
```bash
# 루트에서 모든 서비스 실행
./scripts/dev.sh

# Docker 환경 (선택사항)
docker-compose up -d
```

## 환경 변수 설정

각 프로젝트마다 필요한 환경 변수:
- **api/.env**: Supabase 로컬 설정
- **web/.env.local**: Next.js 환경 변수
- **app/.env**: Expo 환경 변수

## 개발 패턴

### 데이터베이스 작업
- 모든 테이블에 RLS(Row Level Security) 적용
- UUID 기본키 사용
- created_at, updated_at 타임스탬프 포함

### API 개발
- Supabase Edge Functions로 커스텀 로직 구현
- PostgreSQL 함수로 복잡한 쿼리 처리

### 프론트엔드 개발
- TypeScript 엄격 모드 사용
- 컴포넌트는 기능별로 폴더 구성
- Supabase 클라이언트는 싱글톤 패턴 사용

## 테스트 및 빌드

### 코드 품질 검사
```bash
# Web
cd web && pnpm lint && pnpm type-check

# App
cd app && npm run lint && npm run test
```

### 배포 전 체크리스트
1. 환경 변수 확인
2. 마이그레이션 적용 여부 확인
3. 빌드 에러 없음 확인
4. 테스트 통과 확인

## 주요 파일 위치
- 데이터베이스 스키마: `api/supabase/migrations/`
- API 함수: `api/supabase/functions/`
- 웹 컴포넌트: `web/src/components/`
- 앱 스크린: `app/src/screens/`

## 문제 해결
- Supabase 연결 문제: `npx supabase status`로 상태 확인
- 타입 에러: 각 프로젝트의 `tsconfig.json` 설정 확인
- 빌드 실패: 노드 모듈 재설치 (`rm -rf node_modules && npm install`)

상세한 프로젝트 사양은 `docs/PROJECT_SPEC.md` 참조