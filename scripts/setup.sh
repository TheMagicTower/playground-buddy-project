#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}🛠  PlayGround Buddy 개발 환경 설정${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# 필수 도구 확인
echo -e "${YELLOW}📋 필수 도구 확인 중...${NC}"

# Node.js 확인
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js가 설치되어 있지 않습니다.${NC}"
    echo "https://nodejs.org/ 에서 Node.js를 설치하세요."
    exit 1
else
    echo -e "${GREEN}✅ Node.js $(node --version)${NC}"
fi

# pnpm 확인
if ! command -v pnpm &> /dev/null; then
    echo -e "${YELLOW}📦 pnpm 설치 중...${NC}"
    npm install -g pnpm
else
    echo -e "${GREEN}✅ pnpm $(pnpm --version)${NC}"
fi

# Docker 확인
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker가 설치되어 있지 않습니다.${NC}"
    echo "https://www.docker.com/ 에서 Docker를 설치하세요."
    exit 1
else
    echo -e "${GREEN}✅ Docker $(docker --version)${NC}"
fi

# Expo CLI 확인
if ! command -v expo &> /dev/null; then
    echo -e "${YELLOW}📦 Expo CLI 설치 중...${NC}"
    npm install -g expo-cli
else
    echo -e "${GREEN}✅ Expo CLI$(NC}"
fi

# Supabase CLI 확인
if ! command -v supabase &> /dev/null; then
    echo -e "${YELLOW}📦 Supabase CLI 설치 중...${NC}"
    npm install -g supabase
else
    echo -e "${GREEN}✅ Supabase CLI$(NC}"
fi

echo ""
echo -e "${YELLOW}🔄 서브모듈 초기화...${NC}"
git submodule update --init --recursive

# 각 프로젝트 의존성 설치
echo ""
echo -e "${YELLOW}📦 프로젝트 의존성 설치 중...${NC}"

# API 의존성
if [ -d "api" ]; then
    echo -e "${BLUE}[API] 설정 중...${NC}"
    cd api
    if [ ! -f ".env" ] && [ -f ".env.example" ]; then
        cp .env.example .env
        echo -e "${YELLOW}⚠️  api/.env 파일이 생성되었습니다. 환경 변수를 설정하세요.${NC}"
    fi
    cd ..
fi

# Web 의존성
if [ -d "web" ]; then
    echo -e "${BLUE}[Web] 의존성 설치 중...${NC}"
    cd web
    pnpm install
    if [ ! -f ".env.local" ] && [ -f ".env.example" ]; then
        cp .env.example .env.local
        echo -e "${YELLOW}⚠️  web/.env.local 파일이 생성되었습니다. 환경 변수를 설정하세요.${NC}"
    fi
    cd ..
fi

# App 의존성
if [ -d "app" ]; then
    echo -e "${BLUE}[App] 의존성 설치 중...${NC}"
    cd app
    npm install
    if [ ! -f ".env" ] && [ -f ".env.example" ]; then
        cp .env.example .env
        echo -e "${YELLOW}⚠️  app/.env 파일이 생성되었습니다. 환경 변수를 설정하세요.${NC}"
    fi
    cd ..
fi

echo ""
echo -e "${GREEN}✅ 설정이 완료되었습니다!${NC}"
echo ""
echo "다음 명령어로 개발 서버를 시작하세요:"
echo -e "${BLUE}./scripts/dev.sh${NC}"
echo ""