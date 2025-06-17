# PlayGround Buddy - 다음 개발 계획

## 🚀 개발 환경 시작 방법

### 1. Node.js 버전 설정
```bash
nvm use 20
```

### 2. Supabase 시작
```bash
cd api
npx supabase start
# 약 1-2분 대기 (초기 실행 시 더 오래 걸릴 수 있음)
```

### 3. Web Admin 시작
```bash
cd web
pnpm dev
# http://localhost:3000
```

### 4. Mobile App 시작
```bash
cd app
pnpm start
# http://localhost:8081
```

## 📋 다음 개발 TODO

### 1. 인증 시스템 구현 (Priority: High)
- [ ] Web Admin 로그인 기능 완성
  - Supabase Auth 연동
  - 관리자 권한 체크
  - 로그인 유지 (세션 관리)
- [ ] Mobile App 사용자 인증
  - 회원가입 화면
  - 소셜 로그인 (Google, Apple)
  - 프로필 생성 플로우

### 2. Web Admin 기능 구현 (Priority: High)
- [ ] 대시보드 통계 
  - 실제 데이터 연동
  - 차트 구현 (recharts 활용)
- [ ] 놀이터 관리
  - 놀이터 목록 (페이지네이션)
  - 놀이터 추가/수정/삭제
  - 이미지 업로드 (Supabase Storage)
- [ ] 사용자 관리
  - 사용자 목록 조회
  - 사용자 상태 관리 (활성/비활성)
- [ ] 리뷰 모니터링
  - 부적절한 리뷰 신고 처리
  - 리뷰 삭제 기능

### 3. Mobile App 핵심 기능 (Priority: High)
- [ ] 지도 기능
  - 현재 위치 기반 주변 놀이터 표시
  - 놀이터 마커 및 정보 표시
  - 검색 기능
- [ ] 놀이터 상세 화면
  - 놀이터 정보 표시
  - 리뷰 목록
  - 즐겨찾기 기능
- [ ] 리뷰 작성
  - 평점 입력
  - 사진 업로드
  - 세부 평가 (청결도, 안전성, 시설)

### 4. 플레이메이트 기능 (Priority: Medium)
- [ ] 플레이데이트 생성
  - 날짜/시간 선택
  - 참가 조건 설정
- [ ] 플레이데이트 참여
  - 신청/승인 시스템
  - 참가자 목록
- [ ] 알림 시스템
  - 푸시 알림 설정
  - 신청 승인/거절 알림

### 5. 추가 기능 (Priority: Low)
- [ ] 검색 필터
  - 시설별 필터 (주차장, 화장실 등)
  - 연령대별 필터
- [ ] 커뮤니티 기능
  - 지역별 게시판
  - 육아 정보 공유
- [ ] 날씨 연동
  - 놀이터별 날씨 정보
  - 야외 활동 추천

## 🛠 기술적 개선사항

### 1. 성능 최적화
- [ ] 이미지 최적화 (Next.js Image, Expo Image)
- [ ] API 응답 캐싱
- [ ] 무한 스크롤 구현

### 2. 테스트
- [ ] 단위 테스트 설정
- [ ] E2E 테스트 (Cypress/Detox)
- [ ] API 테스트

### 3. CI/CD
- [ ] GitHub Actions 설정
- [ ] 자동 배포 파이프라인
- [ ] 환경별 설정 분리

### 4. 모니터링
- [ ] 에러 트래킹 (Sentry)
- [ ] 사용자 분석 (Analytics)
- [ ] 성능 모니터링

## 📚 참고 자료

- Supabase 문서: https://supabase.com/docs
- Next.js 문서: https://nextjs.org/docs
- Expo 문서: https://docs.expo.dev
- React Native Maps: https://github.com/react-native-maps/react-native-maps

## 🎯 다음 스프린트 목표

**스프린트 1 (1주차)**
- Web Admin 로그인 구현
- Mobile App 회원가입/로그인
- 지도 기반 놀이터 표시

**스프린트 2 (2주차)**
- 놀이터 CRUD (Web Admin)
- 놀이터 상세 화면 (Mobile)
- 리뷰 작성 기능

**스프린트 3 (3주차)**
- 플레이메이트 기본 기능
- 알림 시스템
- 성능 최적화