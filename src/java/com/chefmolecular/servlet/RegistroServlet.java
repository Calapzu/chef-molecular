package com.chefmolecular.servlet;

import com.chefmolecular.logica.AutenticacionLogica;
import com.chefmolecular.modelo.Estudiante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    private final AutenticacionLogica logica = new AutenticacionLogica();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String nombre   = req.getParameter("nombre");
        String correo   = req.getParameter("correo");
        String password = req.getParameter("password");

        String error = logica.registrar(nombre, correo, password);

        if (error != null) {
            req.setAttribute("error", error);
            req.getRequestDispatcher("/registro.jsp").forward(req, res);
            return;
        }

        // Login automático tras registro exitoso
        try {
            Estudiante estudiante = logica.login(correo, password);
            HttpSession session = req.getSession(true);
            session.setAttribute("estudiante", estudiante);
            res.sendRedirect(req.getContextPath() + "/menu");
        } catch (SQLException ex) {
            req.setAttribute("error", "Error al iniciar sesión automáticamente.");
            req.getRequestDispatcher("/registro.jsp").forward(req, res);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/registro.jsp").forward(req, res);
    }
}
