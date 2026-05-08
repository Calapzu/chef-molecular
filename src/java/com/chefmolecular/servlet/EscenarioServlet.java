package com.chefmolecular.servlet;

import com.chefmolecular.dao.ProgresoDAO;
import com.chefmolecular.logica.EscenarioLogica;
import com.chefmolecular.modelo.Estudiante;
import com.chefmolecular.modelo.ProgresoEscenario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/escenario")
public class EscenarioServlet extends HttpServlet {

    private final EscenarioLogica escLogica   = new EscenarioLogica();
    private final ProgresoDAO     progresoDAO = new ProgresoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/menu");
            return;
        }

        int        idEscenario = Integer.parseInt(idStr);
        Estudiante est         = (Estudiante) req.getSession().getAttribute("estudiante");

        long inicioTotal = System.currentTimeMillis();
        System.out.println("\n========== MEDICION: Cargar Escenario " + idEscenario + " ==========");

        try {
            // Servlet → Lógica
            long inicioLogica = System.currentTimeMillis();
            boolean desbloqueado = escLogica.estaDesbloqueado(est.getIdEstudiante(), idEscenario);
            long finLogica = System.currentTimeMillis();
            System.out.println("[Logica→DAO→BD] estaDesbloqueado: " + (finLogica - inicioLogica) + " ms");

            if (!desbloqueado) {
                res.sendRedirect(req.getContextPath() + "/menu");
                return;
            }

            // DAO → BD
            long inicioDAO = System.currentTimeMillis();
            ProgresoEscenario progreso = progresoDAO.buscar(est.getIdEstudiante(), idEscenario);
            long finDAO = System.currentTimeMillis();
            System.out.println("[DAO→BD] buscarProgreso: " + (finDAO - inicioDAO) + " ms");

            req.setAttribute("idEscenario", idEscenario);
            req.setAttribute("progreso",    progreso);

            long finTotal = System.currentTimeMillis();
            System.out.println("[TOTAL] Cargar Escenario: " + (finTotal - inicioTotal) + " ms");
            System.out.println("=====================================================\n");

            req.getRequestDispatcher("/escenarios/escenario" + idEscenario + ".jsp").forward(req, res);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}