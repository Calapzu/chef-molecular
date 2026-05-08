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

        long inicioTotal = System.currentTimeMillis();
        System.out.println("\n========== MEDICION: Cargar Menú ==========");

        try {
            // JSP → Servlet
            long inicioServlet = System.currentTimeMillis();
            System.out.println("[Servlet] Solicitud recibida");

            // Servlet → Lógica → DAO → BD
            long inicioDAO = System.currentTimeMillis();
            List<ProgresoEscenario> progresos = progresoDAO.listarPorEstudiante(est.getIdEstudiante());
            long finDAO = System.currentTimeMillis();
            System.out.println("[DAO→BD] listarPorEstudiante: " + (finDAO - inicioDAO) + " ms");

            // Lógica de gamificación
            long inicioLogica = System.currentTimeMillis();
            String rangoTexto = gamLogica.rangoTexto(est.getRango());
            long finLogica = System.currentTimeMillis();
            System.out.println("[Logica] rangoTexto: " + (finLogica - inicioLogica) + " ms");

            req.setAttribute("progresos", progresos);
            req.setAttribute("rangoTexto", rangoTexto);

            long finServlet = System.currentTimeMillis();
            System.out.println("[Servlet] Procesamiento total servlet: " + (finServlet - inicioServlet) + " ms");
            System.out.println("[TOTAL] Cargar Menú: " + (finServlet - inicioTotal) + " ms");
            System.out.println("===========================================\n");

            req.getRequestDispatcher("/menu.jsp").forward(req, res);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}