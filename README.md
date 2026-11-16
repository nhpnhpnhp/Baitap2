# Bài tập 2 - CRUD Category bằng JPA (Jakarta Persistence 3.x / Hibernate)

Ứng dụng Java Web JSP/Servlet nâng cấp từ Bài tập 1.2 sang **JPA + Hibernate ORM** trên Tomcat 11 và SQL Server.

## Cấu trúc chính

- `src/main/resources/META-INF/persistence.xml`: cấu hình Persistence Unit `jpa-hibernate-mysql`.
- `vn.iotstar.config.JPAConfig`: quản lý singleton `EntityManagerFactory` và đóng khi Tomcat tắt; hỗ trợ ghi đè thông số kết nối từ `.runtime/db.properties` hoặc biến môi trường (`DB_URL`, `DB_USER`, `DB_PASSWORD`).
- `vn.iotstar.entity.Category`, `vn.iotstar.entity.Video`: ánh xạ `@Entity`, `@Table`, `@OneToMany` / `@ManyToOne`.
- `vn.iotstar.dao.ICategoryDao`, `vn.iotstar.dao.impl.CategoryDao`: thao tác JPA (`persist`, `merge`, `find`, `remove`, JPQL, phân trang, đếm).
- `vn.iotstar.service.ICategoryService`, `vn.iotstar.service.impl.CategoryServiceImpl`.
- `vn.iotstar.controller.CategoryController`: `/admin/categories`, `/admin/category/add`, `/admin/category/insert`, `/admin/category/edit`, `/admin/category/update`, `/admin/category/delete`.
- `vn.iotstar.controller.DownloadImageController`: `/image`.
- `src/main/webapp/views/admin/`: `category-list.jsp`, `category-add.jsp`, `category-edit.jsp`.

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
