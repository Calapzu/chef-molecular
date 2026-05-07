package com.chefmolecular.logica;

import com.chefmolecular.dao.EstudianteDAO;
import com.chefmolecular.dao.InsigniaDAO;
import com.chefmolecular.dao.ProgresoDAO;
import com.chefmolecular.dao.RecetaDAO;
import com.chefmolecular.modelo.Insignia;
import com.chefmolecular.modelo.ProgresoEscenario;
import java.sql.SQLException;
import java.util.List;

public class GamificacionLogica {

    private final InsigniaDAO   insigniaDAO   = new InsigniaDAO();
    private final ProgresoDAO   progresoDAO   = new ProgresoDAO();
    private final EstudianteDAO estudianteDAO = new EstudianteDAO();
    private final RecetaDAO     recetaDAO     = new RecetaDAO();

    public void procesarLogros(int idEstudiante, int idEscenario) throws SQLException {
        int totalEstrellas = progresoDAO.sumarEstrellasTotales(idEstudiante);
        String nuevoRango  = calcularRango(totalEstrellas);
        estudianteDAO.actualizarRangoYEstrellas(idEstudiante, nuevoRango, totalEstrellas);

        List<Insignia> todas = insigniaDAO.listarTodas();
        for (Insignia insignia : todas) {
            if (cumpleCondicion(insignia, idEstudiante, idEscenario, totalEstrellas)) {
                insigniaDAO.otorgar(insignia.getIdInsignia(), idEstudiante);
            }
        }
    }

    public List<Insignia> obtenerInsigniasNuevas(int idEstudiante) throws SQLException {
        List<Insignia> nuevas = insigniaDAO.listarNuevas(idEstudiante);
        insigniaDAO.marcarNotificadas(idEstudiante);
        return nuevas;
    }

    public String rangoTexto(String rango) {
        if (rango == null) return "Aprendiz";
        return switch (rango) {
            case "APRENDIZ"                -> "Aprendiz";
            case "SOUS_CHEF"               -> "Sous Chef";
            case "CHEF"                    -> "Chef";
            case "CHEF_MOLECULAR_ESTRELLA" -> "Chef Molecular Estrella";
            default                        -> rango;
        };
    }

    public String calcularRango(int totalEstrellas) {
        if (totalEstrellas >= 12) return "CHEF_MOLECULAR_ESTRELLA";
        if (totalEstrellas >= 9)  return "CHEF";
        if (totalEstrellas >= 3)  return "SOUS_CHEF";
        return "APRENDIZ";
    }

    private boolean cumpleCondicion(Insignia insignia, int idEstudiante,
                                    int idEscenario, int totalEstrellas) throws SQLException {
        return switch (insignia.getTipoCondicion()) {

            case "ESTRELLAS_TOTALES" ->
                totalEstrellas >= insignia.getValorCondicion();

            case "ESCENARIOS_COMPLETADOS" -> {
                long completados = progresoDAO.listarPorEstudiante(idEstudiante)
                        .stream()
                        .filter(ProgresoEscenario::isCompletado)
                        .count();
                yield completados >= insignia.getValorCondicion();
            }

            case "RANGO" -> {
                int rangoActual = rangoANumero(calcularRango(totalEstrellas));
                yield rangoActual >= insignia.getValorCondicion();
            }

            case "RECETAS_DESBLOQUEADAS" -> {
                int recetas = recetaDAO.contarDesbloqueadas(idEstudiante);
                yield recetas >= insignia.getValorCondicion();
            }

            case "PERFECTO_ESCENARIO" -> {
                if (insignia.getIdEscenarioAsociado() != idEscenario) yield false;
                ProgresoEscenario p = progresoDAO.buscar(idEstudiante, idEscenario);
                yield p != null && p.getEstrellas() >= insignia.getValorCondicion();
            }

            default -> false;
        };
    }

    private int rangoANumero(String rango) {
        return switch (rango) {
            case "SOUS_CHEF"               -> 2;
            case "CHEF"                    -> 3;
            case "CHEF_MOLECULAR_ESTRELLA" -> 4;
            default                        -> 1;
        };
    }
}
