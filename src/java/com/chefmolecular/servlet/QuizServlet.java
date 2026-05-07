package com.chefmolecular.servlet;

import com.chefmolecular.logica.EscenarioLogica;
import com.chefmolecular.logica.GamificacionLogica;
import com.chefmolecular.modelo.Estudiante;
import com.chefmolecular.modelo.Pregunta;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {

    private final EscenarioLogica   escLogica = new EscenarioLogica();
    private final GamificacionLogica gamLogica = new GamificacionLogica();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String idEscStr = req.getParameter("escenario");
        if (idEscStr == null) { res.sendRedirect(req.getContextPath() + "/menu"); return; }

        int idEscenario = Integer.parseInt(idEscStr);
        Estudiante est = (Estudiante) req.getSession().getAttribute("estudiante");

        try {
            // Verificar que el escenario está desbloqueado
            if (!escLogica.estaDesbloqueado(est.getIdEstudiante(), idEscenario)) {
                res.sendRedirect(req.getContextPath() + "/menu");
                return;
            }
            List<Pregunta> preguntas = escLogica.obtenerPreguntas(idEscenario);
            req.setAttribute("preguntas", preguntas);
            req.setAttribute("idEscenario", idEscenario);
            req.getRequestDispatcher("/quiz.jsp").forward(req, res);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Estudiante est = (Estudiante) req.getSession().getAttribute("estudiante");
        int idEscenario = Integer.parseInt(req.getParameter("idEscenario"));

        try {
            List<Pregunta> preguntas = escLogica.obtenerPreguntas(idEscenario);
            int correctas = 0;
            for (Pregunta p : preguntas) {
                String resp = req.getParameter("pregunta_" + p.getIdPregunta());
                if (resp != null && Integer.parseInt(resp) == p.getRespuestaCorrecta()) correctas++;
            }

            escLogica.guardarResultado(est.getIdEstudiante(), idEscenario, correctas, preguntas.size());
            gamLogica.procesarLogros(est.getIdEstudiante(), idEscenario);

            // Refrescar datos del estudiante en sesión
            int puntaje   = escLogica.calcularPuntaje(correctas, preguntas.size());
            int estrellas = escLogica.calcularEstrellas(puntaje, idEscenario, correctas);
            req.getSession().setAttribute("estudiante",
                new com.chefmolecular.dao.EstudianteDAO().buscarPorId(est.getIdEstudiante()));

            req.setAttribute("correctas",   correctas);
            req.setAttribute("total",       preguntas.size());
            req.setAttribute("puntaje",     puntaje);
            req.setAttribute("estrellas",   estrellas);
            req.setAttribute("idEscenario", idEscenario);
            req.getRequestDispatcher("/resultado.jsp").forward(req, res);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
