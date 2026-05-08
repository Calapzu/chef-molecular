package com.chefmolecular.logica;

import com.chefmolecular.dao.ActividadDAO;
import com.chefmolecular.dao.ProgresoDAO;
import com.chefmolecular.modelo.ActividadInteractiva;
import com.chefmolecular.modelo.CategoriaActividad;
import com.chefmolecular.modelo.ElementoArrastrable;
import com.chefmolecular.modelo.FenomenoPropiedad;
import com.chefmolecular.modelo.MoleculaPuenteH;
import com.chefmolecular.modelo.ParDipolo;
import com.chefmolecular.modelo.ParPuenteH;
import com.chefmolecular.modelo.PreguntaSimulacionEbullicion;
import com.chefmolecular.modelo.PreguntaSimulacionEstados;
import com.chefmolecular.modelo.ProgresoEscenario;
import com.chefmolecular.modelo.ResultadoActividad;
import org.json.JSONArray;
import org.json.JSONObject;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONException;

public class ActividadLogica {

    private final ActividadDAO actividadDAO = new ActividadDAO();
    private final ProgresoDAO progresoDAO = new ProgresoDAO();

    public List<ActividadInteractiva> obtenerActividadesDelEscenario(int idEscenario) throws SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] obtenerActividadesDelEscenario ---");
        List<ActividadInteractiva> lista = actividadDAO.listarActividadesPorEscenario(idEscenario);
        System.out.println("[DAO→BD] listarActividadesPorEscenario: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("--------------------------------------------------------\n");
        return lista;
    }

    public List<ElementoArrastrable> obtenerElementosDragAndDrop(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] obtenerElementosDragAndDrop ---");
        List<ElementoArrastrable> lista = actividadDAO.listarElementosDragAndDrop(idActividad);
        System.out.println("[DAO→BD] listarElementosDragAndDrop: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("-----------------------------------------------------\n");
        return lista;
    }

    public EvaluacionResultado evaluarDragAndDrop(int idActividad, String respuestasJson) throws SQLException, JSONException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] evaluarDragAndDrop ---");

        long t1 = System.currentTimeMillis();
        List<ElementoArrastrable> elementos = actividadDAO.listarElementosDragAndDrop(idActividad);
        System.out.println("[DAO→BD] listarElementos: " + (System.currentTimeMillis() - t1) + " ms");

        long t2 = System.currentTimeMillis();
        JSONArray respuestas = new JSONArray(respuestasJson);
        Map<Integer, String> respuestasMap = new HashMap<>();
        for (int j = 0; j < respuestas.length(); j++) {
            JSONObject resp = respuestas.getJSONObject(j);
            int id = resp.optInt("idElemento", -1);
            if (id != -1) respuestasMap.put(id, resp.optString("categoria", null));
        }

        int correctos = 0;
        int total = elementos.size();
        for (ElementoArrastrable elemento : elementos) {
            String categoriaSeleccionada = respuestasMap.get(elemento.getIdElemento());
            if (categoriaSeleccionada != null && categoriaSeleccionada.equalsIgnoreCase(elemento.getCategoriaCorrecta())) {
                correctos++;
            }
        }
        System.out.println("[Logica] evaluarRespuestas: " + (System.currentTimeMillis() - t2) + " ms");

        int puntaje = (total > 0) ? (correctos * 100 / total) : 0;
        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos);
        resultado.setIncorrectos(total - correctos);
        resultado.setPuntaje(puntaje);
        resultado.setCompletado(puntaje >= 50);
        resultado.setTotalElementos(total);

        System.out.println("[TOTAL] evaluarDragAndDrop: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("--------------------------------------------\n");
        return resultado;
    }

    public void guardarResultadoActividad(int idEstudiante, int idProgreso, int idActividad,
            EvaluacionResultado evaluacion) throws SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] guardarResultadoActividad ---");

        ResultadoActividad resultado = new ResultadoActividad();
        resultado.setIdActividad(idActividad);
        resultado.setIdEstudiante(idEstudiante);
        resultado.setIdProgreso(idProgreso);
        resultado.setCorrectos(evaluacion.getCorrectos());
        resultado.setIncorrectos(evaluacion.getIncorrectos());
        resultado.setPuntajeObtenido(evaluacion.getPuntaje());
        resultado.setCompletado(evaluacion.isCompletado());

        long t1 = System.currentTimeMillis();
        actividadDAO.guardarResultado(resultado);
        System.out.println("[DAO→BD] guardarResultado: " + (System.currentTimeMillis() - t1) + " ms");

        System.out.println("[TOTAL] guardarResultadoActividad: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("---------------------------------------------------\n");
    }

    public int calcularEstrellasEscenario(int idEstudiante, int idEscenario) throws SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] calcularEstrellasEscenario ---");

        long t1 = System.currentTimeMillis();
        int puntajePromedio = actividadDAO.calcularPuntajeTotalEscenario(idEstudiante, idEscenario);
        System.out.println("[DAO→BD] calcularPuntajeTotalEscenario: " + (System.currentTimeMillis() - t1) + " ms");

        int estrellas;
        if (puntajePromedio >= 90) estrellas = 3;
        else if (puntajePromedio >= 70) estrellas = 2;
        else if (puntajePromedio >= 50) estrellas = 1;
        else estrellas = 0;

        System.out.println("[TOTAL] calcularEstrellasEscenario: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("----------------------------------------------------\n");
        return estrellas;
    }

    public boolean isEscenarioCompletado(int idEstudiante, int idEscenario) throws SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] isEscenarioCompletado ---");

        long t1 = System.currentTimeMillis();
        boolean resultado = actividadDAO.todasActividadesCompletadas(idEstudiante, idEscenario);
        System.out.println("[DAO→BD] todasActividadesCompletadas: " + (System.currentTimeMillis() - t1) + " ms");

        System.out.println("[TOTAL] isEscenarioCompletado: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("-----------------------------------------------\n");
        return resultado;
    }

    public void limpiarResultadosAnteriores(int idEstudiante, int idEscenario) throws SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] limpiarResultadosAnteriores ---");
        //actividadDAO.limpiarResultadosAnteriores(idEstudiante, idEscenario);
        System.out.println("[DAO→BD] limpiarResultadosAnteriores: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("-----------------------------------------------------\n");
    }

    public EvaluacionResultado evaluarMatchDipolos(int idActividad, String respuestasJson) throws JSONException, SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] evaluarMatchDipolos ---");

        long t1 = System.currentTimeMillis();
        List<ParDipolo> paresCorrectos = actividadDAO.listarParesDipolo(idActividad);
        System.out.println("[DAO→BD] listarParesDipolo: " + (System.currentTimeMillis() - t1) + " ms");

        int total = paresCorrectos.size();
        if (total == 0) {
            EvaluacionResultado resultado = new EvaluacionResultado();
            resultado.setCorrectos(0); resultado.setIncorrectos(0);
            resultado.setPuntaje(0); resultado.setCompletado(false); resultado.setTotalElementos(0);
            return resultado;
        }

        long t2 = System.currentTimeMillis();
        JSONArray jsonArray = new JSONArray(respuestasJson);
        Map<String, Boolean> paresAcertados = new HashMap<>();
        int correctos = 0;
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            String pos = obj.getString("extremoPositivo");
            String neg = obj.getString("extremoNegativo");
            String clave = pos + "|" + neg;
            if (paresAcertados.containsKey(clave)) continue;
            for (ParDipolo par : paresCorrectos) {
                if (par.getExtremoPositivo().equals(pos) && par.getExtremoNegativo().equals(neg)) {
                    correctos++; paresAcertados.put(clave, true); break;
                }
            }
        }
        System.out.println("[Logica] evaluarPares: " + (System.currentTimeMillis() - t2) + " ms");

        int puntaje = (correctos * 100 / total);
        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos); resultado.setIncorrectos(total - correctos);
        resultado.setPuntaje(puntaje); resultado.setCompletado(puntaje >= 50); resultado.setTotalElementos(total);

        System.out.println("[TOTAL] evaluarMatchDipolos: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("---------------------------------------------\n");
        return resultado;
    }

    public EvaluacionResultado evaluarMatchPuentesH(int idActividad, String respuestasJson) throws JSONException, SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] evaluarMatchPuentesH ---");

        long t1 = System.currentTimeMillis();
        List<ParPuenteH> paresCorrectos = actividadDAO.listarParesPuenteH(idActividad);
        System.out.println("[DAO→BD] listarParesPuenteH: " + (System.currentTimeMillis() - t1) + " ms");

        long t2 = System.currentTimeMillis();
        JSONArray jsonArray = new JSONArray(respuestasJson);
        int correctos = 0;
        int totalCorrectos = paresCorrectos.size();
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            int id1 = obj.getInt("idMolecula1"); int id2 = obj.getInt("idMolecula2");
            for (ParPuenteH par : paresCorrectos) {
                if ((par.getIdMolecula1()==id1&&par.getIdMolecula2()==id2)||(par.getIdMolecula1()==id2&&par.getIdMolecula2()==id1)) {
                    correctos++; break;
                }
            }
        }
        System.out.println("[Logica] evaluarPuentesH: " + (System.currentTimeMillis() - t2) + " ms");

        int puntaje = totalCorrectos > 0 ? (correctos * 100 / totalCorrectos) : 0;
        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos); resultado.setIncorrectos(jsonArray.length() - correctos);
        resultado.setPuntaje(puntaje); resultado.setCompletado(puntaje >= 50); resultado.setTotalElementos(jsonArray.length());

        System.out.println("[TOTAL] evaluarMatchPuentesH: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("----------------------------------------------\n");
        return resultado;
    }

    public List<CategoriaActividad> obtenerCategoriasPorActividad(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        List<CategoriaActividad> lista = actividadDAO.listarCategoriasPorActividad(idActividad);
        System.out.println("[DAO→BD] listarCategoriasPorActividad: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public List<ParDipolo> obtenerParesDipolo(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        List<ParDipolo> lista = actividadDAO.listarParesDipolo(idActividad);
        System.out.println("[DAO→BD] listarParesDipolo: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public List<MoleculaPuenteH> obtenerMoleculasPuenteH(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        List<MoleculaPuenteH> lista = actividadDAO.listarMoleculasPuenteH(idActividad);
        System.out.println("[DAO→BD] listarMoleculasPuenteH: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public List<PreguntaSimulacionEstados> obtenerPreguntasSimulacionEstados(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        List<PreguntaSimulacionEstados> lista = actividadDAO.listarPreguntasSimulacionEstados(idActividad);
        System.out.println("[DAO→BD] listarPreguntasSimulacionEstados: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public EvaluacionResultado evaluarSimulacionEstados(int idActividad, String respuestasJson) throws JSONException, SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] evaluarSimulacionEstados ---");

        JSONArray array = new JSONArray(respuestasJson);
        int correctos = 0; int total = array.length();
        for (int i = 0; i < total; i++) {
            JSONObject obj = array.getJSONObject(i);
            int idPregunta = obj.getInt("idPregunta");
            int seleccionada = obj.getInt("opcionSeleccionada");
            long t1 = System.currentTimeMillis();
            int correcta = actividadDAO.obtenerRespuestaCorrectaSimulacionEstados(idActividad, idPregunta);
            System.out.println("[DAO→BD] obtenerRespuestaCorrecta: " + (System.currentTimeMillis() - t1) + " ms");
            if (seleccionada == correcta) correctos++;
        }

        int puntaje = total > 0 ? (correctos * 100 / total) : 0;
        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos); resultado.setIncorrectos(total - correctos);
        resultado.setPuntaje(puntaje); resultado.setCompletado(puntaje >= 50); resultado.setTotalElementos(total);

        System.out.println("[TOTAL] evaluarSimulacionEstados: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("-------------------------------------------------\n");
        return resultado;
    }

    public List<FenomenoPropiedad> obtenerFenomenosPropiedad(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        List<FenomenoPropiedad> lista = actividadDAO.listarFenomenosPropiedad(idActividad);
        System.out.println("[DAO→BD] listarFenomenosPropiedad: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public EvaluacionResultado evaluarIdentificacionPropiedad(int idActividad, String respuestasJson) throws JSONException, SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] evaluarIdentificacionPropiedad ---");

        JSONArray jsonArray = new JSONArray(respuestasJson);
        int correctos = 0; int total = jsonArray.length();
        for (int i = 0; i < total; i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            int idFenomeno = obj.getInt("idFenomeno");
            String seleccionada = obj.getString("propiedad");
            long t1 = System.currentTimeMillis();
            String correcta = actividadDAO.obtenerPropiedadCorrecta(idActividad, idFenomeno);
            System.out.println("[DAO→BD] obtenerPropiedadCorrecta: " + (System.currentTimeMillis() - t1) + " ms");
            if (correcta != null && correcta.equals(seleccionada)) correctos++;
        }

        int puntaje = total > 0 ? (correctos * 100 / total) : 0;
        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos); resultado.setIncorrectos(total - correctos);
        resultado.setPuntaje(puntaje); resultado.setCompletado(puntaje >= 50); resultado.setTotalElementos(total);

        System.out.println("[TOTAL] evaluarIdentificacionPropiedad: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("--------------------------------------------------------\n");
        return resultado;
    }

    public List<PreguntaSimulacionEbullicion> obtenerPreguntasSimulacionEbullicion(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        List<PreguntaSimulacionEbullicion> lista = actividadDAO.listarPreguntasSimulacionEbullicion(idActividad);
        System.out.println("[DAO→BD] listarPreguntasSimulacionEbullicion: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public EvaluacionResultado evaluarSimulacionEbullicion(int idActividad, String respuestasJson) throws JSONException, SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [ActividadLogica] evaluarSimulacionEbullicion ---");

        JSONArray jsonArray = new JSONArray(respuestasJson);
        int correctos = 0; int total = jsonArray.length();
        for (int i = 0; i < total; i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            int idPregunta = obj.getInt("idPregunta");
            int seleccionada = obj.getInt("opcionSeleccionada");
            long t1 = System.currentTimeMillis();
            int correcta = actividadDAO.obtenerRespuestaCorrectaEbullicion(idActividad, idPregunta);
            System.out.println("[DAO→BD] obtenerRespuestaCorrectaEbullicion: " + (System.currentTimeMillis() - t1) + " ms");
            if (seleccionada == correcta) correctos++;
        }

        int puntaje = total > 0 ? (correctos * 100 / total) : 0;
        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos); resultado.setIncorrectos(total - correctos);
        resultado.setPuntaje(puntaje); resultado.setCompletado(puntaje >= 50); resultado.setTotalElementos(total);

        System.out.println("[TOTAL] evaluarSimulacionEbullicion: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("-----------------------------------------------------\n");
        return resultado;
    }

    public ActividadInteractiva obtenerActividadPorId(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        ActividadInteractiva actividad = actividadDAO.obtenerActividadPorId(idActividad);
        System.out.println("[DAO→BD] obtenerActividadPorId: " + (System.currentTimeMillis() - inicio) + " ms");
        return actividad;
    }

    // =============================================
    // CLASE INTERNA PARA RESULTADO DE EVALUACIÓN
    // =============================================
    public static class EvaluacionResultado {

        private int correctos;
        private int incorrectos;
        private int puntaje;
        private boolean completado;
        private int totalElementos;

        public int getCorrectos() { return correctos; }
        public void setCorrectos(int correctos) { this.correctos = correctos; }
        public int getIncorrectos() { return incorrectos; }
        public void setIncorrectos(int incorrectos) { this.incorrectos = incorrectos; }
        public int getPuntaje() { return puntaje; }
        public void setPuntaje(int puntaje) { this.puntaje = puntaje; }
        public boolean isCompletado() { return completado; }
        public void setCompletado(boolean completado) { this.completado = completado; }
        public int getTotalElementos() { return totalElementos; }
        public void setTotalElementos(int totalElementos) { this.totalElementos = totalElementos; }
    }
}