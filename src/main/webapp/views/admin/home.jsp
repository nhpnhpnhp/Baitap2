<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html><html lang="vi"><head><meta charset="UTF-8"><title>Trang chủ Admin</title><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css"></head><body>
<%@ include file="/views/topbar.jsp" %>
<h2>Trang chủ Admin</h2><p>Xin chào, <c:out value="${sessionScope.account.fullName}"/>.</p>
<p>Tài khoản: <c:out value="${sessionScope.account.userName}"/></p>
<p><a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục (Category)</a></p>
</body></html>
