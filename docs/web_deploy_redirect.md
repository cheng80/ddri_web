# 웹 배포 시 리다이렉트 설정

Flutter 웹은 SPA이므로, **서버가 모든 경로 요청을 index.html로 보내야** 합니다.  
그렇지 않으면 `/user`, `/admin` 등 직접 접속 시 404가 발생합니다.

## 1. Flutter 앱 내부 (완료)

| 항목 | 설정 |
|------|------|
| `usePathUrlStrategy()` | `/#/user` → `/user` (path 기반 URL) |
| `unknownRoute` | 존재하지 않는 경로 → `/user`로 표시 |

## 2. 서버 설정 (배포 시 필요)

### Firebase Hosting

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      { "source": "**", "destination": "/index.html" }
    ]
  }
}
```

### Nginx

```nginx
location / {
  try_files $uri $uri/ /index.html;
}
```

### Apache (.htaccess)

```apache
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.html [L]
</IfModule>
```

### Vercel (vercel.json)

```json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }]
}
```
