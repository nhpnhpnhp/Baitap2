package vn.iotstar.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.model.User;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = {"/home", "/admin/home", "/manager/home", "/member/myaccount"})
public class HomeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("account");
        String path = req.getServletPath();
        if (("/admin/home".equals(path) && user.getRoleid() != 1)
                || ("/manager/home".equals(path) && user.getRoleid() != 2)) {
            resp.sendError(403);
            return;
        }
        String view = "/admin/home".equals(path) ? "/views/admin/home.jsp"
                : "/manager/home".equals(path) ? "/views/manager/home.jsp" : "/views/home.jsp";
        req.getRequestDispatcher(view).forward(req, resp);
    }
}
