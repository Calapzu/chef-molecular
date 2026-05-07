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

        // Si no viene el parámetro, volver al menú
        if (idStr == null || idStr.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/menu");
            return;
        }

        int        idEscenario = Integer.parseInt(idStr);
        Estudiante est         = (Estudiante) req.getSession().getAttribute("estudiante");

        try {
            // Verificar que el escenario está desbloqueado para este estudiante
            if (!escLogica.estaDesbloqueado(est.getIdEstudiante(), idEscenario)) {
                res.sendRedirect(req.getContextPath() + "/menu");
                return;
            }

            // Obtener progreso del escenario para mostrarlo en la vista
            ProgresoEscenario progreso = progresoDAO.buscar(est.getIdEstudiante(), idEscenario);

            req.setAttribute("idEscenario", idEscenario);
            req.setAttribute("progreso",    progreso);

            // Redirigir a la JSP correspondiente según el número de escenario
            req.getRequestDispatcher("/escenarios/escenario" + idEscenario + ".jsp")
               .forward(req, res);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
