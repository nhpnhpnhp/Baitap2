package vn.iotstar.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import vn.iotstar.util.Constant;

import java.io.*;

@WebServlet(urlPatterns = "/image")
public class DownloadImageController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fileName = req.getParameter("fname");
        if (fileName == null || fileName.contains("/") || fileName.contains("\\")) {
            resp.sendError(404);
            return;
        }
        File file = new File(Constant.DIR + "/" + fileName);
        String contentType = getServletContext().getMimeType(file.getName());
        resp.setContentType(contentType == null ? "application/octet-stream" : contentType);
        if (file.isFile()) {
            try (FileInputStream input = new FileInputStream(file)) {
                input.transferTo(resp.getOutputStream());
            }
        } else {
            resp.sendError(404);
        }
    }
}
