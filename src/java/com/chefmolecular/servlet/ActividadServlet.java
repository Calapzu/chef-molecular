package com.chefmolecular.servlet;

import com.chefmolecular.dao.ProgresoDAO;
import com.chefmolecular.logica.ActividadLogica;
import com.chefmolecular.logica.EscenarioLogica;
import com.chefmolecular.logica.GamificacionLogica;
import com.chefmolecular.logica.RankingLogica;
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

        long inicioTotal = System.currentTimeMillis();
        System.out.println("\n========== MEDICION: Cargar Actividad (Escenario " + idEscenario + ") ==========");

        try {
            // Lógica → DAO → BD: verificar desbloqueo
            long t1 = System.currentTimeMillis();
            boolean desbloqueado = escenarioLogica.estaDesbloqueado(estudiante.getIdEstudiante(), idEscenario);
            System.out.println("[Logica→DAO→BD] estaDesbloqueado: " + (System.currentTimeMillis() - t1) + " ms");

            if (!desbloqueado) {
                response.sendRedirect(request.getContextPath() + "/menu");
                return;
            }

            // DAO → BD: obtener progreso
            long t2 = System.currentTimeMillis();
            ProgresoEscenario progreso = progresoDAO.buscar(estudiante.getIdEstudiante(), idEscenario);
            System.out.println("[DAO→BD] buscarProgreso: " + (System.currentTimeMillis() - t2) + " ms");

            // Lógica → DAO → BD: obtener actividades
            long t3 = System.currentTimeMillis();
            List<ActividadInteractiva> actividades = actividadLogica.obtenerActividadesDelEscenario(idEscenario);
            System.out.println("[Logica→DAO→BD] obtenerActividades: " + (System.currentTimeMillis() - t3) + " ms");

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
            if (actividadIdx == 0) {
                actividadLogica.limpiarResultadosAnteriores(estudiante.getIdEstudiante(), idEscenario);
            }

            ActividadInteractiva actividadActual = actividades.get(actividadIdx);

            // Lógica → DAO → BD: verificar si ya completó
            long t4 = System.currentTimeMillis();
            boolean yaCompletada = actividadLogica.isEscenarioCompletado(estudiante.getIdEstudiante(), idEscenario);
            System.out.println("[Logica→DAO→BD] isEscenarioCompletado: " + (System.currentTimeMillis() - t4) + " ms");

            // DAO → BD: cargar datos según tipo
            long t5 = System.currentTimeMillis();
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
            System.out.println("[DAO→BD] cargarDatosActividad (" + actividadActual.getTipo() + "): " + (System.currentTimeMillis() - t5) + " ms");

            request.setAttribute("actividad", actividadActual);
            request.setAttribute("actividades", actividades);
            request.setAttribute("actividadIdx", actividadIdx);
            request.setAttribute("totalActividades", actividades.size());
            request.setAttribute("idEscenario", idEscenario);
            request.setAttribute("progreso", progreso);
            request.setAttribute("yaCompletada", yaCompletada);

            System.out.println("[TOTAL] Cargar Actividad: " + (System.currentTimeMillis() - inicioTotal) + " ms");
            System.out.println("=============================================================\n");

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

        long inicioTotal = System.currentTimeMillis();
        System.out.println("\n========== MEDICION: Enviar Respuesta Actividad ==========");

        try {
            // DAO → BD: buscar progreso
            long t1 = System.currentTimeMillis();
            ProgresoEscenario progreso = progresoDAO.buscar(estudiante.getIdEstudiante(), idEscenario);
            System.out.println("[DAO→BD] buscarProgreso: " + (System.currentTimeMillis() - t1) + " ms");

            if (progreso == null) {
                request.getSession().setAttribute("mensajeError", "Progreso no encontrado.");
                response.sendRedirect(request.getContextPath() + "/escenario?id=" + idEscenario);
                return;
            }

            // DAO → BD: obtener actividad
            long t2 = System.currentTimeMillis();
            ActividadInteractiva actividad = actividadLogica.obtenerActividadPorId(idActividad);
            System.out.println("[DAO→BD] obtenerActividadPorId: " + (System.currentTimeMillis() - t2) + " ms");

            if (actividad == null) {
                request.getSession().setAttribute("mensajeError", "Actividad no encontrada.");
                response.sendRedirect(request.getContextPath() + "/escenario?id=" + idEscenario);
                return;
            }

            // Lógica: evaluar respuesta
            long t3 = System.currentTimeMillis();
            ActividadLogica.EvaluacionResultado evaluacion = null;
            try {
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
                }
            } catch (org.json.JSONException e) {
                request.getSession().setAttribute("mensajeError", "Formato de respuestas inválido.");
                response.sendRedirect(request.getContextPath() + "/escenario?id=" + idEscenario);
                return;
            }
            System.out.println("[Logica→DAO→BD] evaluarRespuesta (" + actividad.getTipo() + "): " + (System.currentTimeMillis() - t3) + " ms");

            // DAO → BD: guardar resultado
            long t4 = System.currentTimeMillis();
            actividadLogica.guardarResultadoActividad(estudiante.getIdEstudiante(), progreso.getIdProgreso(), idActividad, evaluacion);
            System.out.println("[DAO→BD] guardarResultadoActividad: " + (System.currentTimeMillis() - t4) + " ms");

            // Lógica → DAO → BD: verificar si completó todo
            long t5 = System.currentTimeMillis();
            boolean todasCompletadas = actividadLogica.isEscenarioCompletado(estudiante.getIdEstudiante(), idEscenario);
            System.out.println("[Logica→DAO→BD] isEscenarioCompletado: " + (System.currentTimeMillis() - t5) + " ms");

            if (todasCompletadas) {
                // Lógica: calcular estrellas
                long t6 = System.currentTimeMillis();
                int estrellas = actividadLogica.calcularEstrellasEscenario(estudiante.getIdEstudiante(), idEscenario);
                System.out.println("[Logica→DAO→BD] calcularEstrellas: " + (System.currentTimeMillis() - t6) + " ms");

                boolean completado = estrellas >= 1;

                // DAO → BD: actualizar progreso
                long t7 = System.currentTimeMillis();
                progresoDAO.actualizarProgreso(estudiante.getIdEstudiante(), idEscenario, estrellas, completado);
                System.out.println("[DAO→BD] actualizarProgreso: " + (System.currentTimeMillis() - t7) + " ms");

                if (completado) {
                    progresoDAO.desbloquearSiguiente(estudiante.getIdEstudiante(), idEscenario);
                    gamificacionLogica.procesarLogros(estudiante.getIdEstudiante(), idEscenario);
                }

                com.chefmolecular.dao.EstudianteDAO estudianteDAO = new com.chefmolecular.dao.EstudianteDAO();
                request.getSession().setAttribute("estudiante", estudianteDAO.buscarPorId(estudiante.getIdEstudiante()));

                // ----- NUEVO: Pantalla de logros para Escenario 6 -----
                if (idEscenario == 6) {
                    List<Insignia> insignias = gamificacionLogica.obtenerInsigniasNuevas(estudiante.getIdEstudiante());
                    String rangoTexto = gamificacionLogica.rangoTexto(estudiante.getRango());
                    RankingLogica rankingLogica = new RankingLogica();
                    int posicion = rankingLogica.obtenerPosicion(estudiante.getIdEstudiante());

                    request.getSession().setAttribute("estrellasFinales", estrellas);
                    request.getSession().setAttribute("rangoFinal", rangoTexto);
                    request.getSession().setAttribute("insigniasNuevas", insignias);
                    request.getSession().setAttribute("posicionRanking", posicion);

                    System.out.println("[TOTAL] Enviar Respuesta (escenario 6 completado → logros): " + (System.currentTimeMillis() - inicioTotal) + " ms");
                    System.out.println("===========================================================\n");

                    response.sendRedirect(request.getContextPath() + "/logrosFinales.jsp");
                } else {
                    // Comportamiento original para otros escenarios
                    request.getSession().setAttribute("mensajeExito",
                            String.format("¡Felicitaciones! Completaste el escenario. Has ganado %d estrellas.", estrellas));

                    System.out.println("[TOTAL] Enviar Respuesta (escenario completado): " + (System.currentTimeMillis() - inicioTotal) + " ms");
                    System.out.println("===========================================================\n");

                    response.sendRedirect(request.getContextPath() + "/resultadoActividad.jsp?escenario=" + idEscenario);
                }

            } else {
                int siguienteIdx = actividadIdx + 1;
                System.out.println("[TOTAL] Enviar Respuesta (siguiente actividad " + siguienteIdx + "): " + (System.currentTimeMillis() - inicioTotal) + " ms");
                System.out.println("===========================================================\n");

                response.sendRedirect(request.getContextPath() + "/actividad?escenario=" + idEscenario + "&actividadIdx=" + siguienteIdx);
            }

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
