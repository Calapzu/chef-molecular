package com.chefmolecular.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * QuizServlet — DESACTIVADO.
 * El sistema de evaluación fue reemplazado por actividades interactivas
 * gestionadas por ActividadServlet (/actividad).
 * Este servlet redirige al menú para evitar accesos accidentales a /quiz.
 */
@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/menu");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/menu");
    }
}