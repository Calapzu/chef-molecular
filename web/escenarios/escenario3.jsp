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
        <title>Chef Molecular — Taller del Merengue | Puentes de Hidrógeno 🥚</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            /* ═══════════════════════════════════════
               TEMA TALLER DEL MERENGUE (colores del Escenario 3)
               pero con la estructura del Escenario 1
            ═══════════════════════════════════════ */
            :root {
                --fondo-crema:       #FFF9F0;
                --panel-crema:       #FFFEF7;
                --panel2-crema:      #FFF5E8;
                --borde-crema:       rgba(217,122,43,0.25);
                --borde2-crema:      #F0D8B0;
                --acento-miel:       #D97A2B;
                --acento-miel2:      #F4C28C;
                --texto-oscuro:      #4A2A1A;
                --texto-medio:       #6B3E1C;
                --texto-suave:       #8B5A2B;
                --escarcha-crema:    rgba(244,194,140,0.1);
                --transicion:        0.2s ease;
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--fondo-crema);
                color: var(--texto-oscuro);
                min-height: 100vh;
                position: relative;
                overflow-x: hidden;
                background-image: radial-gradient(circle at 20% 30%, rgba(255,220,150,0.3) 3%, transparent 3.5%),
                                  radial-gradient(circle at 80% 70%, rgba(255,180,120,0.2) 2%, transparent 2.5%);
                background-size: 50px 50px, 40px 40px;
            }

            /* Barra lateral decorativa (como la del escenario1 pero con tono melocotón) */
            body::after {
                content: '';
                position: fixed;
                left: 0;
                top: 0;
                width: 3px;
                height: 100%;
                background: linear-gradient(
                    to bottom,
                    transparent,
                    rgba(217,122,43,0.4) 20%,
                    rgba(244,194,140,0.7) 50%,
                    rgba(217,122,43,0.4) 80%,
                    transparent
                );
                pointer-events: none;
                z-index: 1;
            }

            /* ═══ NAVBAR — estilo del escenario1 con colores cálidos ═══ */
            .navbar {
                background: #F5E6D3;
                border-bottom: 4px solid var(--acento-miel2);
                padding: 0 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 64px;
                position: sticky;
                top: 0;
                z-index: 100;
                backdrop-filter: blur(2px);
                flex-wrap: wrap;
                gap: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
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
                color: var(--texto-medio);
                border: 1px solid transparent;
                padding: 6px 12px;
                border-radius: 5px;
                transition: all var(--transicion);
                letter-spacing: 0.3px;
            }
            .nav-back:hover {
                color: var(--acento-miel);
                border-color: var(--acento-miel2);
                background: rgba(244,194,140,0.2);
            }
            .sep {
                width: 1px;
                height: 18px;
                background: rgba(107,62,28,0.2);
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
                color: var(--acento-miel);
                font-weight: 500;
            }
            .nav-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                color: var(--texto-medio);
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
                background: rgba(217,122,43,0.1);
                border: 1px solid rgba(217,122,43,0.3);
                font-size: 11px;
                color: var(--acento-miel);
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
                background: var(--acento-miel);
            }
            .est.off {
                background: rgba(217,122,43,0.2);
            }
            .nav-temp {
                font-family: 'Playfair Display', serif;
                font-size: 0.85rem;
                font-style: italic;
                color: var(--texto-medio);
            }

            /* ═══ HERO — termómetro y pasos (estructura escenario1) ═══ */
            .hero {
                position: relative;
                padding: 60px 40px 52px;
                overflow: hidden;
                border-bottom: 1px solid var(--borde-crema);
                background: var(--fondo-crema);
            }
            .hero::before {
                content: '';
                position: absolute;
                inset: 0;
                background: linear-gradient(180deg, rgba(255,249,240,0) 0%, rgba(244,194,140,0.05) 100%);
            }
            #canvas-hero {
                position: absolute;
                inset: 0;
                width: 100%;
                height: 100%;
                pointer-events: none;
                z-index: 1;
                opacity: 0.3;
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
                color: var(--acento-miel);
                font-weight: 500;
                margin-bottom: 14px;
            }
            .hero-eyebrow::before {
                content: '';
                width: 24px;
                height: 1px;
                background: var(--acento-miel);
            }
            .hero-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2.8rem;
                font-weight: 700;
                color: var(--texto-oscuro);
                line-height: 1.05;
                margin-bottom: 6px;
                text-shadow: 0 0 40px rgba(217,122,43,0.2);
            }
            .hero-titulo em {
                color: var(--acento-miel);
                font-style: italic;
            }
            .hero-concepto {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-style: italic;
                color: var(--acento-miel);
                opacity: 0.8;
                margin-bottom: 16px;
            }
            .hero-desc {
                font-size: 13px;
                color: var(--texto-medio);
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
                color: var(--acento-miel);
                line-height: 1;
            }
            .temp-barra-wrap {
                width: 6px;
                height: 80px;
                background: var(--borde2-crema);
                border-radius: 3px;
                overflow: hidden;
                position: relative;
            }
            .temp-barra-fill {
                position: absolute;
                bottom: 0;
                width: 100%;
                height: 65%;
                background: linear-gradient(to top, var(--acento-miel2), var(--acento-miel));
                border-radius: 3px;
                animation: subir 4s ease-in-out infinite alternate;
            }
            @keyframes subir {
                from {
                    height: 55%;
                }
                to   {
                    height: 75%;
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
                border: 1px solid var(--borde-crema);
                border-radius: 5px;
                background: var(--panel-crema);
            }

            /* ═══ CONTENIDO PRINCIPAL — secciones escenario1 ═══ */
            .contenido {
                max-width: 1000px;
                margin: 0 auto;
                padding: 44px 40px 80px;
                position: relative;
                z-index: 1;
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
                border: 1px solid var(--borde2-crema);
                background: rgba(217,122,43,0.08);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                color: var(--acento-miel);
                flex-shrink: 0;
            }
            .sec-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.05rem;
                font-weight: 700;
                color: var(--texto-oscuro);
            }
            .sec-linea {
                flex: 1;
                height: 1px;
                background: var(--borde-crema);
            }
            .sec-bloque {
                background: var(--panel-crema);
                border: 1px solid var(--borde-crema);
                border-radius: 8px;
                overflow: hidden;
                margin-bottom: 44px;
                position: relative;
                box-shadow: 6px 6px 14px rgba(0,0,0,0.03), -4px -4px 12px rgba(255,250,210,0.6);
            }
            .sec-bloque::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 2px;
                background: linear-gradient(to bottom, transparent, var(--acento-miel2) 40%, var(--acento-miel) 60%, transparent);
                opacity: 0.6;
            }

            /* Estilos para el canvas de merengue (original del escenario3) */
            .canvas-wrapper {
                width: 100%;
                background: #FFF2E0;
                display: flex;
                justify-content: center;
                padding: 10px;
            }
            #canvas-merengue {
                display: block;
                width: 100%;
                height: auto;
                background: #FFF2E0;
                border-radius: 8px;
            }
            .controles {
                display: flex;
                gap: 12px;
                justify-content: center;
                margin: 20px 0 10px;
                flex-wrap: wrap;
            }
            .ctrl {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                background: none;
                border: 1px solid var(--borde-crema);
                color: var(--texto-suave);
                padding: 6px 12px;
                border-radius: 5px;
                font-size: 11px;
                cursor: pointer;
                transition: all var(--transicion);
            }
            .ctrl:hover {
                color: var(--acento-miel);
                border-color: var(--borde2-crema);
                background: var(--escarcha-crema);
            }
            .info {
                background: var(--panel2-crema);
                border-left: 4px solid var(--acento-miel);
                padding: 16px 20px;
                margin-top: 20px;
                font-size: 12px;
                color: var(--texto-medio);
                line-height: 1.6;
                border-radius: 6px;
            }
            .info strong {
                color: var(--acento-miel);
            }
            .merengue-ejemplo {
                background: rgba(244,194,140,0.15);
                border-radius: 30px;
                padding: 10px 16px;
                margin-top: 12px;
                display: flex;
                align-items: center;
                gap: 10px;
                border: 1px solid var(--borde2-crema);
            }

            /* Laboratorio de puentes de hidrógeno (original escenario3 adaptado) */
            .lab {
                display: flex;
                gap: 28px;
                flex-wrap: wrap;
                padding: 0 0 20px 0;
            }
            .moleculas-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 12px;
                min-width: 220px;
            }
            .mol-lab {
                padding: 12px;
                background: var(--panel2-crema);
                border-radius: 48px;
                border: 2px solid var(--borde2-crema);
                cursor: pointer;
                font-size: 0.85rem;
                text-align: center;
                transition: all 0.2s;
                font-weight: 500;
                color: var(--texto-medio);
                box-shadow: 0 2px 4px rgba(0,0,0,0.02);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                flex-direction: column;
            }
            .mol-lab:hover {
                border-color: var(--acento-miel);
                background: #FFF0DC;
                transform: scale(1.02);
            }
            .mol-lab.activa {
                border-color: var(--acento-miel);
                background: #FEEDD0;
                box-shadow: 0 0 0 2px var(--acento-miel2);
            }
            .zona-lab {
                flex: 1;
                min-width: 280px;
                background: rgba(244,194,140,0.08);
                border-radius: 48px;
                padding: 20px;
            }
            .canvas-lab {
                background: #FFF2E0;
                border-radius: 48px;
                display: block;
                margin-bottom: 16px;
                width: 100%;
                height: auto;
                box-shadow: inset 0 1px 4px rgba(0,0,0,0.02), 0 2px 6px rgba(0,0,0,0.05);
            }
            .pasos {
                margin-top: 16px;
            }
            .paso-texto {
                background: #FFF9EF;
                border-left: 4px solid var(--acento-miel);
                padding: 12px 16px;
                border-radius: 20px;
                margin-bottom: 10px;
                font-size: 0.85rem;
                color: var(--texto-medio);
                line-height: 1.5;
                display: none;
            }
            .paso-texto.visible {
                display: block;
            }
            .paso-texto strong {
                color: var(--acento-miel);
            }
            #msg-lab {
                margin-top: 12px;
                font-size: 0.9rem;
                padding: 10px;
                border-radius: 30px;
                text-align: center;
            }
            .btn-quiz {
                display: inline-block;
                background: var(--acento-miel);
                color: #FFF9F0;
                padding: 12px 28px;
                border-radius: 40px;
                text-decoration: none;
                font-weight: 700;
                font-size: 0.9rem;
                transition: all 0.2s;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
            .btn-quiz:hover {
                background: #C0641A;
                transform: translateY(-2px);
                box-shadow: 0 8px 16px rgba(217,122,43,0.3);
            }
            .quiz-wrap {
                padding: 24px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 20px;
                flex-wrap: wrap;
            }

            @media (max-width: 680px) {
                .navbar {
                    padding: 0 20px;
                }
                .hero {
                    padding: 40px 20px;
                }
                .contenido {
                    padding: 30px 20px 60px;
                }
                .lab {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <div style="position:fixed;right:0;top:0;width:2px;height:100%;background:linear-gradient(to bottom,transparent,rgba(217,122,43,0.3) 30%,rgba(244,194,140,0.5) 60%,transparent);z-index:1;pointer-events:none;"></div>

        <nav class="navbar">
            <div class="navbar-izq">
                <a href="${pageContext.request.contextPath}/menu" class="nav-back">
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="currentColor"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                    Volver
                </a>
                <div class="sep"></div>
                <div class="nav-escenario-info">
                    <span class="nav-badge">Escenario 03 🥚</span>
                    <div class="sep"></div>
                    <span class="nav-nombre">Taller del Merengue 🧁</span>
                </div>
            </div>
            <div class="navbar-der">
                <span class="nav-temp">🍰 22 °C</span>
                <% if (completado) { %>
                <div class="chip-completado">
                    Técnica dominada ✅
                </div>
                <div class="estrellas-nav">
                    <div class="est <%= estrellas >= 1 ? "on" : "off" %>"></div>
                    <div class="est <%= estrellas >= 2 ? "on" : "off" %>"></div>
                    <div class="est <%= estrellas >= 3 ? "on" : "off" %>"></div>
                </div>
                <% } %>
            </div>
        </nav>

        <div class="hero">
            <canvas id="canvas-hero"></canvas>
            <div class="hero-inner">
                <div class="hero-text">
                    <div class="hero-eyebrow">🥄 Puentes de hidrógeno · Merengue perfecto</div>
                    <h1 class="hero-titulo">Taller del<br><em>Merengue 🧁🥚</em></h1>
                    <p class="hero-concepto">Uniones moleculares que levantan claras de huevo</p>
                    <p class="hero-desc">
                        Los puentes de hidrógeno son los responsables de que las claras batidas atrapen aire y no se bajen. Entre las proteínas y el agua se forman estas uniones que dan estructura a la espuma. El azúcar refuerza la red y estabiliza el merengue.
                    </p>
                </div>
                <div class="hero-temp-panel">
                    <div class="termometro">
                        <div class="temp-numero">22</div>
                        <div class="temp-barra-wrap"><div class="temp-barra-fill"></div></div>
                        <div class="temp-unidad">Grados Celsius · Ambiente pastelería</div>
                    </div>
                    <div class="pasos-lista">
                        <div class="paso"><div class="paso-n">🥄</div><span class="paso-t">Batiendo claras (puentes H)</span></div>
                        <div class="paso"><div class="paso-n">⚗️</div><span class="paso-t">Laboratorio de ingredientes</span></div>
                        <div class="paso"><div class="paso-n">📋</div><span class="paso-t">Quiz del merengue</span></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="contenido">
            <!-- SECCIÓN 1: ANIMACIÓN DE MERENGUE (original escenario3) -->
            <div class="sec-head">
                <div class="sec-num">1</div>
                <span class="sec-titulo">🥄 Batiendo claras — Puentes de H en acción</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque">
                <div class="canvas-wrapper">
                    <canvas id="canvas-merengue" width="900" height="240" style="width:100%; height:auto; background:#FFF2E0; border-radius:8px;"></canvas>
                </div>
                <div class="controles">
                    <button class="ctrl" onclick="pausarMerengue()">⏸ Pausar batido</button>
                    <button class="ctrl" onclick="reanudarMerengue()">▶ Seguir batiendo</button>
                    <button class="ctrl" onclick="reiniciarMerengue()">⟳ Reiniciar mezcla</button>
                </div>
                <div class="info">
                    🥚💨 <strong>¿Qué ves?</strong> Las moléculas de agua (H₂O) en la clara de huevo forman <strong>puentes de hidrógeno</strong> (líneas punteadas) entre sí. Al batir, incorporamos aire y estos puentes ayudan a atrapar burbujas, formando la espuma del merengue.
                    <div class="merengue-ejemplo">
                        <span>🧁</span> En un merengue italiano o francés, los puentes de hidrógeno entre el agua y las proteínas de la clara estabilizan la espuma. El azúcar refuerza esta red, ¡evitando que se baje!
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 2: LABORATORIO DE PUENTES DE H (original escenario3) -->
            <div class="sec-head">
                <div class="sec-num">2</div>
                <span class="sec-titulo">⚗️ ¿Qué ingredientes forman puentes de hidrógeno?</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque">
                <div style="padding: 20px;">
                    <p style="color: var(--texto-medio); margin-bottom: 20px;">
                        En el taller, selecciona dos "ingredientes moleculares" y descubre si pueden unirse mediante un puente de hidrógeno (como las proteínas y el agua en el merengue).
                    </p>
                    <div class="lab">
                        <div>
                            <p style="color: var(--acento-miel); font-size:0.8rem; margin-bottom: 10px;">
                                🧪 INGREDIENTES MOLECULARES
                            </p>
                            <div class="moleculas-grid" id="grid-mol">
                                <div class="mol-lab" data-nombre="Agua (H₂O)" data-atomo="O" data-tiene-h="true" data-puede="true">💧 Agua (H₂O)<br><small>O−H</small></div>
                                <div class="mol-lab" data-nombre="Ácido fluorhídrico (HF)" data-atomo="F" data-tiene-h="true" data-puede="true">🧪 HF (F−H)<br><small>muy electronegativo</small></div>
                                <div class="mol-lab" data-nombre="Amoníaco (NH₃)" data-atomo="N" data-tiene-h="true" data-puede="true">⚗️ Amoníaco (NH₃)<br><small>N−H</small></div>
                                <div class="mol-lab" data-nombre="Metano (CH₄)" data-atomo="C" data-tiene-h="false" data-puede="false">⬛ Metano (CH₄)<br><small>sin átomo electronegativo</small></div>
                                <div class="mol-lab" data-nombre="Ácido clorhídrico (HCl)" data-atomo="Cl" data-tiene-h="true" data-puede="false">🟡 Ácido clorhídrico (HCl)<br><small>Cl−H (muy débil)</small></div>
                                <div class="mol-lab" data-nombre="Dióxido de carbono (CO₂)" data-atomo="C" data-tiene-h="false" data-puede="false">🌫️ Dióxido de carbono (CO₂)<br><small>sin H unido a F/O/N</small></div>
                            </div>
                        </div>
                        <div class="zona-lab">
                            <canvas id="canvas-lab" width="340" height="180" class="canvas-lab" style="width:100%; height:auto; max-width:340px;"></canvas>
                            <div id="msg-lab"></div>
                            <div class="pasos" id="pasosDiv"></div>
                        </div>
                    </div>
                    <div class="info" style="margin-top: 20px;">
                        🍰 <strong>En la repostería:</strong> Los puentes de hidrógeno son los que permiten que las proteínas de la clara (ovalbúmina) se desnaturalicen y atrapen aire. El azúcar compite por el agua, reforzando la estructura. ¡Por eso el merengue no se baja!
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 3: QUIZ -->
            <div class="sec-head">
                <div class="sec-num">3</div>
                <span class="sec-titulo">📝 Pon a prueba tu merengue molecular</span>
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
            // ========== HERO CANVAS (copos decorativos con tono cálido) ==========
            const heroCanvas = document.getElementById('canvas-hero');
            let heroCtx = heroCanvas.getContext('2d');
            let heroParticles = [];
            let heroWidth, heroHeight;
            function resizeHero() {
                const rect = heroCanvas.parentElement.getBoundingClientRect();
                heroWidth = rect.width;
                heroHeight = rect.height;
                heroCanvas.width = heroWidth;
                heroCanvas.height = heroHeight;
                heroParticles = Array.from({length: Math.min(60, Math.floor(heroWidth / 20))}, () => ({
                    x: Math.random(), y: Math.random(), s: 1 + Math.random() * 3, v: 0.0001 + Math.random() * 0.00015, a: Math.random() * Math.PI * 2
                }));
            }
            function loopHero() {
                if (!heroCtx || heroWidth === 0) return;
                heroCtx.clearRect(0, 0, heroWidth, heroHeight);
                heroParticles.forEach(p => {
                    p.y -= p.v;
                    p.x += Math.sin(p.a + Date.now() * 0.0005) * 0.0002;
                    if (p.y < -0.05) p.y = 1.05;
                    heroCtx.beginPath();
                    heroCtx.arc(p.x * heroWidth, p.y * heroHeight, p.s, 0, Math.PI * 2);
                    heroCtx.fillStyle = 'rgba(217,122,43,0.3)';
                    heroCtx.fill();
                });
                requestAnimationFrame(loopHero);
            }
            window.addEventListener('resize', resizeHero);
            resizeHero();
            loopHero();

            // ========== ANIMACIÓN DE MERENGUE (puentes de H) ==========
            const canvasMerengue = document.getElementById('canvas-merengue');
            const ctxMerengue = canvasMerengue.getContext('2d');
            let anchoMerengue = 900, altoMerengue = 240;
            canvasMerengue.width = anchoMerengue;
            canvasMerengue.height = altoMerengue;
            let runMerengue = true, animMerengueId = null;

            const aguas = [];
            for (let i = 0; i < 8; i++) {
                aguas.push({
                    x: 80 + (i % 4) * 180,
                    y: 60 + Math.floor(i / 4) * 90,
                    vx: (Math.random() - 0.5) * 0.8,
                    vy: (Math.random() - 0.5) * 0.8
                });
            }

            function dibujarMerengue() {
                ctxMerengue.clearRect(0, 0, anchoMerengue, altoMerengue);
                ctxMerengue.fillStyle = '#FFF2E0';
                ctxMerengue.fillRect(0, 0, anchoMerengue, altoMerengue);

                // Puentes de hidrógeno
                for (let i = 0; i < aguas.length; i++) {
                    for (let j = i + 1; j < aguas.length; j++) {
                        const dx = aguas[j].x - aguas[i].x;
                        const dy = aguas[j].y - aguas[i].y;
                        const d = Math.hypot(dx, dy);
                        if (d < 130) {
                            const opac = (1 - d / 130).toFixed(2);
                            ctxMerengue.beginPath();
                            ctxMerengue.setLineDash([6, 5]);
                            ctxMerengue.strokeStyle = `rgba(217, 122, 43, ${opac * 0.7})`;
                            ctxMerengue.lineWidth = 2;
                            ctxMerengue.moveTo(aguas[i].x, aguas[i].y);
                            ctxMerengue.lineTo(aguas[j].x, aguas[j].y);
                            ctxMerengue.stroke();
                            ctxMerengue.setLineDash([]);
                            if (d < 90) {
                                ctxMerengue.fillStyle = '#D97A2B';
                                ctxMerengue.font = '9px "DM Sans"';
                                ctxMerengue.fillText('H···O', (aguas[i].x + aguas[j].x) / 2 - 10, (aguas[i].y + aguas[j].y) / 2 - 6);
                            }
                        }
                    }
                }
                // Moléculas de agua
                aguas.forEach(a => {
                    ctxMerengue.beginPath();
                    ctxMerengue.arc(a.x, a.y, 18, 0, Math.PI * 2);
                    ctxMerengue.fillStyle = '#FFF0D0';
                    ctxMerengue.fill();
                    ctxMerengue.strokeStyle = '#D97A2B';
                    ctxMerengue.lineWidth = 1.5;
                    ctxMerengue.stroke();
                    ctxMerengue.fillStyle = '#C0641A';
                    ctxMerengue.font = 'bold 12px "DM Sans"';
                    ctxMerengue.textAlign = 'center';
                    ctxMerengue.fillText('O⁻', a.x, a.y + 5);
                    [[-20, -14], [20, -14]].forEach(([hx, hy]) => {
                        ctxMerengue.beginPath();
                        ctxMerengue.arc(a.x + hx, a.y + hy, 9, 0, Math.PI * 2);
                        ctxMerengue.fillStyle = '#FFDDAA';
                        ctxMerengue.fill();
                        ctxMerengue.fillStyle = '#8B5A2B';
                        ctxMerengue.font = '8px sans-serif';
                        ctxMerengue.fillText('H⁺', a.x + hx - 3, a.y + hy + 3);
                    });
                });
                ctxMerengue.textAlign = 'left';
            }

            function moverMerengue() {
                aguas.forEach(a => {
                    a.x += a.vx;
                    a.y += a.vy;
                    if (a.x < 20 || a.x > anchoMerengue - 20) a.vx *= -1;
                    if (a.y < 20 || a.y > altoMerengue - 20) a.vy *= -1;
                });
            }

            function loopMerengue() {
                if (!runMerengue) return;
                moverMerengue();
                dibujarMerengue();
                animMerengueId = requestAnimationFrame(loopMerengue);
            }
            function pausarMerengue() { runMerengue = false; cancelAnimationFrame(animMerengueId); }
            function reanudarMerengue() { if (!runMerengue) { runMerengue = true; loopMerengue(); } }
            function reiniciarMerengue() {
                pausarMerengue();
                aguas.forEach(a => {
                    a.x = Math.random() * (anchoMerengue - 100) + 50;
                    a.y = Math.random() * (altoMerengue - 80) + 40;
                });
                reanudarMerengue();
            }
            loopMerengue();

            // ========== LABORATORIO DE PUENTES DE H ==========
            let seleccionadas = [];
            const canvasLab = document.getElementById('canvas-lab');
            const ctxLab = canvasLab.getContext('2d');
            canvasLab.width = 340;
            canvasLab.height = 180;

            function actualizarSeleccion(div) {
                const nombre = div.getAttribute('data-nombre');
                const atomo = div.getAttribute('data-atomo');
                const tieneH = div.getAttribute('data-tiene-h') === 'true';
                const puedeFormar = div.getAttribute('data-puede') === 'true';

                const idx = seleccionadas.findIndex(m => m.nombre === nombre);
                if (idx !== -1) {
                    seleccionadas.splice(idx, 1);
                    div.classList.remove('activa');
                } else if (seleccionadas.length < 2) {
                    seleccionadas.push({nombre, atomo, tieneH, puedeFormar, el: div});
                    div.classList.add('activa');
                }
                if (seleccionadas.length === 2) {
                    evaluarPuente();
                } else {
                    limpiarLab();
                }
            }

            function evaluarPuente() {
                const [m1, m2] = seleccionadas;
                const aceptores = ['O','N','F'];
                const m1Dona = m1.tieneH && aceptores.includes(m1.atomo);
                const m2Dona = m2.tieneH && aceptores.includes(m2.atomo);
                const m1Acepta = aceptores.includes(m1.atomo);
                const m2Acepta = aceptores.includes(m2.atomo);
                const puedeH = (m1Dona && m2Acepta) || (m2Dona && m1Acepta);

                dibujarPuenteLab(m1, m2, puedeH);

                const msgDiv = document.getElementById('msg-lab');
                const pasosDiv = document.getElementById('pasosDiv');
                if (puedeH) {
                    msgDiv.innerHTML = `<span style="color:#D97A2B;">✅ ¡Sí forman puente de hidrógeno!</span> <span style="font-size:1.2rem;">🧁</span><br><small>Como las proteínas de la clara y el agua, se atraen y estabilizan el merengue.</small>`;
                    const donador = m1Dona ? m1.nombre : m2.nombre;
                    const aceptor = m1Dona ? m2.nombre : m1.nombre;
                    pasosDiv.innerHTML = `
                        <div class="paso-texto visible"><strong>🥄 Paso 1 — Donador de H:</strong> ${donador} tiene H unido a ${m1Dona ? m1.atomo : m2.atomo} (átomo muy electronegativo: F, O o N). El hidrógeno adquiere carga δ+.</div>
                        <div class="paso-texto visible"><strong>🥚 Paso 2 — Aceptor:</strong> ${aceptor} tiene un par de electrones libres en ${m1Dona ? m2.atomo : m1.atomo}, actuando como aceptor (δ-).</div>
                        <div class="paso-texto visible"><strong>✨ Paso 3 — Puente H:</strong> Se forma la unión X−H···Y. Es más débil que un enlace covalente pero fundamental para la espuma del merengue.</div>
                        <div class="paso-texto visible"><strong>🍰 Resultado:</strong> Esta interacción permite que las claras batidas atrapen aire y mantengan la estructura. ¡Así se logra un merengue perfecto!</div>
                    `;
                } else {
                    msgDiv.innerHTML = `<span style="color:#C0392B;">❌ No forman puente de hidrógeno.</span><br><small>Para ello se necesita un H unido a F, O o N (como en el agua, HF o amoníaco).</small>`;
                    pasosDiv.innerHTML = `<div class="paso-texto visible"><strong>¿Por qué no?</strong> ${m1.nombre} y ${m2.nombre} no cumplen la condición: el puente de hidrógeno requiere que el hidrógeno esté unido a flúor, oxígeno o nitrógeno. Aquí solo hay fuerzas de London o dipolo-dipolo.</div>`;
                }
            }

            function dibujarPuenteLab(m1, m2, puedeH) {
                ctxLab.clearRect(0, 0, canvasLab.width, canvasLab.height);
                ctxLab.fillStyle = '#FFF2E0';
                ctxLab.fillRect(0, 0, canvasLab.width, canvasLab.height);
                // Molécula izquierda
                ctxLab.beginPath();
                ctxLab.arc(90, 90, 32, 0, Math.PI * 2);
                ctxLab.fillStyle = '#FFF5E8';
                ctxLab.fill();
                ctxLab.strokeStyle = puedeH ? '#D97A2B' : '#C0392B';
                ctxLab.lineWidth = 2;
                ctxLab.stroke();
                ctxLab.fillStyle = '#6B3E1C';
                ctxLab.font = 'bold 11px "DM Sans"';
                ctxLab.textAlign = 'center';
                ctxLab.fillText(m1.nombre, 90, 96);
                // Molécula derecha
                ctxLab.beginPath();
                ctxLab.arc(250, 90, 32, 0, Math.PI * 2);
                ctxLab.fillStyle = '#FFF5E8';
                ctxLab.fill();
                ctxLab.strokeStyle = puedeH ? '#D97A2B' : '#C0392B';
                ctxLab.stroke();
                ctxLab.fillStyle = '#6B3E1C';
                ctxLab.fillText(m2.nombre, 250, 96);
                // Línea entre ellas
                ctxLab.beginPath();
                if (puedeH) ctxLab.setLineDash([6, 4]);
                else ctxLab.setLineDash([]);
                ctxLab.strokeStyle = puedeH ? '#D97A2B' : '#C0392B';
                ctxLab.lineWidth = 2;
                ctxLab.moveTo(122, 90);
                ctxLab.lineTo(218, 90);
                ctxLab.stroke();
                ctxLab.setLineDash([]);
                if (puedeH) {
                    ctxLab.fillStyle = '#D97A2B';
                    ctxLab.font = '10px "DM Sans"';
                    ctxLab.fillText('H···' + (m1.atomo === 'O' || m1.atomo === 'N' || m1.atomo === 'F' ? m2.atomo : m1.atomo), 160, 80);
                } else {
                    ctxLab.fillStyle = '#C0392B';
                    ctxLab.fillText('✗', 165, 84);
                }
                ctxLab.textAlign = 'left';
            }

            function limpiarLab() {
                ctxLab.clearRect(0, 0, canvasLab.width, canvasLab.height);
                document.getElementById('msg-lab').innerHTML = '';
                document.getElementById('pasosDiv').innerHTML = '';
                ctxLab.fillStyle = '#FFF2E0';
                ctxLab.fillRect(0, 0, canvasLab.width, canvasLab.height);
                ctxLab.fillStyle = '#6B3E1C';
                ctxLab.font = 'italic 12px "DM Sans"';
                ctxLab.fillText('Selecciona dos ingredientes', 70, 100);
            }

            document.querySelectorAll('.mol-lab').forEach(div => {
                div.addEventListener('click', () => actualizarSeleccion(div));
            });
            limpiarLab();
        </script>
    </body>
</html>