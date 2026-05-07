/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.chefmolecular.modelo;

public class Pregunta {
    private int    idPregunta;
    private int    idCuestionario;
    private String enunciado;
    private String opcionA;
    private String opcionB;
    private String opcionC;
    private String opcionD;
    private int    respuestaCorrecta;
    private String explicacion;
    private int    pesoPuntaje;

    public Pregunta() {}

    public int    getIdPregunta()              { return idPregunta; }
    public void   setIdPregunta(int v)         { idPregunta = v; }

    public int    getIdCuestionario()          { return idCuestionario; }
    public void   setIdCuestionario(int v)     { idCuestionario = v; }

    public String getEnunciado()               { return enunciado; }
    public void   setEnunciado(String v)       { enunciado = v; }

    public String getOpcionA()                 { return opcionA; }
    public void   setOpcionA(String v)         { opcionA = v; }

    public String getOpcionB()                 { return opcionB; }
    public void   setOpcionB(String v)         { opcionB = v; }

    public String getOpcionC()                 { return opcionC; }
    public void   setOpcionC(String v)         { opcionC = v; }

    public String getOpcionD()                 { return opcionD; }
    public void   setOpcionD(String v)         { opcionD = v; }

    public int    getRespuestaCorrecta()        { return respuestaCorrecta; }
    public void   setRespuestaCorrecta(int v)  { respuestaCorrecta = v; }

    public String getExplicacion()             { return explicacion; }
    public void   setExplicacion(String v)     { explicacion = v; }

    public int    getPesoPuntaje()             { return pesoPuntaje; }
    public void   setPesoPuntaje(int v)        { pesoPuntaje = v; }
}
