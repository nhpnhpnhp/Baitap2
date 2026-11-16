# Bài tập 2 - CRUD Category bằng JPA (Jakarta Persistence 3.x / Hibernate)

## Chạy và kiểm thử

1. Đảm bảo dịch vụ `MSSQLSERVER` đang chạy.
2. Chạy `scripts/setup-sqlserver.sql` trong SSMS (để tạo bảng `dbo.categories`, `dbo.Videos` và cấp quyền cho `baitap12_app` nếu cần).
3. Kiểm tra `.runtime/db.properties` (copy từ `db.properties.example`).
4. Build và khởi động Tomcat 11 (cổng mặc định `8084`):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\start.ps1
```

Mở trình duyệt tại `http://localhost:8084/baitap2/`.

Dừng server:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\stop.ps1
```
