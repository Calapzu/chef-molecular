/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.chefmolecular.modelo;

import java.time.LocalDateTime;

/**
 *
 * @author Usuario
 */
public class Insignia {
    private int           idInsignia;
    private String        nombre;
    private String        descripcion;
    private String        iconoUrl;
    private String        tipoCondicion;
    private int           valorCondicion;
    private int           idEscenarioAsociado;

    // Para insignia_estudiante
    private LocalDateTime fechaObtencion;
    private boolean       notificada;
    private boolean       obtenida;

    public Insignia() {}

    public int    getIdInsignia()              { return idInsignia; }
    public void   setIdInsignia(int v)         { idInsignia = v; }

    public String getNombre()                  { return nombre; }
    public void   setNombre(String v)          { nombre = v; }

    public String getDescripcion()             { return descripcion; }
    public void   setDescripcion(String v)     { descripcion = v; }

    public String getIconoUrl()                { return iconoUrl; }
    public void   setIconoUrl(String v)        { iconoUrl = v; }

    public String getTipoCondicion()           { return tipoCondicion; }
    public void   setTipoCondicion(String v)   { tipoCondicion = v; }

    public int    getValorCondicion()          { return valorCondicion; }
    public void   setValorCondicion(int v)     { valorCondicion = v; }

    public int    getIdEscenarioAsociado()     { return idEscenarioAsociado; }
    public void   setIdEscenarioAsociado(int v){ idEscenarioAsociado = v; }

    public LocalDateTime getFechaObtencion()   { return fechaObtencion; }
    public void setFechaObtencion(LocalDateTime v){ fechaObtencion = v; }

    public boolean isNotificada()              { return notificada; }
    public void    setNotificada(boolean v)    { notificada = v; }

    public boolean isObtenida()               { return obtenida; }
    public void    setObtenida(boolean v)     { obtenida = v; }
}
