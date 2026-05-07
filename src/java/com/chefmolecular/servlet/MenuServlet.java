package com.chefmolecular.servlet;

import com.chefmolecular.dao.ProgresoDAO;
import com.chefmolecular.logica.GamificacionLogica;
import com.chefmolecular.modelo.Estudiante;
import com.chefmolecular.modelo.ProgresoEscenario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private final ProgresoDAO        progresoDAO = new ProgresoDAO();
    private final GamificacionLogica gamLogica   = new GamificacionLogica();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        Estudiante est = (Estudiante) req.getSession().getAttribute("estudiante");
        try {
            List<ProgresoEscenario> progresos = progresoDAO.listarPorEstudiante(est.getIdEstudiante());
            req.setAttribute("progresos", progresos);
            req.setAttribute("rangoTexto", gamLogica.rangoTexto(est.getRango()));
            req.getRequestDispatcher("/menu.jsp").forward(req, res);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}