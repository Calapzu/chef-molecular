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

        long inicioTotal = System.currentTimeMillis();
        System.out.println("\n========== MEDICION: Cargar Ranking ==========");

        try {
            // Lógica → DAO → BD: top 10
            long t1 = System.currentTimeMillis();
            List<Estudiante> top10 = rankingLogica.obtenerTop10();
            System.out.println("[Logica→DAO→BD] obtenerTop10: " + (System.currentTimeMillis() - t1) + " ms");

            // Lógica → DAO → BD: posición del estudiante
            long t2 = System.currentTimeMillis();
            int posicion = rankingLogica.obtenerPosicion(est.getIdEstudiante());
            System.out.println("[Logica→DAO→BD] obtenerPosicion: " + (System.currentTimeMillis() - t2) + " ms");

            req.setAttribute("top10",    top10);
            req.setAttribute("posicion", posicion);
            req.setAttribute("idActual", est.getIdEstudiante());

            System.out.println("[TOTAL] Cargar Ranking: " + (System.currentTimeMillis() - inicioTotal) + " ms");
            System.out.println("==============================================\n");

            req.getRequestDispatcher("/ranking.jsp").forward(req, res);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}