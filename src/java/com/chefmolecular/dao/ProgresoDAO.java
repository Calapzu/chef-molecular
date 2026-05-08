package com.chefmolecular.dao;

import com.chefmolecular.conexion.ConexionDB;
import com.chefmolecular.modelo.ProgresoEscenario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProgresoDAO {

    public void inicializarProgreso(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "INSERT IGNORE INTO progreso_escenario "
                   + "(id_estudiante, id_escenario, estrellas, completado, desbloqueado) "
                   + "SELECT ?, id_escenario, 0, 0, IF(orden = 1, 1, 0) FROM escenario";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            ps.executeUpdate();
        }
        System.out.println("    [BD] inicializarProgreso: " + (System.currentTimeMillis() - inicio) + " ms");
    }

    public List<ProgresoEscenario> listarPorEstudiante(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT pe.*, e.nombre AS nombre_escenario, e.orden "
                   + "FROM progreso_escenario pe "
                   + "JOIN escenario e ON pe.id_escenario = e.id_escenario "
                   + "WHERE pe.id_estudiante = ? ORDER BY e.orden";
        List<ProgresoEscenario> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        System.out.println("    [BD] listarPorEstudiante: " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public ProgresoEscenario buscar(int idEstudiante, int idEscenario) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT pe.*, e.nombre AS nombre_escenario, e.orden "
                   + "FROM progreso_escenario pe "
                   + "JOIN escenario e ON pe.id_escenario = e.id_escenario "
                   + "WHERE pe.id_estudiante = ? AND pe.id_escenario = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idEscenario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProgresoEscenario p = mapear(rs);
                    System.out.println("    [BD] buscarProgreso: " + (System.currentTimeMillis() - inicio) + " ms");
                    return p;
                }
            }
        }
        System.out.println("    [BD] buscarProgreso (null): " + (System.currentTimeMillis() - inicio) + " ms");
        return null;
    }

    public void actualizarProgreso(int idEstudiante, int idEscenario,
                                   int estrellas, boolean completado) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "UPDATE progreso_escenario "
                   + "SET estrellas = GREATEST(estrellas, ?), "
                   + "    completado = IF(? = 1 OR completado = 1, 1, 0), "
                   + "    intentos = intentos + 1, "
                   + "    fecha_completado = IF(? = 1 AND completado = 0, NOW(), fecha_completado) "
                   + "WHERE id_estudiante = ? AND id_escenario = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            int c = completado ? 1 : 0;
            ps.setInt(1, estrellas);
            ps.setInt(2, c);
            ps.setInt(3, c);
            ps.setInt(4, idEstudiante);
            ps.setInt(5, idEscenario);
            ps.executeUpdate();
        }
        System.out.println("    [BD] actualizarProgreso: " + (System.currentTimeMillis() - inicio) + " ms");
    }

    public void desbloquearSiguiente(int idEstudiante, int idEscenarioActual) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "UPDATE progreso_escenario pe "
                   + "JOIN escenario e ON pe.id_escenario = e.id_escenario "
                   + "JOIN escenario eActual ON eActual.id_escenario = ? "
                   + "SET pe.desbloqueado = 1 "
                   + "WHERE pe.id_estudiante = ? AND e.orden = eActual.orden + 1";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEscenarioActual);
            ps.setInt(2, idEstudiante);
            ps.executeUpdate();
        }
        System.out.println("    [BD] desbloquearSiguiente: " + (System.currentTimeMillis() - inicio) + " ms");
    }

    public int sumarEstrellasTotales(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT COALESCE(SUM(estrellas), 0) FROM progreso_escenario WHERE id_estudiante = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int resultado = rs.getInt(1);
                    System.out.println("    [BD] sumarEstrellasTotales: " + (System.currentTimeMillis() - inicio) + " ms");
                    return resultado;
                }
            }
        }
        return 0;
    }

    private ProgresoEscenario mapear(ResultSet rs) throws SQLException {
        ProgresoEscenario p = new ProgresoEscenario();
        p.setIdProgreso(rs.getInt("id_progreso"));
        p.setIdEstudiante(rs.getInt("id_estudiante"));
        p.setIdEscenario(rs.getInt("id_escenario"));
        p.setEstrellas(rs.getInt("estrellas"));
        p.setCompletado(rs.getBoolean("completado"));
        p.setDesbloqueado(rs.getBoolean("desbloqueado"));
        p.setIntentos(rs.getInt("intentos"));
        Timestamp ts = rs.getTimestamp("fecha_completado");
        if (ts != null) p.setFechaCompletado(ts.toLocalDateTime());
        p.setNombreEscenario(rs.getString("nombre_escenario"));
        p.setOrdenEscenario(rs.getInt("orden"));
        return p;
    }
}