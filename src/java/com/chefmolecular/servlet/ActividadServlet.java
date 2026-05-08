package com.chefmolecular.servlet;

import com.chefmolecular.dao.ProgresoDAO;
import com.chefmolecular.logica.ActividadLogica;
import com.chefmolecular.logica.EscenarioLogica;
import com.chefmolecular.logica.GamificacionLogica;
import com.chefmolecular.modelo.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import org.json.JSONException;

@WebServlet("/actividad")
public class ActividadServlet extends HttpServlet {

    private final ActividadLogica actividadLogica = new ActividadLogica();
    private final EscenarioLogica escenarioLogica = new EscenarioLogica();
    private final ProgresoDAO progresoDAO = new ProgresoDAO();
    private final GamificacionLogica gamificacionLogica = new GamificacionLogica();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idEscStr = request.getParameter("escenario");
        if (idEscStr == null) {
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        int idEscenario = Integer.parseInt(idEscStr);
        Estudiante estudiante = (Estudiante) request.getSession().getAttribute("estudiante");

        try {
            if (!escenarioLogica.estaDesbloqueado(estudiante.getIdEstudiante(), idEscenario)) {
                response.sendRedirect(request.getContextPath() + "/menu");
                return;
            }

            ProgresoEscenario progreso = progresoDAO.buscar(estudiante.getIdEstudiante(), idEscenario);
            List<ActividadInteractiva> actividades = actividadLogica.obtenerActividadesDelEscenario(idEscenario);

            if (actividades == null || actividades.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/menu");
                return;
            }

            String idxStr = request.getParameter("actividadIdx");
            int actividadIdx = (idxStr != null) ? Integer.parseInt(idxStr) : 0;

            if (actividadIdx >= actividades.size()) {
                response.sendRedirect(request.getContextPath() + "/resultadoActividad.jsp?escenario=" + idEscenario);
                return;
            }

            ActividadInteractiva actividadActual = actividades.get(actividadIdx);
            boolean yaCompletada = actividadLogica.isEscenarioCompletado(estudiante.getIdEstudiante(), idEscenario);

            // Cargar datos según tipo
            if ("DRAG_AND_DROP".equals(actividadActual.getTipo())) {
                List<ElementoArrastrable> elementos = actividadLogica.obtenerElementosDragAndDrop(actividadActual.getIdActividad());
                List<CategoriaActividad> categorias = actividadLogica.obtenerCategoriasPorActividad(actividadActual.getIdActividad());
                request.setAttribute("elementos", elementos);
                request.setAttribute("categorias", categorias);

            } else if ("MATCH_DIPOLOS".equals(actividadActual.getTipo())) {
                List<ParDipolo> pares = actividadLogica.obtenerParesDipolo(actividadActual.getIdActividad());
                request.setAttribute("pares", pares);

            } else if ("MATCH_PUENTES_H".equals(actividadActual.getTipo())) {
                List<MoleculaPuenteH> moleculas = actividadLogica.obtenerMoleculasPuenteH(actividadActual.getIdActividad());
                request.setAttribute("moleculas", moleculas);

            } else if ("SIMULACION_ESTADOS".equals(actividadActual.getTipo())) {
                List<PreguntaSimulacionEstados> preguntas = actividadLogica.obtenerPreguntasSimulacionEstados(actividadActual.getIdActividad());
                request.setAttribute("preguntas", preguntas);

            } else if ("IDENTIFICACION_PROPIEDAD".equals(actividadActual.getTipo())) {
                List<FenomenoPropiedad> fenomenos = actividadLogica.obtenerFenomenosPropiedad(actividadActual.getIdActividad());
                request.setAttribute("fenomenos", fenomenos);

            } else if ("SIMULACION_EBULLICION".equals(actividadActual.getTipo())) {
                List<PreguntaSimulacionEbullicion> preguntas = actividadLogica.obtenerPreguntasSimulacionEbullicion(actividadActual.getIdActividad());
                request.setAttribute("preguntas", preguntas);
            }

            request.setAttribute("actividad", actividadActual);
            request.setAttribute("actividades", actividades);
            request.setAttribute("actividadIdx", actividadIdx);
            request.setAttribute("totalActividades", actividades.size());
            request.setAttribute("idEscenario", idEscenario);
            request.setAttribute("progreso", progreso);
            request.setAttribute("yaCompletada", yaCompletada);

            request.getRequestDispatcher("/actividad.jsp").forward(request, response);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Estudiante estudiante = (Estudiante) request.getSession().getAttribute("estudiante");
        int idEscenario = Integer.parseInt(request.getParameter("idEscenario"));
        int idActividad = Integer.parseInt(request.getParameter("idActividad"));
        int actividadIdx = Integer.parseInt(request.getParameter("actividadIdx"));
        String respuestasJson = request.getParameter("respuestas");

        System.out.println("=== Respuestas recibidas: " + respuestasJson);

        try {
            ProgresoEscenario progreso = progresoDAO.buscar(estudiante.getIdEstudiante(), idEscenario);
            if (progreso == null) {
                request.getSession().setAttribute("mensajeError", "Progreso no encontrado.");
                response.sendRedirect(request.getContextPath() + "/escenario?id=" + idEscenario);
                return;
            }

            ActividadInteractiva actividad = actividadLogica.obtenerActividadPorId(idActividad);
            System.out.println("=== Actividad tipo: " + actividad.getTipo());
            if (actividad == null) {
                request.getSession().setAttribute("mensajeError", "Actividad no encontrada.");
                response.sendRedirect(request.getContextPath() + "/escenario?id=" + idEscenario);
                return;
            }

            ActividadLogica.EvaluacionResultado evaluacion = null;
            try {
                // Evaluar según el tipo
                if ("DRAG_AND_DROP".equals(actividad.getTipo())) {
                    evaluacion = actividadLogica.evaluarDragAndDrop(idActividad, respuestasJson);
                } else if ("MATCH_DIPOLOS".equals(actividad.getTipo())) {
                    evaluacion = actividadLogica.evaluarMatchDipolos(idActividad, respuestasJson);
                } else if ("MATCH_PUENTES_H".equals(actividad.getTipo())) {
                    evaluacion = actividadLogica.evaluarMatchPuentesH(idActividad, respuestasJson);
                } else if ("SIMULACION_ESTADOS".equals(actividad.getTipo())) {
                    evaluacion = actividadLogica.evaluarSimulacionEstados(idActividad, respuestasJson);
                } else if ("IDENTIFICACION_PROPIEDAD".equals(actividad.getTipo())) {
                    evaluacion = actividadLogica.evaluarIdentificacionPropiedad(idActividad, respuestasJson);
                } else if ("SIMULACION_EBULLICION".equals(actividad.getTipo())) {
                    evaluacion = actividadLogica.evaluarSimulacionEbullicion(idActividad, respuestasJson);
                } else {
                    request.getSession().setAttribute("mensajeError", "Tipo de actividad no soportado.");
                    response.sendRedirect(request.getContextPath() + "/escenario?id=" + idEscenario);
                    return;
                }
            } catch (JSONException e) {
                request.getSession().setAttribute("mensajeError", "Formato de respuestas inválido. Intenta de nuevo.");
                response.sendRedirect(request.getContextPath() + "/escenario?id=" + idEscenario);
                return;
            }

            actividadLogica.guardarResultadoActividad(estudiante.getIdEstudiante(), progreso.getIdProgreso(),
                    idActividad, evaluacion);

            boolean todasCompletadas = actividadLogica.isEscenarioCompletado(estudiante.getIdEstudiante(), idEscenario);

            if (todasCompletadas) {
                int estrellas = actividadLogica.calcularEstrellasEscenario(estudiante.getIdEstudiante(), idEscenario);
                boolean completado = estrellas >= 1;
                progresoDAO.actualizarProgreso(estudiante.getIdEstudiante(), idEscenario, estrellas, completado);

                if (completado) {
                    progresoDAO.desbloquearSiguiente(estudiante.getIdEstudiante(), idEscenario);
                    gamificacionLogica.procesarLogros(estudiante.getIdEstudiante(), idEscenario);
                }

                com.chefmolecular.dao.EstudianteDAO estudianteDAO = new com.chefmolecular.dao.EstudianteDAO();
                request.getSession().setAttribute("estudiante", estudianteDAO.buscarPorId(estudiante.getIdEstudiante()));

                request.getSession().setAttribute("mensajeExito",
                        String.format("¡Felicitaciones! Completaste el escenario. Has ganado %d estrellas.", estrellas));

                response.sendRedirect(request.getContextPath() + "/resultadoActividad.jsp?escenario=" + idEscenario);

            } else {
                int siguienteIdx = actividadIdx + 1;
                response.sendRedirect(request.getContextPath() + "/actividad?escenario=" + idEscenario + "&actividadIdx=" + siguienteIdx);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
