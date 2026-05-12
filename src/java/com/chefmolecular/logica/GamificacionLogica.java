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

    private final InsigniaDAO insigniaDAO = new InsigniaDAO();
    private final ProgresoDAO progresoDAO = new ProgresoDAO();
    private final EstudianteDAO estudianteDAO = new EstudianteDAO();
    private final RecetaDAO recetaDAO = new RecetaDAO();

    public void procesarLogros(int idEstudiante, int idEscenario) throws SQLException {
        long inicioTotal = System.currentTimeMillis();
        System.out.println("\n--- [GamificacionLogica] procesarLogros ---");

        long t1 = System.currentTimeMillis();
        int totalEstrellas = progresoDAO.sumarEstrellasTotales(idEstudiante);
        System.out.println("[DAO→BD] sumarEstrellasTotales: " + (System.currentTimeMillis() - t1) + " ms");

        long t2 = System.currentTimeMillis();
        String nuevoRango = calcularRango(totalEstrellas);
        System.out.println("[Logica] calcularRango: " + (System.currentTimeMillis() - t2) + " ms");

        long t3 = System.currentTimeMillis();
        estudianteDAO.actualizarRangoYEstrellas(idEstudiante, nuevoRango, totalEstrellas);
        System.out.println("[DAO→BD] actualizarRangoYEstrellas: " + (System.currentTimeMillis() - t3) + " ms");

        long t4 = System.currentTimeMillis();
        List<Insignia> todas = insigniaDAO.listarTodas();
        System.out.println("[DAO→BD] listarInsignias: " + (System.currentTimeMillis() - t4) + " ms");

        long t5 = System.currentTimeMillis();
        for (Insignia insignia : todas) {
            if (cumpleCondicion(insignia, idEstudiante, idEscenario, totalEstrellas)) {
                insigniaDAO.otorgar(insignia.getIdInsignia(), idEstudiante);
            }
        }
        System.out.println("[Logica→DAO→BD] evaluarYOtorgarInsignias: " + (System.currentTimeMillis() - t5) + " ms");

        System.out.println("[TOTAL] procesarLogros: " + (System.currentTimeMillis() - inicioTotal) + " ms");
        System.out.println("-------------------------------------------\n");
    }

    public List<Insignia> obtenerInsigniasNuevas(int idEstudiante) throws SQLException {
        long inicioTotal = System.currentTimeMillis();
        System.out.println("\n--- [GamificacionLogica] obtenerInsigniasNuevas ---");

        long t1 = System.currentTimeMillis();
        List<Insignia> nuevas = insigniaDAO.listarNuevas(idEstudiante);
        System.out.println("[DAO→BD] listarNuevas: " + (System.currentTimeMillis() - t1) + " ms");

        long t2 = System.currentTimeMillis();
        insigniaDAO.marcarNotificadas(idEstudiante);
        System.out.println("[DAO→BD] marcarNotificadas: " + (System.currentTimeMillis() - t2) + " ms");

        System.out.println("[TOTAL] obtenerInsigniasNuevas: " + (System.currentTimeMillis() - inicioTotal) + " ms");
        System.out.println("---------------------------------------------------\n");

        return nuevas;
    }

    public String rangoTexto(String rango) {
        if (rango == null) {
            return "Aprendiz";
        }
        return switch (rango) {
            case "APRENDIZ" ->
                "Aprendiz";
            case "SOUS_CHEF" ->
                "Sous Chef";
            case "CHEF" ->
                "Chef";
            case "CHEF_MOLECULAR_ESTRELLA" ->
                "Chef Molecular Estrella";
            default ->
                rango;
        };
    }

    public String calcularRango(int totalEstrellas) {
        if (totalEstrellas >= 16) {
            return "CHEF_MOLECULAR_ESTRELLA";
        }
        if (totalEstrellas >= 11) {
            return "CHEF";
        }
        if (totalEstrellas >= 6) {
            return "SOUS_CHEF";
        }
        return "APRENDIZ";
    }

    private boolean cumpleCondicion(Insignia insignia, int idEstudiante,
            int idEscenario, int totalEstrellas) throws SQLException {
        return switch (insignia.getTipoCondicion()) {

            case "ESTRELLAS_TOTALES" ->
                totalEstrellas >= insignia.getValorCondicion();

            case "ESCENARIOS_COMPLETADOS" -> {
                long t = System.currentTimeMillis();
                long completados = progresoDAO.listarPorEstudiante(idEstudiante)
                        .stream()
                        .filter(ProgresoEscenario::isCompletado)
                        .count();
                System.out.println("[DAO→BD] listarParaContarCompletados: " + (System.currentTimeMillis() - t) + " ms");
                yield completados >= insignia.getValorCondicion();
            }

            case "RANGO" -> {
                int rangoActual = rangoANumero(calcularRango(totalEstrellas));
                yield rangoActual >= insignia.getValorCondicion();
            }

            case "RECETAS_DESBLOQUEADAS" -> {
                long t = System.currentTimeMillis();
                int recetas = recetaDAO.contarDesbloqueadas(idEstudiante);
                System.out.println("[DAO→BD] contarRecetasDesbloqueadas: " + (System.currentTimeMillis() - t) + " ms");
                yield recetas >= insignia.getValorCondicion();
            }

            case "PERFECTO_ESCENARIO" -> {
                if (insignia.getIdEscenarioAsociado() != idEscenario) {
                    yield false;
                }
                long t = System.currentTimeMillis();
                ProgresoEscenario p = progresoDAO.buscar(idEstudiante, idEscenario);
                System.out.println("[DAO→BD] buscarProgresoParaInsignia: " + (System.currentTimeMillis() - t) + " ms");
                yield p != null && p.getEstrellas() >= insignia.getValorCondicion();
            }

            default ->
                false;
        };
    }

    private int rangoANumero(String rango) {
        return switch (rango) {
            case "SOUS_CHEF" ->
                2;
            case "CHEF" ->
                3;
            case "CHEF_MOLECULAR_ESTRELLA" ->
                4;
            default ->
                1;
        };
    }

    public List<Insignia> obtenerTodasInsigniasObtenidas(int idEstudiante) throws SQLException {
        long inicioTotal = System.currentTimeMillis();
        System.out.println("\n--- [GamificacionLogica] obtenerTodasInsigniasObtenidas ---");

        long t1 = System.currentTimeMillis();
        List<Insignia> todas = insigniaDAO.listarTodasConEstado(idEstudiante);
        System.out.println("[DAO→BD] listarTodasConEstado: " + (System.currentTimeMillis() - t1) + " ms");

        // Filtrar solo las que el estudiante ya obtuvo
        List<Insignia> obtenidas = new java.util.ArrayList<>();
        for (Insignia i : todas) {
            if (i.isObtenida()) {
                obtenidas.add(i);
            }
        }

        System.out.println("[TOTAL] obtenerTodasInsigniasObtenidas: " + (System.currentTimeMillis() - inicioTotal) + " ms");
        System.out.println("-----------------------------------------------------------\n");

        return obtenidas;
    }
}
