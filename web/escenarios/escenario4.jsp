<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.ProgresoEscenario" %>
<%
    int idEscenario = (int) request.getAttribute("idEscenario");
    ProgresoEscenario progreso = (ProgresoEscenario) request.getAttribute("progreso");
    boolean completado = progreso != null && progreso.isCompletado();
    int estrellas = progreso != null ? progreso.getEstrellas() : 0;
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
        <title>Chef Molecular — Horno y Congelador | Cambios de Estado</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <style>
            /* ============================================
               ESTILOS ORIGINALES DEL ESCENARIO 4 (100% iguales)
               Solo se reorganiza la estructura HTML
            ============================================ */
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: #0B2B36;
                min-height: 100vh;
                position: relative;
            }

            /* Fondo dividido (hielo vs fuego) */
            body::before {
                content: "";
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(112deg, 
                    #9DC8E8 0%,
                    #C3DFF2 25%,
                    #F0EDE5 50%,
                    #FCD5A5 75%,
                    #E66A2C 100%);
                z-index: -2;
            }

            /* Patrón de escarcha (solo zona izquierda) */
            body::after {
                content: "";
                position: fixed;
                top: 0;
                left: 0;
                width: 50%;
                height: 100%;
                background-image: radial-gradient(circle at 20% 30%, rgba(255,255,255,0.4) 1px, transparent 1px);
                background-size: 24px 24px;
                pointer-events: none;
                z-index: -1;
            }

            /* Patrón de llamas (zona derecha) */
            .flame-pattern {
                position: fixed;
                top: 0;
                right: 0;
                width: 50%;
                height: 100%;
                background-image: repeating-linear-gradient(45deg, rgba(230,106,44,0.08) 0px, rgba(230,106,44,0.08) 2px, transparent 2px, transparent 12px);
                pointer-events: none;
                z-index: -1;
            }

            /* Termómetro decorativo de fondo (tenue) */
            .bg-thermometer {
                position: fixed;
                bottom: 20px;
                left: 20px;
                width: 60px;
                height: 180px;
                opacity: 0.15;
                z-index: -1;
                pointer-events: none;
            }
            .bg-thermometer .bulb {
                width: 30px;
                height: 30px;
                background: radial-gradient(circle, #ff5e00, #aa2b00);
                border-radius: 50%;
                position: absolute;
                bottom: 0;
                left: 15px;
            }
            .bg-thermometer .tube {
                width: 12px;
                height: 140px;
                background: linear-gradient(180deg, #ff5e00, #0066aa);
                border-radius: 6px;
                position: absolute;
                bottom: 25px;
                left: 24px;
            }

            /* ========== NAVBAR (estructura tipo escenario1, colores originales) ========== */
            .navbar {
                background: #3E2A1F;
                border-bottom: 3px solid #D97A2B;
                padding: 0 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 64px;
                position: sticky;
                top: 0;
                z-index: 100;
                flex-wrap: wrap;
                gap: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            }

            .navbar-izq {
                display: flex;
                align-items: center;
                gap: 20px;
                flex-wrap: wrap;
            }

            .nav-back {
                display: flex;
                align-items: center;
                gap: 7px;
                text-decoration: none;
                font-size: 12px;
                color: #FDF8F0;
                border: 1px solid transparent;
                padding: 6px 12px;
                border-radius: 5px;
                transition: all 0.2s;
                letter-spacing: 0.3px;
            }
            .nav-back:hover {
                color: #F4C28C;
                border-color: #D97A2B;
                background: rgba(0,0,0,0.2);
            }
            .sep {
                width: 1px;
                height: 18px;
                background: rgba(255,248,240,0.3);
            }
            .nav-escenario-info {
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: wrap;
            }
            .nav-badge {
                font-size: 9px;
                letter-spacing: 3px;
                text-transform: uppercase;
                color: #F4C28C;
                font-weight: 500;
            }
            .nav-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                color: #FDF8F0;
                font-weight: 700;
            }
            .navbar-der {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .chip-completado {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 5px 12px;
                border-radius: 100px;
                background: rgba(217,122,43,0.2);
                border: 1px solid rgba(217,122,43,0.4);
                font-size: 11px;
                color: #F4C28C;
            }
            .estrellas-nav {
                display: flex;
                gap: 3px;
            }
            .est {
                width: 9px;
                height: 9px;
                clip-path: polygon(50% 0%,61% 35%,98% 35%,68% 57%,79% 91%,50% 70%,21% 91%,32% 57%,2% 35%,39% 35%);
            }
            .est.on  {
                background: #D97A2B;
            }
            .est.off {
                background: rgba(217,122,43,0.3);
            }
            .nav-temp {
                font-family: 'Playfair Display', serif;
                font-size: 0.85rem;
                font-style: italic;
                color: #FDF8F0;
            }

            /* ========== HERO (termómetro y pasos) ========== */
            .hero {
                position: relative;
                padding: 60px 40px 52px;
                overflow: hidden;
                border-bottom: 1px solid rgba(255,255,255,0.2);
                background: rgba(11,43,54,0.5);
                backdrop-filter: blur(4px);
            }
            .hero-inner {
                position: relative;
                z-index: 2;
                max-width: 860px;
                margin: 0 auto;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 40px;
                flex-wrap: wrap;
            }
            .hero-text {
                flex: 1;
                min-width: 240px;
            }
            .hero-eyebrow {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 10px;
                letter-spacing: 4px;
                text-transform: uppercase;
                color: #F4C28C;
                font-weight: 500;
                margin-bottom: 14px;
            }
            .hero-eyebrow::before {
                content: '';
                width: 24px;
                height: 1px;
                background: #D97A2B;
            }
            .hero-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2.8rem;
                font-weight: 700;
                color: #FDF8F0;
                line-height: 1.05;
                margin-bottom: 6px;
                text-shadow: 0 0 40px rgba(0,0,0,0.3);
            }
            .hero-titulo em {
                color: #F4C28C;
                font-style: italic;
            }
            .hero-concepto {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-style: italic;
                color: #F4C28C;
                opacity: 0.9;
                margin-bottom: 16px;
            }
            .hero-desc {
                font-size: 13px;
                color: #FDF8F0;
                font-weight: 300;
                line-height: 1.7;
                text-shadow: 0 1px 2px rgba(0,0,0,0.2);
            }
            .hero-temp-panel {
                flex-shrink: 0;
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 16px;
            }
            .termometro {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 8px;
            }
            .temp-numero {
                font-family: 'Playfair Display', serif;
                font-size: 3rem;
                font-weight: 700;
                color: #F4C28C;
                line-height: 1;
            }
            .temp-barra-wrap {
                width: 6px;
                height: 80px;
                background: #5A5A5A;
                border-radius: 3px;
                overflow: hidden;
                position: relative;
            }
            .temp-barra-fill {
                position: absolute;
                bottom: 0;
                width: 100%;
                height: 60%;
                background: linear-gradient(to top, #3A7CA5, #E66A2C);
                border-radius: 3px;
                animation: subirTemperatura 6s ease-in-out infinite alternate;
            }
            @keyframes subirTemperatura {
                from { height: 20%; background: linear-gradient(to top, #3A7CA5, #7EC8FF); }
                to   { height: 80%; background: linear-gradient(to top, #E66A2C, #F4A261); }
            }
            .pasos-lista {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }
            .paso {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 7px 13px;
                border: 1px solid rgba(255,255,255,0.2);
                border-radius: 5px;
                background: rgba(0,0,0,0.3);
                backdrop-filter: blur(4px);
            }

            /* ========== CONTENIDO PRINCIPAL (secciones estilo escenario1) ========== */
            .contenido {
                max-width: 1000px;
                margin: 0 auto;
                padding: 44px 40px 80px;
                position: relative;
                z-index: 2;
            }
            .sec-head {
                display: flex;
                align-items: center;
                gap: 14px;
                margin-bottom: 18px;
                flex-wrap: wrap;
            }
            .sec-num {
                width: 24px;
                height: 24px;
                border-radius: 50%;
                border: 1px solid #D97A2B;
                background: rgba(217,122,43,0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                color: #F4C28C;
                flex-shrink: 0;
            }
            .sec-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.05rem;
                font-weight: 700;
                color: #FDF8F0;
            }
            .sec-linea {
                flex: 1;
                height: 1px;
                background: rgba(255,255,255,0.2);
            }
            .sec-bloque {
                background: rgba(0,0,0,0.4);
                backdrop-filter: blur(8px);
                border: 1px solid rgba(255,255,255,0.2);
                border-radius: 8px;
                overflow: hidden;
                margin-bottom: 44px;
                position: relative;
            }
            .sec-bloque::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 2px;
                background: linear-gradient(to bottom, transparent, #3A7CA5 30%, #E66A2C 70%, transparent);
                opacity: 0.8;
            }

            /* ========== ESTILOS ORIGINALES DE ELECTRODOMÉSTICOS, SLIDER Y CANVAS ========== */
            .electrodomesticos {
                display: flex;
                gap: 30px;
                margin-bottom: 40px;
                flex-wrap: wrap;
                justify-content: center;
                padding: 20px;
            }
            .freezer {
                flex: 1;
                min-width: 280px;
                background: #E8E6E1;
                border-radius: 20px 20px 16px 16px;
                box-shadow: 0 15px 25px rgba(0,0,0,0.3), inset 0 1px 0 rgba(255,255,255,0.7);
                position: relative;
                border: 1px solid #b0aaa0;
                transition: transform 0.2s;
            }
            .freezer:hover { transform: translateY(-5px); }
            .freezer::after {
                content: "";
                position: absolute;
                top: 5px; left: 5px; right: 5px; bottom: 5px;
                border: 2px solid #5F9EAA;
                border-radius: 14px;
                pointer-events: none;
                opacity: 0.5;
            }
            .freezer-led {
                position: absolute;
                top: 12px; right: 20px;
                width: 12px; height: 12px;
                background: #00A8FF;
                border-radius: 50%;
                box-shadow: 0 0 8px #00A8FF;
                animation: pulse 1.5s infinite;
            }
            @keyframes pulse {
                0% { opacity: 0.4; transform: scale(0.9);}
                100% { opacity: 1; transform: scale(1.2);}
            }
            .freezer-vaho {
                position: absolute;
                bottom: 10px; left: 10%;
                width: 80%; height: 40%;
                background: radial-gradient(circle, rgba(200,230,255,0.25) 0%, transparent 80%);
                filter: blur(10px);
                pointer-events: none;
                animation: coldSteam 3s ease-in-out infinite;
            }
            @keyframes coldSteam {
                0% { opacity: 0.2; transform: translateY(0px);}
                50% { opacity: 0.5; transform: translateY(-5px);}
                100% { opacity: 0.2; transform: translateY(0px);}
            }
            .freezer-door {
                background: #F5F3EF;
                border-radius: 16px;
                margin: 12px;
                padding: 16px;
                box-shadow: inset 0 0 0 2px #ffffff, 0 4px 8px rgba(0,0,0,0.1);
                text-align: center;
                position: relative;
                z-index: 2;
            }
            .freezer-handle {
                width: 80px; height: 8px;
                background: linear-gradient(135deg, #C0C0C0, #F0F0F0);
                border-radius: 4px;
                margin: 0 auto 16px auto;
                box-shadow: 0 1px 2px rgba(0,0,0,0.2);
            }
            .freezer-icon { font-size: 3.5rem; margin: 16px 0; text-shadow: 0 2px 4px rgba(0,0,0,0.1); }
            .freezer-temp {
                background: #DCE6F0;
                border-radius: 30px;
                padding: 8px;
                font-size: 0.8rem;
                color: #1E3A5F;
                font-weight: bold;
            }
            .frost-3d {
                background: radial-gradient(circle at 20% 30%, rgba(255,255,255,0.6) 1px, transparent 1px),
                            repeating-linear-gradient(45deg, rgba(150,200,255,0.2) 0px, rgba(150,200,255,0.2) 2px, transparent 2px, transparent 8px);
                background-size: 20px 20px, 12px 12px;
                border-radius: 12px;
                padding: 8px;
            }
            .oven {
                flex: 1;
                min-width: 280px;
                background: #2C2C2C;
                border-radius: 20px 20px 16px 16px;
                box-shadow: 0 15px 25px rgba(0,0,0,0.4), inset 0 1px 0 rgba(255,255,255,0.1);
                position: relative;
                transition: transform 0.2s;
            }
            .oven:hover { transform: translateY(-5px); }
            .oven-glow {
                position: absolute;
                top: 20%; left: 15%;
                width: 70%; height: 60%;
                background: radial-gradient(ellipse, rgba(230,106,44,0.4), transparent);
                filter: blur(20px);
                pointer-events: none;
                z-index: 0;
            }
            .oven-door {
                background: #3A3A3A;
                border-radius: 16px;
                margin: 12px;
                padding: 16px;
                box-shadow: inset 0 0 0 2px #5A5A5A, 0 4px 8px rgba(0,0,0,0.3);
                text-align: center;
                position: relative;
                z-index: 2;
                backdrop-filter: blur(1px);
            }
            .oven-door::before {
                content: "";
                position: absolute;
                top: 10%; left: 5%;
                width: 90%; height: 80%;
                background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0) 50%, rgba(255,255,255,0.05) 100%);
                border-radius: 12px;
                pointer-events: none;
            }
            .oven-handle {
                width: 100px; height: 10px;
                background: linear-gradient(145deg, #E0E0E0, #909090);
                border-radius: 5px;
                margin: 0 auto 16px auto;
                box-shadow: 0 2px 3px rgba(0,0,0,0.3), inset 0 1px 0 white;
            }
            .oven-icon { font-size: 3.5rem; margin: 16px 0; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3)); }
            .oven-temp {
                background: #2A1E12;
                border-radius: 30px;
                padding: 8px;
                font-size: 0.8rem;
                color: #F4A261;
                font-weight: bold;
            }
            .heating-coils {
                background: repeating-linear-gradient(45deg, #D97A2B 0px, #D97A2B 3px, #A0522D 3px, #A0522D 10px);
                height: 8px;
                border-radius: 4px;
                margin-top: 12px;
                box-shadow: inset 0 1px 2px rgba(0,0,0,0.3), 0 0 6px #F4A261;
            }
            .heat-waves {
                position: absolute;
                bottom: 15px; left: 10%;
                width: 80%; height: 30px;
                pointer-events: none;
                z-index: 3;
            }
            .heat-waves::before, .heat-waves::after {
                content: "";
                position: absolute;
                bottom: 0; left: 0;
                width: 100%; height: 100%;
                background: repeating-linear-gradient(transparent, rgba(255,140,0,0.3) 2px, transparent 6px);
                animation: heatRise 1.2s infinite;
            }
            .heat-waves::after { animation-delay: 0.6s; opacity: 0.6; }
            @keyframes heatRise {
                0% { transform: translateY(0px); opacity: 0; }
                50% { transform: translateY(-12px); opacity: 0.6; }
                100% { transform: translateY(-24px); opacity: 0; }
            }
            .oven-knob {
                position: absolute;
                bottom: -15px; right: 20px;
                width: 40px; height: 40px;
                background: radial-gradient(circle, #5A5A5A, #2C2C2C);
                border-radius: 50%;
                border: 2px solid #A0A0A0;
                box-shadow: 0 2px 6px black;
                z-index: 4;
                cursor: pointer;
            }
            .oven-knob::after {
                content: "◀";
                position: absolute;
                font-size: 16px;
                top: 50%; left: 50%;
                transform: translate(-50%, -50%);
                color: #F4A261;
            }
            .slider-central {
                background: rgba(0,0,0,0.5);
                backdrop-filter: blur(8px);
                border-radius: 60px;
                padding: 20px;
                text-align: center;
                margin: 20px 20px 30px;
            }
            input[type=range] {
                width: 90%;
                height: 8px;
                -webkit-appearance: none;
                background: linear-gradient(90deg, #3A7CA5, #F4A261, #C0392B);
                border-radius: 10px;
            }
            input[type=range]::-webkit-slider-thumb {
                -webkit-appearance: none;
                width: 28px; height: 28px;
                background: #D97A2B;
                border-radius: 50%;
                border: 3px solid white;
                cursor: pointer;
                box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            }
            .temp-actual {
                font-size: 1.8rem;
                font-weight: bold;
                margin: 12px 0;
                background: #FFF0DC;
                display: inline-block;
                padding: 6px 24px;
                border-radius: 50px;
                color: #4A2A1A;
            }
            .estado-texto {
                font-size: 1rem;
                background: #FFF0DC;
                display: inline-block;
                padding: 6px 18px;
                border-radius: 40px;
                margin-left: 10px;
                color: #4A2A1A;
            }
            .canvas-container {
                background: rgba(0,0,0,0.4);
                backdrop-filter: blur(4px);
                border-radius: 32px;
                padding: 12px;
                margin: 0 20px 20px;
            }
            canvas {
                display: block;
                margin: 0 auto;
                border-radius: 24px;
                background: #FFF8F0;
                width: 100%;
                height: auto;
            }
            .seccion-explicativa {
                background: rgba(0,0,0,0.5);
                backdrop-filter: blur(8px);
                border-radius: 32px;
                padding: 24px;
                margin: 20px;
                color: #FDF8F0;
            }
            .btn-quiz {
                background: #D97A2B;
                color: #FDF8F0;
                padding: 12px 28px;
                border-radius: 40px;
                text-decoration: none;
                font-weight: bold;
                display: inline-block;
                transition: 0.2s;
                margin-top: 12px;
            }
            .btn-quiz:hover {
                background: #C0641A;
                transform: translateY(-2px);
            }
            @media (max-width: 800px) {
                .electrodomesticos { flex-direction: column; align-items: center; }
                .navbar { padding: 0 20px; }
                .hero { padding: 40px 20px; }
                .contenido { padding: 30px 20px 60px; }
            }
        </style>
    </head>
    <body>
        <div class="flame-pattern"></div>
        <div class="bg-thermometer">
            <div class="tube"></div>
            <div class="bulb"></div>
        </div>

        <nav class="navbar">
            <div class="navbar-izq">
                <a href="${pageContext.request.contextPath}/menu" class="nav-back">
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="currentColor"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                    Volver
                </a>
                <div class="sep"></div>
                <div class="nav-escenario-info">
                    <span class="nav-badge">Escenario 04 🔥❄️</span>
                    <div class="sep"></div>
                    <span class="nav-nombre">Horno y Congelador</span>
                </div>
            </div>
            <div class="navbar-der">
                <span class="nav-temp">🌡️ Control térmico</span>
                <% if (completado) { %>
                <div class="chip-completado">✅ Completado</div>
                <div class="estrellas-nav">
                    <div class="est <%= estrellas >= 1 ? "on" : "off" %>"></div>
                    <div class="est <%= estrellas >= 2 ? "on" : "off" %>"></div>
                    <div class="est <%= estrellas >= 3 ? "on" : "off" %>"></div>
                </div>
                <% } %>
            </div>
        </nav>

        <div class="hero">
            <div class="hero-inner">
                <div class="hero-text">
                    <div class="hero-eyebrow">🔥❄️ Cambios de estado · Materia en la cocina</div>
                    <h1 class="hero-titulo">Horno y<br><em>Congelador 🌡️</em></h1>
                    <p class="hero-concepto">De sólido a líquido, de líquido a gas</p>
                    <p class="hero-desc">
                        Mueve el control deslizante desde el congelador (-20°C) hasta el horno (220°C). Observa cómo se comportan las moléculas: vibran en frío, fluyen a temperatura ambiente y se agitan violentamente al calentarse.
                    </p>
                </div>
                <div class="hero-temp-panel">
                    <div class="termometro">
                        <div class="temp-numero">🌡️</div>
                        <div class="temp-barra-wrap"><div class="temp-barra-fill"></div></div>
                        <div class="temp-unidad">Rango térmico</div>
                    </div>
                    <div class="pasos-lista">
                        <div class="paso"><span>🧊</span> Congelador (sólido)</div>
                        <div class="paso"><span>💧</span> Ambiente (líquido)</div>
                        <div class="paso"><span>💨</span> Horno (gas)</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="contenido">
            <!-- Sección 1: Electrodomésticos y termostato -->
            <div class="sec-head">
                <div class="sec-num">1</div>
                <span class="sec-titulo">❄️ Electrodomésticos moleculares</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque">
                <div class="electrodomesticos">
                    <div class="freezer">
                        <div class="freezer-led"></div>
                        <div class="freezer-vaho"></div>
                        <div class="freezer-door">
                            <div class="freezer-handle"></div>
                            <div class="frost-3d">
                                <div class="freezer-icon">🧊❄️🧊</div>
                                <div class="freezer-temp">❄️ -18 °C a 0 °C ❄️</div>
                                <div style="font-size:0.7rem; margin-top: 8px;">Congelador · Alimentos sólidos</div>
                            </div>
                        </div>
                    </div>
                    <div class="oven">
                        <div class="oven-glow"></div>
                        <div class="oven-door">
                            <div class="oven-handle"></div>
                            <div class="oven-icon">🔥🍲🔥</div>
                            <div class="oven-temp">🔥 100 °C a 220 °C 🔥</div>
                            <div class="heating-coils"></div>
                            <div class="heat-waves"></div>
                            <div style="font-size:0.7rem; margin-top: 8px; color:#F4A261;">Horno · Alimentos calientes</div>
                        </div>
                        <div class="oven-knob" title="Perilla de temperatura"></div>
                    </div>
                </div>
                <div class="slider-central">
                    <label style="color:#FDF8F0; font-weight: bold;">🌡️ Mueve el termostato del congelador al horno</label>
                    <input type="range" id="tempSlider" min="-20" max="220" value="20" step="1" oninput="actualizarTemp(this.value)">
                    <div>
                        <span class="temp-actual" id="tempVal">20 °C</span>
                        <span class="estado-texto" id="estadoText">💧 Líquido</span>
                    </div>
                </div>
                <div class="canvas-container">
                    <canvas id="canvasCambioEstado" width="780" height="240" style="max-width:100%; height:auto;"></canvas>
                </div>
            </div>

            <!-- Sección 2: Explicación molecular -->
            <div class="sec-head">
                <div class="sec-num">2</div>
                <span class="sec-titulo">🔬 ¿Qué pasa dentro de la materia?</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque">
                <div class="seccion-explicativa" id="infoTexto">
                    A temperatura ambiente, las moléculas se mueven libremente. Al enfriar (congelador) se ordenan y se vuelven sólidas. Al calentar (horno) se agitan mucho y pueden volverse gaseosas (vapor).
                </div>
            </div>

            <!-- SECCIÓN 3: ACTIVIDAD INTERACTIVA -->
            <div class="sec-head">
                <div class="sec-num">3</div>
                <span class="sec-titulo">🎮 Actividad de Cambios de estado</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque">
                <div class="quiz-wrap">
                    <div>
                        <div class="quiz-titulo" style="font-family:'Playfair Display',serif; font-size:1.1rem;">🧪 Clasifica las moléculas polares y no polares</div>
                        <p class="quiz-desc" style="font-size:12px; color: var(--texto2-color);">
                            <% if (completado) { %>
                            ✅ ¡Ya completaste este escenario! Puedes volver a practicar para mejorar tu puntuación.
                            <% } else { %>
                            🧂 Arrastra cada molécula a la categoría correcta (Polar o No polar). Completa la actividad para obtener tus estrellas.
                            <% }%>
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/actividad?escenario=<%= idEscenario%>" class="btn-quiz">
                        <% if (completado) { %>
                        🔁 Practicar de nuevo
                        <% } else { %>
                        🎮 Comenzar actividad →
                        <% }%>
                    </a>
                </div>
            </div>
        </div>

        <script>
            // ========== SIMULACIÓN DE PARTÍCULAS (cambios de estado) ==========
            const canvas = document.getElementById('canvasCambioEstado');
            const ctx = canvas.getContext('2d');
            let tempActual = 20;
            let particles = [];
            let currentState = 'liquid';
            let animId;

            function resizeCanvas() {
                const container = canvas.parentElement;
                const w = container.clientWidth;
                canvas.width = Math.min(w, 780);
                canvas.height = 240;
                initParticles(currentState);
            }
            window.addEventListener('resize', resizeCanvas);
            resizeCanvas();

            function getState(t) {
                if (t <= 0) return 'solid';
                if (t >= 100) return 'gas';
                return 'liquid';
            }

            function initParticles(state) {
                particles = [];
                let count = state === 'solid' ? 55 : (state === 'liquid' ? 40 : 25);
                let radius = state === 'gas' ? 8 : 11;
                for (let i = 0; i < count; i++) {
                    let x, y;
                    if (state === 'solid') {
                        x = 30 + (i % 14) * 55;
                        y = 30 + Math.floor(i / 14) * 45;
                        if (x > canvas.width - 30) x = canvas.width - 30;
                        if (y > canvas.height - 40) y = canvas.height - 40;
                    } else {
                        x = 20 + Math.random() * (canvas.width - 40);
                        y = 20 + Math.random() * (canvas.height - 40);
                    }
                    let speed = state === 'gas' ? 2.5 : (state === 'liquid' ? 1.2 : 0.2);
                    particles.push({
                        x, y,
                        vx: (Math.random() - 0.5) * speed,
                        vy: (Math.random() - 0.5) * speed,
                        r: radius + (Math.random() * 4 - 2)
                    });
                }
            }

            function drawState(state) {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                ctx.fillStyle = '#FFF8F0';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                let color = state === 'solid' ? '#7EC8FF' : (state === 'liquid' ? '#D97A2B' : '#F4C28C');
                if (state !== 'gas') {
                    let maxDist = state === 'solid' ? 80 : 95;
                    for (let i = 0; i < particles.length; i++) {
                        for (let j = i + 1; j < particles.length; j++) {
                            let dx = particles[j].x - particles[i].x;
                            let dy = particles[j].y - particles[i].y;
                            let d = Math.hypot(dx, dy);
                            if (d < maxDist) {
                                let opacity = (1 - d / maxDist) * 0.4;
                                ctx.beginPath();
                                ctx.strokeStyle = `rgba(217, 122, 43, ${opacity})`;
                                ctx.lineWidth = 1.2;
                                ctx.moveTo(particles[i].x, particles[i].y);
                                ctx.lineTo(particles[j].x, particles[j].y);
                                ctx.stroke();
                            }
                        }
                    }
                }
                for (let p of particles) {
                    ctx.beginPath();
                    ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
                    ctx.fillStyle = color;
                    ctx.shadowBlur = 3;
                    ctx.fill();
                    ctx.beginPath();
                    ctx.arc(p.x - 2, p.y - 2, p.r * 0.3, 0, Math.PI * 2);
                    ctx.fillStyle = '#FFF9E0';
                    ctx.fill();
                }
                ctx.shadowBlur = 0;
            }

            function moveParticles(state) {
                if (state === 'solid') {
                    for (let p of particles) {
                        p.x += (Math.random() - 0.5) * 0.7;
                        p.y += (Math.random() - 0.5) * 0.7;
                        p.x = Math.min(Math.max(p.x, p.r + 2), canvas.width - p.r - 2);
                        p.y = Math.min(Math.max(p.y, p.r + 2), canvas.height - p.r - 2);
                    }
                } else {
                    for (let p of particles) {
                        p.x += p.vx;
                        p.y += p.vy;
                        if (p.x < p.r || p.x > canvas.width - p.r) p.vx *= -0.95;
                        if (p.y < p.r || p.y > canvas.height - p.r) p.vy *= -0.95;
                        p.x = Math.min(Math.max(p.x, p.r), canvas.width - p.r);
                        p.y = Math.min(Math.max(p.y, p.r), canvas.height - p.r);
                    }
                }
            }

            function animate() {
                moveParticles(currentState);
                drawState(currentState);
                animId = requestAnimationFrame(animate);
            }

            function actualizarTemp(val) {
                tempActual = parseInt(val);
                document.getElementById('tempVal').innerHTML = tempActual + ' °C';
                let newState = getState(tempActual);
                if (newState !== currentState) {
                    currentState = newState;
                    initParticles(currentState);
                }
                let estadoNombre = '';
                let desc = '';
                if (currentState === 'solid') {
                    estadoNombre = '🧊 Sólido (congelado)';
                    desc = 'Las moléculas están muy juntas y vibran. En el congelador, los alimentos se vuelven sólidos.';
                } else if (currentState === 'liquid') {
                    estadoNombre = '💧 Líquido (temperatura ambiente)';
                    desc = 'Las moléculas fluyen. Es el estado de la mayoría de salsas y bebidas.';
                } else {
                    estadoNombre = '💨 Gaseoso (vapor)';
                    desc = 'Las moléculas se separan y se mueven rápido. El agua hierve y se evapora.';
                }
                document.getElementById('estadoText').innerHTML = estadoNombre;
                document.getElementById('infoTexto').innerHTML = desc + ' El control se mueve desde el congelador (❄️) hasta el horno (🔥).';
            }

            initParticles('liquid');
            animate();
            actualizarTemp(20);
        </script>
    </body>
</html>