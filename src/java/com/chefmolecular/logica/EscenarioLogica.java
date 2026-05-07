package com.chefmolecular.logica;

import com.chefmolecular.dao.PreguntaDAO;
import com.chefmolecular.dao.ProgresoDAO;
import com.chefmolecular.dao.RecetaDAO;
import com.chefmolecular.modelo.Pregunta;
import com.chefmolecular.modelo.ProgresoEscenario;
import java.sql.SQLException;
import java.util.List;

public class EscenarioLogica {

    private final PreguntaDAO preguntaDAO = new PreguntaDAO();
    private final ProgresoDAO progresoDAO = new ProgresoDAO();
    private final RecetaDAO recetaDAO = new RecetaDAO();

    public boolean estaDesbloqueado(int idEstudiante, int idEscenario) throws SQLException {
        ProgresoEscenario p = progresoDAO.buscar(idEstudiante, idEscenario);
        return p != null && p.isDesbloqueado();
    }

    public List<Pregunta> obtenerPreguntas(int idEscenario) throws SQLException {
        return preguntaDAO.listarPorEscenario(idEscenario);
    }

    public int calcularPuntaje(int correctas, int total) {
        if (total == 0) {
            return 0;
        }
        return (correctas * 100) / total;
    }

    public int calcularEstrellas(int puntaje, int idEscenario, int correctas) {
        // Escenario 4 usa escala fija por aciertos
        if (idEscenario == 4) {
            if (correctas >= 5) {
                return 3;
            }
            if (correctas >= 4) {
                return 2;
            }
            if (correctas >= 3) {
                return 1;
            }
            return 0;
        }
        // Demás escenarios: por porcentaje
        if (puntaje >= 90) {
            return 3;
        }
        if (puntaje >= 70) {
            return 2;
        }
        if (puntaje >= 50) {
            return 1;
        }
        return 0;
    }

    public void guardarResultado(int idEstudiante, int idEscenario,
            int correctas, int totalPreguntas) throws SQLException {
        int puntaje = calcularPuntaje(correctas, totalPreguntas);
        int estrellas = calcularEstrellas(puntaje, idEscenario, correctas);
        boolean completado = estrellas >= 1;

        progresoDAO.actualizarProgreso(idEstudiante, idEscenario, estrellas, completado);
        if (completado) {
            progresoDAO.desbloquearSiguiente(idEstudiante, idEscenario);
        }
    }
}
