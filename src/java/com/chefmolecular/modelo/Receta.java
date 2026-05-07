/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.chefmolecular.modelo;

public class Receta {
    
    private int     idReceta;
    private int     idEscenario;
    private String  nombre;
    private String  descripcion;
    private String  ingredientes;
    private String  pasos;
    private String  imagenUrl;
    private boolean esOpcional;
    private boolean desbloqueada;
    private java.time.LocalDateTime fechaDesbloqueo;

    public Receta() {}

    public int    getIdReceta()              { return idReceta; }
    public void   setIdReceta(int v)         { idReceta = v; }

    public int    getIdEscenario()           { return idEscenario; }
    public void   setIdEscenario(int v)      { idEscenario = v; }

    public String getNombre()                { return nombre; }
    public void   setNombre(String v)        { nombre = v; }

    public String getDescripcion()           { return descripcion; }
    public void   setDescripcion(String v)   { descripcion = v; }

    public String getIngredientes()          { return ingredientes; }
    public void   setIngredientes(String v)  { ingredientes = v; }

    public String getPasos()                 { return pasos; }
    public void   setPasos(String v)         { pasos = v; }

    public String getImagenUrl()             { return imagenUrl; }
    public void   setImagenUrl(String v)     { imagenUrl = v; }

    public boolean isEsOpcional()            { return esOpcional; }
    public void    setEsOpcional(boolean v)  { esOpcional = v; }

    public boolean isDesbloqueada()          { return desbloqueada; }
    public void    setDesbloqueada(boolean v){ desbloqueada = v; }
    
    public java.time.LocalDateTime getFechaDesbloqueo() { return fechaDesbloqueo; }
public void setFechaDesbloqueo(java.time.LocalDateTime v) { fechaDesbloqueo = v; }
}