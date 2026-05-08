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

        long inicioTotal = System.currentTimeMillis();
        System.out.println("\n========== MEDICION: Cargar Perfil ==========");

        try {
            // DAO → BD: insignias
            long t1 = System.currentTimeMillis();
            req.setAttribute("insignias", insigniaDAO.listarTodasConEstado(estudiante.getIdEstudiante()));
            System.out.println("[DAO→BD] listarInsignias: " + (System.currentTimeMillis() - t1) + " ms");

            // DAO → BD: recetas desbloqueadas
            long t2 = System.currentTimeMillis();
            req.setAttribute("recetasDesbloqueadas", recetaDAO.obtenerDesbloqueadas(estudiante.getIdEstudiante()));
            System.out.println("[DAO→BD] obtenerRecetasDesbloqueadas: " + (System.currentTimeMillis() - t2) + " ms");

            // DAO → BD: progresos
            long t3 = System.currentTimeMillis();
            req.setAttribute("progresos", progresoDAO.listarPorEstudiante(estudiante.getIdEstudiante()));
            System.out.println("[DAO→BD] listarProgresos: " + (System.currentTimeMillis() - t3) + " ms");

            System.out.println("[TOTAL] Cargar Perfil: " + (System.currentTimeMillis() - inicioTotal) + " ms");
            System.out.println("=============================================\n");

        } catch (SQLException e) {
            req.setAttribute("error", "Error al cargar el perfil.");
        }

        req.getRequestDispatcher("/perfil.jsp").forward(req, res);
    }
}