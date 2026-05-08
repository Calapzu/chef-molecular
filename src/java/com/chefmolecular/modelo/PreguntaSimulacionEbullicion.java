package com.chefmolecular.modelo;

public class PreguntaSimulacionEbullicion {
    private int idPregunta;
    private int idActividad;
    private int parametroAltitud;
    private double parametroPresion;
    private String enunciado;
    private String opcionA, opcionB, opcionC, opcionD;
    private int respuestaCorrecta;
    private String explicacion;

    public PreguntaSimulacionEbullicion() {}

    public int getIdPregunta() { return idPregunta; }
    public void setIdPregunta(int idPregunta) { this.idPregunta = idPregunta; }

    public int getIdActividad() { return idActividad; }
    public void setIdActividad(int idActividad) { this.idActividad = idActividad; }

    public int getParametroAltitud() { return parametroAltitud; }
    public void setParametroAltitud(int parametroAltitud) { this.parametroAltitud = parametroAltitud; }

    public double getParametroPresion() { return parametroPresion; }
    public void setParametroPresion(double parametroPresion) { this.parametroPresion = parametroPresion; }

    public String getEnunciado() { return enunciado; }
    public void setEnunciado(String enunciado) { this.enunciado = enunciado; }

    public String getOpcionA() { return opcionA; }
    public void setOpcionA(String opcionA) { this.opcionA = opcionA; }

    public String getOpcionB() { return opcionB; }
    public void setOpcionB(String opcionB) { this.opcionB = opcionB; }

    public String getOpcionC() { return opcionC; }
    public void setOpcionC(String opcionC) { this.opcionC = opcionC; }

    public String getOpcionD() { return opcionD; }
    public void setOpcionD(String opcionD) { this.opcionD = opcionD; }

    public int getRespuestaCorrecta() { return respuestaCorrecta; }
    public void setRespuestaCorrecta(int respuestaCorrecta) { this.respuestaCorrecta = respuestaCorrecta; }

    public String getExplicacion() { return explicacion; }
    public void setExplicacion(String explicacion) { this.explicacion = explicacion; }
}