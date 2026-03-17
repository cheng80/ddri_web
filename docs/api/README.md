# DDRI API 명세서

## 파일 구성

| 파일 | 설명 |
|------|------|
| **API_SPEC.md** | API 명세서 (인간 가독형, 요약·예시 포함) |
| **openapi.yaml** | OpenAPI 3.0 명세 (기계 가독형, Swagger/ReDoc) |
| **README.md** | 본 문서 |

## 추천 명세 양식

| 양식 | 장점 | 도구 |
|------|------|------|
| **OpenAPI 3.0** | 업계 표준, FastAPI 자동 생성, Swagger/ReDoc 지원 | Swagger Editor, Redoc |
| **Markdown (API_SPEC.md)** | 간단, 버전 관리 용이, 팀 공유 용이 | - |

## 사용법

- **명세서 읽기**: `API_SPEC.md` — 엔드포인트 요약, 파라미터, 응답 예시
- **Swagger UI**: 서버 실행 후 http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **YAML 편집**: [Swagger Editor](https://editor.swagger.io/)에 `openapi.yaml` 붙여넣기
