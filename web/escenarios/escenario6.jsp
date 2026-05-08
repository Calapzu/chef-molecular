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
        <title>Chef Molecular — Olla a Presión · Simulación termodinámica ⏲️</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            /* ============================================
               ESTILOS ORIGINALES DEL ESCENARIO 6 (OLLA A PRESIÓN)
               Solo se reorganiza la estructura HTML
            ============================================ */
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Inter', sans-serif;
                background: #2c2e31;
                background-image: radial-gradient(circle at 10% 20%, rgba(255,255,255,0.05) 2%, transparent 2.5%),
                    repeating-linear-gradient(45deg, #3a3d42 0px, #3a3d42 1px, #2c2e31 1px, #2c2e31 20px);
                min-height: 100vh;
                color: #f1f5f9;
            }

            /* Barra lateral decorativa (estilo escenario1, pero con color naranja industrial) */
            .sidebar-industry {
                position: fixed;
                left: 0;
                top: 0;
                width: 3px;
                height: 100%;
                background: linear-gradient(to bottom, transparent, #f97316, #facc15, #f97316, transparent);
                opacity: 0.8;
                pointer-events: none;
                z-index: 10;
            }

            /* ========== NAVBAR (estructura escenario1, colores industriales) ========== */
            .navbar {
                background: #1a1c1e;
                backdrop-filter: blur(10px);
                border-bottom: 3px solid #f97316;
                padding: 0 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 70px;
                position: sticky;
                top: 0;
                z-index: 100;
                flex-wrap: wrap;
                gap: 10px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.4);
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
                color: #cbd5e1;
                border: 1px solid #475569;
                padding: 6px 12px;
                border-radius: 40px;
                transition: all 0.2s;
                letter-spacing: 0.3px;
                background: rgba(0,0,0,0.3);
            }
            .nav-back:hover {
                background: #f97316;
                color: #0f172a;
                border-color: #f97316;
                transform: scale(1.02);
            }
            .sep {
                width: 1px;
                height: 24px;
                background: rgba(249,115,22,0.4);
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
                color: #f97316;
                font-weight: 500;
            }
            .nav-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-weight: 700;
                color: #f1f5f9;
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
                background: rgba(249,115,22,0.2);
                border: 1px solid rgba(249,115,22,0.5);
                font-size: 11px;
                color: #facc15;
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
                background: #facc15;
            }
            .est.off {
                background: rgba(250,204,21,0.3);
            }
            .nav-temp {
                font-family: 'Playfair Display', serif;
                font-size: 0.85rem;
                font-style: italic;
                color: #f97316;
            }

            /* ========== HERO (termómetro y pasos) adaptado a Olla a presión ========== */
            .hero {
                position: relative;
                padding: 60px 40px 52px;
                overflow: hidden;
                border-bottom: 1px solid rgba(249,115,22,0.3);
                background: rgba(20, 22, 26, 0.7);
                backdrop-filter: blur(4px);
            }
            .hero-inner {
                position: relative;
                z-index: 2;
                max-width: 1100px;
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
                color: #f97316;
                font-weight: 500;
                margin-bottom: 14px;
            }
            .hero-eyebrow::before {
                content: '';
                width: 24px;
                height: 1px;
                background: #facc15;
            }
            .hero-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2.8rem;
                font-weight: 700;
                color: #f1f5f9;
                line-height: 1.05;
                margin-bottom: 6px;
                text-shadow: 0 0 20px rgba(249,115,22,0.3);
            }
            .hero-titulo em {
                color: #f97316;
                font-style: italic;
            }
            .hero-concepto {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-style: italic;
                color: #facc15;
                opacity: 0.9;
                margin-bottom: 16px;
            }
            .hero-desc {
                font-size: 13px;
                color: #cbd5e1;
                font-weight: 300;
                line-height: 1.7;
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
                color: #facc15;
                line-height: 1;
            }
            .temp-barra-wrap {
                width: 6px;
                height: 80px;
                background: #3a3d42;
                border-radius: 3px;
                overflow: hidden;
                position: relative;
            }
            .temp-barra-fill {
                position: absolute;
                bottom: 0;
                width: 100%;
                height: 70%;
                background: linear-gradient(to top, #f97316, #facc15);
                border-radius: 3px;
                animation: subirPresion 5s ease-in-out infinite alternate;
            }
            @keyframes subirPresion {
                from {
                    height: 20%;
                    opacity: 0.6;
                }
                to   {
                    height: 85%;
                    opacity: 1;
                }
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
                border: 1px solid rgba(249,115,22,0.4);
                border-radius: 5px;
                background: rgba(0,0,0,0.4);
                backdrop-filter: blur(4px);
            }

            /* ========== CONTENIDO PRINCIPAL (secciones estilo escenario1) ========== */
            .contenido {
                max-width: 1300px;
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
                border: 1px solid #f97316;
                background: rgba(249,115,22,0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                color: #facc15;
                flex-shrink: 0;
            }
            .sec-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.05rem;
                font-weight: 700;
                color: #f1f5f9;
            }
            .sec-linea {
                flex: 1;
                height: 1px;
                background: rgba(249,115,22,0.3);
            }
            .sec-bloque {
                background: #1e1f22;
                border-radius: 48px;
                border: 1px solid #f97316;
                box-shadow: 0 20px 35px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,255,255,0.05);
                backdrop-filter: blur(2px);
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
                background: linear-gradient(to bottom, transparent, #f97316 40%, #facc15 60%, transparent);
                opacity: 0.8;
            }

            /* ========== CONTENIDO ORIGINAL DEL ESCENARIO 6 (sin cambios en estilos internos) ========== */
            /* Se mantienen las clases originales: .olla-card, .controles-sim, .perilla, .indicadores, etc. */
            .olla-card {
                padding: 28px;
            }
            .olla-title {
                display: flex;
                align-items: baseline;
                gap: 20px;
                margin-bottom: 20px;
                flex-wrap: wrap;
                border-bottom: 1px dashed #f97316;
                padding-bottom: 10px;
            }
            .olla-title h2 {
                color: #f97316;
                font-size: 1.6rem;
                font-weight: 800;
                letter-spacing: -0.5px;
            }
            .badge-pressure {
                background: #00000060;
                padding: 6px 18px;
                border-radius: 60px;
                font-size: 0.75rem;
                font-weight: 600;
                border-left: 3px solid #f97316;
                backdrop-filter: blur(4px);
            }
            canvas {
                display: block;
                margin: 0 auto;
                border-radius: 28px;
                background: #141517;
                box-shadow: 0 10px 25px rgba(0,0,0,0.5), inset 0 0 0 2px #2a2c30;
                width: 100%;
                height: auto;
                cursor: pointer;
            }
            .controles-sim {
                display: flex;
                flex-wrap: wrap;
                gap: 30px;
                margin-top: 30px;
                justify-content: center;
            }
            .perilla {
                background: #2a2c30;
                border-radius: 60px;
                padding: 16px 24px;
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 12px;
                border: 1px solid #4a4e55;
                box-shadow: inset 0 1px 2px rgba(0,0,0,0.5), 0 5px 10px rgba(0,0,0,0.3);
                min-width: 180px;
            }
            .perilla label {
                font-size: 0.8rem;
                font-weight: 600;
                color: #f97316;
                letter-spacing: 1px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .perilla .valor {
                font-size: 1.6rem;
                font-weight: 800;
                background: #0f0f12;
                padding: 4px 16px;
                border-radius: 40px;
                font-family: monospace;
                color: #facc15;
            }
            input[type=range] {
                width: 180px;
                height: 4px;
                -webkit-appearance: none;
                background: #3a3d42;
                border-radius: 4px;
                outline: none;
            }
            input[type=range]::-webkit-slider-thumb {
                -webkit-appearance: none;
                width: 22px;
                height: 22px;
                background: #f97316;
                border-radius: 50%;
                cursor: pointer;
                box-shadow: 0 0 6px #f97316;
                border: 2px solid white;
            }
            select {
                background: #0f0f12;
                border: 1px solid #f97316;
                padding: 10px 16px;
                border-radius: 60px;
                color: white;
                font-weight: 500;
                font-size: 0.85rem;
                cursor: pointer;
            }
            .indicadores {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-top: 20px;
                justify-content: space-between;
                background: #141517;
                border-radius: 40px;
                padding: 16px 24px;
            }
            .led {
                display: flex;
                align-items: center;
                gap: 12px;
                background: #1e1f22;
                padding: 5px 18px;
                border-radius: 60px;
            }
            .led-light {
                width: 16px;
                height: 16px;
                border-radius: 50%;
                background: gray;
                box-shadow: 0 0 4px;
            }
            .led-light.verde {
                background: #22c55e;
                box-shadow: 0 0 6px #22c55e;
            }
            .led-light.naranja {
                background: #f97316;
                box-shadow: 0 0 8px #f97316;
                animation: pulse 0.8s infinite;
            }
            .led-light.rojo {
                background: #ef4444;
                box-shadow: 0 0 10px #ef4444;
                animation: pulse 0.4s infinite;
            }
            @keyframes pulse {
                0% {
                    opacity: 0.4;
                    transform: scale(0.9);
                }
                100% {
                    opacity: 1;
                    transform: scale(1.2);
                }
            }
            .timer {
                font-family: monospace;
                font-size: 1.4rem;
                background: black;
                padding: 6px 20px;
                border-radius: 60px;
                letter-spacing: 2px;
            }
            .info-panel {
                background: #0b0c0e;
                border-radius: 28px;
                padding: 20px;
                margin-top: 24px;
                border-left: 6px solid #f97316;
                font-size: 0.9rem;
                line-height: 1.4;
            }
            .ebullicion-alerta {
                text-align: center;
                padding: 12px;
                border-radius: 60px;
                font-weight: bold;
                margin-top: 16px;
                transition: 0.2s;
                font-size: 0.85rem;
            }
            .btn-quiz {
                display: block;
                background: linear-gradient(135deg, #f97316, #ea580c);
                text-align: center;
                padding: 16px;
                border-radius: 60px;
                text-decoration: none;
                font-weight: 800;
                color: white;
                font-size: 1.1rem;
                margin-top: 20px;
                transition: 0.2s;
                box-shadow: 0 5px 12px rgba(249,115,22,0.4);
            }
            .btn-quiz:hover {
                transform: scale(1.01);
                background: linear-gradient(135deg, #fd7e2e, #f97316);
                box-shadow: 0 8px 20px #f97316;
            }
            footer {
                text-align: center;
                font-size: 0.7rem;
                color: #6c6f78;
                margin: 40px 0 20px;
            }
            @media (max-width: 800px) {
                .navbar {
                    padding: 0 20px;
                }
                .hero {
                    padding: 40px 20px;
                }
                .contenido {
                    padding: 30px 20px 60px;
                }
            }
        </style>
    </head>
    <body>
        <div class="sidebar-industry"></div>

        <nav class="navbar">
            <div class="navbar-izq">
                <a href="${pageContext.request.contextPath}/menu" class="nav-back">
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="currentColor"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                    Volver
                </a>
                <div class="sep"></div>
                <div class="nav-escenario-info">
                    <span class="nav-badge">Escenario 06 ⏲️</span>
                    <div class="sep"></div>
                    <span class="nav-nombre">Olla a Presión</span>
                </div>
            </div>
            <div class="navbar-der">
                <span class="nav-temp">⚙️ Simulación termodinámica</span>
                <% if (completado) {%>
                <div class="chip-completado">✅ Completado</div>
                <div class="estrellas-nav">
                    <div class="est <%= estrellas >= 1 ? "on" : "off"%>"></div>
                    <div class="est <%= estrellas >= 2 ? "on" : "off"%>"></div>
                    <div class="est <%= estrellas >= 3 ? "on" : "off"%>"></div>
                </div>
                <% } %>
            </div>
        </nav>

        <div class="hero">
            <div class="hero-inner">
                <div class="hero-text">
                    <div class="hero-eyebrow">⚙️ Ley de Clausius‑Clapeyron · Presión de vapor</div>
                    <h1 class="hero-titulo">Olla a <em>Presión</em> ⏲️</h1>
                    <p class="hero-concepto">Aumenta la presión, eleva el punto de ebullición</p>
                    <p class="hero-desc">
                        Ajusta la temperatura y la presión interna. Observa cómo se comporta la válvula, el vapor y las moléculas. La olla a presión confina el vapor, incrementando la presión y el punto de ebullición, cocinando los alimentos más rápido.
                    </p>
                </div>
                <div class="hero-temp-panel">
                    <div class="termometro">
                        <div class="temp-numero">⏲️</div>
                        <div class="temp-barra-wrap"><div class="temp-barra-fill"></div></div>
                        <div class="temp-unidad">Presión & Temperatura</div>
                    </div>
                    <div class="pasos-lista">
                        <div class="paso"><span>🔥</span> Ajusta temperatura</div>
                        <div class="paso"><span>💨</span> Controla presión</div>
                        <div class="paso"><span>🧪</span> Elige el líquido</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="contenido">
            <!-- SECCIÓN 1: Simulación de la olla -->
            <div class="sec-head">
                <div class="sec-num">1</div>
                <span class="sec-titulo">🍲 Simulación de Olla a Presión</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque">
                <div class="olla-card">
                    <div class="olla-title">
                        <h2>🍲 OLLA A PRESIÓN · PRESIÓN DE VAPOR</h2>
                        <div class="badge-pressure">⚙️ Simulación termodinámica en tiempo real</div>
                    </div>

                    <canvas id="ollaCanvas" width="900" height="400" style="max-width:100%; height:auto; border-radius:28px;"></canvas>

                    <div class="controles-sim">
                        <div class="perilla">
                            <label>🔥 TEMPERATURA</label>
                            <input type="range" id="tempSlider" min="0" max="200" value="85" step="1" oninput="actualizarSimulacion()">
                            <div class="valor" id="tempVal">85</div>
                            <span style="font-size:0.7rem;">°C</span>
                        </div>
                        <div class="perilla">
                            <label>💨 PRESIÓN INTERNA</label>
                            <input type="range" id="presSlider" min="0.8" max="2.8" value="1.2" step="0.01" oninput="actualizarSimulacion()">
                            <div class="valor" id="presVal">1.20</div>
                            <span style="font-size:0.7rem;">atm</span>
                        </div>
                        <div class="perilla">
                            <label>🧪 LÍQUIDO</label>
                            <select id="sustanciaSelect" onchange="actualizarSimulacion()">
                                <option value="agua" data-pe="100">💧 Agua</option>
                                <option value="etanol" data-pe="78">🍶 Etanol</option>
                                <option value="caldo" data-pe="102">🥣 Caldo de pollo</option>
                                <option value="aceite" data-pe="180">🫒 Aceite vegetal</option>
                            </select>
                        </div>
                    </div>

                    <div class="indicadores">
                        <div class="led"><span class="led-light" id="ledPressure"></span> <span id="ledStatus">Presión normal</span></div>
                        <div class="led">⏱️ Temporizador de cocción: <span id="timerDisplay" class="timer">00:00</span></div>
                        <div class="led">🎛️ Válvula: <span id="valvulaStatus">Cerrada</span></div>
                    </div>

                    <div class="info-panel" id="infoPanel">
                        Ajusta temperatura y presión. Observa cómo se mueve la válvula y el vapor.
                    </div>
                    <div id="ebullicionMsg" class="ebullicion-alerta">⚙️ Condiciones normales</div>
                </div>
            </div>

            <!-- SECCIÓN 2: Explicación científica -->
            <div class="sec-head">
                <div class="sec-num">2</div>
                <span class="sec-titulo">🔬 ¿Cómo funciona la olla a presión?</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque">
                <div class="info-panel" style="margin: 20px; border-left-color: #facc15;">
                    <strong style="color:#facc15;">⚡ Ley de Clausius‑Clapeyron:</strong> ln(P₂/P₁) = (ΔH_vap/R) · (1/T₁ - 1/T₂)<br>
                    Al aumentar la presión externa dentro de la olla, el punto de ebullición del líquido se eleva, permitiendo cocinar a temperaturas superiores a 100°C sin que el agua se evapore. Esto acelera las reacciones de cocción y ablanda los alimentos más rápido.
                </div>
            </div>

            <!-- SECCIÓN 3: Quiz integrador -->
            <div class="sec-head">
                <div class="sec-num">3</div>
                <span class="sec-titulo">📝 Evaluación final</span>
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
            // ========== CÓDIGO ORIGINAL DEL ESCENARIO 6 (sin cambios) ==========
            const canvas = document.getElementById('ollaCanvas');
            const ctx = canvas.getContext('2d');
            canvas.width = 900;
            canvas.height = 400;

            let temp = 85;
            let pres = 1.2;
            let sustancia = 'agua';
            let puntoEbullicionBase = {agua: 100, etanol: 78, caldo: 102, aceite: 180};
            let fuerzaIntermolecular = {
                agua: 'Puentes de hidrógeno (alta cohesión)',
                etanol: 'Dipolo-dipolo + puentes H (media)',
                caldo: 'Mezcla compleja (agua + sales iónicas)',
                aceite: 'Dispersión de London (baja polaridad)'
            };

            let particulas = [];
            function initParticulas(n) {
                particulas = [];
                for (let i = 0; i < n; i++) {
                    particulas.push({
                        x: 160 + Math.random() * 580,
                        y: 220 + Math.random() * 130,
                        vx: (Math.random() - 0.5) * 1.5,
                        vy: (Math.random() - 0.5) * 1.2,
                        esVapor: false
                    });
                }
            }
            initParticulas(55);

            let tiempoCoccionSeg = 0;
            let timerActivo = false;
            let intervaloReloj = null;

            function getPuntoEbullicionActual(presAtm, basePE) {
                return basePE + (presAtm - 1.0) * 18;
            }

            function actualizarSimulacion() {
                temp = parseFloat(document.getElementById('tempSlider').value);
                pres = parseFloat(document.getElementById('presSlider').value);
                sustancia = document.getElementById('sustanciaSelect').value;

                document.getElementById('tempVal').innerText = temp;
                document.getElementById('presVal').innerText = pres.toFixed(2);

                const basePE = puntoEbullicionBase[sustancia];
                const peActual = getPuntoEbullicionActual(pres, basePE);
                const estaHirviendo = (temp >= peActual);
                const delta = peActual - temp;

                const ledLight = document.getElementById('ledPressure');
                const ledStatus = document.getElementById('ledStatus');
                const valvulaSpan = document.getElementById('valvulaStatus');
                if (pres >= 2.2) {
                    ledLight.className = 'led-light rojo';
                    ledStatus.innerText = '⚠️ PELIGRO · Válvula liberando!';
                    valvulaSpan.innerText = 'ABIERTA (silbido)';
                } else if (pres >= 1.6) {
                    ledLight.className = 'led-light naranja';
                    ledStatus.innerText = '⚡ Presión alta · Válvula vibrando';
                    valvulaSpan.innerText = 'SEMI-ABIERTA';
                } else {
                    ledLight.className = 'led-light verde';
                    ledStatus.innerText = '✓ Presión normal';
                    valvulaSpan.innerText = 'Cerrada';
                }

                const msgDiv = document.getElementById('ebullicionMsg');
                if (estaHirviendo) {
                    msgDiv.innerHTML = `♨️ ¡EBULLICIÓN ACTIVA! Presión de vapor = ${pres.toFixed(2)} atm · Punto ebullición = ${peActual.toFixed(0)}°C · Se están cocinando los alimentos más rápido.`;
                    msgDiv.style.background = '#7f1a1a';
                    msgDiv.style.color = '#ffc4c4';
                    msgDiv.style.borderLeft = '4px solid #f97316';
                } else {
                    msgDiv.innerHTML = `✅ Estable · Faltan ${delta.toFixed(0)}°C para alcanzar el punto de ebullición a ${pres.toFixed(2)} atm`;
                    msgDiv.style.background = '#0f172a';
                    msgDiv.style.color = '#94a3b8';
                }

                document.getElementById('infoPanel').innerHTML = `
                    <strong style="color:#f97316;">${sustancia.charAt(0).toUpperCase() + sustancia.slice(1)}</strong> · Fuerza intermolecular: ${fuerzaIntermolecular[sustancia]}<br>
                    📌 Punto ebullición normal (1 atm): <strong>${basePE}°C</strong><br>
                    📈 Punto ebullición a ${pres.toFixed(2)} atm : <strong>${peActual.toFixed(0)}°C</strong><br>
                    <small>⚡ Ley de Clausius‑Clapeyron: al aumentar la presión externa, se requiere mayor temperatura para que la presión de vapor iguale a la presión externa.<br>
                    🧪 La olla a presión confina el vapor, elevando la presión y el punto de ebullición, cocinando más rápido.</small>
                `;

                const debeActivarTimer = (estaHirviendo && pres >= 1.2);
                if (debeActivarTimer && !timerActivo) {
                    iniciarTemporizador();
                } else if (!debeActivarTimer && timerActivo) {
                    detenerTemporizador();
                }

                const factorVel = 0.5 + (temp / 200) * 3;
                particulas.forEach(p => {
                    if (!p.esVapor) {
                        p.vx = (Math.random() - 0.5) * factorVel;
                        p.vy = (Math.random() - 0.5) * factorVel;
                    }
                    if (estaHirviendo && !p.esVapor && Math.random() < 0.025) {
                        p.esVapor = true;
                        p.vy = -2.5 - (pres - 1.0) * 1.2;
                        p.vx += (Math.random() - 0.5) * 1.2;
                    }
                });
            }

            function iniciarTemporizador() {
                if (intervaloReloj)
                    clearInterval(intervaloReloj);
                timerActivo = true;
                tiempoCoccionSeg = 0;
                actualizarDisplayTiempo();
                intervaloReloj = setInterval(() => {
                    if (timerActivo) {
                        tiempoCoccionSeg++;
                        actualizarDisplayTiempo();
                    }
                }, 1000);
            }

            function detenerTemporizador() {
                if (intervaloReloj) {
                    clearInterval(intervaloReloj);
                    intervaloReloj = null;
                }
                timerActivo = false;
                tiempoCoccionSeg = 0;
                actualizarDisplayTiempo();
            }

            function actualizarDisplayTiempo() {
                let minutos = Math.floor(tiempoCoccionSeg / 60);
                let segundos = tiempoCoccionSeg % 60;
                document.getElementById('timerDisplay').innerText = `${minutos.toString().padStart(2,'0')}:${segundos.toString().padStart(2,'0')}`;
                    }

                    let anguloValvula = 0;
                    let offsetValvulaY = 0;
                    function dibujarOlla() {
                        ctx.clearRect(0, 0, canvas.width, canvas.height);
                        ctx.fillStyle = "#2a2c30";
                        ctx.fillRect(0, 0, canvas.width, canvas.height);
                        for (let i = 0; i < 20; i++) {
                            ctx.strokeStyle = "#3a3d42";
                            ctx.lineWidth = 1;
                            ctx.strokeRect(i * 45, 0, 40, canvas.height);
                            ctx.strokeRect(0, i * 35, canvas.width, 30);
                        }
                        ctx.shadowColor = "rgba(0,0,0,0.6)";
                        ctx.shadowBlur = 12;
                        ctx.fillStyle = "#5a5e66";
                        ctx.beginPath();
                        ctx.ellipse(canvas.width / 2, 330, 300, 35, 0, 0, Math.PI * 2);
                        ctx.fill();
                        ctx.fillStyle = "#8a8f99";
                        ctx.beginPath();
                        ctx.rect(100, 110, 700, 220);
                        ctx.fill();
                        const gradMetal = ctx.createLinearGradient(100, 110, 800, 330);
                        gradMetal.addColorStop(0, "#b0b4bc");
                        gradMetal.addColorStop(0.6, "#7a7f8a");
                        ctx.fillStyle = gradMetal;
                        ctx.fillRect(102, 112, 696, 216);
                        ctx.fillStyle = "#4a4e55";
                        ctx.beginPath();
                        ctx.ellipse(canvas.width / 2, 325, 295, 28, 0, 0, Math.PI * 2);
                        ctx.fill();
                        ctx.fillStyle = "#6b7078";
                        ctx.beginPath();
                        ctx.ellipse(canvas.width / 2, 110, 280, 30, 0, 0, Math.PI * 2);
                        ctx.fill();
                        ctx.fillStyle = "#9ea3ae";
                        ctx.beginPath();
                        ctx.ellipse(canvas.width / 2, 108, 270, 26, 0, 0, Math.PI * 2);
                        ctx.fill();
                        ctx.fillStyle = "#2c2e32";
                        ctx.fillRect(130, 98, 40, 28);
                        ctx.fillRect(canvas.width - 170, 98, 40, 28);
                        const presN = Math.min(2.8, Math.max(0.8, pres));
                        const levantar = Math.max(0, (presN - 1.2) * 18);
                        const rotar = (presN - 1.0) * 0.8;
                        ctx.save();
                        ctx.translate(canvas.width / 2, 78);
                        ctx.rotate(rotar);
                        ctx.fillStyle = "#b45309";
                        ctx.beginPath();
                        ctx.rect(-25, -20 + levantar, 50, 35);
                        ctx.fill();
                        ctx.fillStyle = "#fbbf24";
                        ctx.beginPath();
                        ctx.ellipse(0, -5 + levantar, 20, 13, 0, 0, Math.PI * 2);
                        ctx.fill();
                        ctx.fillStyle = "#92400e";
                        ctx.fillRect(-8, -30 + levantar, 16, 18);
                        ctx.fillStyle = "#ea580c";
                        ctx.beginPath();
                        ctx.ellipse(0, -28 + levantar, 12, 8, 0, 0, Math.PI * 2);
                        ctx.fill();
                        ctx.restore();
                        ctx.fillStyle = "#1e1f22";
                        ctx.beginPath();
                        ctx.arc(210, 145, 32, 0, Math.PI * 2);
                        ctx.fill();
                        ctx.fillStyle = "#f8fafc";
                        ctx.beginPath();
                        ctx.arc(210, 145, 26, 0, Math.PI * 2);
                        ctx.fill();
                        ctx.fillStyle = "#0f0f12";
                        ctx.font = "bold 12px 'Inter'";
                        ctx.fillText(`${pres.toFixed(1)} atm`, 188, 148);
                        const anguloAguja = -Math.PI / 1.8 + (pres - 0.8) * 1.4;
                        ctx.beginPath();
                        ctx.moveTo(210, 145);
                        ctx.lineTo(210 + 18 * Math.cos(anguloAguja), 145 + 18 * Math.sin(anguloAguja));
                        ctx.lineWidth = 3;
                        ctx.strokeStyle = "#f97316";
                        ctx.stroke();
                        ctx.beginPath();
                        ctx.arc(210, 145, 24, -Math.PI / 2.5, -Math.PI / 3.5);
                        ctx.strokeStyle = "#22c55e";
                        ctx.stroke();
                        ctx.beginPath();
                        ctx.arc(210, 145, 24, -Math.PI / 3.2, -Math.PI / 4);
                        ctx.strokeStyle = "#f97316";
                        ctx.stroke();
                        ctx.beginPath();
                        ctx.arc(210, 145, 24, -Math.PI / 3.8, -Math.PI / 2.2);
                        ctx.strokeStyle = "#ef4444";
                        ctx.stroke();
                        const nivelLiquido = 180 + (temp / 200) * 40;
                        ctx.fillStyle = "#3b82f6";
                        ctx.globalAlpha = 0.7;
                        ctx.fillRect(120, nivelLiquido, 660, 260 - nivelLiquido);
                        ctx.globalAlpha = 1;
                        const basePE = puntoEbullicionBase[sustancia];
                        const peActual = getPuntoEbullicionActual(pres, basePE);
                        const hirviendo = (temp >= peActual);
                        particulas.forEach(p => {
                            ctx.beginPath();
                            if (p.esVapor) {
                                ctx.fillStyle = "#e2e8f0cc";
                                ctx.arc(p.x, p.y, 6, 0, Math.PI * 2);
                                ctx.fill();
                                p.y += p.vy;
                                p.x += p.vx * 0.8;
                                if (p.y < 40 || p.x < 100 || p.x > canvas.width - 100) {
                                    p.esVapor = false;
                                    p.y = 210 + Math.random() * 90;
                                    p.x = 150 + Math.random() * 600;
                                    p.vx = (Math.random() - 0.5) * 1.8;
                                    p.vy = (Math.random() - 0.5) * 1.4;
                                }
                            } else {
                                ctx.fillStyle = "#ffb347";
                                ctx.arc(p.x, p.y, 6, 0, Math.PI * 2);
                                ctx.fill();
                                p.x += p.vx;
                                p.y += p.vy;
                                if (p.x < 125 || p.x > canvas.width - 125)
                                    p.vx *= -1;
                                if (p.y < nivelLiquido)
                                    p.vy = Math.abs(p.vy);
                                if (p.y > 310)
                                    p.vy = -Math.abs(p.vy);
                            }
                        });
                        if (pres > 1.5) {
                            for (let i = 0; i < 18; i++) {
                                ctx.fillStyle = `rgba(255,255,240,${0.3+Math.random()*0.4})`;
                                ctx.beginPath();
                                ctx.ellipse(canvas.width / 2 + (Math.sin(Date.now() * 0.01 + i) * 8), 40 - i * 3, 7, 12, 0, 0, Math.PI * 2);
                                ctx.fill();
                            }
                        }
                        if (hirviendo) {
                            for (let i = 0; i < 20; i++) {
                                let bx = 150 + Math.random() * 600;
                                let by = 240 + Math.random() * 70;
                                ctx.beginPath();
                                ctx.arc(bx, by, 3 + Math.random() * 6, 0, Math.PI * 2);
                                ctx.strokeStyle = "#ffffffaa";
                                ctx.stroke();
                            }
                        }
                        for (let i = 0; i < 30; i++) {
                            let gx = 130 + Math.random() * (canvas.width - 260);
                            let gy = 100 + Math.random() * 20;
                            ctx.fillStyle = `rgba(100,180,255,${0.2+Math.random()*0.5})`;
                            ctx.beginPath();
                            ctx.ellipse(gx, gy, 2, 4, 0, 0, Math.PI * 2);
                            ctx.fill();
                        }
                        ctx.font = "12px 'Inter'";
                        ctx.fillStyle = "#f1f5f9";
                        ctx.fillText(`🔥 ${temp}°C  |  💨 ${pres.toFixed(2)} atm`, canvas.width - 150, 380);
                        ctx.fillStyle = "#f97316";
                        ctx.fillText(`Ebullición actual: ${peActual.toFixed(0)}°C`, canvas.width - 170, 360);
                        ctx.shadowBlur = 0;
                        requestAnimationFrame(dibujarOlla);
                    }

                    window.addEventListener('load', () => {
                        actualizarSimulacion();
                        dibujarOlla();
                        setInterval(() => actualizarSimulacion(), 80);
                    });
        </script>
    </body>
</html>