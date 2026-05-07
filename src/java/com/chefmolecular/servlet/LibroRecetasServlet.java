package com.chefmolecular.servlet;

import com.chefmolecular.dao.RecetaDAO;
import com.chefmolecular.modelo.Estudiante;
import com.chefmolecular.modelo.Receta;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/libroRecetas")
public class LibroRecetasServlet extends HttpServlet {

    private final RecetaDAO recetaDAO = new RecetaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Estudiante est = (Estudiante) req.getSession().getAttribute("estudiante");

        try {
            List<Receta> recetas = recetaDAO.listarTodasConEstado(est.getIdEstudiante());
            req.setAttribute("recetas", recetas);
            req.getRequestDispatcher("/libroRecetas.jsp").forward(req, res);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
