# 🚀 kpostal_plus 배포 체크리스트

## ✅ 배포 전 필수 작업

### 1. GitHub 저장소 설정

```bash
# 현재 디렉토리로 이동
cd /Users/pyowonsik/Downloads/workspace/kpostal_plus

# Git 상태 확인
git status
git remote -v
```

#### GitHub 저장소 이름 변경:
1. https://github.com/pyowonsik/cocode_postal/settings 접속
2. "Repository name" → `kpostal_plus`로 변경
3. "Rename" 클릭

#### 로컬 Git remote URL 업데이트:
```bash
git remote set-url origin https://github.com/pyowonsik/kpostal_plus.git
git remote -v  # 확인
```

### 2. 변경사항 커밋 & 푸시

```bash
# 변경사항 확인
git status

# 모든 파일 추가
git add .

# 커밋
git commit -m "feat: release kpostal_plus v1.0.0

- Rename from cocode_postal to kpostal_plus
- Add comprehensive cross-platform support (iOS/Android/Web)
- Refactor README with detailed documentation
- Improve test coverage (13 test cases)
- Enhance example app with Material 3 UI
- Optimize pubspec.yaml with topics and platforms
- Add Korean/English documentation
"

# 푸시
git push origin main
```

### 3. 최종 테스트

```bash
# 의존성 업데이트
flutter pub get

# 테스트 실행
flutter test

# 코드 분석
flutter analyze

# 배포 시뮬레이션
flutter pub publish --dry-run
```

## 🚀 실제 배포

### 1. pub.dev 로그인

```bash
flutter pub login
```

- Google 계정으로 로그인
- pub.dev 권한 부여

### 2. 배포 실행

```bash
flutter pub publish
```

- 확인 메시지에 `y` 입력
- 완료될 때까지 대기 (1-2분)

### 3. 배포 확인

https://pub.dev/packages/kpostal_plus 접속하여 확인

## 📊 배포 후 작업

### 1. GitHub Release 생성

1. https://github.com/pyowonsik/kpostal_plus/releases/new 접속
2. Tag version: `v1.0.0`
3. Release title: `kpostal_plus v1.0.0`
4. Description: CHANGELOG.md 내용 복사
5. "Publish release" 클릭

### 2. README 배지 업데이트

pub.dev 배포 후 배지가 자동으로 작동하는지 확인

### 3. 홍보

- Flutter 커뮤니티에 소개
- 기존 kpostal 사용자들에게 마이그레이션 가이드 공유

## ⚠️ 주의사항

- ❌ **pub.dev에 배포하면 삭제 불가능!**
- ✅ Discontinue만 가능
- ✅ 신중하게 최종 확인 후 배포

## ✅ 완료 체크

- [ ] GitHub 저장소 이름 변경
- [ ] Git remote URL 업데이트
- [ ] 모든 변경사항 커밋 & 푸시
- [ ] 테스트 통과 확인
- [ ] Analyze 이슈 없음 확인
- [ ] dry-run 성공 확인
- [ ] pub.dev 로그인
- [ ] **실제 배포 실행**
- [ ] pub.dev에서 패키지 확인
- [ ] GitHub Release 생성
- [ ] 홍보 및 공유

---

**배포 준비 완료! 위 단계들을 순서대로 진행하세요.** 🚀

