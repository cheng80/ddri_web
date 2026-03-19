# DDRI API 문서

## 파일 구성

| 파일 | 설명 |
|------|------|
| **API_SPEC.md** | 현재 서비스 기준 API 요약 명세 |
| **openapi.yaml** | OpenAPI 3.0 명세 |
| **README.md** | 본 문서 |

## 추천 명세 양식

| 양식 | 장점 | 도구 |
|------|------|------|
| **OpenAPI 3.0** | 업계 표준, FastAPI 자동 생성, Swagger/ReDoc 지원 | Swagger Editor, Redoc |
| **Markdown (API_SPEC.md)** | 간단, 버전 관리 용이, 팀 공유 용이 | - |

## 현재 기준

- 조회형 웹 API를 기준으로 문서를 유지한다.
- 설계 기준은 아래 문서를 따른다.
  - [01_screen_design_and_scope.md](/Users/cheng80/Desktop/ddri_web/docs/02_web_service_final/01_screen_design_and_scope.md)
  - [02_system_design.md](/Users/cheng80/Desktop/ddri_web/docs/02_web_service_final/02_system_design.md)
  - [03_api_and_runtime_contract.md](/Users/cheng80/Desktop/ddri_web/docs/02_web_service_final/03_api_and_runtime_contract.md)

## 사용법

- 명세서 읽기: [API_SPEC.md](/Users/cheng80/Desktop/ddri_web/docs/api/API_SPEC.md)
- Swagger UI: 서버 실행 후 `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`
- YAML 편집: [Swagger Editor](https://editor.swagger.io/)에 `openapi.yaml` 붙여넣기
