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

        long inicioTotal = System.currentTimeMillis();
        System.out.println("\n========== MEDICION: Cargar Libro de Recetas ==========");

        try {
            // DAO → BD: listar recetas con estado
            long t1 = System.currentTimeMillis();
            List<Receta> recetas = recetaDAO.listarTodasConEstado(est.getIdEstudiante());
            System.out.println("[DAO→BD] listarTodasConEstado: " + (System.currentTimeMillis() - t1) + " ms");

            req.setAttribute("recetas", recetas);

            System.out.println("[TOTAL] Cargar Libro de Recetas: " + (System.currentTimeMillis() - inicioTotal) + " ms");
            System.out.println("=======================================================\n");

            req.getRequestDispatcher("/libroRecetas.jsp").forward(req, res);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}