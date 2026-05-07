package com.chefmolecular.servlet;

import com.chefmolecular.dao.InsigniaDAO;
import com.chefmolecular.dao.RecetaDAO;
import com.chefmolecular.dao.ProgresoDAO;
import com.chefmolecular.modelo.Estudiante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {

    private final InsigniaDAO insigniaDAO = new InsigniaDAO();
    private final RecetaDAO   recetaDAO   = new RecetaDAO();
    private final ProgresoDAO progresoDAO = new ProgresoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session   = req.getSession(false);
        Estudiante estudiante = (Estudiante) session.getAttribute("estudiante");

        try {
            req.setAttribute("insignias",
                insigniaDAO.listarTodasConEstado(estudiante.getIdEstudiante()));
            req.setAttribute("recetasDesbloqueadas",
                recetaDAO.obtenerDesbloqueadas(estudiante.getIdEstudiante()));
            req.setAttribute("progresos",
                progresoDAO.listarPorEstudiante(estudiante.getIdEstudiante()));
        } catch (SQLException e) {
            req.setAttribute("error", "Error al cargar el perfil.");
        }

        req.getRequestDispatcher("/perfil.jsp").forward(req, res);
    }
}