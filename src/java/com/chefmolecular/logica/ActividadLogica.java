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
        return actividadDAO.listarActividadesPorEscenario(idEscenario);
    }

    public List<ElementoArrastrable> obtenerElementosDragAndDrop(int idActividad) throws SQLException {
        return actividadDAO.listarElementosDragAndDrop(idActividad);
    }

    public EvaluacionResultado evaluarDragAndDrop(int idActividad, String respuestasJson) throws SQLException, JSONException {
        List<ElementoArrastrable> elementos = actividadDAO.listarElementosDragAndDrop(idActividad);
        JSONArray respuestas = new JSONArray(respuestasJson);

        Map<Integer, String> respuestasMap = new HashMap<>();
        for (int j = 0; j < respuestas.length(); j++) {
            JSONObject resp = respuestas.getJSONObject(j);
            int id = resp.optInt("idElemento", -1);
            if (id != -1) {
                respuestasMap.put(id, resp.optString("categoria", null));
            }
        }

        int correctos = 0;
        int total = elementos.size();

        for (ElementoArrastrable elemento : elementos) {
            String categoriaSeleccionada = respuestasMap.get(elemento.getIdElemento());
            if (categoriaSeleccionada != null
                    && categoriaSeleccionada.equalsIgnoreCase(elemento.getCategoriaCorrecta())) {
                correctos++;
            }
        }

        int puntaje = (total > 0) ? (correctos * 100 / total) : 0;

        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos);
        resultado.setIncorrectos(total - correctos);
        resultado.setPuntaje(puntaje);
        resultado.setCompletado(puntaje >= 50);
        resultado.setTotalElementos(total);

        return resultado;
    }

    public void guardarResultadoActividad(int idEstudiante, int idProgreso, int idActividad,
            EvaluacionResultado evaluacion) throws SQLException {
        ResultadoActividad resultado = new ResultadoActividad();
        resultado.setIdActividad(idActividad);
        resultado.setIdEstudiante(idEstudiante);
        resultado.setIdProgreso(idProgreso);
        resultado.setCorrectos(evaluacion.getCorrectos());
        resultado.setIncorrectos(evaluacion.getIncorrectos());
        resultado.setPuntajeObtenido(evaluacion.getPuntaje());
        resultado.setCompletado(evaluacion.isCompletado());

        actividadDAO.guardarResultado(resultado);
    }

    public int calcularEstrellasEscenario(int idEstudiante, int idEscenario) throws SQLException {
        int puntajePromedio = actividadDAO.calcularPuntajeTotalEscenario(idEstudiante, idEscenario);
        if (puntajePromedio >= 90) {
            return 3;
        }
        if (puntajePromedio >= 70) {
            return 2;
        }
        if (puntajePromedio >= 50) {
            return 1;
        }
        return 0;
    }

    public boolean isEscenarioCompletado(int idEstudiante, int idEscenario) throws SQLException {
        return actividadDAO.todasActividadesCompletadas(idEstudiante, idEscenario);
    }

    public EvaluacionResultado evaluarMatchDipolos(int idActividad, String respuestasJson) throws JSONException, SQLException {
        List<ParDipolo> paresCorrectos = actividadDAO.listarParesDipolo(idActividad);
        int total = paresCorrectos.size();

        if (total == 0) {
            EvaluacionResultado resultado = new EvaluacionResultado();
            resultado.setCorrectos(0);
            resultado.setIncorrectos(0);
            resultado.setPuntaje(0);
            resultado.setCompletado(false);
            resultado.setTotalElementos(0);
            return resultado;
        }

        JSONArray jsonArray = new JSONArray(respuestasJson);
        Map<String, Boolean> paresAcertados = new HashMap<>();
        int correctos = 0;

        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            String pos = obj.getString("extremoPositivo");
            String neg = obj.getString("extremoNegativo");
            String clave = pos + "|" + neg;

            if (paresAcertados.containsKey(clave)) {
                continue;
            }

            for (ParDipolo par : paresCorrectos) {
                if (par.getExtremoPositivo().equals(pos) && par.getExtremoNegativo().equals(neg)) {
                    correctos++;
                    paresAcertados.put(clave, true);
                    break;
                }
            }
        }

        int puntaje = (correctos * 100 / total);

        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos);
        resultado.setIncorrectos(total - correctos);
        resultado.setPuntaje(puntaje);
        resultado.setCompletado(puntaje >= 50);
        resultado.setTotalElementos(total);

        return resultado;
    }

    public EvaluacionResultado evaluarMatchPuentesH(int idActividad, String respuestasJson) throws JSONException, SQLException {
        List<ParPuenteH> paresCorrectos = actividadDAO.listarParesPuenteH(idActividad);
        JSONArray jsonArray = new JSONArray(respuestasJson);
        int correctos = 0;
        int totalCorrectos = paresCorrectos.size();

        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            int id1 = obj.getInt("idMolecula1");
            int id2 = obj.getInt("idMolecula2");
            for (ParPuenteH par : paresCorrectos) {
                if ((par.getIdMolecula1() == id1 && par.getIdMolecula2() == id2)
                        || (par.getIdMolecula1() == id2 && par.getIdMolecula2() == id1)) {
                    correctos++;
                    break;
                }
            }
        }

        int puntaje = totalCorrectos > 0 ? (correctos * 100 / totalCorrectos) : 0;

        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos);
        resultado.setIncorrectos(jsonArray.length() - correctos);
        resultado.setPuntaje(puntaje);
        resultado.setCompletado(puntaje >= 50);
        resultado.setTotalElementos(jsonArray.length());

        return resultado;
    }

    public List<CategoriaActividad> obtenerCategoriasPorActividad(int idActividad) throws SQLException {
        return actividadDAO.listarCategoriasPorActividad(idActividad);
    }

    public List<ParDipolo> obtenerParesDipolo(int idActividad) throws SQLException {
        return actividadDAO.listarParesDipolo(idActividad);
    }

    public List<MoleculaPuenteH> obtenerMoleculasPuenteH(int idActividad) throws SQLException {
        return actividadDAO.listarMoleculasPuenteH(idActividad);
    }

    public List<PreguntaSimulacionEstados> obtenerPreguntasSimulacionEstados(int idActividad) throws SQLException {
        return actividadDAO.listarPreguntasSimulacionEstados(idActividad);
    }

    public EvaluacionResultado evaluarSimulacionEstados(int idActividad, String respuestasJson) throws JSONException, SQLException {
        JSONArray array = new JSONArray(respuestasJson);
        int correctos = 0;
        int total = array.length();

        for (int i = 0; i < total; i++) {
            JSONObject obj = array.getJSONObject(i);
            int idPregunta = obj.getInt("idPregunta");
            int seleccionada = obj.getInt("opcionSeleccionada");
            int correcta = actividadDAO.obtenerRespuestaCorrectaSimulacionEstados(idActividad, idPregunta);
            if (seleccionada == correcta) {
                correctos++;
            }
        }

        int puntaje = total > 0 ? (correctos * 100 / total) : 0;

        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos);
        resultado.setIncorrectos(total - correctos);
        resultado.setPuntaje(puntaje);
        resultado.setCompletado(puntaje >= 50);
        resultado.setTotalElementos(total);

        return resultado;
    }

    public List<FenomenoPropiedad> obtenerFenomenosPropiedad(int idActividad) throws SQLException {
        return actividadDAO.listarFenomenosPropiedad(idActividad);
    }

    public EvaluacionResultado evaluarIdentificacionPropiedad(int idActividad, String respuestasJson) throws JSONException, SQLException {
        JSONArray jsonArray = new JSONArray(respuestasJson);
        int correctos = 0;
        int total = jsonArray.length();

        for (int i = 0; i < total; i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            int idFenomeno = obj.getInt("idFenomeno");
            String seleccionada = obj.getString("propiedad");
            String correcta = actividadDAO.obtenerPropiedadCorrecta(idActividad, idFenomeno);
            if (correcta != null && correcta.equals(seleccionada)) {
                correctos++;
            }
        }

        int puntaje = total > 0 ? (correctos * 100 / total) : 0;

        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos);
        resultado.setIncorrectos(total - correctos);
        resultado.setPuntaje(puntaje);
        resultado.setCompletado(puntaje >= 50);
        resultado.setTotalElementos(total);

        return resultado;
    }

    public List<PreguntaSimulacionEbullicion> obtenerPreguntasSimulacionEbullicion(int idActividad) throws SQLException {
        return actividadDAO.listarPreguntasSimulacionEbullicion(idActividad);
    }

    public EvaluacionResultado evaluarSimulacionEbullicion(int idActividad, String respuestasJson) throws JSONException, SQLException {
        JSONArray jsonArray = new JSONArray(respuestasJson);
        int correctos = 0;
        int total = jsonArray.length();

        for (int i = 0; i < total; i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            int idPregunta = obj.getInt("idPregunta");
            int seleccionada = obj.getInt("opcionSeleccionada");
            int correcta = actividadDAO.obtenerRespuestaCorrectaEbullicion(idActividad, idPregunta);
            if (seleccionada == correcta) {
                correctos++;
            }
        }

        int puntaje = total > 0 ? (correctos * 100 / total) : 0;
        EvaluacionResultado resultado = new EvaluacionResultado();
        resultado.setCorrectos(correctos);
        resultado.setIncorrectos(total - correctos);
        resultado.setPuntaje(puntaje);
        resultado.setCompletado(puntaje >= 50);
        resultado.setTotalElementos(total);

        return resultado;
    }

    public ActividadInteractiva obtenerActividadPorId(int idActividad) throws SQLException {
        return actividadDAO.obtenerActividadPorId(idActividad);
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

        public int getCorrectos() {
            return correctos;
        }

        public void setCorrectos(int correctos) {
            this.correctos = correctos;
        }

        public int getIncorrectos() {
            return incorrectos;
        }

        public void setIncorrectos(int incorrectos) {
            this.incorrectos = incorrectos;
        }

        public int getPuntaje() {
            return puntaje;
        }

        public void setPuntaje(int puntaje) {
            this.puntaje = puntaje;
        }

        public boolean isCompletado() {
            return completado;
        }

        public void setCompletado(boolean completado) {
            this.completado = completado;
        }

        public int getTotalElementos() {
            return totalElementos;
        }

        public void setTotalElementos(int totalElementos) {
            this.totalElementos = totalElementos;
        }
    }
}
