# PlayGround Buddy

놀이터에서 함께 놀 친구를 찾아주는 커뮤니티 플랫폼

## 프로젝트 구조

이 리포지터리는 PlayGround Buddy 프로젝트의 메타 리포지터리입니다. 
각 서브프로젝트는 Git 서브모듈로 관리됩니다:

- **api/** - Supabase 백엔드 API
- **web/** - Next.js 관리자 대시보드
- **app/** - React Native 모바일 앱

## 시작하기

### 1. 서브모듈 초기화
```bash
git clone --recursive https://github.com/TheMagicTower/playground-buddy-project.git
cd playground-buddy-project
```

### 2. 개발 환경 설정
```bash
./scripts/setup.sh
```

### 3. 전체 서비스 실행
```bash
./scripts/dev.sh
```

## 개발 가이드

자세한 개발 가이드는 [CLAUDE.md](./CLAUDE.md)를 참조하세요.
프로젝트 전체 사양은 [docs/PROJECT_SPEC.md](./docs/PROJECT_SPEC.md)를 참조하세요.

## 라이선스

MIT License