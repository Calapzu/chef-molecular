
package com.chefmolecular.modelo;

import java.time.LocalDateTime;

public class Estudiante {
    private int           idEstudiante;
    private String        nombreCompleto;
    private String        correo;
    private String        passwordHash;
    private String        rango;
    private int           totalEstrellas;
    private LocalDateTime fechaRegistro;

    public Estudiante() {}

    public int    getIdEstudiante()          { return idEstudiante; }
    public void   setIdEstudiante(int v)     { idEstudiante = v; }

    public String getNombreCompleto()        { return nombreCompleto; }
    public void   setNombreCompleto(String v){ nombreCompleto = v; }

    public String getCorreo()               { return correo; }
    public void   setCorreo(String v)       { correo = v.toLowerCase().trim(); }

    public String getPasswordHash()         { return passwordHash; }
    public void   setPasswordHash(String v) { passwordHash = v; }

    public String getRango()                { return rango; }
    public void   setRango(String v)        { rango = v; }

    public int    getTotalEstrellas()       { return totalEstrellas; }
    public void   setTotalEstrellas(int v)  { totalEstrellas = v; }

    public LocalDateTime getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(LocalDateTime v){ fechaRegistro = v; }
}
