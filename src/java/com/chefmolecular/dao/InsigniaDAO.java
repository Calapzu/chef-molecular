package com.chefmolecular.dao;

import com.chefmolecular.conexion.ConexionDB;
import com.chefmolecular.modelo.Insignia;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InsigniaDAO {

    public List<Insignia> listarTodasConEstado(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT i.*, ie.fecha_obtencion, ie.notificada, "
                   + "IF(ie.id_insignia IS NOT NULL, 1, 0) AS obtenida "
                   + "FROM insignia i "
                   + "LEFT JOIN insignia_estudiante ie "
                   + "ON i.id_insignia = ie.id_insignia AND ie.id_estudiante = ? "
                   + "ORDER BY i.id_insignia";
        List<Insignia> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        System.out.println("    [BD] listarTodasConEstado (insignias): " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public List<Insignia> listarNuevas(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT i.*, ie.fecha_obtencion, ie.notificada, 1 AS obtenida "
                   + "FROM insignia_estudiante ie "
                   + "JOIN insignia i ON ie.id_insignia = i.id_insignia "
                   + "WHERE ie.id_estudiante = ? AND ie.notificada = 0";
        List<Insignia> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        System.out.println("    [BD] listarNuevas (insignias): " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public void marcarNotificadas(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "UPDATE insignia_estudiante SET notificada = 1 WHERE id_estudiante = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            ps.executeUpdate();
        }
        System.out.println("    [BD] marcarNotificadas: " + (System.currentTimeMillis() - inicio) + " ms");
    }

    public void otorgar(int idInsignia, int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "INSERT IGNORE INTO insignia_estudiante (id_insignia, id_estudiante, notificada) VALUES (?, ?, 0)";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idInsignia);
            ps.setInt(2, idEstudiante);
            ps.executeUpdate();
        }
        System.out.println("    [BD] otorgarInsignia: " + (System.currentTimeMillis() - inicio) + " ms");
    }

    public List<Insignia> listarTodas() throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT *, 0 AS obtenida, NULL AS fecha_obtencion, 0 AS notificada FROM insignia ORDER BY id_insignia";
        List<Insignia> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        }
        System.out.println("    [BD] listarTodas (insignias): " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    private Insignia mapear(ResultSet rs) throws SQLException {
        Insignia i = new Insignia();
        i.setIdInsignia(rs.getInt("id_insignia"));
        i.setNombre(rs.getString("nombre"));
        i.setDescripcion(rs.getString("descripcion"));
        i.setIconoUrl(rs.getString("icono_url"));
        i.setTipoCondicion(rs.getString("tipo_condicion"));
        i.setValorCondicion(rs.getInt("valor_condicion"));
        i.setIdEscenarioAsociado(rs.getInt("id_escenario_asociado"));
        i.setObtenida(rs.getBoolean("obtenida"));
        i.setNotificada(rs.getBoolean("notificada"));
        Timestamp ts = rs.getTimestamp("fecha_obtencion");
        if (ts != null) i.setFechaObtencion(ts.toLocalDateTime());
        return i;
    }
}