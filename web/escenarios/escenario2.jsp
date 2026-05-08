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
        <title>Chef Molecular — La Sala de Salsas | Dipolos y Emulsiones 🥫</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            /* ═══════════════════════════════════════
               TEMA COCINA CÁLIDA (colores del Escenario 2)
               pero manteniendo la estructura del Escenario 1
            ═══════════════════════════════════════ */
            :root {
                --fondo-principal:   #FDF8F0;  /* base crema como papel de cocina */
                --panel-color:       #FFF8F0;
                --panel2-color:      #F4E9D8;
                --borde-color:       rgba(200,100,50,0.3);
                --borde2-color:      #CD8D5A;
                --acento-color:      #D98A3C;
                --acento2-color:     #C0392B;
                --cristal-color:     #4A2A18;
                --texto-color:       #3E2723;
                --texto2-color:      #5D3A1A;
                --texto3-color:      #8B5A2B;
                --escarcha-color:    rgba(210,150,100,0.1);
                --transicion:        0.2s ease;
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--fondo-principal);
                color: var(--texto-color);
                min-height: 100vh;
                position: relative;
                overflow-x: hidden;
                background-image: radial-gradient(circle at 10% 20%, rgba(255,200,150,0.1) 2%, transparent 2.5%),
                    radial-gradient(circle at 80% 70%, rgba(200,80,50,0.05) 1.5%, transparent 2%);
                background-size: 40px 40px, 30px 30px;
            }

            /* Barra lateral decorativa (como la del escenario1 pero con color cálido) */
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
                    rgba(217,138,60,0.4) 20%,
                    rgba(192,57,43,0.6) 50%,
                    rgba(217,138,60,0.4) 80%,
                    transparent
                    );
                pointer-events: none;
                z-index: 1;
            }

            /* ═══ NAVBAR (estructura del escenario1, colores cálidos) ═══ */
            .navbar {
                background: #5D3A1A;
                background-image: repeating-linear-gradient(45deg, rgba(255,215,150,0.1) 0px, rgba(255,215,150,0.1) 2px, transparent 2px, transparent 8px);
                border-bottom: 4px solid var(--acento-color);
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
                color: #FFF0D4;
                border: 1px solid transparent;
                padding: 6px 12px;
                border-radius: 5px;
                transition: all var(--transicion);
                letter-spacing: 0.3px;
            }
            .nav-back:hover {
                color: var(--acento2-color);
                border-color: var(--acento-color);
                background: rgba(0,0,0,0.2);
            }
            .sep {
                width: 1px;
                height: 18px;
                background: rgba(255,240,212,0.3);
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
                color: var(--acento-color);
                font-weight: 500;
            }
            .nav-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                color: #FFF0D4;
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
                background: rgba(217,138,60,0.2);
                border: 1px solid rgba(217,138,60,0.4);
                font-size: 11px;
                color: var(--acento-color);
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
                background: var(--acento2-color);
            }
            .est.off {
                background: rgba(192,57,43,0.3);
            }
            .nav-temp {
                font-family: 'Playfair Display', serif;
                font-size: 0.85rem;
                font-style: italic;
                color: #FFF0D4;
            }

            /* ═══ HERO — termómetro y pasos (estructura del escenario1) ═══ */
            .hero {
                position: relative;
                padding: 60px 40px 52px;
                overflow: hidden;
                border-bottom: 1px solid var(--borde-color);
                background: var(--fondo-principal);
            }
            .hero::before {
                content: '';
                position: absolute;
                inset: 0;
                background: linear-gradient(180deg, rgba(255,248,240,0) 0%, rgba(210,150,100,0.05) 100%);
                background-color: var(--panel-color);
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
                color: var(--acento2-color);
                font-weight: 500;
                margin-bottom: 14px;
            }
            .hero-eyebrow::before {
                content: '';
                width: 24px;
                height: 1px;
                background: var(--acento-color);
            }
            .hero-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2.8rem;
                font-weight: 700;
                color: var(--cristal-color);
                line-height: 1.05;
                margin-bottom: 6px;
                text-shadow: 0 0 40px rgba(217,138,60,0.2);
            }
            .hero-titulo em {
                color: var(--acento2-color);
                font-style: italic;
            }
            .hero-concepto {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-style: italic;
                color: var(--acento-color);
                opacity: 0.8;
                margin-bottom: 16px;
            }
            .hero-desc {
                font-size: 13px;
                color: var(--texto2-color);
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
                color: var(--acento2-color);
                line-height: 1;
            }
            .temp-barra-wrap {
                width: 6px;
                height: 80px;
                background: var(--borde2-color);
                border-radius: 3px;
                overflow: hidden;
                position: relative;
            }
            .temp-barra-fill {
                position: absolute;
                bottom: 0;
                width: 100%;
                height: 55%;
                background: linear-gradient(to top, var(--acento-color), var(--acento2-color));
                border-radius: 3px;
                animation: subir 4s ease-in-out infinite alternate;
            }
            @keyframes subir {
                from {
                    height: 45%;
                }
                to   {
                    height: 65%;
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
                border: 1px solid var(--borde-color);
                border-radius: 5px;
                background: var(--panel-color);
            }

            /* ═══ CONTENIDO PRINCIPAL — secciones tipo escenario1 ═══ */
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
                border: 1px solid var(--borde2-color);
                background: rgba(217,138,60,0.1);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                color: var(--acento2-color);
                flex-shrink: 0;
            }
            .sec-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.05rem;
                font-weight: 700;
                color: var(--cristal-color);
            }
            .sec-linea {
                flex: 1;
                height: 1px;
                background: var(--borde-color);
            }
            .sec-bloque {
                background: var(--panel-color);
                border: 1px solid var(--borde-color);
                border-radius: 8px;
                overflow: hidden;
                margin-bottom: 44px;
                position: relative;
                box-shadow: 8px 8px 16px rgba(0,0,0,0.05), -4px -4px 12px rgba(255,255,200,0.6);
            }
            .sec-bloque::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 2px;
                background: linear-gradient(to bottom, transparent, var(--acento-color) 40%, var(--acento2-color) 60%, transparent);
                opacity: 0.5;
            }

            /* Estilos para el canvas de gotas (sin cambios en su interior) */
            .canvas-wrapper {
                width: 100%;
                background: #F9E2B7;
                display: flex;
                justify-content: center;
                padding: 10px;
            }
            #canvas-gotas {
                display: block;
                width: 100%;
                height: auto;
                background: #F9E2B7;
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
                border: 1px solid var(--borde-color);
                color: var(--texto3-color);
                padding: 6px 12px;
                border-radius: 5px;
                font-size: 11px;
                cursor: pointer;
                transition: all var(--transicion);
            }
            .ctrl:hover {
                color: var(--acento2-color);
                border-color: var(--borde2-color);
                background: var(--escarcha-color);
            }
            .info {
                background: var(--panel2-color);
                border-left: 4px solid var(--acento-color);
                padding: 16px 20px;
                margin-top: 20px;
                font-size: 12px;
                color: var(--texto2-color);
                line-height: 1.6;
                border-radius: 6px;
            }
            .info strong {
                color: var(--acento2-color);
            }
            .salsa-ejemplo {
                background: rgba(217,138,60,0.1);
                border-radius: 30px;
                padding: 10px 16px;
                margin-top: 12px;
                display: flex;
                align-items: center;
                gap: 10px;
                border: 1px solid var(--borde2-color);
            }

            /* Drag & Drop adaptado a colores cálidos */
            .dd-area {
                display: flex;
                gap: 32px;
                align-items: flex-start;
                flex-wrap: wrap;
                margin: 20px 0 10px;
            }
            .moleculas-pool {
                display: flex;
                flex-direction: column;
                gap: 16px;
                min-width: 200px;
            }
            .mol-drag {
                padding: 12px 18px;
                background: #F7E5C2;
                border: 2px solid var(--borde2-color);
                border-radius: 60px;
                cursor: grab;
                font-size: 0.9rem;
                text-align: center;
                color: var(--texto-color);
                transition: all 0.2s;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
                font-weight: 500;
                box-shadow: 3px 3px 0 #BFA07A;
            }
            .mol-drag:hover {
                background: #FFE0B5;
                border-color: var(--acento2-color);
                transform: scale(1.02);
            }
            .zona-alineacion {
                flex: 1;
                min-width: 340px;
                background: rgba(210,150,100,0.1);
                border-radius: 20px;
                padding: 20px;
                border: 1px dashed var(--borde2-color);
            }
            .fila-zona {
                display: flex;
                gap: 20px;
                margin-bottom: 24px;
                align-items: center;
                justify-content: center;
                flex-wrap: wrap;
            }
            .drop-slot {
                width: 170px;
                height: 80px;
                border: 2px dashed var(--borde2-color);
                border-radius: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.8rem;
                color: var(--texto3-color);
                transition: all 0.2s;
                background: #FFF7E8;
                text-align: center;
                padding: 8px;
                font-weight: 500;
                box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
            }
            .drop-slot.sobre {
                border-color: var(--acento2-color);
                background: #FFE0C0;
            }
            .drop-slot.correcto {
                border-color: #2E7D32;
                background: #E8F5E9;
                color: #1B5E20;
            }
            .drop-slot.incorrecto {
                border-color: #C62828;
                background: #FFEBEE;
                color: #B71C1C;
            }
            .flecha {
                color: var(--acento-color);
                font-size: 1.8rem;
                font-weight: bold;
            }
            #feedback-dd {
                margin-top: 20px;
                padding: 14px;
                border-radius: 12px;
                background: var(--panel2-color);
                font-size: 0.85rem;
                display: none;
                border-left: 5px solid var(--acento-color);
            }
            .btn-verificar {
                background: var(--acento2-color);
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

            /* Botón quiz */
            .btn-quiz {
                display: inline-block;
                background: var(--acento-color);
                color: #3E2723;
                padding: 12px 28px;
                border-radius: 40px;
                text-decoration: none;
                font-weight: 700;
                font-size: 0.9rem;
                transition: all 0.2s;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
            .btn-quiz:hover {
                background: #E67E22;
                transform: translateY(-2px);
                box-shadow: 0 8px 16px rgba(217,138,60,0.4);
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
                .dd-area {
                    flex-direction: column;
                }
                .drop-slot {
                    width: 140px;
                    height: 70px;
                }
            }
        </style>
    </head>
    <body>
        <div style="position:fixed;right:0;top:0;width:2px;height:100%;background:linear-gradient(to bottom,transparent,rgba(217,138,60,0.3) 30%,rgba(192,57,43,0.5) 60%,transparent);z-index:1;pointer-events:none;"></div>

        <nav class="navbar">
            <div class="navbar-izq">
                <a href="${pageContext.request.contextPath}/menu" class="nav-back">
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="currentColor"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                    Volver
                </a>
                <div class="sep"></div>
                <div class="nav-escenario-info">
                    <span class="nav-badge">Escenario 02 🥫</span>
                    <div class="sep"></div>
                    <span class="nav-nombre">La Sala de Salsas 🧂</span>
                </div>
            </div>
            <div class="navbar-der">
                <span class="nav-temp">🍲 25 °C</span>
                <% if (completado) {%>
                <div class="chip-completado">
                    Técnica dominada ✅
                </div>
                <div class="estrellas-nav">
                    <div class="est <%= estrellas >= 1 ? "on" : "off"%>"></div>
                    <div class="est <%= estrellas >= 2 ? "on" : "off"%>"></div>
                    <div class="est <%= estrellas >= 3 ? "on" : "off"%>"></div>
                </div>
                <% }%>
            </div>
        </nav>

        <div class="hero">
            <canvas id="canvas-hero"></canvas>
            <div class="hero-inner">
                <div class="hero-text">
                    <div class="hero-eyebrow">🥄 Fuerzas dipolo-dipolo · Emulsiones</div>
                    <h1 class="hero-titulo">La Sala de<br><em>Salsas 🥫🧅</em></h1>
                    <p class="hero-concepto">Atracción entre moléculas polares · El arte de emulsionar</p>
                    <p class="hero-desc">
                        Las salsas como la vinagreta o la mayonesa existen gracias a las fuerzas dipolo-dipolo: la atracción entre cargas parciales de moléculas polares (agua, vinagre) y la ayuda de emulsionantes. A temperatura ambiente, estas interacciones dan cuerpo y textura a tus platillos.
                    </p>
                </div>
                <div class="hero-temp-panel">
                    <div class="termometro">
                        <div class="temp-numero">25</div>
                        <div class="temp-barra-wrap"><div class="temp-barra-fill"></div></div>
                        <div class="temp-unidad" style="font-size:10px;">Grados Celsius · Ambiente cocina</div>
                    </div>
                    <div class="pasos-lista">
                        <div class="paso"><div class="paso-n">🍯</div><span class="paso-t">Emulsionando en la sartén</span></div>
                        <div class="paso"><div class="paso-n">🧂</div><span class="paso-t">Alinea frascos polares</span></div>
                        <div class="paso"><div class="paso-n">📋</div><span class="paso-t">Quiz de salsas</span></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="contenido">
            <!-- SECCIÓN 1: ANIMACIÓN DE GOTAS (original del escenario2) -->
            <div class="sec-head">
                <div class="sec-num">1</div>
                <span class="sec-titulo">🍯 Emulsionando — fuerzas dipolo-dipolo en acción</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque">
                <div class="canvas-wrapper">
                    <canvas id="canvas-gotas" width="900" height="240" style="width:100%; height:auto; background:#F9E2B7; border-radius:8px;"></canvas>
                </div>
                <div class="controles">
                    <button class="ctrl" onclick="pausarGotas()">⏸ Pausar</button>
                    <button class="ctrl" onclick="reanudarGotas()">▶ Reanudar</button>
                    <button class="ctrl" onclick="reiniciarGotas()">⟳ Reiniciar</button>
                </div>
                <div class="info">
                    🫒💧 <strong>¡Observa las gotas!</strong> Las gotas <span style="color:#F5B041;">amarillas</span> son aceite (no polar) y las <span style="color:#4DAACC;">azuladas</span> representan vinagre/agua (polar). Cuando se acercan, la atracción dipolo-dipolo las hace “abrazarse”. Así empieza una emulsión.
                    <div class="salsa-ejemplo">
                        <span>🥗</span> En una vinagreta, el vinagre (polar) y el agua se atraen, mientras que el aceite necesita un emulsionante (mostaza, yema) para unirse.
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 2: ACTIVIDAD DRAG & DROP (original del escenario2) -->
            <div class="sec-head">
                <div class="sec-num">2</div>
                <span class="sec-titulo">🧂 Alinea los frascos — dipolos positivos y negativos</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque">
                <div style="padding: 20px;">
                    <p style="color: var(--texto2-color); margin-bottom: 20px;">
                        Arrastra cada "frasco de ingrediente" al lugar correcto. Para que la salsa no se corte, el polo <span style="color:#C0392B;">δ+</span> debe quedar frente al <span style="color:#2C7A4D;">δ−</span> de su compañero. ¡Como cuando emulsionas a mano!
                    </p>
                    <div class="dd-area">
                        <div class="moleculas-pool" id="pool">
                            <div class="mol-drag" draggable="true" ondragstart="dragStart(event,'HCl-pos')" id="HCl-pos">
                                🧂 Vinagre (HCl) <span style="color:#C0392B;">δ+→</span>
                            </div>
                            <div class="mol-drag" draggable="true" ondragstart="dragStart(event,'HCl-neg')" id="HCl-neg">
                                🧂 Vinagre (HCl) <span style="color:#2C7A4D;">←δ−</span>
                            </div>
                            <div class="mol-drag" draggable="true" ondragstart="dragStart(event,'HF-pos')" id="HF-pos">
                                💧 Agua (HF) <span style="color:#C0392B;">δ+→</span>
                            </div>
                            <div class="mol-drag" draggable="true" ondragstart="dragStart(event,'HF-neg')" id="HF-neg">
                                💧 Agua (HF) <span style="color:#2C7A4D;">←δ−</span>
                            </div>
                        </div>
                        <div class="zona-alineacion">
                            <div class="fila-zona">
                                <div class="drop-slot" id="slot1" data-esperado="HCl-pos" ondragover="allowDrop(event)" ondrop="drop(event, 'slot1')">
                                    🥄 Ingrediente polar +
                                </div>
                                <span class="flecha">⇢</span>
                                <div class="drop-slot" id="slot2" data-esperado="HCl-neg" ondragover="allowDrop(event)" ondrop="drop(event, 'slot2')">
                                    🥄 Ingrediente polar -
                                </div>
                            </div>
                            <div class="fila-zona">
                                <div class="drop-slot" id="slot3" data-esperado="HF-pos" ondragover="allowDrop(event)" ondrop="drop(event, 'slot3')">
                                    🥄 Ingrediente polar +
                                </div>
                                <span class="flecha">⇢</span>
                                <div class="drop-slot" id="slot4" data-esperado="HF-neg" ondragover="allowDrop(event)" ondrop="drop(event, 'slot4')">
                                    🥄 Ingrediente polar -
                                </div>
                            </div>
                            <button class="btn-verificar" onclick="verificarDD()">✨ Verificar emulsión</button>
                            <div id="feedback-dd"></div>
                        </div>
                    </div>
                    <div class="info" style="margin-top: 20px;">
                        🥚 <strong>Mayonesa molecular:</strong> La lecitina del huevo tiene una cabeza polar (que se une al agua/vinagre) y una cola no polar (que se une al aceite). ¡Las fuerzas dipolo-dipolo mantienen la salsa estable!
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 3: QUIZ -->
            <!-- SECCIÓN 3: ACTIVIDAD INTERACTIVA -->
            <div class="sec-head">
                <div class="sec-num">3</div>
                <span class="sec-titulo">🎮 Actividad Interactiva — Pon en práctica lo aprendido</span>
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
            <script>
                // ========== HERO CANVAS (copos de nieve decorativos, pero adaptado a tonos cálidos) ==========
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
                    if (!heroCtx || heroWidth === 0)
                        return;
                    heroCtx.clearRect(0, 0, heroWidth, heroHeight);
                    heroParticles.forEach(p => {
                        p.y -= p.v;
                        p.x += Math.sin(p.a + Date.now() * 0.0005) * 0.0002;
                        if (p.y < -0.05)
                            p.y = 1.05;
                        heroCtx.beginPath();
                        heroCtx.arc(p.x * heroWidth, p.y * heroHeight, p.s, 0, Math.PI * 2);
                        heroCtx.fillStyle = 'rgba(217,138,60,0.3)';
                        heroCtx.fill();
                    });
                    requestAnimationFrame(loopHero);
                }
                window.addEventListener('resize', resizeHero);
                resizeHero();
                loopHero();

                // ========== ANIMACIÓN DE GOTAS (idéntica al escenario2 original) ==========
                const canvasGotas = document.getElementById('canvas-gotas');
                const ctxGotas = canvasGotas.getContext('2d');
                let anchoGotas = 900, altoGotas = 240;
                canvasGotas.width = anchoGotas;
                canvasGotas.height = altoGotas;
                let runGotas = true, animGotasId = null;

                let gotas = [];
                function initGotas() {
                    gotas = [];
                    for (let i = 0; i < 14; i++) {
                        gotas.push({
                            x: Math.random() * anchoGotas,
                            y: Math.random() * altoGotas,
                            vx: (Math.random() - 0.5) * 1.2,
                            vy: (Math.random() - 0.5) * 1.2,
                            type: Math.random() > 0.5 ? 'oil' : 'vinegar'
                        });
                    }
                }
                initGotas();

                function dibujarGotas() {
                    ctxGotas.clearRect(0, 0, anchoGotas, altoGotas);
                    ctxGotas.fillStyle = '#F9E2B7';
                    ctxGotas.fillRect(0, 0, anchoGotas, altoGotas);
                    // Líneas de atracción dipolo-dipolo
                    for (let i = 0; i < gotas.length; i++) {
                        for (let j = i + 1; j < gotas.length; j++) {
                            const a = gotas[i];
                            const b = gotas[j];
                            const dx = b.x - a.x;
                            const dy = b.y - a.y;
                            const dist = Math.hypot(dx, dy);
                            if (dist < 70 && a.type !== b.type) {
                                const opac = 1 - dist / 70;
                                ctxGotas.beginPath();
                                ctxGotas.strokeStyle = `rgba(200, 80, 50, ${opac * 0.6})`;
                                ctxGotas.lineWidth = 1.8;
                                ctxGotas.setLineDash([5, 6]);
                                ctxGotas.moveTo(a.x, a.y);
                                ctxGotas.lineTo(b.x, b.y);
                                ctxGotas.stroke();
                                ctxGotas.setLineDash([]);
                            }
                        }
                    }
                    // Dibujar gotas
                    gotas.forEach(g => {
                        ctxGotas.beginPath();
                        ctxGotas.ellipse(g.x, g.y, 12, 10, 0, 0, Math.PI * 2);
                        if (g.type === 'oil') {
                            ctxGotas.fillStyle = '#F5B041';
                            ctxGotas.shadowBlur = 6;
                            ctxGotas.shadowColor = '#D35400';
                            ctxGotas.fill();
                            ctxGotas.fillStyle = '#B9770E';
                            ctxGotas.font = 'bold 12px "DM Sans"';
                            ctxGotas.fillText('🫒', g.x - 8, g.y + 4);
                        } else {
                            ctxGotas.fillStyle = '#B3E4F0';
                            ctxGotas.shadowBlur = 4;
                            ctxGotas.fill();
                            ctxGotas.fillStyle = '#2C7A4D';
                            ctxGotas.font = 'bold 12px "DM Sans"';
                            ctxGotas.fillText('💧', g.x - 6, g.y + 5);
                        }
                        ctxGotas.shadowBlur = 0;
                        ctxGotas.strokeStyle = '#8B5A2B';
                        ctxGotas.lineWidth = 1;
                        ctxGotas.stroke();
                    });
                }

                function moverGotas() {
                    for (let i = 0; i < gotas.length; i++) {
                        const g = gotas[i];
                        for (let j = 0; j < gotas.length; j++) {
                            if (i === j)
                                continue;
                            const o = gotas[j];
                            if (g.type !== o.type) {
                                const dx = o.x - g.x;
                                const dy = o.y - g.y;
                                const dist = Math.hypot(dx, dy);
                                if (dist < 90) {
                                    const force = (90 - dist) / 90 * 0.08;
                                    g.vx += dx / dist * force;
                                    g.vy += dy / dist * force;
                                    o.vx -= dx / dist * force;
                                    o.vy -= dy / dist * force;
                                }
                            } else {
                                const dx = o.x - g.x;
                                const dy = o.y - g.y;
                                const dist = Math.hypot(dx, dy);
                                if (dist < 40) {
                                    const force = (40 - dist) / 40 * 0.05;
                                    g.vx -= dx / dist * force;
                                    g.vy -= dy / dist * force;
                                    o.vx += dx / dist * force;
                                    o.vy += dy / dist * force;
                                }
                            }
                        }
                        let spd = Math.hypot(g.vx, g.vy);
                        if (spd > 2.2) {
                            g.vx = g.vx / spd * 2.2;
                            g.vy = g.vy / spd * 2.2;
                        }
                        g.x += g.vx;
                        g.y += g.vy;
                        if (g.x < 15) {
                            g.x = 15;
                            g.vx *= -0.9;
                        }
                        if (g.x > anchoGotas - 15) {
                            g.x = anchoGotas - 15;
                            g.vx *= -0.9;
                        }
                        if (g.y < 15) {
                            g.y = 15;
                            g.vy *= -0.9;
                        }
                        if (g.y > altoGotas - 15) {
                            g.y = altoGotas - 15;
                            g.vy *= -0.9;
                        }
                    }
                }

                function loopGotas() {
                    if (!runGotas)
                        return;
                    moverGotas();
                    dibujarGotas();
                    animGotasId = requestAnimationFrame(loopGotas);
                }
                function pausarGotas() {
                    runGotas = false;
                    cancelAnimationFrame(animGotasId);
                }
                function reanudarGotas() {
                    if (!runGotas) {
                        runGotas = true;
                        loopGotas();
                    }
                }
                function reiniciarGotas() {
                    pausarGotas();
                    initGotas();
                    reanudarGotas();
                }
                loopGotas();

                // ========== DRAG & DROP (sin cambios) ==========
                let colocados = {};
                function dragStart(e, id) {
                    e.dataTransfer.setData('text', id);
                }
                function allowDrop(e) {
                    e.preventDefault();
                    e.currentTarget.classList.add('sobre');
                }
                document.querySelectorAll('.drop-slot').forEach(slot => {
                    slot.addEventListener('dragleave', () => slot.classList.remove('sobre'));
                });
                function drop(e, slotId) {
                    e.preventDefault();
                    const slot = document.getElementById(slotId);
                    slot.classList.remove('sobre');
                    const molId = e.dataTransfer.getData('text');
                    const molEl = document.getElementById(molId);
                    if (!molEl)
                        return;
                    if (colocados[slotId]) {
                        const prev = document.getElementById(colocados[slotId]);
                        if (prev)
                            document.getElementById('pool').appendChild(prev);
                    }
                    colocados[slotId] = molId;
                    slot.innerHTML = '';
                    slot.appendChild(molEl);
                    slot.classList.remove('correcto', 'incorrecto');
                }
                function verificarDD() {
                    let correctos = 0;
                    ['slot1', 'slot2', 'slot3', 'slot4'].forEach(id => {
                        const slot = document.getElementById(id);
                        const esperado = slot.dataset.esperado;
                        const ok = colocados[id] === esperado;
                        slot.classList.toggle('correcto', ok);
                        slot.classList.toggle('incorrecto', !ok);
                        if (ok)
                            correctos++;
                    });
                    const fb = document.getElementById('feedback-dd');
                    fb.style.display = 'block';
                    if (correctos === 4) {
                        fb.innerHTML = '<span style="color:#2E7D32;">✅ 🎉 ¡Salsa perfecta! Alineaste todos los dipolos. El polo δ⁺ frente al δ⁻ maximiza la atracción, igual que cuando logramos una vinagreta homogénea.</span>';
                    } else {
                        fb.innerHTML = `<span style="color:#C62828;">⚠ ${correctos}/4 correctos. Algunos ingredientes no se alinearon bien. Recuerda: δ⁺ debe quedar frente a δ⁻, como los sabores que se complementan en una salsa.</span>`;
                    }
                }
            </script>
    </body>
</html>