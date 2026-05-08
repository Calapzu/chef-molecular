<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.ActividadInteractiva,
         com.chefmolecular.modelo.CategoriaActividad,
         com.chefmolecular.modelo.ElementoArrastrable,
         com.chefmolecular.modelo.ProgresoEscenario,
         com.chefmolecular.modelo.ParDipolo,
         com.chefmolecular.modelo.MoleculaPuenteH,
         com.chefmolecular.modelo.PreguntaSimulacionEstados,
         com.chefmolecular.modelo.PreguntaSimulacionEbullicion,
         com.chefmolecular.modelo.FenomenoPropiedad,
         java.util.List" %>
<%
    ActividadInteractiva actividad = (ActividadInteractiva) request.getAttribute("actividad");
    List<ActividadInteractiva> actividades = (List<ActividadInteractiva>) request.getAttribute("actividades");
    List<ElementoArrastrable> elementos = (List<ElementoArrastrable>) request.getAttribute("elementos");
    List<CategoriaActividad> categorias = (List<CategoriaActividad>) request.getAttribute("categorias");
    int actividadIdx = (int) request.getAttribute("actividadIdx");
    int totalActividades = (int) request.getAttribute("totalActividades");
    int idEscenario = (int) request.getAttribute("idEscenario");
    ProgresoEscenario progreso = (ProgresoEscenario) request.getAttribute("progreso");
    boolean yaCompletada = (boolean) request.getAttribute("yaCompletada");
    String nombreEscenario = "";
    if (idEscenario == 1)
        nombreEscenario = "La Cocina Fría — Dispersión de London";
    else if (idEscenario == 2)
        nombreEscenario = "La Sala de Salsas — Dipolo-dipolo";
    else if (idEscenario == 3)
        nombreEscenario = "El Taller del Merengue — Puentes de hidrógeno";
    else if (idEscenario == 4)
        nombreEscenario = "El Horno y el Congelador — Estados de la materia";
    else if (idEscenario == 5)
        nombreEscenario = "El Bar Molecular — Propiedades de los líquidos";
    else if (idEscenario == 6)
        nombreEscenario = "La Olla a Presión — Presión de vapor";
    else
        nombreEscenario = "Escenario " + idEscenario;
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chef Molecular — Actividad | <%= nombreEscenario%></title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            :root {
                --bg-base: #0C0702;
                --bg-card: #110D06;
                --border: #2E2010;
                --text-ppal: #F5ECD7;
                --text-dim: rgba(245,236,215,0.3);
                --cobre: #C87A2C;
                --dorado: #D4A438;
                --correcto: #4CAF50;
                --incorrecto: #f44336;
            }
            body.dia {
                --bg-base: #EDE8DF;
                --bg-card: #FFFFFF;
                --border: #D8CDB8;
                --text-ppal: #1C1208;
                --text-dim: rgba(28,18,8,0.45);
                --cobre: #9B5515;
                --dorado: #8A6A00;
            }
            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--bg-base);
                color: var(--text-ppal);
                min-height: 100vh;
                transition: background 0.3s, color 0.3s;
            }
            .navbar {
                background: var(--bg-card);
                border-bottom: 1px solid var(--border);
                padding: 0 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 64px;
                position: sticky;
                top: 0;
                z-index: 100;
            }
            .navbar-marca {
                display: flex;
                align-items: center;
                gap: 14px;
            }
            .marca-icono {
                width: 34px;
                height: 34px;
                background: var(--cobre);
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .marca-icono svg {
                width: 18px;
                height: 18px;
                fill: #F5ECD7;
            }
            .marca-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1.1rem;
                font-weight: 700;
            }
            .marca-nombre span {
                color: var(--cobre);
                font-style: italic;
            }
            .navbar-nav {
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .nav-link {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 7px 14px;
                border-radius: 6px;
                text-decoration: none;
                font-size: 12px;
                color: var(--text-dim);
                border: 1px solid transparent;
                transition: all 0.2s;
            }
            .nav-link:hover {
                color: var(--text-ppal);
                background: rgba(200,122,44,0.06);
                border-color: var(--border);
            }
            .nav-salir {
                color: rgba(200,122,44,0.7);
                border-color: rgba(200,122,44,0.2);
            }
            .btn-tema {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 7px 14px;
                border-radius: 6px;
                font-size: 12px;
                color: var(--text-dim);
                background: none;
                border: 1px solid var(--border);
                cursor: pointer;
            }
            .contenedor {
                max-width: 900px;
                margin: 0 auto;
                padding: 48px 24px;
            }
            .progreso-actividades {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
                margin-bottom: 32px;
                flex-wrap: wrap;
            }
            .progreso-paso {
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .paso-indicador {
                width: 32px;
                height: 32px;
                border-radius: 50%;
                background: var(--bg-card);
                border: 2px solid var(--border);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                font-weight: bold;
                color: var(--text-dim);
            }
            .paso-indicador.activo {
                border-color: var(--cobre);
                background: var(--cobre);
                color: white;
            }
            .paso-indicador.completado {
                border-color: #4CAF50;
                background: #4CAF50;
                color: white;
            }
            .paso-linea {
                width: 40px;
                height: 2px;
                background: var(--border);
            }
            .actividad-card {
                background: var(--bg-card);
                border: 1px solid var(--border);
                border-radius: 16px;
                padding: 32px;
                margin-bottom: 24px;
            }
            .actividad-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.5rem;
                margin-bottom: 8px;
            }
            .actividad-desc {
                color: var(--text-dim);
                font-size: 13px;
                margin-bottom: 24px;
            }
            .drag-container {
                display: flex;
                gap: 32px;
                flex-wrap: wrap;
            }
            .elementos-origen {
                flex: 1;
                min-width: 200px;
                background: rgba(200,122,44,0.05);
                border-radius: 12px;
                padding: 16px;
            }
            .elemento-drag {
                background: var(--cobre);
                color: white;
                padding: 12px 16px;
                margin: 8px 0;
                border-radius: 8px;
                cursor: grab;
                text-align: center;
                transition: transform 0.2s;
            }
            .elemento-drag:active {
                cursor: grabbing;
            }
            .elemento-drag.dragging {
                opacity: 0.5;
            }
            .zonas-container {
                flex: 1;
                min-width: 200px;
                display: flex;
                flex-direction: column;
                gap: 16px;
            }
            .zona-destino {
                background: rgba(200,122,44,0.05);
                border: 2px dashed var(--border);
                border-radius: 12px;
                padding: 16px;
                min-height: 150px;
            }
            .zona-destino h4 {
                font-size: 14px;
                margin-bottom: 12px;
                color: var(--dorado);
            }
            .zona-destino.drag-over {
                border-color: var(--cobre);
                background: rgba(200,122,44,0.1);
            }
            .elemento-ubicado {
                background: var(--cobre);
                color: white;
                padding: 8px 12px;
                margin: 6px 0;
                border-radius: 6px;
                font-size: 13px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .mol-drag {
                padding: 12px 18px;
                border: 2px solid var(--cobre);
                border-radius: 60px;
                cursor: grab;
                font-size: 0.9rem;
                text-align: center;
                color: var(--text-ppal);
                transition: all 0.2s;
                box-shadow: 3px 3px 0 rgba(200,122,44,0.3);
            }
            .mol-drag:hover {
                transform: scale(1.02);
            }
            .zona-alineacion {
                background: rgba(210,150,100,0.05);
                border-radius: 16px;
                padding: 20px;
                border: 1px dashed var(--cobre);
            }
            .drag-over {
                background: rgba(200,122,44,0.15) !important;
            }
            .btn-verificar {
                background: var(--cobre);
                color: white;
                border: none;
                padding: 10px 24px;
                border-radius: 40px;
                cursor: pointer;
                font-weight: 600;
                font-family: 'DM Sans', sans-serif;
                margin-top: 20px;
                transition: all 0.2s;
                font-size: 0.85rem;
                box-shadow: 0 3px 6px rgba(0,0,0,0.2);
            }
            .btn-verificar:hover {
                background: #A93226;
                transform: translateY(-2px);
            }
            .laboratorio-puentes {
                display: flex;
                gap: 24px;
                align-items: flex-start;
                flex-wrap: wrap;
                margin: 20px 0;
            }
            .moleculas-pool {
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
                flex: 1;
                min-width: 200px;
            }
            .mol-chip {
                padding: 10px 16px;
                border-radius: 30px;
                cursor: pointer;
                font-weight: 500;
                border: 2px solid;
                transition: transform 0.2s;
                text-align: center;
            }
            .mol-chip.seleccionada {
                transform: scale(1.05);
                box-shadow: 0 0 0 3px rgba(0,0,0,0.2);
            }
            .zona-pares {
                flex: 1;
                min-width: 250px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .pares-formados {
                margin-top: 20px;
            }
            .pares-formados h4 {
                margin-bottom: 10px;
            }
            .par-item {
                display: flex;
                align-items: center;
                gap: 8px;
                background: var(--cobre);
                color: white;
                padding: 8px 12px;
                border-radius: 8px;
                margin-bottom: 8px;
            }
            .btn-limpiar {
                background: none;
                border: 1px solid var(--border);
                color: var(--text-dim);
                border-radius: 8px;
                padding: 8px 16px;
                font-size: 13px;
                cursor: pointer;
                margin-top: 10px;
                transition: all 0.2s;
            }
            .btn-limpiar:hover {
                color: var(--text-ppal);
                border-color: var(--cobre);
            }
            .btn-accion {
                background: var(--cobre);
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 24px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
                margin-top: 24px;
            }
            .btn-accion:hover {
                background: #D98A3C;
                transform: translateY(-1px);
            }
            .btn-accion:disabled {
                background: var(--text-dim);
                cursor: not-allowed;
            }
            .btn-quitar {
                background: none;
                border: none;
                color: white;
                cursor: pointer;
                font-size: 14px;
                opacity: 0.7;
            }
            .btn-quitar:hover {
                opacity: 1;
            }
            .feedback {
                margin-top: 20px;
                padding: 16px;
                border-radius: 8px;
                display: none;
            }
            .feedback.success {
                background: rgba(76,175,80,0.1);
                border-left: 4px solid #4CAF50;
                display: block;
                color: #4CAF50;
            }
            .feedback.error {
                background: rgba(244,67,54,0.1);
                border-left: 4px solid #f44336;
                display: block;
                color: #f44336;
            }
            .btn-opcion {
                padding: 10px 16px;
                background: var(--bg-card);
                border: 2px solid var(--cobre);
                color: var(--text-ppal);
                border-radius: 8px;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.2s;
                font-family: 'DM Sans', sans-serif;
            }
            .btn-opcion:hover {
                background: rgba(200,122,44,0.1);
            }
            #altitudSlider {
                width: 200px;
                margin: 0 15px;
                vertical-align: middle;
            }
            #altitudLabel, #tempEbullicionLabel {
                font-size: 14px;
                color: var(--text-ppal);
            }

            /* ── ESCENARIO 3: MERENGUE ── */
            .merengue-card {
                background: linear-gradient(135deg, #f0f8ff, #e8f4fd);
                border: 2px solid #b3d9f5;
                border-radius: 20px;
                padding: 32px;
                margin-bottom: 24px;
            }
            .merengue-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.5rem;
                color: #1a4a6b;
                margin-bottom: 8px;
            }
            .merengue-desc {
                color: #4a7fa5;
                font-size: 13px;
                margin-bottom: 24px;
            }
            .nodos-container {
                display: flex;
                gap: 40px;
                justify-content: center;
                flex-wrap: wrap;
                margin: 20px 0;
            }
            .nodos-col {
                display: flex;
                flex-direction: column;
                gap: 16px;
                align-items: center;
            }
            .nodos-col h4 {
                color: #1a4a6b;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .nodo {
                background: white;
                border: 2px solid #b3d9f5;
                border-radius: 50px;
                padding: 12px 20px;
                cursor: pointer;
                font-size: 14px;
                color: #1a4a6b;
                transition: all 0.2s;
                box-shadow: 0 2px 8px rgba(100,180,255,0.15);
                min-width: 120px;
                text-align: center;
            }
            .nodo:hover {
                border-color: #4a9fd4;
                background: #e0f2ff;
                transform: scale(1.03);
            }
            .nodo.seleccionado {
                border-color: #1a7abf;
                background: #cce8ff;
                box-shadow: 0 0 0 3px rgba(26,122,191,0.3);
            }
            .nodo.conectado {
                border-color: #4caf50;
                background: #e8f5e9;
                color: #2e7d32;
                pointer-events: none;
            }
            .conexiones-lista {
                margin-top: 24px;
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                justify-content: center;
            }
            .conexion-item {
                background: #1a7abf;
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 13px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .btn-quitar-conexion {
                background: none;
                border: none;
                color: white;
                cursor: pointer;
                font-size: 14px;
                opacity: 0.7;
            }
            .btn-quitar-conexion:hover {
                opacity: 1;
            }
            .btn-merengue {
                background: #1a7abf;
                color: white;
                border: none;
                border-radius: 50px;
                padding: 12px 28px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                margin-top: 24px;
                transition: all 0.2s;
                font-family: 'DM Sans', sans-serif;
            }
            .btn-merengue:hover {
                background: #155d94;
                transform: translateY(-1px);
            }
            .btn-merengue:disabled {
                background: #b3d9f5;
                cursor: not-allowed;
                transform: none;
            }
            .feedback-merengue {
                margin-top: 16px;
                padding: 12px 16px;
                border-radius: 8px;
                font-size: 13px;
                display: none;
            }
            .feedback-merengue.success {
                background: #e8f5e9;
                border-left: 4px solid #4caf50;
                color: #2e7d32;
                display: block;
            }
            .feedback-merengue.error {
                background: #ffebee;
                border-left: 4px solid #f44336;
                color: #c62828;
                display: block;
            }

            /* ── ESCENARIO 4: HORNO/CONGELADOR ── */
            .horno-card {
                background: linear-gradient(135deg, #1a0a0a, #0a0a1a);
                border: 2px solid #5a2a2a;
                border-radius: 20px;
                padding: 32px;
                margin-bottom: 24px;
            }
            .horno-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.5rem;
                color: #ffcccc;
                margin-bottom: 8px;
            }
            .horno-desc {
                color: rgba(255,200,200,0.6);
                font-size: 13px;
                margin-bottom: 24px;
            }
            .horno-grid {
                display: flex;
                gap: 24px;
                flex-wrap: wrap;
                justify-content: center;
                margin: 20px 0;
            }
            .tarjeta-flip {
                width: 150px;
                height: 100px;
                perspective: 1000px;
                cursor: pointer;
            }
            .tarjeta-inner {
                position: relative;
                width: 100%;
                height: 100%;
                transition: transform 0.6s;
                transform-style: preserve-3d;
            }
            .tarjeta-flip.volteada .tarjeta-inner {
                transform: rotateY(180deg);
            }
            .tarjeta-frente, .tarjeta-dorso {
                position: absolute;
                width: 100%;
                height: 100%;
                backface-visibility: hidden;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                font-weight: 600;
                text-align: center;
                padding: 10px;
            }
            .tarjeta-frente {
                background: linear-gradient(135deg, #c0392b, #1a6699);
                color: white;
                border: 2px solid #e74c3c;
                font-size: 24px;
            }
            .tarjeta-dorso {
                background: #1a1a2e;
                color: #a0c4ff;
                border: 2px solid #4a90d9;
                transform: rotateY(180deg);
                font-size: 12px;
            }
            .tarjeta-flip.asignada .tarjeta-frente {
                opacity: 0.4;
            }
            .zonas-horno {
                display: flex;
                gap: 16px;
                flex-wrap: wrap;
                justify-content: center;
                margin-top: 24px;
            }
            .zona-horno {
                flex: 1;
                min-width: 150px;
                border-radius: 12px;
                padding: 16px;
                min-height: 120px;
                border: 2px dashed;
                text-align: center;
                transition: all 0.2s;
            }
            .zona-horno.caliente {
                background: rgba(231,76,60,0.1);
                border-color: #e74c3c;
            }
            .zona-horno.frio {
                background: rgba(74,144,217,0.1);
                border-color: #4a90d9;
            }
            .zona-horno h4 {
                margin-bottom: 10px;
                font-size: 13px;
            }
            .zona-horno.caliente h4 {
                color: #e74c3c;
            }
            .zona-horno.frio h4 {
                color: #4a90d9;
            }
            .zona-horno.activa {
                transform: scale(1.02);
            }
            .elem-asignado-horno {
                padding: 6px 10px;
                border-radius: 6px;
                font-size: 12px;
                margin: 4px;
                display: inline-block;
                color: white;
            }
            .elem-asignado-horno.caliente {
                background: #c0392b;
            }
            .elem-asignado-horno.frio {
                background: #1a6699;
            }
            .btn-horno {
                background: linear-gradient(135deg, #c0392b, #1a6699);
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 28px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                margin-top: 24px;
                transition: all 0.2s;
                font-family: 'DM Sans', sans-serif;
            }
            .btn-horno:hover {
                opacity: 0.9;
                transform: translateY(-1px);
            }
            .btn-horno:disabled {
                opacity: 0.4;
                cursor: not-allowed;
                transform: none;
            }
            .feedback-horno {
                margin-top: 16px;
                padding: 12px 16px;
                border-radius: 8px;
                font-size: 13px;
                display: none;
            }
            .feedback-horno.success {
                background: rgba(76,175,80,0.15);
                border-left: 4px solid #4caf50;
                color: #4caf50;
                display: block;
            }
            .feedback-horno.error {
                background: rgba(231,76,60,0.15);
                border-left: 4px solid #e74c3c;
                color: #e74c3c;
                display: block;
            }

            /* ── ESCENARIO 5: BAR MOLECULAR ── */
            .bar-card {
                background: linear-gradient(135deg, #0d0d1a, #1a0d2e);
                border: 2px solid #4a1a7a;
                border-radius: 20px;
                padding: 32px;
                margin-bottom: 24px;
            }
            .bar-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.5rem;
                color: #e0aaff;
                margin-bottom: 8px;
            }
            .bar-desc {
                color: rgba(224,170,255,0.6);
                font-size: 13px;
                margin-bottom: 24px;
            }
            .bar-elementos {
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
                justify-content: center;
                margin: 20px 0;
            }
            .copa-elemento {
                background: linear-gradient(135deg, #2d1a4a, #1a2d4a);
                border: 2px solid #7b2fff;
                border-radius: 12px;
                padding: 16px 20px;
                cursor: pointer;
                font-size: 14px;
                color: #e0aaff;
                transition: all 0.3s;
                text-align: center;
                min-width: 120px;
                position: relative;
                overflow: hidden;
            }
            .copa-elemento::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(123,47,255,0.1) 0%, transparent 70%);
                opacity: 0;
                transition: opacity 0.3s;
            }
            .copa-elemento:hover::before {
                opacity: 1;
            }
            .copa-elemento:hover {
                border-color: #00f5d4;
                color: #00f5d4;
                transform: translateY(-3px);
                box-shadow: 0 8px 20px rgba(0,245,212,0.2);
            }
            .copa-elemento.seleccionado {
                border-color: #00f5d4;
                background: linear-gradient(135deg, #1a3a3a, #2a1a4a);
                color: #00f5d4;
                box-shadow: 0 0 15px rgba(0,245,212,0.3);
            }
            .copa-elemento.asignado {
                border-color: #4caf50;
                background: linear-gradient(135deg, #1a2e1a, #1a2e1a);
                color: #4caf50;
                pointer-events: none;
            }
            .bar-zonas {
                display: flex;
                gap: 16px;
                flex-wrap: wrap;
                justify-content: center;
                margin-top: 24px;
            }
            .zona-bar {
                flex: 1;
                min-width: 140px;
                border-radius: 12px;
                padding: 16px;
                min-height: 110px;
                border: 2px dashed #4a1a7a;
                background: rgba(74,26,122,0.1);
                text-align: center;
                transition: all 0.2s;
                cursor: pointer;
            }
            .zona-bar h4 {
                color: #7b2fff;
                font-size: 13px;
                margin-bottom: 10px;
            }
            .zona-bar:hover {
                border-color: #00f5d4;
                background: rgba(0,245,212,0.05);
            }
            .zona-bar.activa {
                border-color: #00f5d4;
                background: rgba(0,245,212,0.08);
                transform: scale(1.02);
            }
            .elem-asignado-bar {
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 11px;
                margin: 3px;
                display: inline-block;
                background: rgba(0,245,212,0.15);
                color: #00f5d4;
                border: 1px solid #00f5d4;
            }
            .btn-bar {
                background: linear-gradient(135deg, #7b2fff, #00f5d4);
                color: white;
                border: none;
                border-radius: 50px;
                padding: 12px 28px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                margin-top: 24px;
                transition: all 0.2s;
                font-family: 'DM Sans', sans-serif;
            }
            .btn-bar:hover {
                opacity: 0.9;
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(123,47,255,0.4);
            }
            .btn-bar:disabled {
                opacity: 0.3;
                cursor: not-allowed;
                transform: none;
            }
            .feedback-bar {
                margin-top: 16px;
                padding: 12px 16px;
                border-radius: 8px;
                font-size: 13px;
                display: none;
            }
            .feedback-bar.success {
                background: rgba(0,245,212,0.1);
                border-left: 4px solid #00f5d4;
                color: #00f5d4;
                display: block;
            }
            .feedback-bar.error {
                background: rgba(255,50,50,0.1);
                border-left: 4px solid #ff3232;
                color: #ff3232;
                display: block;
            }

            /* ── ESCENARIO 6: OLLA A PRESION ── */
            .olla-card {
                background: linear-gradient(135deg, #1a1a1a, #2a2a2a);
                border: 2px solid #5a5a5a;
                border-radius: 20px;
                padding: 32px;
                margin-bottom: 24px;
            }
            .olla-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.5rem;
                color: #ffd700;
                margin-bottom: 8px;
            }
            .olla-desc {
                color: rgba(255,215,0,0.5);
                font-size: 13px;
                margin-bottom: 24px;
            }
            .olla-elementos {
                display: flex;
                flex-direction: column;
                gap: 16px;
                margin: 20px 0;
            }
            .olla-item {
                background: #2a2a2a;
                border: 2px solid #5a5a5a;
                border-radius: 12px;
                padding: 16px 20px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 12px;
            }
            .olla-item-nombre {
                font-size: 14px;
                color: #e0e0e0;
                font-weight: 600;
                flex: 1;
                min-width: 120px;
            }
            .olla-botones {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }
            .btn-olla-cat {
                padding: 8px 14px;
                border-radius: 8px;
                border: 2px solid #5a5a5a;
                background: #1a1a1a;
                color: #aaa;
                font-size: 12px;
                cursor: pointer;
                transition: all 0.2s;
                font-family: 'DM Sans', sans-serif;
            }
            .btn-olla-cat:hover {
                border-color: #ffd700;
                color: #ffd700;
            }
            .btn-olla-cat.seleccionado {
                border-color: #ffd700;
                background: rgba(255,215,0,0.15);
                color: #ffd700;
            }
            .btn-olla-cat.correcto {
                border-color: #4caf50;
                background: rgba(76,175,80,0.15);
                color: #4caf50;
            }
            .btn-olla-cat.incorrecto {
                border-color: #f44336;
                background: rgba(244,67,54,0.15);
                color: #f44336;
            }
            .olla-item.asignado {
                border-color: #ffd700;
                background: rgba(255,215,0,0.05);
            }
            .btn-olla-enviar {
                background: linear-gradient(135deg, #5a5a5a, #ffd700);
                color: #1a1a1a;
                border: none;
                border-radius: 8px;
                padding: 12px 28px;
                font-size: 14px;
                font-weight: 700;
                cursor: pointer;
                margin-top: 24px;
                transition: all 0.2s;
                font-family: 'DM Sans', sans-serif;
            }
            .btn-olla-enviar:hover {
                opacity: 0.9;
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(255,215,0,0.3);
            }
            .btn-olla-enviar:disabled {
                opacity: 0.3;
                cursor: not-allowed;
                transform: none;
            }
            .feedback-olla {
                margin-top: 16px;
                padding: 12px 16px;
                border-radius: 8px;
                font-size: 13px;
                display: none;
            }
            .feedback-olla.success {
                background: rgba(76,175,80,0.1);
                border-left: 4px solid #4caf50;
                color: #4caf50;
                display: block;
            }
            .feedback-olla.error {
                background: rgba(244,67,54,0.1);
                border-left: 4px solid #f44336;
                color: #f44336;
                display: block;
            }

            @media (max-width: 640px) {
                .drag-container {
                    flex-direction: column;
                }
                .navbar {
                    padding: 0 16px;
                }
                .contenedor {
                    padding: 32px 16px;
                }
                .tarjeta-flip {
                    width: 120px;
                    height: 80px;
                }
            }
        </style>
    </head>
    <body>
        <nav class="navbar">
            <div class="navbar-marca">
                <div class="marca-icono">
                    <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/></svg>
                </div>
                <span class="marca-nombre">Chef <span>Molecular</span></span>
            </div>
            <div class="navbar-nav">
                <a href="${pageContext.request.contextPath}/menu" class="nav-link">Menú</a>
                <a href="${pageContext.request.contextPath}/perfil" class="nav-link">Perfil</a>
                <a href="${pageContext.request.contextPath}/libroRecetas" class="nav-link">Recetas</a>
                <a href="${pageContext.request.contextPath}/ranking" class="nav-link">Ranking</a>
                <button class="btn-tema" id="btnTema" onclick="toggleTema()">🌙 Noche</button>
                <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-salir">Salir</a>
            </div>
        </nav>

        <div class="contenedor">
            <div class="progreso-actividades">
                <% for (int i = 0; i < totalActividades; i++) {%>
                <div class="progreso-paso">
                    <div class="paso-indicador <%= (i < actividadIdx) ? "completado" : (i == actividadIdx) ? "activo" : ""%>">
                        <%= i + 1%>
                    </div>
                    <% if (i < totalActividades - 1) {%>
                    <div class="paso-linea"></div>
                    <% }%>
                </div>
                <% }%>
            </div>

            <!-- ══════════════════════════════════════════ -->
            <!-- DRAG & DROP                                -->
            <!-- ══════════════════════════════════════════ -->
            <% if ("DRAG_AND_DROP".equals(actividad.getTipo())) {%>

            <!-- ESCENARIO 3: CONECTAR NODOS -->
            <% if (idEscenario == 3) {%>
            <div class="merengue-card">
                <h2 class="merengue-titulo">🍦 Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
                <p class="merengue-desc">Haz clic en un elemento de la izquierda y luego en su categoría correcta para conectarlos.</p>
                <div class="nodos-container">
                    <div class="nodos-col">
                        <h4>📦 Elementos</h4>
                        <% for (ElementoArrastrable e : elementos) {%>
                        <div class="nodo" id="elem_<%= e.getIdElemento()%>"
                             data-id="<%= e.getIdElemento()%>"
                             data-nombre="<%= e.getNombre()%>"
                             data-categoria-correcta="<%= e.getCategoriaCorrecta()%>"
                             data-tipo="elemento"
                             onclick="seleccionarNodo(this)">
                            <%= e.getNombre()%>
                        </div>
                        <% }%>
                    </div>
                    <div class="nodos-col">
                        <h4>🎯 Categorías</h4>
                        <% for (CategoriaActividad cat : categorias) {%>
                        <div class="nodo" id="cat_<%= cat.getIdCategoria()%>"
                             data-nombre="<%= cat.getNombreCategoria()%>"
                             data-tipo="categoria"
                             onclick="seleccionarNodo(this)">
                            <%= cat.getNombreCategoria()%>
                        </div>
                        <% }%>
                    </div>
                </div>
                <div class="conexiones-lista" id="conexionesMerengue"></div>
                <br>
                <button class="btn-merengue" id="btnEnviarMerengue" disabled onclick="enviarMerengue()">✅ Enviar conexiones</button>
                <div class="feedback-merengue" id="feedbackMerengue"></div>
                <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
                    <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
                    <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
                    <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
                    <input type="hidden" name="respuestas" id="respuestasJsonDnD">
                </form>
            </div>

            <!-- ESCENARIO 4: TARJETAS QUE SE VOLTEAN -->
            <% } else if (idEscenario == 4) {%>
            <div class="horno-card">
                <h2 class="horno-titulo">🔥❄️ Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
                <p class="horno-desc">Haz clic en cada tarjeta para revelar el elemento. Luego asígnalo a la categoría correcta.</p>
                <div class="horno-grid" id="hornoGrid">
                    <% for (ElementoArrastrable e : elementos) {%>
                    <div class="tarjeta-flip" id="tarjeta_<%= e.getIdElemento()%>"
                         data-id="<%= e.getIdElemento()%>"
                         data-nombre="<%= e.getNombre()%>"
                         data-categoria-correcta="<%= e.getCategoriaCorrecta()%>"
                         onclick="voltearTarjeta(this)">
                        <div class="tarjeta-inner">
                            <div class="tarjeta-frente">🃏</div>
                            <div class="tarjeta-dorso"><%= e.getNombre()%></div>
                        </div>
                    </div>
                    <% }%>
                </div>
                <div class="zonas-horno">
                    <% for (CategoriaActividad cat : categorias) {
                            String claseZona = cat.getNombreCategoria().toLowerCase().contains("calor") || cat.getNombreCategoria().toLowerCase().contains("caliente") || cat.getNombreCategoria().toLowerCase().contains("alto") ? "caliente" : "frio";
                    %>
                    <div class="zona-horno <%= claseZona%>" id="zonaH_<%= cat.getIdCategoria()%>"
                         data-categoria="<%= cat.getNombreCategoria()%>"
                         data-clase="<%= claseZona%>"
                         onclick="asignarAZonaHorno(this)">
                        <h4><%= cat.getNombreCategoria()%></h4>
                        <div id="elemsZonaH_<%= cat.getIdCategoria()%>"></div>
                    </div>
                    <% }%>
                </div>
                <button class="btn-horno" id="btnEnviarHorno" disabled onclick="enviarHorno()">✅ Enviar clasificación</button>
                <div class="feedback-horno" id="feedbackHorno"></div>
                <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
                    <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
                    <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
                    <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
                    <input type="hidden" name="respuestas" id="respuestasJsonDnD">
                </form>
            </div>

            <!-- ESCENARIO 5: BAR MOLECULAR CON NEON -->
            <% } else if (idEscenario == 5) {%>
            <div class="bar-card">
                <h2 class="bar-titulo">🍹 Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
                <p class="bar-desc">Selecciona un elemento y luego haz clic en la categoría donde pertenece. ¡El bar espera tus decisiones!</p>
                <div class="bar-elementos" id="barElementos">
                    <% for (ElementoArrastrable e : elementos) {%>
                    <div class="copa-elemento" id="barElem_<%= e.getIdElemento()%>"
                         data-id="<%= e.getIdElemento()%>"
                         data-nombre="<%= e.getNombre()%>"
                         data-categoria-correcta="<%= e.getCategoriaCorrecta()%>"
                         onclick="seleccionarElementoBar(this)">
                        🧪 <%= e.getNombre()%>
                    </div>
                    <% }%>
                </div>
                <div class="bar-zonas">
                    <% for (CategoriaActividad cat : categorias) {%>
                    <div class="zona-bar" id="zonaBar_<%= cat.getIdCategoria()%>"
                         data-categoria="<%= cat.getNombreCategoria()%>"
                         onclick="asignarAZonaBar(this)">
                        <h4>🏷️ <%= cat.getNombreCategoria()%></h4>
                        <div id="elemsZonaBar_<%= cat.getIdCategoria()%>"></div>
                    </div>
                    <% }%>
                </div>
                <button class="btn-bar" id="btnEnviarBar" disabled onclick="enviarBar()">✅ Servir respuestas</button>
                <div class="feedback-bar" id="feedbackBar"></div>
                <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
                    <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
                    <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
                    <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
                    <input type="hidden" name="respuestas" id="respuestasJsonDnD">
                </form>
            </div>

            <!-- ESCENARIO 6: OLLA A PRESION CON BOTONES -->
            <% } else if (idEscenario == 6) {%>
            <div class="olla-card">
                <h2 class="olla-titulo">⚗️ Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
                <p class="olla-desc">Para cada elemento, selecciona la categoría correcta presionando el botón correspondiente.</p>
                <div class="olla-elementos" id="ollaElementos">
                    <% for (ElementoArrastrable e : elementos) {%>
                    <div class="olla-item" id="ollaItem_<%= e.getIdElemento()%>"
                         data-id="<%= e.getIdElemento()%>"
                         data-categoria-correcta="<%= e.getCategoriaCorrecta()%>">
                        <span class="olla-item-nombre">⚙️ <%= e.getNombre()%></span>
                        <div class="olla-botones">
                            <% for (CategoriaActividad cat : categorias) {%>
                            <button class="btn-olla-cat"
                                    data-elemento-id="<%= e.getIdElemento()%>"
                                    data-categoria="<%= cat.getNombreCategoria()%>"
                                    onclick="seleccionarCategoriaOlla(this)">
                                <%= cat.getNombreCategoria()%>
                            </button>
                            <% }%>
                        </div>
                    </div>
                    <% }%>
                </div>
                <button class="btn-olla-enviar" id="btnEnviarOlla" disabled onclick="enviarOlla()">✅ Confirmar clasificación</button>
                <div class="feedback-olla" id="feedbackOlla"></div>
                <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
                    <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
                    <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
                    <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
                    <input type="hidden" name="respuestas" id="respuestasJsonDnD">
                </form>
            </div>

            <!-- UI ORIGINAL escenarios 1 y 2 -->
            <% } else {%>
            <div class="actividad-card">
                <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
                <p class="actividad-desc">Arrastra cada elemento a la categoría correcta.</p>
                <div class="drag-container">
                    <div class="elementos-origen" id="elementosOrigen">
                        <h4>📦 Elementos para clasificar</h4>
                        <div id="listaElementos">
                            <% for (ElementoArrastrable e : elementos) {%>
                            <div class="elemento-drag" draggable="true"
                                 data-id="<%= e.getIdElemento()%>"
                                 data-nombre="<%= e.getNombre()%>"
                                 data-categoria-correcta="<%= e.getCategoriaCorrecta()%>">
                                <%= e.getNombre()%>
                            </div>
                            <% }%>
                        </div>
                    </div>
                    <div class="zonas-container" id="zonasDestino">
                        <% for (CategoriaActividad cat : categorias) {%>
                        <div class="zona-destino" data-categoria="<%= cat.getNombreCategoria()%>">
                            <h4><%= cat.getNombreCategoria()%></h4>
                            <div class="elementos-colocados" id="zona_<%= cat.getIdCategoria()%>"></div>
                        </div>
                        <% }%>
                    </div>
                </div>
                <button class="btn-accion" id="btnEnviar" disabled>✅ Enviar respuestas</button>
                <div class="feedback" id="feedback"></div>
                <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
                    <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
                    <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
                    <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
                    <input type="hidden" name="respuestas" id="respuestasJsonDnD">
                </form>
            </div>
            <% }%>

            <!-- ══════════════════════════════════════════ -->
            <!-- MATCH DIPOLOS                              -->
            <!-- ══════════════════════════════════════════ -->
            <% } else if ("MATCH_DIPOLOS".equals(actividad.getTipo())) {
                List<ParDipolo> pares = (List<ParDipolo>) request.getAttribute("pares");
                java.util.Set<String> positivos = new java.util.LinkedHashSet<>();
                java.util.Set<String> negativos = new java.util.LinkedHashSet<>();
                if (pares != null) {
                    for (ParDipolo p : pares) {
                        positivos.add(p.getExtremoPositivo());
                        negativos.add(p.getExtremoNegativo());
                    }
                }
            %>
            <div class="actividad-card">
                <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
                <p class="actividad-desc">🥄 Arrastra cada extremo δ⁺ sobre el δ⁻ correcto para formar el par dipolo.</p>
                <div style="display:flex; gap:32px; align-items:flex-start; flex-wrap:wrap;">
                    <div style="flex:1; min-width:180px;">
                        <h4 style="color:var(--cobre);">Extremos δ⁺</h4>
                        <div id="positivos-pool" style="display:flex; flex-direction:column; gap:12px; margin-top:12px;">
                            <% for (String pos : positivos) {%>
                            <div class="mol-drag" draggable="true" data-extremo="<%= pos%>" data-tipo="positivo" style="background:#FFE0C0; border-color:var(--incorrecto);"><%= pos%></div>
                            <% }%>
                        </div>
                    </div>
                    <div style="flex:1; min-width:180px;">
                        <h4 style="color:var(--cobre);">Extremos δ⁻</h4>
                        <div id="negativos-pool" style="display:flex; flex-direction:column; gap:12px; margin-top:12px;">
                            <% for (String neg : negativos) {%>
                            <div class="mol-drag" draggable="true" data-extremo="<%= neg%>" data-tipo="negativo" style="background:#D5F0E0; border-color:#2C7A4D;"><%= neg%></div>
                            <% }%>
                        </div>
                    </div>
                </div>
                <div class="zona-alineacion" style="margin-top:24px;">
                    <h4 style="color:var(--cobre);">Pares formados (arrastra aquí):</h4>
                    <div id="pares-formados" style="display:flex; flex-wrap:wrap; gap:16px; min-height:80px; background:rgba(210,150,100,0.1); border-radius:12px; padding:16px; border:2px dashed var(--cobre);"></div>
                    <button class="btn-verificar" onclick="prepararEnvioDipolos()">✅ Verificar pares</button>
                    <div class="feedback" id="feedback"></div>
                </div>
                <form id="formMatch" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
                    <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
                    <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
                    <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
                    <input type="hidden" name="respuestas" id="respuestasJsonMatch">
                </form>
            </div>

            <!-- ══════════════════════════════════════════ -->
            <!-- MATCH PUENTES H                            -->
            <!-- ══════════════════════════════════════════ -->
            <% } else if ("MATCH_PUENTES_H".equals(actividad.getTipo())) {
                List<MoleculaPuenteH> moleculas = (List<MoleculaPuenteH>) request.getAttribute("moleculas");
            %>
            <div class="actividad-card">
                <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
                <p class="actividad-desc">⚛️ Seleccioná dos moléculas que puedan formar un <strong>puente de hidrógeno</strong>.</p>
                <div class="laboratorio-puentes">
                    <div class="moleculas-pool" id="moleculasPool">
                        <% for (MoleculaPuenteH m : moleculas) {%>
                        <div class="mol-chip" data-id="<%= m.getIdMolecula()%>" data-nombre="<%= m.getNombre()%>"
                             style="background:<%= m.isPuedeFormar() ? "#e8f5e9" : "#ffebee"%>; border-color:<%= m.isPuedeFormar() ? "#4caf50" : "#f44336"%>;">
                            <%= m.getNombre()%>
                        </div>
                        <% }%>
                    </div>
                    <div class="zona-pares">
                        <canvas id="canvasPuente" width="300" height="150" style="background:#fafafa; border-radius:12px; margin-bottom:10px;"></canvas>
                        <button class="btn-accion" id="btnFormarPar" disabled>🔗 Formar par</button>
                        <button class="btn-limpiar" id="btnLimpiarSeleccion">🧹 Limpiar selección</button>
                    </div>
                </div>
                <div class="pares-formados" id="paresFormados"><h4>Pares formados:</h4><div id="listaPares"></div></div>
                <button class="btn-accion" id="btnEnviar" disabled>✅ Enviar respuestas</button>
                <div class="feedback" id="feedback"></div>
                <form id="formMatchPuentes" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
                    <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
                    <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
                    <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
                    <input type="hidden" name="respuestas" id="respuestasJsonPuentes">
                </form>
            </div>

            <!-- ══════════════════════════════════════════ -->
            <!-- SIMULACION ESTADOS                         -->
            <!-- ══════════════════════════════════════════ -->
            <% } else if ("SIMULACION_ESTADOS".equals(actividad.getTipo())) {
                List<PreguntaSimulacionEstados> preguntas = (List<PreguntaSimulacionEstados>) request.getAttribute("preguntas");
                PreguntaSimulacionEstados preguntaActual = (preguntas != null && !preguntas.isEmpty()) ? preguntas.get(0) : null;
            %>
            <div class="actividad-card">
                <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
                <p class="actividad-desc">🌡️ Mueve el deslizador para cambiar la temperatura y observa cómo se comportan las partículas.</p>
                <div style="text-align:center; margin:20px 0;">
                    <canvas id="canvasEstados" width="500" height="200" style="background:#f0f0f0; border-radius:8px;"></canvas>
                    <div style="margin-top:10px;">
                        <input type="range" id="tempSlider" min="-50" max="150" value="25" step="1" oninput="actualizarTemperatura(this.value)">
                        <span id="tempLabel">25 °C</span>
                        <span id="estadoLabel" style="margin-left:20px; font-weight:bold;">Líquido</span>
                    </div>
                </div>
                <% if (preguntaActual != null) {%>
                <div style="margin-top:30px;">
                    <h4><%= preguntaActual.getEnunciado()%></h4>
                    <div style="display:flex; gap:20px; justify-content:center; margin-top:15px; flex-wrap:wrap;">
                        <button onclick="seleccionarOpcion(1, event)" class="btn-opcion">A. <%= preguntaActual.getOpcionA()%></button>
                        <button onclick="seleccionarOpcion(2, event)" class="btn-opcion">B. <%= preguntaActual.getOpcionB()%></button>
                        <button onclick="seleccionarOpcion(3, event)" class="btn-opcion">C. <%= preguntaActual.getOpcionC()%></button>
                        <button onclick="seleccionarOpcion(4, event)" class="btn-opcion">D. <%= preguntaActual.getOpcionD()%></button>
                    </div>
                </div>
                <% }%>
                <div style="margin-top:30px;">
                    <button class="btn-accion" id="btnEnviarEstados" disabled onclick="enviarRespuesta()">✅ Enviar respuesta</button>
                </div>
                <form id="formSimulacionEstados" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
                    <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
                    <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
                    <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
                    <input type="hidden" name="respuestas" id="respuestasEstadosJson">
                </form>
            </div>

            <!-- ══════════════════════════════════════════ -->
            <!-- IDENTIFICACION PROPIEDAD                   -->
            <!-- ══════════════════════════════════════════ -->
            <% } else if ("IDENTIFICACION_PROPIEDAD".equals(actividad.getTipo())) {
                List<FenomenoPropiedad> fenomenos = (List<FenomenoPropiedad>) request.getAttribute("fenomenos");
                if (fenomenos == null || fenomenos.isEmpty()) {
            %>
            <div class="actividad-card"><p>No hay fenómenos disponibles.</p></div>
            <% } else {%>
            <div class="actividad-card">
                <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
                <p class="actividad-desc">🔬 Observá la animación y elegí la propiedad del líquido que se está mostrando.</p>
                <div id="visorFenomeno" style="text-align:center; margin:20px 0;">
                    <canvas id="canvasFenomeno" width="300" height="150" style="background:#e0f7fa; border-radius:12px;"></canvas>
                    <p id="descripcionFenomeno" style="margin-top:10px;"></p>
                    <div id="botonesPropiedades" style="margin-top:15px; display:flex; gap:12px; justify-content:center; flex-wrap:wrap;">
                        <button class="btn-opcion" onclick="seleccionarPropiedad('TENSION_SUPERFICIAL')">🌊 Tensión superficial</button>
                        <button class="btn-opcion" onclick="seleccionarPropiedad('VISCOSIDAD')">🍯 Viscosidad</button>
                        <button class="btn-opcion" onclick="seleccionarPropiedad('CAPILARIDAD')">🧪 Capilaridad</button>
                    </div>
                </div>
                <button class="btn-accion" id="btnSiguiente" disabled onclick="siguienteFenomeno()">Siguiente ➡️</button>
                <button class="btn-accion" id="btnEnviarPropiedades" style="display:none;" onclick="enviarRespuestas()">✅ Enviar todas las respuestas</button>
                <div id="feedbackFenomeno" style="margin-top:15px; color:#f44336;"></div>
            </div>
            <form id="formPropiedades" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
                <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
                <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
                <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
                <input type="hidden" name="respuestas" id="respuestasPropiedadesJson">
            </form>
            <% }%>

            <!-- ══════════════════════════════════════════ -->
            <!-- SIMULACION EBULLICION                      -->
            <!-- ══════════════════════════════════════════ -->
            <% } else if ("SIMULACION_EBULLICION".equals(actividad.getTipo())) {
                List<PreguntaSimulacionEbullicion> preguntas = (List<PreguntaSimulacionEbullicion>) request.getAttribute("preguntas");
                if (preguntas == null || preguntas.isEmpty()) {
            %>
            <p>No hay preguntas disponibles.</p>
            <% } else {%>
            <div class="actividad-card">
                <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
                <p class="actividad-desc">🌋 Ajustá la altitud con el deslizador y observá cómo cambia la temperatura de ebullición.</p>
                <div style="text-align:center; margin:20px 0;">
                    <canvas id="canvasEbullicion" width="400" height="200" style="background:#fff3e0; border-radius:8px;"></canvas>
                    <div style="margin-top:10px;">
                        <input type="range" id="altitudSlider" min="0" max="4000" value="0" step="100" oninput="actualizarAltitud(this.value)">
                        <span id="altitudLabel">0 m</span>
                        <span id="tempEbullicionLabel" style="margin-left:20px; font-weight:bold;">100 °C</span>
                    </div>
                </div>
                <% for (PreguntaSimulacionEbullicion pregunta : preguntas) {%>
                <div style="margin:30px 0;">
                    <h4><%= pregunta.getEnunciado()%></h4>
                    <div style="display:flex; gap:15px; justify-content:center; margin-top:10px;">
                        <button class="btn-opcion" data-pregunta="<%= pregunta.getIdPregunta()%>" data-opcion="1">A. <%= pregunta.getOpcionA()%></button>
                        <button class="btn-opcion" data-pregunta="<%= pregunta.getIdPregunta()%>" data-opcion="2">B. <%= pregunta.getOpcionB()%></button>
                        <button class="btn-opcion" data-pregunta="<%= pregunta.getIdPregunta()%>" data-opcion="3">C. <%= pregunta.getOpcionC()%></button>
                        <button class="btn-opcion" data-pregunta="<%= pregunta.getIdPregunta()%>" data-opcion="4">D. <%= pregunta.getOpcionD()%></button>
                    </div>
                </div>
                <% }%>
                <button class="btn-accion" id="btnEnviarEbullicion" onclick="enviarRespuestasEbullicion()">✅ Enviar respuestas</button>
                <div id="feedbackEbullicion" style="margin-top:15px;"></div>
            </div>
            <form id="formEbullicion" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
                <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
                <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
                <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
                <input type="hidden" name="respuestas" id="respuestasEbullicionJson">
            </form>
            <% }%>

            <% } else {%>
            <div class="actividad-card"><p>Actividad no disponible aún.</p></div>
            <% }%>

        </div>

        <script>
            const btnT = document.getElementById('btnTema');
            function aplicarTema(esDia) {
                document.body.classList.toggle('dia', esDia);
                btnT.textContent = esDia ? '☀️ Día' : '🌙 Noche';
            }
            function toggleTema() {
                const esDia = document.body.classList.contains('dia');
                localStorage.setItem('chefMolecularTema', esDia ? 'noche' : 'dia');
                aplicarTema(!esDia);
            }
            if (localStorage.getItem('chefMolecularTema') === 'dia')
                aplicarTema(true);

            function mostrarFeedback(mensaje, tipo) {
                const fb = document.getElementById('feedback');
                if (!fb)
                    return;
                fb.textContent = mensaje;
                fb.className = 'feedback ' + tipo;
                setTimeout(() => {
                    fb.className = 'feedback';
                }, 3000);
            }

            // ================================================================
            // DRAG & DROP - LÓGICA POR ESCENARIO
            // ================================================================
            <% if ("DRAG_AND_DROP".equals(actividad.getTipo())) {%>

            <% if (idEscenario == 3) {%>
            // ── ESCENARIO 3: CONECTAR NODOS ──
            let asignacionesMerengue = {};
            let elementoSeleccionado = null;
            let totalElementosMerengue = <%= elementos != null ? elementos.size() : 0%>;

            function seleccionarNodo(nodo) {
                const tipo = nodo.dataset.tipo;
                if (tipo === 'elemento') {
                    if (nodo.classList.contains('conectado'))
                        return;
                    document.querySelectorAll('.nodo[data-tipo="elemento"]').forEach(n => n.classList.remove('seleccionado'));
                    if (elementoSeleccionado === nodo) {
                        elementoSeleccionado = null;
                        return;
                    }
                    elementoSeleccionado = nodo;
                    nodo.classList.add('seleccionado');
                } else if (tipo === 'categoria') {
                    if (!elementoSeleccionado) {
                        mostrarFeedbackMerengue('Primero selecciona un elemento.', 'error');
                        return;
                    }
                    const idElemento = elementoSeleccionado.dataset.id;
                    const nombreElemento = elementoSeleccionado.dataset.nombre;
                    const categoriaCorrecta = elementoSeleccionado.dataset.categoriaCorrecta;
                    const categoriaDestino = nodo.dataset.nombre;
                    if (categoriaDestino !== categoriaCorrecta) {
                        mostrarFeedbackMerengue('"' + nombreElemento + '" no pertenece a "' + categoriaDestino + '".', 'error');
                        elementoSeleccionado.classList.remove('seleccionado');
                        elementoSeleccionado = null;
                        return;
                    }
                    asignacionesMerengue[idElemento] = categoriaDestino;
                    elementoSeleccionado.classList.remove('seleccionado');
                    elementoSeleccionado.classList.add('conectado');
                    elementoSeleccionado = null;
                    const div = document.createElement('div');
                    div.className = 'conexion-item';
                    div.innerHTML = nombreElemento + ' → ' + categoriaDestino + ' <button class="btn-quitar-conexion" onclick="quitarConexion(\'' + idElemento + '\', this)">✖</button>';
                    document.getElementById('conexionesMerengue').appendChild(div);
                    mostrarFeedbackMerengue('✓ "' + nombreElemento + '" conectado.', 'success');
                    if (Object.keys(asignacionesMerengue).length === totalElementosMerengue) {
                        document.getElementById('btnEnviarMerengue').disabled = false;
                        mostrarFeedbackMerengue('✅ ¡Todos conectados!', 'success');
                    }
                }
            }
            function quitarConexion(idElemento, btn) {
                delete asignacionesMerengue[idElemento];
                const nodo = document.getElementById('elem_' + idElemento);
                if (nodo)
                    nodo.classList.remove('conectado');
                btn.parentElement.remove();
                document.getElementById('btnEnviarMerengue').disabled = true;
            }
            function mostrarFeedbackMerengue(mensaje, tipo) {
                const fb = document.getElementById('feedbackMerengue');
                fb.textContent = mensaje;
                fb.className = 'feedback-merengue ' + tipo;
                setTimeout(() => {
                    fb.className = 'feedback-merengue';
                }, 3000);
            }
            function enviarMerengue() {
                const respuestas = Object.entries(asignacionesMerengue).map(([idElemento, categoria]) => ({idElemento: parseInt(idElemento), categoria}));
                document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
                document.getElementById('formDnD').submit();
            }

            <% } else if (idEscenario == 4) {%>
            // ── ESCENARIO 4: TARJETAS ──
            let asignacionesHorno = {};
            let tarjetaSeleccionada = null;
            let totalElementosHorno = <%= elementos != null ? elementos.size() : 0%>;

            function voltearTarjeta(tarjeta) {
                if (tarjeta.classList.contains('asignada'))
                    return;
                tarjeta.classList.toggle('volteada');
                if (tarjeta.classList.contains('volteada')) {
                    document.querySelectorAll('.tarjeta-flip.volteada').forEach(t => {
                        if (t !== tarjeta)
                            t.classList.remove('volteada');
                    });
                    tarjetaSeleccionada = tarjeta;
                    document.querySelectorAll('.zona-horno').forEach(z => z.classList.add('activa'));
                } else {
                    tarjetaSeleccionada = null;
                    document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa'));
                }
            }
            function asignarAZonaHorno(zona) {
                if (!tarjetaSeleccionada) {
                    mostrarFeedbackHorno('Primero haz clic en una tarjeta para revelarla.', 'error');
                    return;
                }
                const idElemento = tarjetaSeleccionada.dataset.id;
                const nombreElemento = tarjetaSeleccionada.dataset.nombre;
                const categoriaCorrecta = tarjetaSeleccionada.dataset.categoriaCorrecta;
                const categoriaDestino = zona.dataset.categoria;
                if (categoriaDestino !== categoriaCorrecta) {
                    mostrarFeedbackHorno('"' + nombreElemento + '" no pertenece aquí.', 'error');
                    tarjetaSeleccionada.classList.remove('volteada');
                    tarjetaSeleccionada = null;
                    document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa'));
                    return;
                }
                asignacionesHorno[idElemento] = categoriaDestino;
                tarjetaSeleccionada.classList.add('asignada');
                tarjetaSeleccionada.classList.remove('volteada');
                tarjetaSeleccionada = null;
                document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa'));
                const span = document.createElement('span');
                span.className = 'elem-asignado-horno ' + zona.dataset.clase;
                span.textContent = nombreElemento;
                zona.querySelector('[id^="elemsZonaH_"]').appendChild(span);
                mostrarFeedbackHorno('✓ "' + nombreElemento + '" asignado.', 'success');
                if (Object.keys(asignacionesHorno).length === totalElementosHorno) {
                    document.getElementById('btnEnviarHorno').disabled = false;
                    mostrarFeedbackHorno('✅ ¡Todos clasificados!', 'success');
                }
            }
            function mostrarFeedbackHorno(mensaje, tipo) {
                const fb = document.getElementById('feedbackHorno');
                fb.textContent = mensaje;
                fb.className = 'feedback-horno ' + tipo;
                setTimeout(() => {
                    fb.className = 'feedback-horno';
                }, 3000);
            }
            function enviarHorno() {
                const respuestas = Object.entries(asignacionesHorno).map(([idElemento, categoria]) => ({idElemento: parseInt(idElemento), categoria}));
                document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
                document.getElementById('formDnD').submit();
            }

            <% } else if (idEscenario == 5) {%>
            // ── ESCENARIO 5: BAR MOLECULAR ──
            let asignacionesBar = {};
            let elementoSeleccionadoBar = null;
            let totalElementosBar = <%= elementos != null ? elementos.size() : 0%>;

            function seleccionarElementoBar(elem) {
                if (elem.classList.contains('asignado'))
                    return;
                document.querySelectorAll('.copa-elemento').forEach(e => e.classList.remove('seleccionado'));
                if (elementoSeleccionadoBar === elem) {
                    elementoSeleccionadoBar = null;
                    return;
                }
                elementoSeleccionadoBar = elem;
                elem.classList.add('seleccionado');
                document.querySelectorAll('.zona-bar').forEach(z => z.classList.add('activa'));
            }
            function asignarAZonaBar(zona) {
                if (!elementoSeleccionadoBar) {
                    mostrarFeedbackBar('Primero selecciona un elemento.', 'error');
                    return;
                }
                const idElemento = elementoSeleccionadoBar.dataset.id;
                const nombreElemento = elementoSeleccionadoBar.dataset.nombre;
                const categoriaCorrecta = elementoSeleccionadoBar.dataset.categoriaCorrecta;
                const categoriaDestino = zona.dataset.categoria;
                if (categoriaDestino !== categoriaCorrecta) {
                    mostrarFeedbackBar('"' + nombreElemento + '" no va aquí. Intenta de nuevo.', 'error');
                    elementoSeleccionadoBar.classList.remove('seleccionado');
                    elementoSeleccionadoBar = null;
                    document.querySelectorAll('.zona-bar').forEach(z => z.classList.remove('activa'));
                    return;
                }
                asignacionesBar[idElemento] = categoriaDestino;
                elementoSeleccionadoBar.classList.remove('seleccionado');
                elementoSeleccionadoBar.classList.add('asignado');
                elementoSeleccionadoBar = null;
                document.querySelectorAll('.zona-bar').forEach(z => z.classList.remove('activa'));
                const span = document.createElement('span');
                span.className = 'elem-asignado-bar';
                span.textContent = nombreElemento;
                zona.querySelector('[id^="elemsZonaBar_"]').appendChild(span);
                mostrarFeedbackBar('✓ "' + nombreElemento + '" servido.', 'success');
                if (Object.keys(asignacionesBar).length === totalElementosBar) {
                    document.getElementById('btnEnviarBar').disabled = false;
                    mostrarFeedbackBar('✅ ¡Todos servidos! Envía tus respuestas.', 'success');
                }
            }
            function mostrarFeedbackBar(mensaje, tipo) {
                const fb = document.getElementById('feedbackBar');
                fb.textContent = mensaje;
                fb.className = 'feedback-bar ' + tipo;
                setTimeout(() => {
                    fb.className = 'feedback-bar';
                }, 3000);
            }
            function enviarBar() {
                const respuestas = Object.entries(asignacionesBar).map(([idElemento, categoria]) => ({idElemento: parseInt(idElemento), categoria}));
                document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
                document.getElementById('formDnD').submit();
            }

            <% } else if (idEscenario == 6) {%>
            // ── ESCENARIO 6: OLLA A PRESION ──
            let asignacionesOlla = {};
            let totalElementosOlla = <%= elementos != null ? elementos.size() : 0%>;

            function seleccionarCategoriaOlla(btn) {
                const idElemento = btn.dataset.elementoId;
                const categoria = btn.dataset.categoria;
                const item = document.getElementById('ollaItem_' + idElemento);
                const categoriaCorrecta = item.dataset.categoriaCorrecta;
                document.querySelectorAll('.btn-olla-cat[data-elemento-id="' + idElemento + '"]').forEach(b => {
                    b.classList.remove('seleccionado', 'correcto', 'incorrecto');
                });
                if (categoria === categoriaCorrecta) {
                    btn.classList.add('correcto');
                    asignacionesOlla[idElemento] = categoria;
                    item.classList.add('asignado');
                    mostrarFeedbackOlla('✓ Correcto.', 'success');
                } else {
                    btn.classList.add('incorrecto');
                    delete asignacionesOlla[idElemento];
                    mostrarFeedbackOlla('✗ Incorrecto, intenta de nuevo.', 'error');
                }
                if (Object.keys(asignacionesOlla).length === totalElementosOlla) {
                    document.getElementById('btnEnviarOlla').disabled = false;
                    mostrarFeedbackOlla('✅ ¡Todo clasificado!', 'success');
                }
            }
            function mostrarFeedbackOlla(mensaje, tipo) {
                const fb = document.getElementById('feedbackOlla');
                fb.textContent = mensaje;
                fb.className = 'feedback-olla ' + tipo;
                setTimeout(() => {
                    fb.className = 'feedback-olla';
                }, 3000);
            }
            function enviarOlla() {
                const respuestas = Object.entries(asignacionesOlla).map(([idElemento, categoria]) => ({idElemento: parseInt(idElemento), categoria}));
                document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
                document.getElementById('formDnD').submit();
            }

            <% } else {%>
            // ── UI ORIGINAL escenarios 1 y 2 ──
            let asignaciones = {};
            let elementosOriginalesDnD = [];
            let elementoDragActual = null;

            document.querySelectorAll('.elemento-drag').forEach(el => {
                elementosOriginalesDnD.push({id: el.dataset.id, nombre: el.dataset.nombre, elemento: el, categoriaCorrecta: el.dataset.categoriaCorrecta});
                el.addEventListener('dragstart', function (e) {
                    elementoDragActual = this;
                    e.dataTransfer.setData('text/plain', this.dataset.id);
                    this.classList.add('dragging');
                });
                el.addEventListener('dragend', function () {
                    this.classList.remove('dragging');
                    elementoDragActual = null;
                });
            });

            document.querySelectorAll('.zona-destino').forEach(zona => {
                zona.addEventListener('dragover', function (e) {
                    e.preventDefault();
                    this.classList.add('drag-over');
                });
                zona.addEventListener('dragleave', function () {
                    this.classList.remove('drag-over');
                });
                zona.addEventListener('drop', function (e) {
                    e.preventDefault();
                    this.classList.remove('drag-over');
                    if (!elementoDragActual)
                        return;
                    const idElemento = elementoDragActual.dataset.id;
                    const nombreElemento = elementoDragActual.dataset.nombre;
                    const categoriaCorrecta = elementoDragActual.dataset.categoriaCorrecta;
                    const categoriaDestino = this.dataset.categoria;
                    if (asignaciones[idElemento]) {
                        mostrarFeedback('Este elemento ya fue colocado.', 'error');
                        return;
                    }
                    if (categoriaDestino !== categoriaCorrecta) {
                        mostrarFeedback('"' + nombreElemento + '" no pertenece aquí.', 'error');
                        return;
                    }
                    asignaciones[idElemento] = categoriaDestino;
                    elementoDragActual.style.display = 'none';
                    const div = document.createElement('div');
                    div.className = 'elemento-ubicado';
                    div.innerHTML = nombreElemento + ' <button class="btn-quitar" data-id="' + idElemento + '">✖</button>';
                    this.querySelector('.elementos-colocados').appendChild(div);
                    div.querySelector('.btn-quitar').addEventListener('click', function (e) {
                        e.stopPropagation();
                        const orig = elementosOriginalesDnD.find(el => el.id === this.dataset.id);
                        if (orig)
                            orig.elemento.style.display = 'block';
                        delete asignaciones[this.dataset.id];
                        this.parentElement.remove();
                        document.getElementById('btnEnviar').disabled = (Object.keys(asignaciones).length !== elementosOriginalesDnD.length);
                    });
                    mostrarFeedback('✓ "' + nombreElemento + '" colocado.', 'success');
                    if (Object.keys(asignaciones).length === elementosOriginalesDnD.length) {
                        document.getElementById('btnEnviar').disabled = false;
                        mostrarFeedback('✅ ¡Todos clasificados!', 'success');
                    }
                });
            });

            document.getElementById('btnEnviar').addEventListener('click', function () {
                if (Object.keys(asignaciones).length !== elementosOriginalesDnD.length) {
                    mostrarFeedback('❌ Clasificá todos los elementos.', 'error');
                    return;
                }
                const respuestas = Object.entries(asignaciones).map(([idElemento, categoria]) => ({idElemento: parseInt(idElemento), categoria}));
                document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
                document.getElementById('formDnD').submit();
            });
            <% }%>
            <% }%>

            // ================================================================
            // MATCH DIPOLOS
            // ================================================================
            <% if ("MATCH_DIPOLOS".equals(actividad.getTipo())) {%>
            let paresColocados = [];
            const paresFormadosDiv = document.getElementById('pares-formados');
            document.querySelectorAll('.mol-drag').forEach(el => {
                el.addEventListener('dragstart', function (e) {
                    e.dataTransfer.setData('text/plain', JSON.stringify({extremo: this.dataset.extremo, tipo: this.dataset.tipo}));
                    this.style.opacity = '0.4';
                });
                el.addEventListener('dragend', function () {
                    this.style.opacity = '1';
                });
            });
            paresFormadosDiv.addEventListener('dragover', function (e) {
                e.preventDefault();
                this.classList.add('drag-over');
            });
            paresFormadosDiv.addEventListener('dragleave', function () {
                this.classList.remove('drag-over');
            });
            paresFormadosDiv.addEventListener('drop', function (e) {
                e.preventDefault();
                this.classList.remove('drag-over');
                try {
                    const data = JSON.parse(e.dataTransfer.getData('text/plain'));
                    if (!data.extremo || !data.tipo)
                        return;
                    if (paresColocados.some(p => (data.tipo === 'positivo' && p.positivo === data.extremo) || (data.tipo === 'negativo' && p.negativo === data.extremo))) {
                        alert('Ese extremo ya fue emparejado.');
                        return;
                    }
                    const parIncompleto = paresColocados.find(p => (data.tipo === 'positivo' && !p.positivo) || (data.tipo === 'negativo' && !p.negativo));
                    if (parIncompleto) {
                        if (data.tipo === 'positivo')
                            parIncompleto.positivo = data.extremo;
                        else
                            parIncompleto.negativo = data.extremo;
                    } else {
                        paresColocados.push({positivo: data.tipo === 'positivo' ? data.extremo : null, negativo: data.tipo === 'negativo' ? data.extremo : null});
                    }
                    actualizarParesUI();
                } catch (err) {
                }
            });
            function actualizarParesUI() {
                paresFormadosDiv.innerHTML = '';
                paresColocados.forEach((par, idx) => {
                    const div = document.createElement('div');
                    div.style.cssText = 'display:flex;align-items:center;gap:8px;background:var(--cobre);color:white;padding:8px 12px;border-radius:8px;';
                    div.innerHTML = '<span>' + (par.positivo || '?') + '</span> ↔ <span>' + (par.negativo || '?') + '</span>';
                    const btn = document.createElement('button');
                    btn.textContent = '✖';
                    btn.className = 'btn-quitar';
                    btn.onclick = () => {
                        paresColocados.splice(idx, 1);
                        actualizarParesUI();
                    };
                    div.appendChild(btn);
                    paresFormadosDiv.appendChild(div);
                });
            }
            function prepararEnvioDipolos() {
                const completos = paresColocados.filter(p => p.positivo && p.negativo);
                if (completos.length === 0) {
                    mostrarFeedback('Debés formar al menos un par.', 'error');
                    return;
                }
                document.getElementById('respuestasJsonMatch').value = JSON.stringify(completos.map(p => ({extremoPositivo: p.positivo, extremoNegativo: p.negativo})));
                document.getElementById('formMatch').submit();
            }
            <% }%>

            // ================================================================
            // MATCH PUENTES H
            // ================================================================
            <% if ("MATCH_PUENTES_H".equals(actividad.getTipo())) {%>
            let seleccionadas = [];
            let paresConfirmados = [];
            const canvas = document.getElementById('canvasPuente');
            const ctx = canvas.getContext('2d');
            const btnFormar = document.getElementById('btnFormarPar');
            const btnLimpiar = document.getElementById('btnLimpiarSeleccion');
            const listaPares = document.getElementById('listaPares');
            const btnEnviar = document.getElementById('btnEnviar');

            function dibujarCanvas(m1, m2, conectado) {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                ctx.strokeStyle = '#aaa';
                ctx.lineWidth = 1;
                ctx.beginPath();
                ctx.arc(80, 75, 30, 0, Math.PI * 2);
                ctx.fillStyle = '#e3f2fd';
                ctx.fill();
                ctx.stroke();
                if (m1) {
                    ctx.fillStyle = '#333';
                    ctx.font = '11px sans-serif';
                    ctx.textAlign = 'center';
                    ctx.fillText(m1.nombre.length > 10 ? m1.nombre.substring(0, 9) + '…' : m1.nombre, 80, 79);
                }
                ctx.beginPath();
                ctx.arc(220, 75, 30, 0, Math.PI * 2);
                ctx.fillStyle = '#e3f2fd';
                ctx.fill();
                ctx.stroke();
                if (m2) {
                    ctx.fillStyle = '#333';
                    ctx.textAlign = 'center';
                    ctx.fillText(m2.nombre.length > 10 ? m2.nombre.substring(0, 9) + '…' : m2.nombre, 220, 79);
                }
                if (conectado) {
                    ctx.beginPath();
                    ctx.moveTo(110, 75);
                    ctx.lineTo(190, 75);
                    ctx.strokeStyle = '#4caf50';
                    ctx.lineWidth = 3;
                    ctx.setLineDash([5, 3]);
                    ctx.stroke();
                    ctx.setLineDash([]);
                }
            }
            document.querySelectorAll('.mol-chip').forEach(chip => {
                chip.addEventListener('click', function () {
                    const id = parseInt(this.dataset.id), nombre = this.dataset.nombre;
                    if (paresConfirmados.some(p => p.id1 === id || p.id2 === id)) {
                        mostrarFeedback('Esa molécula ya está en un par.', 'error');
                        return;
                    }
                    if (seleccionadas.length >= 2) {
                        mostrarFeedback('Solo podés seleccionar dos.', 'error');
                        return;
                    }
                    if (seleccionadas.find(m => m.id === id)) {
                        seleccionadas = seleccionadas.filter(m => m.id !== id);
                        this.classList.remove('seleccionada');
                    } else {
                        seleccionadas.push({id, nombre, elemento: this});
                        this.classList.add('seleccionada');
                    }
                    btnFormar.disabled = (seleccionadas.length !== 2);
                    btnLimpiar.disabled = (seleccionadas.length === 0);
                    dibujarCanvas(seleccionadas[0] || null, seleccionadas[1] || null, seleccionadas.length === 2);
                });
            });
            btnLimpiar.addEventListener('click', () => {
                seleccionadas.forEach(m => m.elemento.classList.remove('seleccionada'));
                seleccionadas = [];
                btnFormar.disabled = true;
                dibujarCanvas(null, null, false);
            });
            btnFormar.addEventListener('click', () => {
                if (seleccionadas.length !== 2)
                    return;
                const [m1, m2] = seleccionadas;
                if (paresConfirmados.some(p => (p.id1 === m1.id && p.id2 === m2.id) || (p.id1 === m2.id && p.id2 === m1.id))) {
                    mostrarFeedback('Ese par ya fue formado.', 'error');
                    return;
                }
                paresConfirmados.push({id1: m1.id, id2: m2.id, nombre1: m1.nombre, nombre2: m2.nombre});
                const divPar = document.createElement('div');
                divPar.className = 'par-item';
                divPar.innerHTML = '<span>' + m1.nombre + '</span> ↔ <span>' + m2.nombre + '</span><button class="btn-quitar" data-id1="' + m1.id + '" data-id2="' + m2.id + '">✖</button>';
                listaPares.appendChild(divPar);
                divPar.querySelector('.btn-quitar').addEventListener('click', function (e) {
                    e.stopPropagation();
                    const i1 = parseInt(this.dataset.id1), i2 = parseInt(this.dataset.id2);
                    paresConfirmados = paresConfirmados.filter(p => !(p.id1 === i1 && p.id2 === i2));
                    this.parentElement.remove();
                    btnEnviar.disabled = (paresConfirmados.length === 0);
                });
                seleccionadas.forEach(m => m.elemento.classList.remove('seleccionada'));
                seleccionadas = [];
                btnFormar.disabled = true;
                dibujarCanvas(null, null, false);
                btnEnviar.disabled = false;
            });
            btnEnviar.addEventListener('click', () => {
                if (paresConfirmados.length === 0) {
                    mostrarFeedback('Debés formar al menos un par.', 'error');
                    return;
                }
                document.getElementById('respuestasJsonPuentes').value = JSON.stringify(paresConfirmados.map(p => ({idMolecula1: p.id1, idMolecula2: p.id2})));
                document.getElementById('formMatchPuentes').submit();
            });
            <% }%>

            // ================================================================
            // SIMULACION ESTADOS
            // ================================================================
            <% if ("SIMULACION_ESTADOS".equals(actividad.getTipo())) {
                    PreguntaSimulacionEstados preguntaActual = null;
                    List<PreguntaSimulacionEstados> preguntasJs = (List<PreguntaSimulacionEstados>) request.getAttribute("preguntas");
                    if (preguntasJs != null && !preguntasJs.isEmpty())
                        preguntaActual = preguntasJs.get(0);
            %>
            const canvasEstados = document.getElementById('canvasEstados');
            const ctxEstados = canvasEstados.getContext('2d');
            let temperatura = 25, opcionSeleccionada = 0;
            let particulas = [];
            for (let i = 0; i < 20; i++)
                particulas.push({x: Math.random() * canvasEstados.width, y: Math.random() * canvasEstados.height, vx: (Math.random() - 0.5) * 2, vy: (Math.random() - 0.5) * 2, radio: 4});

            function actualizarTemperatura(valor) {
                temperatura = parseInt(valor);
                document.getElementById('tempLabel').textContent = valor + ' °C';
                let estado = 'Sólido';
                if (temperatura > 0 && temperatura < 100)
                    estado = 'Líquido';
                else if (temperatura >= 100)
                    estado = 'Gas';
                document.getElementById('estadoLabel').textContent = estado;
            }
            function animar() {
                ctxEstados.clearRect(0, 0, canvasEstados.width, canvasEstados.height);
                let vMax = temperatura <= 0 ? 0.1 : temperatura < 100 ? 1.5 : 4;
                particulas.forEach(p => {
                    p.vx += (Math.random() - 0.5) * 0.2;
                    p.vy += (Math.random() - 0.5) * 0.2;
                    let vel = Math.sqrt(p.vx * p.vx + p.vy * p.vy);
                    if (vel > vMax) {
                        p.vx = (p.vx / vel) * vMax;
                        p.vy = (p.vy / vel) * vMax;
                    }
                    if (temperatura <= 0) {
                        let px = (p.x % 100) + 10, py = (p.y % 100) + 10;
                        p.vx += (px - p.x) * 0.01;
                        p.vy += (py - p.y) * 0.01;
                    }
                    p.x += p.vx;
                    p.y += p.vy;
                    if (p.x < 0 || p.x > canvasEstados.width)
                        p.vx *= -1;
                    if (p.y < 0 || p.y > canvasEstados.height)
                        p.vy *= -1;
                    ctxEstados.beginPath();
                    ctxEstados.arc(p.x, p.y, p.radio, 0, Math.PI * 2);
                    ctxEstados.fillStyle = '#4CAF50';
                    ctxEstados.fill();
                });
                requestAnimationFrame(animar);
            }
            animar();
            function seleccionarOpcion(opcion, event) {
                opcionSeleccionada = opcion;
                document.getElementById('btnEnviarEstados').disabled = false;
                document.querySelectorAll('.btn-opcion').forEach(b => b.style.background = '');
                event.target.style.background = '#c8e6c9';
            }
            function enviarRespuesta() {
                if (opcionSeleccionada === 0)
                    return;
            <% if (preguntaActual != null) {%>const preguntaId =<%= preguntaActual.getIdPregunta()%>;<% } else {%>const preguntaId = 0;<% }%>
                        document.getElementById('respuestasEstadosJson').value = JSON.stringify([{idPregunta: preguntaId, opcionSeleccionada: opcionSeleccionada}]);
                        document.getElementById('formSimulacionEstados').submit();
                    }
            <% }%>

                    // ================================================================
                    // IDENTIFICACION PROPIEDAD
                    // ================================================================
            <% if ("IDENTIFICACION_PROPIEDAD".equals(actividad.getTipo())) {
                    List<FenomenoPropiedad> fenomenosJs = (List<FenomenoPropiedad>) request.getAttribute("fenomenos");
                    if (fenomenosJs != null && !fenomenosJs.isEmpty()) {
            %>
                    const canvasFen = document.getElementById('canvasFenomeno');
                    const ctxFen = canvasFen.getContext('2d');
                    let fenomenos = [];
            <% for (int i = 0; i < fenomenosJs.size(); i++) {%>
                    fenomenos.push({id:<%= fenomenosJs.get(i).getIdFenomeno()%>, descripcion: "<%= fenomenosJs.get(i).getDescripcion().replace("\"", "\\\"")%>", correcta: "<%= fenomenosJs.get(i).getPropiedadCorrecta()%>"});
            <% }%>
                    let indiceActual = 0, respuestasProp = [], seleccionActual = null;
                    function dibujarFenomeno(propiedad) {
                        ctxFen.clearRect(0, 0, canvasFen.width, canvasFen.height);
                        if (propiedad === 'TENSION_SUPERFICIAL') {
                            ctxFen.fillStyle = '#0288d1';
                            ctxFen.fillRect(0, 100, canvasFen.width, 2);
                            ctxFen.fillStyle = '#000';
                            ctxFen.font = '30px serif';
                            ctxFen.fillText('🦗', 120, 95);
                        } else if (propiedad === 'VISCOSIDAD') {
                            ctxFen.fillStyle = '#f57c00';
                            ctxFen.beginPath();
                            ctxFen.arc(150, 50, 10, 0, Math.PI);
                            ctxFen.fill();
                            ctxFen.fillRect(145, 50, 10, 40);
                        } else if (propiedad === 'CAPILARIDAD') {
                            ctxFen.fillStyle = '#0277bd';
                            ctxFen.fillRect(140, 80, 20, 10);
                            ctxFen.fillRect(148, 30, 4, 50);
                        }
                    }
                    function mostrarFenomeno(indice) {
                        if (indice >= fenomenos.length) {
                            document.getElementById('btnSiguiente').style.display = 'none';
                            document.getElementById('botonesPropiedades').style.display = 'none';
                            document.getElementById('descripcionFenomeno').innerText = 'Todos los fenómenos fueron clasificados.';
                            document.getElementById('btnEnviarPropiedades').style.display = 'inline-block';
                            return;
                        }
                        const f = fenomenos[indice];
                        document.getElementById('descripcionFenomeno').innerText = f.descripcion;
                        dibujarFenomeno(f.correcta);
                        seleccionActual = null;
                        document.getElementById('btnSiguiente').disabled = true;
                        document.querySelectorAll('.btn-opcion').forEach(b => b.style.background = '');
                    }
                    function seleccionarPropiedad(propiedad) {
                        seleccionActual = propiedad;
                        document.getElementById('btnSiguiente').disabled = false;
                        document.querySelectorAll('.btn-opcion').forEach(b => {
                            b.style.background = b.getAttribute('onclick').includes(propiedad) ? '#c8e6c9' : '';
                        });
                    }
                    function siguienteFenomeno() {
                        if (!seleccionActual)
                            return;
                        respuestasProp.push({idFenomeno: fenomenos[indiceActual].id, propiedad: seleccionActual});
                        indiceActual++;
                        mostrarFenomeno(indiceActual);
                    }
                    function enviarRespuestas() {
                        document.getElementById('respuestasPropiedadesJson').value = JSON.stringify(respuestasProp);
                        document.getElementById('formPropiedades').submit();
                    }
                    mostrarFenomeno(0);
            <% }
                }%>

                    // ================================================================
                    // SIMULACION EBULLICION
                    // ================================================================
            <% if ("SIMULACION_EBULLICION".equals(actividad.getTipo())) {%>
                    const canvasEb = document.getElementById('canvasEbullicion');
                    const ctxEb = canvasEb.getContext('2d');
                    let altitud = 0, temperaturaEbullicion = 100, respuestasEbullicion = {};
                    function dibujarOlla(temp) {
                        ctxEb.clearRect(0, 0, canvasEb.width, canvasEb.height);
                        ctxEb.fillStyle = '#bdbdbd';
                        ctxEb.fillRect(150, 80, 100, 70);
                        ctxEb.fillStyle = '#ff7043';
                        ctxEb.fillRect(170, 60, 60, 20);
                        ctxEb.fillStyle = '#fff';
                        ctxEb.fillRect(60, 30, 20, 120);
                        ctxEb.fillStyle = '#f44336';
                        let alturaTemp = (temp - 70) * (100 / 60);
                        ctxEb.fillRect(65, 150 - alturaTemp, 10, alturaTemp);
                        ctxEb.fillStyle = '#000';
                        ctxEb.font = '12px sans-serif';
                        ctxEb.fillText(temp + ' °C', 90, 150 - alturaTemp - 5);
                        if (temp >= 90) {
                            ctxEb.fillStyle = 'rgba(255,255,255,0.6)';
                            for (let i = 0; i < 5; i++) {
                                ctxEb.beginPath();
                                ctxEb.arc(180 + Math.random() * 40, 70 + Math.random() * 30, 3, 0, Math.PI * 2);
                                ctxEb.fill();
                            }
                        }
                    }
                    function actualizarAltitud(valor) {
                        altitud = parseInt(valor);
                        document.getElementById('altitudLabel').textContent = altitud + ' m';
                        if (altitud <= 0)
                            temperaturaEbullicion = 100;
                        else if (altitud <= 2000)
                            temperaturaEbullicion = 100 - (altitud / 1000) * 5;
                        else
                            temperaturaEbullicion = 100 - 10 - (altitud - 2000) / 1000 * 2;
                        temperaturaEbullicion = Math.round(temperaturaEbullicion * 10) / 10;
                        document.getElementById('tempEbullicionLabel').textContent = temperaturaEbullicion + ' °C';
                        dibujarOlla(temperaturaEbullicion);
                    }
                    document.querySelectorAll('.btn-opcion').forEach(btn => {
                        btn.addEventListener('click', function () {
                            const preguntaId = parseInt(this.dataset.pregunta), opcion = parseInt(this.dataset.opcion);
                            respuestasEbullicion[preguntaId] = opcion;
                            document.querySelectorAll('.btn-opcion[data-pregunta="' + preguntaId + '"]').forEach(b => {
                                b.style.background = (parseInt(b.dataset.opcion) === opcion) ? '#c8e6c9' : '';
                            });
                        });
                    });
                    function enviarRespuestasEbullicion() {
                        const preguntas = [];
                        for (let id in respuestasEbullicion)
                            preguntas.push({idPregunta: parseInt(id), opcionSeleccionada: respuestasEbullicion[id]});
            <% int totalPreguntas = 0;
                    if (request.getAttribute("preguntas") != null) {
                        totalPreguntas = ((List<PreguntaSimulacionEbullicion>) request.getAttribute("preguntas")).size();
                    }%>
                        const totalPreguntas =<%= totalPreguntas%>;
                        if (preguntas.length < totalPreguntas) {
                            document.getElementById('feedbackEbullicion').innerText = 'Debes responder todas las preguntas.';
                            document.getElementById('feedbackEbullicion').style.color = '#f44336';
                            return;
                        }
                        document.getElementById('respuestasEbullicionJson').value = JSON.stringify(preguntas);
                        document.getElementById('formEbullicion').submit();
                    }
                    dibujarOlla(100);
            <% }%>
        </script>
    </body>
</html>