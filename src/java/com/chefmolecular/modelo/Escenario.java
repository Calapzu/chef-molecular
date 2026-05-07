package com.chefmolecular.modelo;

public class Escenario {
    private int    idEscenario;
    private String nombre;
    private String descripcion;
    private int    orden;
    private int    estrellasRequeridas;

    public Escenario() {}

    public int    getIdEscenario()              { return idEscenario; }
    public void   setIdEscenario(int v)         { idEscenario = v; }

    public String getNombre()                   { return nombre; }
    public void   setNombre(String v)           { nombre = v; }

    public String getDescripcion()              { return descripcion; }
    public void   setDescripcion(String v)      { descripcion = v; }

    public int    getOrden()                    { return orden; }
    public void   setOrden(int v)               { orden = v; }

    public int    getEstrellasRequeridas()      { return estrellasRequeridas; }
    public void   setEstrellasRequeridas(int v) { estrellasRequeridas = v; }
}