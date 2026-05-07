/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.chefmolecular.dao;

import com.chefmolecular.conexion.ConexionDB;
import com.chefmolecular.modelo.Estudiante;
import java.sql.*;

/**
 *
 * @author Usuario
 */
import com.chefmolecular.modelo.Estudiante;
public class EstudianteDAO {
    public boolean registrar(Estudiante e) throws SQLException {
        String sql = "INSERT INTO estudiante (nombre_completo, correo, password_hash, rango, total_estrellas) "
                   + "VALUES (?, ?, ?, 'APRENDIZ', 0)";
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, e.getNombreCompleto());
            ps.setString(2, e.getCorreo());
            ps.setString(3, e.getPasswordHash());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean existeCorreo(String correo) throws SQLException {
        String sql = "SELECT 1 FROM estudiante WHERE correo = ?";
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo.toLowerCase().trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public Estudiante buscarPorCredenciales(String correo, String passwordHash) throws SQLException {
        String sql = "SELECT * FROM estudiante WHERE correo = ? AND password_hash = ?";
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo.toLowerCase().trim());
            ps.setString(2, passwordHash);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        }
        return null;
    }

    public Estudiante buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM estudiante WHERE id_estudiante = ?";
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        }
        return null;
    }

    public boolean actualizarRangoYEstrellas(int idEstudiante, String rango, int totalEstrellas)
            throws SQLException {
        String sql = "UPDATE estudiante SET rango = ?, total_estrellas = ? "
                   + "WHERE id_estudiante = ?";
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, rango);
            ps.setInt(2, totalEstrellas);
            ps.setInt(3, idEstudiante);
            return ps.executeUpdate() > 0;
        }
    }

    private Estudiante mapear(ResultSet rs) throws SQLException {
        Estudiante e = new Estudiante();
        e.setIdEstudiante(rs.getInt("id_estudiante"));
        e.setNombreCompleto(rs.getString("nombre_completo"));
        e.setCorreo(rs.getString("correo"));
        e.setPasswordHash(rs.getString("password_hash"));
        e.setRango(rs.getString("rango"));
        e.setTotalEstrellas(rs.getInt("total_estrellas"));
        Timestamp ts = rs.getTimestamp("fecha_registro");
        if (ts != null) e.setFechaRegistro(ts.toLocalDateTime());
        return e;
    }
}
