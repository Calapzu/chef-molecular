package com.chefmolecular.dao;

import com.chefmolecular.conexion.ConexionDB;
import com.chefmolecular.modelo.ActividadInteractiva;
import com.chefmolecular.modelo.CategoriaActividad;
import com.chefmolecular.modelo.ElementoArrastrable;
import com.chefmolecular.modelo.FenomenoPropiedad;
import com.chefmolecular.modelo.MoleculaPuenteH;
import com.chefmolecular.modelo.ParDipolo;
import com.chefmolecular.modelo.ParPuenteH;
import com.chefmolecular.modelo.PiezaMolecular;
import com.chefmolecular.modelo.PreguntaSimulacionEbullicion;
import com.chefmolecular.modelo.PreguntaSimulacionEstados;
import com.chefmolecular.modelo.ResultadoActividad;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActividadDAO {

    public List<ActividadInteractiva> listarActividadesPorEscenario(int idEscenario) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM actividad_interactiva WHERE id_escenario = ? ORDER BY orden";
        List<ActividadInteractiva> actividades = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEscenario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ActividadInteractiva a = new ActividadInteractiva();
                    a.setIdActividad(rs.getInt("id_actividad"));
                    a.setIdEscenario(rs.getInt("id_escenario"));
                    a.setTipo(rs.getString("tipo"));
                    a.setOrden(rs.getInt("orden"));
                    a.setPesoPuntaje(rs.getInt("peso_puntaje"));
                    actividades.add(a);
                }
            }
        }
        System.out.println("    [BD] listarActividadesPorEscenario: " + (System.currentTimeMillis() - inicio) + " ms");
        return actividades;
    }

    public List<CategoriaActividad> listarCategoriasPorActividad(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM categoria_actividad WHERE id_actividad = ? ORDER BY id_categoria";
        List<CategoriaActividad> categorias = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CategoriaActividad c = new CategoriaActividad();
                    c.setIdCategoria(rs.getInt("id_categoria"));
                    c.setIdActividad(rs.getInt("id_actividad"));
                    c.setNombreCategoria(rs.getString("nombre_categoria"));
                    categorias.add(c);
                }
            }
        }
        System.out.println("    [BD] listarCategoriasPorActividad: " + (System.currentTimeMillis() - inicio) + " ms");
        return categorias;
    }

    public List<ElementoArrastrable> listarElementosDragAndDrop(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT ea.*, ca.nombre_categoria FROM elemento_arrastrable ea "
                + "JOIN categoria_actividad ca ON ea.id_categoria = ca.id_categoria "
                + "WHERE ea.id_actividad = ? ORDER BY ea.id_elemento";
        List<ElementoArrastrable> elementos = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ElementoArrastrable e = new ElementoArrastrable();
                    e.setIdElemento(rs.getInt("id_elemento"));
                    e.setIdActividad(rs.getInt("id_actividad"));
                    e.setNombre(rs.getString("nombre"));
                    e.setIdCategoria(rs.getInt("id_categoria"));
                    e.setCategoriaCorrecta(rs.getString("nombre_categoria"));
                    elementos.add(e);
                }
            }
        }
        System.out.println("    [BD] listarElementosDragAndDrop: " + (System.currentTimeMillis() - inicio) + " ms");
        return elementos;
    }

    public List<PiezaMolecular> listarPiezasMoleculares(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM pieza_molecular WHERE id_actividad = ? ORDER BY id_pieza";
        List<PiezaMolecular> piezas = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PiezaMolecular p = new PiezaMolecular();
                    p.setIdPieza(rs.getInt("id_pieza"));
                    p.setIdActividad(rs.getInt("id_actividad"));
                    p.setNombre(rs.getString("nombre"));
                    p.setFormula(rs.getString("formula"));
                    p.setColor(rs.getString("color"));
                    piezas.add(p);
                }
            }
        }
        System.out.println("    [BD] listarPiezasMoleculares: " + (System.currentTimeMillis() - inicio) + " ms");
        return piezas;
    }

    public boolean isActividadCompletada(int idEstudiante, int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT COUNT(*) FROM resultado_actividad WHERE id_estudiante = ? AND id_actividad = ? AND completado = 1";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    boolean resultado = rs.getInt(1) > 0;
                    System.out.println("    [BD] isActividadCompletada: " + (System.currentTimeMillis() - inicio) + " ms");
                    return resultado;
                }
            }
        }
        return false;
    }

    public ResultadoActividad obtenerMejorResultado(int idEstudiante, int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM resultado_actividad WHERE id_estudiante = ? AND id_actividad = ? ORDER BY puntaje_obtenido DESC LIMIT 1";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ResultadoActividad r = mapearResultado(rs);
                    System.out.println("    [BD] obtenerMejorResultado: " + (System.currentTimeMillis() - inicio) + " ms");
                    return r;
                }
            }
        }
        return null;
    }

    public void guardarResultado(ResultadoActividad resultado) throws SQLException {
        long inicio = System.currentTimeMillis();
        String checkSql = "SELECT id_resultado, puntaje_obtenido FROM resultado_actividad WHERE id_actividad = ? AND id_estudiante = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement psCheck = cn.prepareStatement(checkSql)) {
            psCheck.setInt(1, resultado.getIdActividad());
            psCheck.setInt(2, resultado.getIdEstudiante());
            ResultSet rs = psCheck.executeQuery();
            if (rs.next()) {
                int idExistente = rs.getInt("id_resultado");
                int puntajeExistente = rs.getInt("puntaje_obtenido");
                if (resultado.getPuntajeObtenido() >= puntajeExistente) {
                    String updateSql = "UPDATE resultado_actividad SET correctos = ?, incorrectos = ?, puntaje_obtenido = ?, completado = ? WHERE id_resultado = ?";
                    try (PreparedStatement psUpdate = cn.prepareStatement(updateSql)) {
                        psUpdate.setInt(1, resultado.getCorrectos());
                        psUpdate.setInt(2, resultado.getIncorrectos());
                        psUpdate.setInt(3, resultado.getPuntajeObtenido());
                        psUpdate.setBoolean(4, resultado.isCompletado());
                        psUpdate.setInt(5, idExistente);
                        psUpdate.executeUpdate();
                    }
                }
            } else {
                String insertSql = "INSERT INTO resultado_actividad (id_actividad, id_estudiante, id_progreso, correctos, incorrectos, puntaje_obtenido, completado) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement psInsert = cn.prepareStatement(insertSql)) {
                    psInsert.setInt(1, resultado.getIdActividad());
                    psInsert.setInt(2, resultado.getIdEstudiante());
                    psInsert.setInt(3, resultado.getIdProgreso());
                    psInsert.setInt(4, resultado.getCorrectos());
                    psInsert.setInt(5, resultado.getIncorrectos());
                    psInsert.setInt(6, resultado.getPuntajeObtenido());
                    psInsert.setBoolean(7, resultado.isCompletado());
                    psInsert.executeUpdate();
                }
            }
        }
        System.out.println("    [BD] guardarResultado: " + (System.currentTimeMillis() - inicio) + " ms");
    }

    public int calcularPuntajeTotalEscenario(int idEstudiante, int idEscenario) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT COALESCE(AVG(ra.puntaje_obtenido), 0) as promedio "
                + "FROM resultado_actividad ra "
                + "JOIN actividad_interactiva ai ON ra.id_actividad = ai.id_actividad "
                + "WHERE ra.id_estudiante = ? AND ai.id_escenario = ? AND ra.completado = 1";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idEscenario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int resultado = rs.getInt("promedio");
                    System.out.println("    [BD] calcularPuntajeTotalEscenario: " + (System.currentTimeMillis() - inicio) + " ms");
                    return resultado;
                }
            }
        }
        return 0;
    }

    public boolean todasActividadesCompletadas(int idEstudiante, int idEscenario) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT COUNT(*) as total, "
                + "SUM(CASE WHEN ra.completado = 1 THEN 1 ELSE 0 END) as completadas "
                + "FROM actividad_interactiva ai "
                + "LEFT JOIN ( "
                + "    SELECT id_actividad, id_estudiante, completado "
                + "    FROM resultado_actividad ra2 "
                + "    WHERE id_estudiante = ? "
                + "    AND id_resultado = ( "
                + "        SELECT MAX(id_resultado) FROM resultado_actividad "
                + "        WHERE id_actividad = ra2.id_actividad AND id_estudiante = ra2.id_estudiante "
                + "    ) "
                + ") ra ON ai.id_actividad = ra.id_actividad "
                + "WHERE ai.id_escenario = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idEscenario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt("total");
                    int completadas = rs.getInt("completadas");
                    boolean resultado = total > 0 && total == completadas;
                    System.out.println("    [BD] todasActividadesCompletadas: " + (System.currentTimeMillis() - inicio) + " ms");
                    return resultado;
                }
            }
        }
        return false;
    }

    public void limpiarResultadosAnteriores(int idEstudiante, int idEscenario) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "DELETE FROM resultado_actividad "
                + "WHERE id_estudiante = ? "
                + "AND id_actividad IN ("
                + "    SELECT id_actividad FROM actividad_interactiva WHERE id_escenario = ?"
                + ")";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idEscenario);
            ps.executeUpdate();
        }
        System.out.println("    [BD] limpiarResultadosAnteriores: " + (System.currentTimeMillis() - inicio) + " ms");
    }

    public List<ParDipolo> listarParesDipolo(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM par_dipolo WHERE id_actividad = ? ORDER BY id_par";
        List<ParDipolo> pares = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ParDipolo p = new ParDipolo();
                    p.setIdPar(rs.getInt("id_par"));
                    p.setIdActividad(rs.getInt("id_actividad"));
                    p.setExtremoPositivo(rs.getString("extremo_positivo"));
                    p.setExtremoNegativo(rs.getString("extremo_negativo"));
                    pares.add(p);
                }
            }
        }
        System.out.println("    [BD] listarParesDipolo: " + (System.currentTimeMillis() - inicio) + " ms");
        return pares;
    }

    public List<MoleculaPuenteH> listarMoleculasPuenteH(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM molecula_puente_h WHERE id_actividad = ? ORDER BY id_molecula";
        List<MoleculaPuenteH> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MoleculaPuenteH m = new MoleculaPuenteH();
                    m.setIdMolecula(rs.getInt("id_molecula"));
                    m.setIdActividad(rs.getInt("id_actividad"));
                    m.setNombre(rs.getString("nombre"));
                    m.setAtomo(rs.getString("atomo"));
                    m.setTieneH(rs.getBoolean("tiene_h"));
                    m.setPuedeFormar(rs.getBoolean("puede_formar"));
                    lista.add(m);
                }
            }
        }
        System.out.println("    [BD] listarMoleculasPuenteH: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public List<ParPuenteH> listarParesPuenteH(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM par_puente_h WHERE id_actividad = ?";
        List<ParPuenteH> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ParPuenteH p = new ParPuenteH();
                    p.setIdPar(rs.getInt("id_par"));
                    p.setIdActividad(rs.getInt("id_actividad"));
                    p.setIdMolecula1(rs.getInt("id_molecula1"));
                    p.setIdMolecula2(rs.getInt("id_molecula2"));
                    lista.add(p);
                }
            }
        }
        System.out.println("    [BD] listarParesPuenteH: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public List<PreguntaSimulacionEstados> listarPreguntasSimulacionEstados(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM pregunta_simulacion_estados WHERE id_actividad = ? ORDER BY id_pregunta";
        List<PreguntaSimulacionEstados> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PreguntaSimulacionEstados p = new PreguntaSimulacionEstados();
                    p.setIdPregunta(rs.getInt("id_pregunta"));
                    p.setIdActividad(rs.getInt("id_actividad"));
                    p.setEnunciado(rs.getString("enunciado"));
                    p.setOpcionA(rs.getString("opcion_a"));
                    p.setOpcionB(rs.getString("opcion_b"));
                    p.setOpcionC(rs.getString("opcion_c"));
                    p.setOpcionD(rs.getString("opcion_d"));
                    p.setRespuestaCorrecta(rs.getInt("respuesta_correcta"));
                    p.setExplicacion(rs.getString("explicacion"));
                    lista.add(p);
                }
            }
        }
        System.out.println("    [BD] listarPreguntasSimulacionEstados: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public int obtenerRespuestaCorrectaSimulacionEstados(int idActividad, int idPregunta) throws SQLException {
        long inicio = System.currentTimeMillis();
        // ✅ Consulta corregida: solo busca por id_pregunta (que es único)
        String sql = "SELECT respuesta_correcta FROM pregunta_simulacion_estados WHERE id_pregunta = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idPregunta);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int resultado = rs.getInt("respuesta_correcta");
                    System.out.println("    [BD] obtenerRespuestaCorrectaSimulacionEstados: " + (System.currentTimeMillis() - inicio) + " ms");
                    return resultado;
                }
            }
        }
        return -1;
    }

    public List<FenomenoPropiedad> listarFenomenosPropiedad(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM fenomeno_propiedad WHERE id_actividad = ? ORDER BY id_fenomeno";
        List<FenomenoPropiedad> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FenomenoPropiedad f = new FenomenoPropiedad();
                    f.setIdFenomeno(rs.getInt("id_fenomeno"));
                    f.setIdActividad(rs.getInt("id_actividad"));
                    f.setDescripcion(rs.getString("descripcion"));
                    f.setPropiedadCorrecta(rs.getString("propiedad_correcta"));
                    lista.add(f);
                }
            }
        }
        System.out.println("    [BD] listarFenomenosPropiedad: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public String obtenerPropiedadCorrecta(int idActividad, int idFenomeno) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT propiedad_correcta FROM fenomeno_propiedad WHERE id_fenomeno = ? AND id_actividad = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idFenomeno);
            ps.setInt(2, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String resultado = rs.getString("propiedad_correcta");
                    System.out.println("    [BD] obtenerPropiedadCorrecta: " + (System.currentTimeMillis() - inicio) + " ms");
                    return resultado;
                }
            }
        }
        return null;
    }

    public List<PreguntaSimulacionEbullicion> listarPreguntasSimulacionEbullicion(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM pregunta_simulacion_ebullicion WHERE id_actividad = ? ORDER BY id_pregunta";
        List<PreguntaSimulacionEbullicion> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PreguntaSimulacionEbullicion p = new PreguntaSimulacionEbullicion();
                    p.setIdPregunta(rs.getInt("id_pregunta"));
                    p.setIdActividad(rs.getInt("id_actividad"));
                    p.setParametroAltitud(rs.getInt("parametro_altitud"));
                    p.setParametroPresion(rs.getDouble("parametro_presion"));
                    p.setEnunciado(rs.getString("enunciado"));
                    p.setOpcionA(rs.getString("opcion_a"));
                    p.setOpcionB(rs.getString("opcion_b"));
                    p.setOpcionC(rs.getString("opcion_c"));
                    p.setOpcionD(rs.getString("opcion_d"));
                    p.setRespuestaCorrecta(rs.getInt("respuesta_correcta"));
                    p.setExplicacion(rs.getString("explicacion"));
                    lista.add(p);
                }
            }
        }
        System.out.println("    [BD] listarPreguntasSimulacionEbullicion: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public int obtenerRespuestaCorrectaEbullicion(int idActividad, int idPregunta) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT respuesta_correcta FROM pregunta_simulacion_ebullicion WHERE id_pregunta = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idPregunta);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int resultado = rs.getInt("respuesta_correcta");
                    System.out.println("    [BD] obtenerRespuestaCorrectaEbullicion: " + (System.currentTimeMillis() - inicio) + " ms");
                    return resultado;
                }
            }
        }
        return -1;
    }

    public ActividadInteractiva obtenerActividadPorId(int idActividad) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT * FROM actividad_interactiva WHERE id_actividad = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idActividad);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ActividadInteractiva a = new ActividadInteractiva();
                    a.setIdActividad(rs.getInt("id_actividad"));
                    a.setIdEscenario(rs.getInt("id_escenario"));
                    a.setTipo(rs.getString("tipo"));
                    a.setOrden(rs.getInt("orden"));
                    a.setPesoPuntaje(rs.getInt("peso_puntaje"));
                    System.out.println("    [BD] obtenerActividadPorId: " + (System.currentTimeMillis() - inicio) + " ms");
                    return a;
                }
            }
        }
        return null;
    }

    private ResultadoActividad mapearResultado(ResultSet rs) throws SQLException {
        ResultadoActividad r = new ResultadoActividad();
        r.setIdResultado(rs.getInt("id_resultado"));
        r.setIdActividad(rs.getInt("id_actividad"));
        r.setIdEstudiante(rs.getInt("id_estudiante"));
        r.setIdProgreso(rs.getInt("id_progreso"));
        r.setCorrectos(rs.getInt("correctos"));
        r.setIncorrectos(rs.getInt("incorrectos"));
        r.setPuntajeObtenido(rs.getInt("puntaje_obtenido"));
        r.setCompletado(rs.getBoolean("completado"));
        Timestamp ts = rs.getTimestamp("creado_en");
        if (ts != null) {
            r.setCreadoEn(ts.toLocalDateTime());
        }
        return r;
    }

    public int sumarAciertosEscenario(int idEstudiante, int idEscenario) throws SQLException {
        String sql = "SELECT COALESCE(SUM(ra.correctos), 0) "
                + "FROM resultado_actividad ra "
                + "JOIN actividad_interactiva ai ON ra.id_actividad = ai.id_actividad "
                + "WHERE ra.id_estudiante = ? AND ai.id_escenario = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idEscenario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
}
