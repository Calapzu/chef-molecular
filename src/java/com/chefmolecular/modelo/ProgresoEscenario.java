/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.chefmolecular.modelo;

import java.time.LocalDateTime;

public class ProgresoEscenario {
    private int           idProgreso;
    private int           idEstudiante;
    private int           idEscenario;
    private int           estrellas;
    private boolean       completado;
    private boolean       desbloqueado;
    private int           intentos;
    private LocalDateTime fechaCompletado;
    private String        nombreEscenario;
    private int           ordenEscenario;

    public ProgresoEscenario() {}

    public int    getIdProgreso()              { return idProgreso; }
    public void   setIdProgreso(int v)         { idProgreso = v; }

    public int    getIdEstudiante()            { return idEstudiante; }
    public void   setIdEstudiante(int v)       { idEstudiante = v; }

    public int    getIdEscenario()             { return idEscenario; }
    public void   setIdEscenario(int v)        { idEscenario = v; }

    public int    getEstrellas()               { return estrellas; }
    public void   setEstrellas(int v)          { estrellas = v; }

    public boolean isCompletado()              { return completado; }
    public void    setCompletado(boolean v)    { completado = v; }

    public boolean isDesbloqueado()            { return desbloqueado; }
    public void    setDesbloqueado(boolean v)  { desbloqueado = v; }

    public int    getIntentos()                { return intentos; }
    public void   setIntentos(int v)           { intentos = v; }

    public LocalDateTime getFechaCompletado()  { return fechaCompletado; }
    public void setFechaCompletado(LocalDateTime v){ fechaCompletado = v; }

    public String getNombreEscenario()         { return nombreEscenario; }
    public void   setNombreEscenario(String v) { nombreEscenario = v; }

    public int    getOrdenEscenario()          { return ordenEscenario; }
    public void   setOrdenEscenario(int v)     { ordenEscenario = v; }
}