package com.chefmolecular.servlet;

import com.chefmolecular.logica.RankingLogica;
import com.chefmolecular.modelo.Estudiante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ranking")
public class RankingServlet extends HttpServlet {

    private final RankingLogica rankingLogica = new RankingLogica();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Estudiante est = (Estudiante) req.getSession().getAttribute("estudiante");

        try {
            List<Estudiante> top10    = rankingLogica.obtenerTop10();
            int              posicion = rankingLogica.obtenerPosicion(est.getIdEstudiante());

            req.setAttribute("top10",    top10);
            req.setAttribute("posicion", posicion);
            req.setAttribute("idActual", est.getIdEstudiante());
            req.getRequestDispatcher("/ranking.jsp").forward(req, res);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
