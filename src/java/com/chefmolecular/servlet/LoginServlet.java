package com.chefmolecular.servlet;

import com.chefmolecular.logica.AutenticacionLogica;
import com.chefmolecular.modelo.Estudiante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AutenticacionLogica logica = new AutenticacionLogica();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String correo   = req.getParameter("correo");
        String password = req.getParameter("password");

        try {
            Estudiante estudiante = logica.login(correo, password);
            if (estudiante == null) {
                req.setAttribute("error", "Correo o contraseña incorrectos.");
                req.getRequestDispatcher("/index.jsp").forward(req, res);
                return;
            }
            HttpSession session = req.getSession(true);
            session.setAttribute("estudiante", estudiante);
            res.sendRedirect(req.getContextPath() + "/menu");
        } catch (SQLException ex) {
            req.setAttribute("error", "Error de base de datos.");
            req.getRequestDispatcher("/index.jsp").forward(req, res);
        }
    }
}
