#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 PlayGround Buddy 개발 환경 시작${NC}"
echo ""

# Docker 서비스 시작
echo -e "${YELLOW}📦 Docker 서비스 시작...${NC}"
docker-compose up -d

# Docker 서비스가 준비될 때까지 대기
echo -e "${YELLOW}⏳ 서비스 준비 중...${NC}"
sleep 5

# 서브모듈이 초기화되었는지 확인
if [ ! -d "api/.git" ] || [ ! -d "web/.git" ] || [ ! -d "app/.git" ]; then
    echo -e "${RED}❌ 서브모듈이 초기화되지 않았습니다.${NC}"
    echo -e "${YELLOW}먼저 다음 명령어를 실행하세요:${NC}"
    echo "git submodule update --init --recursive"
    exit 1
fi

# API 서버 시작
echo -e "${GREEN}🔧 API 서버 시작 (Supabase)...${NC}"
cd api && npx supabase start &
API_PID=$!

# Web Admin 시작
echo -e "${GREEN}🌐 Web Admin 시작 (Next.js)...${NC}"
cd ../web && pnpm dev &
WEB_PID=$!

# Mobile App 시작
echo -e "${GREEN}📱 Mobile App 시작 (Expo)...${NC}"
cd ../app && npx expo start &
APP_PID=$!

echo ""
echo -e "${GREEN}✅ 모든 서비스가 시작되었습니다!${NC}"
echo ""
echo "서비스 URL:"
echo "  - Supabase Studio: http://localhost:54323"
echo "  - Web Admin: http://localhost:3000"
echo "  - Expo DevTools: http://localhost:8081"
echo "  - PostgreSQL: localhost:5432"
echo "  - Redis: localhost:6379"
echo ""
echo -e "${YELLOW}종료하려면 Ctrl+C를 누르세요${NC}"

# 종료 시그널 처리
trap "echo -e '\n${YELLOW}🛑 서비스 종료 중...${NC}'; kill $API_PID $WEB_PID $APP_PID 2>/dev/null; docker-compose down; exit" SIGINT SIGTERM

# 프로세스가 종료되지 않도록 대기
wait