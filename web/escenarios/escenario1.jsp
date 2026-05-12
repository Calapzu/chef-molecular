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
        <title>Chef Molecular — La Cocina Fría 🧊 | Agua y Aceite</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            /* ═══════════════════════════════════════
               TEMA COCINA FRÍA — NEVERA MOLECULAR
            ═══════════════════════════════════════ */
            :root {
                --hie-fondo:        #040C14;
                --hie-panel:        #071525;
                --hie-panel2:       #0A1E30;
                --hie-borde:        #0E2D45;
                --hie-borde2:       #164060;
                --hie-acento:       #4DAACC;
                --hie-acento2:      #7DCFEA;
                --hie-cristal:      #B8E8F5;
                --hie-texto:        #DCF0F8;
                --hie-texto2:       rgba(184,232,245,0.45);
                --hie-texto3:       rgba(184,232,245,0.2);
                --hie-escarcha:     rgba(184,232,245,0.06);
                --cobre-suave:      #C87A2C;
                --transicion:       0.2s ease;
                --polar-positivo:   #FFB347;
                --polar-negativo:   #6DC4F0;
            }

            /* ══ MODO DÍA (TEMA CLARO PARA LA COCINA FRÍA) ══ */
            body.dia {
                --hie-fondo:        #E8F0F5;
                --hie-panel:        #F5F8FC;
                --hie-panel2:       #EDF3F8;
                --hie-borde:        #B8CCDA;
                --hie-borde2:       #99B8CC;
                --hie-acento:       #2C7FA0;
                --hie-acento2:      #3E92B0;
                --hie-cristal:      #1C4050;
                --hie-texto:        #1A2E3A;
                --hie-texto2:       rgba(26,46,58,0.5);
                --hie-texto3:       rgba(26,46,58,0.3);
                --hie-escarcha:     rgba(44,127,160,0.06);
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--hie-fondo);
                color: var(--hie-texto);
                min-height: 100vh;
                position: relative;
                overflow-x: hidden;
                transition: background 0.3s ease, color 0.2s ease;
            }

            body::before {
                content: '';
                position: fixed;
                inset: 0;
                background-image:
                    radial-gradient(ellipse at 20% 10%, rgba(77,170,204,0.07) 0%, transparent 50%),
                    radial-gradient(ellipse at 80% 90%, rgba(77,170,204,0.05) 0%, transparent 45%),
                    url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><path fill="rgba(77,170,204,0.04)" d="M20,20 L30,18 L28,28 Z M70,70 L80,68 L78,78 Z M45,45 L55,43 L53,53 Z"/></svg>');
                background-repeat: repeat, repeat, repeat;
                background-size: auto, auto, 60px 60px;
                pointer-events: none;
                z-index: 0;
            }

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
                    rgba(77,170,204,0.4) 20%,
                    rgba(125,207,234,0.6) 50%,
                    rgba(77,170,204,0.4) 80%,
                    transparent
                    );
                pointer-events: none;
                z-index: 1;
            }

            /* ═══ NAVBAR — CONGELADOR MOLECULAR ═══ */
            .navbar {
                background: rgba(4,12,20,0.92);
                border-bottom: 1px solid var(--hie-borde);
                padding: 0 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 64px;
                position: sticky;
                top: 0;
                z-index: 100;
                backdrop-filter: blur(12px);
                flex-wrap: wrap;
                gap: 10px;
                transition: background 0.3s ease, border-color 0.3s ease;
            }
            body.dia .navbar {
                background: rgba(245,248,252,0.92);
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
                color: var(--hie-texto3);
                border: 1px solid transparent;
                padding: 6px 12px;
                border-radius: 5px;
                transition: all var(--transicion);
                letter-spacing: 0.3px;
            }
            .nav-back:hover {
                color: var(--hie-acento2);
                border-color: var(--hie-borde2);
                background: var(--hie-escarcha);
            }
            .sep {
                width: 1px;
                height: 18px;
                background: var(--hie-borde);
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
                color: var(--hie-acento);
                font-weight: 500;
            }
            .nav-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                color: var(--hie-cristal);
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
                background: rgba(77,170,204,0.08);
                border: 1px solid rgba(77,170,204,0.2);
                font-size: 11px;
                color: var(--hie-acento2);
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
                background: var(--hie-acento2);
            }
            .est.off {
                background: rgba(77,170,204,0.12);
            }
            .nav-temp {
                font-family: 'Playfair Display', serif;
                font-size: 0.85rem;
                font-style: italic;
                color: var(--hie-texto3);
            }

            /* ═══ BOTÓN TEMA (integrado en navbar) ═══ */
            .btn-tema {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 400;
                font-family: 'DM Sans', sans-serif;
                letter-spacing: 0.3px;
                color: var(--hie-texto3);
                background: none;
                border: 1px solid var(--hie-borde);
                cursor: pointer;
                transition: all 0.2s;
            }
            .btn-tema svg {
                width: 14px;
                height: 14px;
                fill: currentColor;
                flex-shrink: 0;
            }
            .btn-tema:hover {
                color: var(--hie-acento2);
                border-color: var(--hie-borde2);
                background: var(--hie-escarcha);
            }

            /* ═══ HERO — NEVERA MOLECULAR ═══ */
            .hero {
                position: relative;
                padding: 60px 40px 52px;
                overflow: hidden;
                border-bottom: 1px solid var(--hie-borde);
            }
            .hero::before {
                content: '';
                position: absolute;
                inset: 0;
                background: linear-gradient(180deg, rgba(7,21,37,0) 0%, rgba(4,12,20,0.4) 100%);
                background-color: var(--hie-panel);
            }
            #canvas-hero {
                position: absolute;
                inset: 0;
                width: 100%;
                height: 100%;
                pointer-events: none;
                z-index: 1;
                opacity: 0.5;
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
                color: var(--hie-acento);
                font-weight: 500;
                margin-bottom: 14px;
            }
            .hero-eyebrow::before {
                content: '';
                width: 24px;
                height: 1px;
                background: var(--hie-acento);
            }
            .hero-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 3rem;
                font-weight: 700;
                color: var(--hie-cristal);
                line-height: 1.05;
                margin-bottom: 6px;
                text-shadow: 0 0 40px rgba(77,170,204,0.3);
            }
            .hero-titulo em {
                color: var(--hie-acento2);
                font-style: italic;
            }
            .hero-concepto {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-style: italic;
                color: var(--hie-acento);
                opacity: 0.7;
                margin-bottom: 16px;
            }
            .hero-desc {
                font-size: 13px;
                color: var(--hie-texto2);
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
                font-size: 3.5rem;
                font-weight: 700;
                color: var(--hie-acento2);
                line-height: 1;
            }
            .temp-barra-wrap {
                width: 6px;
                height: 80px;
                background: var(--hie-borde);
                border-radius: 3px;
                overflow: hidden;
                position: relative;
            }
            .temp-barra-fill {
                position: absolute;
                bottom: 0;
                width: 100%;
                height: 25%;
                background: linear-gradient(to top, var(--hie-acento2), var(--hie-acento));
                border-radius: 3px;
                animation: subir 3s ease-in-out infinite alternate;
            }
            @keyframes subir {
                from {
                    height: 20%;
                }
                to   {
                    height: 35%;
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
                border: 1px solid var(--hie-borde);
                border-radius: 5px;
                background: rgba(7,21,37,0.6);
            }

            /* ═══ NAVEGACIÓN STICKY (MEJORA UX) ═══ */
            .scroll-nav {
                display: flex;
                justify-content: center;
                gap: 24px;
                padding: 12px 16px;
                background: var(--hie-panel);
                border-bottom: 1px solid var(--hie-borde);
                position: sticky;
                top: 64px;
                z-index: 90;
                backdrop-filter: blur(8px);
                flex-wrap: wrap;
            }
            .scroll-link {
                font-size: 13px;
                font-weight: 500;
                color: var(--hie-texto2);
                text-decoration: none;
                padding: 6px 12px;
                border-radius: 20px;
                transition: all var(--transicion);
            }
            .scroll-link:hover {
                color: var(--hie-acento2);
                background: var(--hie-escarcha);
            }

            /* ═══ CONTENIDO ═══ */
            .contenido {
                max-width: 860px;
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
                border: 1px solid var(--hie-borde2);
                background: rgba(77,170,204,0.06);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                color: var(--hie-acento);
                flex-shrink: 0;
            }
            .sec-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.05rem;
                font-weight: 700;
                color: var(--hie-cristal);
            }
            .sec-linea {
                flex: 1;
                height: 1px;
                background: var(--hie-borde);
            }
            .sec-bloque {
                background: var(--hie-panel);
                border: 1px solid var(--hie-borde);
                border-radius: 8px;
                overflow: hidden;
                margin-bottom: 44px;
                position: relative;
                transition: background 0.3s ease, border-color 0.3s ease;
            }
            .sec-bloque::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 2px;
                background: linear-gradient(to bottom, transparent, var(--hie-acento) 40%, var(--hie-acento2) 60%, transparent);
                opacity: 0.4;
            }

            /* Canvas responsivo */
            .canvas-wrapper {
                width: 100%;
                aspect-ratio: 1600 / 560;
                background: #030B12;
            }
            #canvas-mol {
                width: 100%;
                height: 100%;
                display: block;
                background: #030B12;
            }
            .anim-pie {
                padding: 14px 22px;
                border-top: 1px solid var(--hie-borde);
                display: flex;
                align-items: center;
                gap: 8px;
                flex-wrap: wrap;
            }
            .ctrl {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                background: none;
                border: 1px solid var(--hie-borde);
                color: var(--hie-texto3);
                padding: 6px 12px;
                border-radius: 5px;
                font-size: 11px;
                cursor: pointer;
                transition: all var(--transicion);
            }
            .ctrl:hover {
                color: var(--hie-acento2);
                border-color: var(--hie-borde2);
                background: var(--hie-escarcha);
            }
            .leyenda {
                margin-left: auto;
                display: flex;
                align-items: center;
                gap: 16px;
                flex-wrap: wrap;
            }
            .ley-item {
                display: flex;
                align-items: center;
                gap: 5px;
                font-size: 10px;
                color: var(--hie-texto3);
            }
            .anim-nota {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 0;
                border-top: 1px solid var(--hie-borde);
            }
            .nota-col {
                padding: 18px 22px;
                border-right: 1px solid var(--hie-borde);
            }
            .nota-col:last-child {
                border-right: none;
            }
            .tooltip-icon {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 16px;
                height: 16px;
                background: rgba(77,170,204,0.2);
                border-radius: 50%;
                font-size: 10px;
                font-weight: bold;
                color: var(--hie-acento2);
                margin-left: 6px;
                cursor: help;
                position: relative;
            }
            .tooltip-icon:hover::after,
            .tooltip-icon:focus::after,
            .tooltip-icon:active::after {
                content: attr(data-tooltip);
                position: absolute;
                bottom: 150%;
                left: 50%;
                transform: translateX(-50%);
                background: #071525;
                color: #B8E8F5;
                font-size: 10px;
                padding: 5px 10px;
                border-radius: 6px;
                white-space: nowrap;
                border: 1px solid var(--hie-borde2);
                z-index: 20;
                font-weight: normal;
                letter-spacing: normal;
            }
            .exp-wrap {
                padding: 24px;
            }
            .exp-intro {
                font-size: 12px;
                color: var(--hie-texto2);
                font-weight: 300;
                margin-bottom: 20px;
                line-height: 1.65;
            }
            .mols-grid {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 20px;
            }
            .mol-chip {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 9px 15px;
                border: 1px solid var(--hie-borde);
                border-radius: 6px;
                background: rgba(3,11,18,0.6);
                cursor: pointer;
                transition: all var(--transicion);
                user-select: none;
            }
            .mol-chip:focus-visible {
                outline: 2px solid var(--hie-acento2);
                outline-offset: 2px;
            }
            .mol-chip:hover {
                border-color: var(--hie-borde2);
                background: var(--hie-escarcha);
                box-shadow: 0 0 8px rgba(125,207,234,0.2);
            }
            .mol-chip.sel {
                border-color: var(--hie-acento);
                background: rgba(77,170,204,0.08);
            }
            .res-panel {
                display: none;
                border: 1px solid var(--hie-borde);
                border-radius: 6px;
                overflow: hidden;
                animation: fadein 0.2s ease;
            }
            .res-panel.vis {
                display: block;
            }
            @keyframes fadein {
                from {
                    opacity: 0;
                    transform: translateY(-4px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .res-franja {
                height: 2px;
            }
            .f-london   {
                background: var(--hie-acento2);
            }
            .f-dipolar  {
                background: var(--cobre-suave);
            }
            .f-inmisc   {
                background: rgba(200,90,0,0.5);
            }
            .res-body {
                padding: 18px 20px;
                background: var(--hie-panel2);
            }
            .res-tipo {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-weight: 700;
                margin-bottom: 8px;
            }
            .t-london  {
                color: var(--hie-acento2);
            }
            .t-dipolar {
                color: var(--cobre-suave);
            }
            .t-inmisc  {
                color: rgba(200,120,80,0.9);
            }
            .res-texto {
                font-size: 12px;
                color: var(--hie-texto2);
                font-weight: 300;
                line-height: 1.75;
                margin-bottom: 14px;
            }
            .res-texto strong {
                color: var(--hie-cristal);
                font-weight: 500;
            }
            .res-footer {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding-top: 12px;
                border-top: 1px solid var(--hie-borde);
                flex-wrap: wrap;
                gap: 10px;
            }
            .btn-limpiar {
                background: none;
                border: 1px solid var(--hie-borde);
                color: var(--hie-texto3);
                padding: 5px 12px;
                border-radius: 5px;
                font-size: 11px;
                cursor: pointer;
                transition: all var(--transicion);
            }
            .btn-limpiar:hover {
                color: var(--hie-cristal);
                border-color: var(--hie-borde2);
            }
            .quiz-wrap {
                padding: 24px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 20px;
                flex-wrap: wrap;
            }
            .btn-quiz {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: var(--hie-acento);
                color: #040C14;
                text-decoration: none;
                padding: 11px 22px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 500;
                transition: background var(--transicion);
                border: none;
                cursor: pointer;
            }
            .btn-quiz:hover {
                background: var(--hie-acento2);
            }

            .ctrl.activo {
                border-color: var(--hie-acento2);
                color: var(--hie-cristal);
                background: rgba(77,170,204,0.15);
                box-shadow: 0 0 4px rgba(125,207,234,0.3);
            }

            /* ═══ TOAST DE LOGRO ═══ */
            #toastLogro {
                position: fixed;
                bottom: 20px;
                left: 50%;
                transform: translateX(-50%);
                background: var(--hie-acento);
                color: #040C14;
                padding: 10px 20px;
                border-radius: 40px;
                font-weight: bold;
                z-index: 200;
                opacity: 0;
                transition: opacity 0.3s ease;
                pointer-events: none;
                font-size: 14px;
                white-space: nowrap;
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            }

            /* ═══ MEJORAS DE CONTRASTE EN MODO DÍA ═══ */
            body.dia .hero-desc,
            body.dia .res-texto,
            body.dia .exp-intro {
                color: rgba(26,46,58,0.75);
            }

            /* ═══ MEJORAS TÁCTILES EN MÓVIL ═══ */
            @media (max-width: 680px) {
                .anim-nota {
                    grid-template-columns: 1fr;
                }
                .nota-col {
                    border-right: none;
                    border-bottom: 1px solid var(--hie-borde);
                }
                .nota-col:last-child {
                    border-bottom: none;
                }
                .navbar {
                    padding: 0 20px;
                }
                .hero {
                    padding: 40px 20px;
                }
                .contenido {
                    padding: 30px 20px 60px;
                }
                .ctrl, .mol-chip, .btn-tema, .nav-back {
                    padding: 8px 16px;
                    font-size: 13px;
                }
                .mols-grid {
                    gap: 12px;
                }
                .scroll-nav {
                    gap: 12px;
                    top: 56px;
                }
                .scroll-link {
                    font-size: 11px;
                    padding: 4px 10px;
                }
                #toastLogro {
                    font-size: 12px;
                    white-space: normal;
                    text-align: center;
                    width: 90%;
                }
            }
        </style>
    </head>
    <body>
        <div style="position:fixed;right:0;top:0;width:2px;height:100%;background:linear-gradient(to bottom,transparent,rgba(77,170,204,0.3) 30%,rgba(125,207,234,0.5) 60%,transparent);z-index:1;pointer-events:none;"></div>

        <nav class="navbar">
            <div class="navbar-izq">
                <a href="${pageContext.request.contextPath}/menu" class="nav-back">
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="currentColor"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                    Volver
                </a>
                <div class="sep"></div>
                <div class="nav-escenario-info">
                    <span class="nav-badge">Escenario 01 ❄️</span>
                    <div class="sep"></div>
                    <span class="nav-nombre">La Cocina Fría 🧊</span>
                </div>
            </div>
            <div class="navbar-der">
                <span class="nav-temp">🧊 −18 °C</span>
                <% if (completado) {%>
                <div class="chip-completado">
                    <div class="chip-dot"></div>
                    Técnica dominada ✅
                </div>
                <div class="estrellas-nav">
                    <div class="est <%= estrellas >= 1 ? "on" : "off"%>"></div>
                    <div class="est <%= estrellas >= 2 ? "on" : "off"%>"></div>
                    <div class="est <%= estrellas >= 3 ? "on" : "off"%>"></div>
                </div>
                <% }%>

                <!-- ══ BOTÓN MODO DÍA / NOCHE ══ -->
                <button class="btn-tema" id="btnTema" onclick="toggleTema()" title="Cambiar modo de color">
                    <svg viewBox="0 0 24 24" id="iconoTema" width="14" height="14">
                    <path id="iconoPath" d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z"/>
                    </svg>
                    <span id="textoTema">Día</span>
                </button>
            </div>
        </nav>

        <div class="hero">
            <canvas id="canvas-hero"></canvas>
            <div class="hero-inner">
                <div class="hero-text">
                    <div class="hero-eyebrow">❄️ Fuerzas intermoleculares · I</div>
                    <h1 class="hero-titulo">La Cocina<br><em>Fría 🧊❄️</em></h1>
                    <p class="hero-concepto">Dispersión de London · Fuerzas de congelación</p>
                    <p class="hero-desc">
                        A temperaturas bajo cero, los aceites, mantecas y moléculas no polares
                        se mueven lentamente. En ese silencio frío, los electrones fluctúan
                        creando atracciones momentáneas — el secreto de la textura de los helados
                        y la fluidez de los aceites en la nevera.
                    </p>
                </div>
                <div class="hero-temp-panel">
                    <div class="termometro">
                        <div class="temp-numero">−18</div>
                        <div class="temp-barra-wrap"><div class="temp-barra-fill"></div></div>
                        <div class="temp-unidad">Grados Celsius · Nevera molecular</div>
                    </div>
                    <div class="pasos-lista">
                        <div class="paso"><div class="paso-n">❄️</div><span class="paso-t">Animación molecular</span></div>
                        <div class="paso"><div class="paso-n">🧪</div><span class="paso-t">Experimento virtual</span></div>
                        <div class="paso"><div class="paso-n">📋</div><span class="paso-t">Quiz de cocina fría</span></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- NAVEGACIÓN STICKY (MEJORA UX) -->
        <div class="scroll-nav">
            <a href="#seccion-anim" class="scroll-link" data-target="seccion-anim">❄️ Fuerzas</a>
            <a href="#seccion-exp" class="scroll-link" data-target="seccion-exp">🧪 Experimenta</a>
            <a href="#seccion-act" class="scroll-link" data-target="seccion-act">🎮 Actividad</a>
        </div>

        <div class="contenido">
            <!-- SECCIÓN 1 — ANIMACIÓN (AGUA vs ACEITE) -->
            <div class="sec-head" id="seccion-anim">
                <div class="sec-num">1</div>
                <span class="sec-titulo">❄️ Interacción molecular — Agua (polar) vs Aceite/Octano (no polar)
                    <span class="tooltip-icon" tabindex="0" role="tooltip" data-tooltip="Modo Polar: moléculas de AGUA con dipolo permanente. Modo No Polar: moléculas de OCTANO (aceite) con fuerzas de London">ⓘ</span>
                </span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque" id="seccion-anim-bloque">
                <div class="canvas-wrapper">
                    <canvas id="canvas-mol" width="1600" height="560"></canvas>
                </div>
                <div class="anim-pie">
                    <button id="btnPausa" class="ctrl" onclick="pausarAnim()">⏸ Pausar</button>
                    <button id="btnReanudar" class="ctrl activo" onclick="reanudarAnim()">▶ Reanudar</button>
                    <button class="ctrl" onclick="reiniciarAnim()">⟳ Reiniciar</button>
                    <button id="btnModoNoPolar" class="ctrl activo">🫒 No polares (Aceite / Octano)</button>
                    <button id="btnModoPolar" class="ctrl">💧 Polares (Agua H₂O)</button>
                    <div class="leyenda" id="leyendaAnim">
                        <div class="ley-item"><div class="ley-dot" style="background:rgba(77,170,204,0.8)"></div>🫒 Octano (no polar)</div>
                        <div class="ley-item"><div class="ley-dot" style="background:rgba(125,207,234,0.6);border-radius:0;width:16px;height:1px;"></div>💨 Atracción de London</div>
                    </div>
                </div>
                <div class="anim-nota" id="animNota">
                    <div class="nota-col">
                        <div class="nota-etq">🫒 Modo No Polar — Aceite / Octano</div>
                        <p class="nota-txt">Moléculas de <strong>octano (C₈H₁₈)</strong>, representante del aceite. No tienen carga permanente. Las líneas cian son las <strong>fuerzas de dispersión de London</strong>, más intensas cuanto más se acercan.</p>
                    </div>
                    <div class="nota-col">
                        <div class="nota-etq">💧 Modo Polar — Agua (H₂O)</div>
                        <p class="nota-txt">Moléculas de <strong>agua</strong> con forma angular y dipolo permanente (δ⁺ en H, δ⁻ en O). Las líneas naranjas representan la <strong>atracción dipolo-dipolo</strong>.</p>
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 2 — EXPERIMENTO MEJORADO -->
            <div class="sec-head" id="seccion-exp">
                <div class="sec-num">2</div>
                <span class="sec-titulo">🧪 Experimento — ¿Se mezclan en la nevera?</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque" id="seccion-exp-bloque">
                <div class="exp-wrap">
                    <p class="exp-intro">🥄 Selecciona dos ingredientes y observa qué fuerzas intermoleculares actúan entre ellos y si forman una mezcla homogénea en frío.</p>
                    <div class="mols-grid" id="molGrid">
                        <div class="mol-chip" role="button" tabindex="0" data-nombre="Aceite de oliva" data-tipo="np">
                            <div class="mol-dot-chip np"></div>
                            <div><div class="mol-chip-nombre">🫒 Aceite de oliva</div><div class="mol-chip-tipo">No polar · Grasa</div></div>
                        </div>
                        <div class="mol-chip" role="button" tabindex="0" data-nombre="Hexano" data-tipo="np">
                            <div class="mol-dot-chip np"></div>
                            <div><div class="mol-chip-nombre">⛽ Hexano</div><div class="mol-chip-tipo">No polar · Disolvente</div></div>
                        </div>
                        <div class="mol-chip" role="button" tabindex="0" data-nombre="Octano" data-tipo="np">
                            <div class="mol-dot-chip np"></div>
                            <div><div class="mol-chip-nombre">🔥 Octano (C₈H₁₈)</div><div class="mol-chip-tipo">No polar · Hidrocarburo</div></div>
                        </div>
                        <div class="mol-chip" role="button" tabindex="0" data-nombre="Agua (H₂O)" data-tipo="po">
                            <div class="mol-dot-chip po"></div>
                            <div><div class="mol-chip-nombre">💧 Agua (H₂O)</div><div class="mol-chip-tipo">Polar · Solvente universal</div></div>
                        </div>
                        <div class="mol-chip" role="button" tabindex="0" data-nombre="Etanol (alcohol)" data-tipo="po">
                            <div class="mol-dot-chip po"></div>
                            <div><div class="mol-chip-nombre">🍸 Etanol</div><div class="mol-chip-tipo">Polar · Alcohol</div></div>
                        </div>
                    </div>
                    <div class="res-panel" id="resPanel">
                        <div class="res-franja" id="resFranja"></div>
                        <div class="res-body">
                            <div class="res-tipo" id="resTipo"></div>
                            <div class="res-texto" id="resTexto"></div>
                            <div class="res-footer">
                                <span class="res-misc" id="resMisc"></span>
                                <button class="btn-limpiar" id="btnLimpiarExp">🧽 Nueva mezcla</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 3 — ACTIVIDAD INTERACTIVA -->
            <div class="sec-head" id="seccion-act">
                <div class="sec-num">3</div>
                <span class="sec-titulo">🧪 Actividad Interactiva — Pon en práctica lo aprendido</span>
                <div class="sec-linea"></div>
            </div>
            <div class="sec-bloque" id="seccion-act-bloque">
                <div class="quiz-wrap">
                    <div>
                        <div class="quiz-titulo">🎮 Actividad de clasificación molecular</div>
                        <p class="quiz-desc">
                            <% if (completado) { %>
                            ✅ ¡Ya completaste este escenario! Puedes volver a practicar para mejorar tu puntuación.
                            <% } else { %>
                            🔬 Arrastra cada elemento a la categoría correcta (Polar o No polar). Completa todas las actividades para obtener tus estrellas.
                            <% }%>
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/actividad?escenario=<%= idEscenario%>" class="btn-quiz" id="btnQuiz">
                        <% if (completado) { %>
                        🔁 Practicar de nuevo
                        <% } else { %>
                        🎮 Comenzar actividad →
                        <% }%>
                    </a>
                </div>
            </div>
        </div>

        <!-- TOAST DE LOGRO -->
        <div id="toastLogro">✨ ¡Escenario completado! +1 estrella</div>

        <script>
            // ========== TOAST AUTOMÁTICO SI YA ESTÁ COMPLETADO ==========
            <% if (completado) { %>
            setTimeout(() => {
                const toast = document.getElementById('toastLogro');
                if (toast) {
                    toast.style.opacity = '1';
                    setTimeout(() => toast.style.opacity = '0', 3000);
                }
            }, 500);
            <% }%>

            // ========== HERO CANVAS (copos de nieve con límite móvil) ==========
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
                const maxParticles = heroWidth < 600 ? 25 : 60;
                heroParticles = Array.from({length: Math.min(maxParticles, Math.floor(heroWidth / 20))}, () => ({
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
                    heroCtx.fillStyle = 'rgba(184,232,245,0.4)';
                    heroCtx.fill();
                });
                requestAnimationFrame(loopHero);
            }
            window.addEventListener('resize', () => {
                resizeHero();
            });
            resizeHero();
            loopHero();

            // ========== CANVAS MOLECULAR: AGUA (POLAR) vs OCTANO / ACEITE (NO POLAR) ==========
            const canvasMol = document.getElementById('canvas-mol');
            const ctxm = canvasMol.getContext('2d');
            let CW = canvasMol.width, CH = canvasMol.height;
            let corriendoAnim = true;
            let animId = null;
            let modoPolar = false;      // false = No polar (Octano/Aceite), true = Polar (Agua)

            let mols = [];

            function generarMols(modo) {
                const numMols = 16;
                const nuevos = [];
                for (let i = 0; i < numMols; i++) {
                    nuevos.push({
                        x: Math.random() * (CW - 100) + 50,
                        y: Math.random() * (CH - 80) + 40,
                        vx: (Math.random() - 0.5) * (modo ? 0.7 : 0.9),
                        vy: (Math.random() - 0.5) * (modo ? 0.7 : 0.9),
                        r: 28 + Math.random() * 8,
                        fase: Math.random() * Math.PI * 2,
                        polar: modo,
                        angulo: Math.random() * Math.PI * 2,
                        velocidadAngular: (Math.random() - 0.5) * 0.02
                    });
                }
                return nuevos;
            }

            function reiniciarMolsSegunModo() {
                mols = generarMols(modoPolar);
            }

            reiniciarMolsSegunModo();

            const cristalesFondo = Array.from({length: 22}, () => ({
                    x: Math.random() * CW, y: Math.random() * CH, sz: 18 + Math.random() * 32, rot: Math.random() * Math.PI, op: 0.03 + Math.random() * 0.05
                }));

            function dibujarCristal(x, y, sz, rot, op) {
                ctxm.save();
                ctxm.translate(x, y);
                ctxm.rotate(rot);
                ctxm.strokeStyle = `rgba(77,170,204,${op})`;
                ctxm.lineWidth = 0.8;
                for (let i = 0; i < 6; i++) {
                    ctxm.save();
                    ctxm.rotate(i * Math.PI / 3);
                    ctxm.beginPath();
                    ctxm.moveTo(0, 0);
                    ctxm.lineTo(0, -sz);
                    ctxm.moveTo(0, -sz * 0.38);
                    ctxm.lineTo(sz * 0.22, -sz * 0.58);
                    ctxm.moveTo(0, -sz * 0.38);
                    ctxm.lineTo(-sz * 0.22, -sz * 0.58);
                    ctxm.moveTo(0, -sz * 0.62);
                    ctxm.lineTo(sz * 0.14, -sz * 0.76);
                    ctxm.moveTo(0, -sz * 0.62);
                    ctxm.lineTo(-sz * 0.14, -sz * 0.76);
                    ctxm.stroke();
                    ctxm.restore();
                }
                ctxm.restore();
            }

            function dibujarAgua(m, tiempo) {
                const cx = m.x, cy = m.y, rad = m.r;
                let ang = m.angulo;
                const dH = rad * 0.7;
                const anguloH1 = ang - 0.8;
                const anguloH2 = ang + 0.8;
                const hx1 = cx + Math.cos(anguloH1) * dH;
                const hy1 = cy + Math.sin(anguloH1) * dH;
                const hx2 = cx + Math.cos(anguloH2) * dH;
                const hy2 = cy + Math.sin(anguloH2) * dH;
                ctxm.beginPath();
                ctxm.arc(cx, cy, rad * 0.55, 0, Math.PI * 2);
                ctxm.fillStyle = '#6DC4F0';
                ctxm.fill();
                ctxm.strokeStyle = '#2A7FA8';
                ctxm.lineWidth = 1.2;
                ctxm.stroke();
                ctxm.beginPath();
                ctxm.arc(hx1, hy1, rad * 0.25, 0, Math.PI * 2);
                ctxm.fillStyle = '#D0F0FF';
                ctxm.fill();
                ctxm.beginPath();
                ctxm.arc(hx2, hy2, rad * 0.25, 0, Math.PI * 2);
                ctxm.fill();
                ctxm.beginPath();
                ctxm.moveTo(cx, cy);
                ctxm.lineTo(hx1, hy1);
                ctxm.moveTo(cx, cy);
                ctxm.lineTo(hx2, hy2);
                ctxm.strokeStyle = 'rgba(255,255,255,0.7)';
                ctxm.lineWidth = 1.5;
                ctxm.stroke();
                ctxm.font = 'bold 11px "DM Sans", sans-serif';
                ctxm.fillStyle = '#FFB347';
                ctxm.fillText('δ⁺', hx1 - 8, hy1 - 4);
                ctxm.fillText('δ⁺', hx2 - 8, hy2 - 4);
                ctxm.fillStyle = '#FF8C42';
                ctxm.fillText('δ⁻', cx + 5, cy - 8);
                ctxm.font = 'bold 10px "DM Sans", sans-serif';
                ctxm.fillStyle = 'rgba(255,255,210,0.9)';
                ctxm.fillText('H₂O', cx - 12, cy - rad * 0.6);
            }

            function dibujarOctano(m, tiempo) {
                const cx = m.x, cy = m.y, rad = m.r;
                const grad = ctxm.createLinearGradient(cx - rad * 0.4, cy - rad * 0.4, cx + rad * 0.5, cy + rad * 0.5);
                grad.addColorStop(0, '#C0E0E8');
                grad.addColorStop(0.5, '#8DBCCF');
                grad.addColorStop(1, '#4A7C8F');
                ctxm.beginPath();
                ctxm.arc(cx, cy, rad * 0.75, 0, Math.PI * 2);
                ctxm.fillStyle = grad;
                ctxm.fill();
                ctxm.strokeStyle = '#1E4A60';
                ctxm.lineWidth = 1;
                ctxm.stroke();
                ctxm.save();
                ctxm.beginPath();
                ctxm.arc(cx, cy, rad * 0.55, 0, Math.PI * 2);
                ctxm.clip();
                for (let i = 0; i < 6; i++) {
                    const angle = (i / 6) * Math.PI * 2 + m.angulo;
                    const x1 = cx + Math.cos(angle) * rad * 0.3;
                    const y1 = cy + Math.sin(angle) * rad * 0.3;
                    const x2 = cx + Math.cos(angle + 0.6) * rad * 0.6;
                    const y2 = cy + Math.sin(angle + 0.6) * rad * 0.6;
                    ctxm.beginPath();
                    ctxm.moveTo(x1, y1);
                    ctxm.lineTo(x2, y2);
                    ctxm.strokeStyle = 'rgba(0,30,40,0.4)';
                    ctxm.lineWidth = 1.2;
                    ctxm.stroke();
                }
                ctxm.restore();
                ctxm.font = 'bold 9px "DM Sans", sans-serif';
                ctxm.fillStyle = '#E6F7FF';
                ctxm.fillText('C₈H₁₈', cx - 14, cy - rad * 0.5);
                ctxm.font = 'italic 9px "DM Sans", sans-serif';
                ctxm.fillStyle = '#B0E0F0';
                ctxm.fillText('aceite', cx - 10, cy + rad * 0.5);
            }

            function dibujarMolecula(m, tiempo) {
                if (m.polar) {
                    dibujarAgua(m, tiempo);
                } else {
                    dibujarOctano(m, tiempo);
                }
            }

            function dibujarInteracciones() {
                for (let i = 0; i < mols.length; i++) {
                    for (let j = i + 1; j < mols.length; j++) {
                        const dx = mols[j].x - mols[i].x, dy = mols[j].y - mols[i].y, d = Math.hypot(dx, dy);
                        const umbral = 140;
                        if (d < umbral) {
                            let intensidad = (1 - d / umbral) * 0.65;
                            if (!modoPolar) {
                                ctxm.beginPath();
                                ctxm.moveTo(mols[i].x, mols[i].y);
                                ctxm.lineTo(mols[j].x, mols[j].y);
                                ctxm.strokeStyle = `rgba(125,207,234,${intensidad})`;
                                ctxm.lineWidth = 0.9;
                                ctxm.setLineDash([4, 5]);
                                ctxm.stroke();
                                ctxm.setLineDash([]);
                            } else {
                                const angI = mols[i].angulo, angJ = mols[j].angulo;
                                const dirI = {x: Math.cos(angI), y: Math.sin(angI)};
                                const dirJ = {x: Math.cos(angJ), y: Math.sin(angJ)};
                                const dot = dirI.x * dirJ.x + dirI.y * dirJ.y;
                                const factorAlin = Math.abs(dot) * 0.5 + 0.5;
                                ctxm.beginPath();
                                ctxm.moveTo(mols[i].x, mols[i].y);
                                ctxm.lineTo(mols[j].x, mols[j].y);
                                ctxm.strokeStyle = `rgba(200,134,10,${intensidad * factorAlin})`;
                                ctxm.lineWidth = 1.3;
                                ctxm.setLineDash([5, 4]);
                                ctxm.stroke();
                                ctxm.setLineDash([]);
                            }
                        }
                    }
                }
            }

            function dibujarMolsCompleto() {
                if (!ctxm)
                    return;
                ctxm.clearRect(0, 0, CW, CH);
                ctxm.fillStyle = '#030A10';
                ctxm.fillRect(0, 0, CW, CH);
                const grad = ctxm.createLinearGradient(0, 0, 0, 60);
                grad.addColorStop(0, 'rgba(77,170,204,0.08)');
                grad.addColorStop(1, 'transparent');
                ctxm.fillStyle = grad;
                ctxm.fillRect(0, 0, CW, 60);
                cristalesFondo.forEach(c => dibujarCristal(c.x, c.y, c.sz, c.rot, c.op));
                dibujarInteracciones();
                const tiempoSin = Date.now() / 800;
                for (let m of mols) {
                    dibujarMolecula(m, tiempoSin);
                }
                ctxm.font = '10px "DM Sans", sans-serif';
                ctxm.fillStyle = 'rgba(77,170,204,0.25)';
                ctxm.fillText(`❄️ ${modoPolar ? 'MODO POLAR: Moléculas de AGUA (H₂O) · Dipolo-dipolo' : 'MODO NO POLAR: Moléculas de OCTANO / ACEITE · Dispersión de London'}`, 16, CH - 12);
            }

            function moverMols() {
                mols.forEach(m => {
                    m.x += m.vx;
                    m.y += m.vy;
                    m.angulo += m.velocidadAngular;
                    const rEfectivo = m.r * 0.8;
                    if (m.x - rEfectivo < 0) {
                        m.x = rEfectivo;
                        m.vx *= -0.96;
                    }
                    if (m.x + rEfectivo > CW) {
                        m.x = CW - rEfectivo;
                        m.vx *= -0.96;
                    }
                    if (m.y - rEfectivo < 0) {
                        m.y = rEfectivo;
                        m.vy *= -0.96;
                    }
                    if (m.y + rEfectivo > CH) {
                        m.y = CH - rEfectivo;
                        m.vy *= -0.96;
                    }
                });
            }

            function actualizarLeyendaYNotas() {
                const leyendaDiv = document.getElementById('leyendaAnim');
                const notaDiv = document.getElementById('animNota');
                if (modoPolar) {
                    leyendaDiv.innerHTML = `
                        <div class="ley-item"><div class="ley-dot" style="background:#6DC4F0; width:12px; height:12px; border-radius:50%;"></div>💧 Agua (H₂O) polar</div>
                        <div class="ley-item"><div class="ley-dot" style="background:rgba(200,134,10,0.8);border-radius:0;width:16px;height:2px;"></div>🔗 Atracción dipolo-dipolo</div>
                    `;
                    notaDiv.innerHTML = `
                        <div class="nota-col">
                            <div class="nota-etq">💧 Moléculas polares: AGUA</div>
                            <p class="nota-txt">El agua tiene un <strong>momento dipolar permanente</strong> (δ⁺ en hidrógenos, δ⁻ en oxígeno). Las líneas naranjas representan las <strong>fuerzas dipolo-dipolo</strong>, más direccionales que London.</p>
                        </div>
                        <div class="nota-col">
                            <div class="nota-etq">🍳 Aplicación culinaria</div>
                            <p class="nota-txt">En la cocina fría, el agua (hielo, caldos) interactúa fuertemente consigo misma, afectando texturas y solubilidad de sales y azúcares.</p>
                        </div>
                    `;
                } else {
                    leyendaDiv.innerHTML = `
                        <div class="ley-item"><div class="ley-dot" style="background:rgba(77,170,204,0.8); width:12px; height:12px; border-radius:50%;"></div>🫒 Octano / Aceite (no polar)</div>
                        <div class="ley-item"><div class="ley-dot" style="background:rgba(125,207,234,0.6);border-radius:0;width:16px;height:1px;"></div>💨 Atracción de London</div>
                    `;
                    notaDiv.innerHTML = `
                        <div class="nota-col">
                            <div class="nota-etq">🫒 Moléculas no polares: ACEITE (Octano)</div>
                            <p class="nota-txt">El octano (C₈H₁₈) es un hidrocarburo apolar. Las líneas cian son las <strong>fuerzas de dispersión de London</strong>, más intensas en frío.</p>
                        </div>
                        <div class="nota-col">
                            <div class="nota-etq">🔬 El secreto molecular</div>
                            <p class="nota-txt">La nube electrónica fluctúa generando dipolos instantáneos. Es la fuerza que hace que los aceites sean viscosos en el congelador.</p>
                        </div>
                    `;
                }
            }

            function setModo(polar) {
                if (modoPolar === polar)
                    return;
                modoPolar = polar;
                pausarAnim();
                reiniciarMolsSegunModo();
                actualizarLeyendaYNotas();
                if (corriendoAnim) {
                    reanudarAnim();
                } else {
                    dibujarMolsCompleto();
                }
                document.getElementById('btnModoNoPolar').classList.toggle('activo', !polar);
                document.getElementById('btnModoPolar').classList.toggle('activo', polar);
            }

            function animLoop() {
                if (!corriendoAnim)
                    return;
                moverMols();
                dibujarMolsCompleto();
                animId = requestAnimationFrame(animLoop);
            }

            function pausarAnim() {
                if (!corriendoAnim)
                    return;
                corriendoAnim = false;
                if (animId) {
                    cancelAnimationFrame(animId);
                    animId = null;
                }
                document.getElementById('btnPausa').classList.add('activo');
                document.getElementById('btnReanudar').classList.remove('activo');
            }
            function reanudarAnim() {
                if (corriendoAnim)
                    return;
                corriendoAnim = true;
                animLoop();
                document.getElementById('btnReanudar').classList.add('activo');
                document.getElementById('btnPausa').classList.remove('activo');
            }
            function reiniciarAnim() {
                pausarAnim();
                reiniciarMolsSegunModo();
                reanudarAnim();
            }

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (!entry.isIntersecting && corriendoAnim) {
                        pausarAnim();
                    } else if (entry.isIntersecting && !corriendoAnim && animId === null) {
                        reanudarAnim();
                    }
                });
            }, {threshold: 0.2});
            observer.observe(document.querySelector('.sec-bloque'));

            animLoop();

            document.getElementById('btnModoNoPolar').addEventListener('click', () => setModo(false));
            document.getElementById('btnModoPolar').addEventListener('click', () => setModo(true));

            window.addEventListener('resize', () => {
                const oldCW = CW, oldCH = CH;
                CW = canvasMol.width;
                CH = canvasMol.height;
                if (oldCW !== CW || oldCH !== CH) {
                    const scaleX = CW / oldCW;
                    const scaleY = CH / oldCH;
                    mols.forEach(m => {
                        m.x *= scaleX;
                        m.y *= scaleY;
                        m.r = Math.min(m.r * ((scaleX + scaleY) / 2), 60);
                        if (m.x - m.r < 0)
                            m.x = m.r;
                        if (m.x + m.r > CW)
                            m.x = CW - m.r;
                        if (m.y - m.r < 0)
                            m.y = m.r;
                        if (m.y + m.r > CH)
                            m.y = CH - m.r;
                    });
                    cristalesFondo.forEach(c => {
                        c.x *= scaleX;
                        c.y *= scaleY;
                        c.sz *= (scaleX + scaleY) / 2;
                    });
                    dibujarMolsCompleto();
                }
            });

            // ========== EXPERIMENTO (con mejora anti-duplicado) ==========
            let seleccionados = [];
            const resPanel = document.getElementById('resPanel');
            const resFranja = document.getElementById('resFranja');
            const resTipo = document.getElementById('resTipo');
            const resTexto = document.getElementById('resTexto');
            const resMisc = document.getElementById('resMisc');
            const btnLimpiar = document.getElementById('btnLimpiarExp');

            function actualizarSeleccion(chip, nombre, tipo) {
                const existe = seleccionados.find(s => s.nombre === nombre);
                // No permitir seleccionar el mismo elemento dos veces
                if (existe) {
                    return false;
                }
                if (seleccionados.length >= 2) {
                    limpiarExperimento();
                }
                seleccionados.push({elemento: chip, nombre, tipo});
                chip.classList.add('sel');
                chip.setAttribute('aria-selected', 'true');
                if (seleccionados.length === 2)
                    mostrarResultado();
                return true;
            }

            function mostrarResultado() {
                const [a, b] = seleccionados;
                if (!a || !b)
                    return;
                const am = a.tipo, bm = b.tipo;
                resPanel.classList.add('vis');
                if (am === 'np' && bm === 'np') {
                    resFranja.className = 'res-franja f-london';
                    resTipo.className = 'res-tipo t-london';
                    resTipo.textContent = '❄️ Dispersión de London — Se mezclan en frío';
                    resTexto.innerHTML = `<strong>${a.nombre}</strong> y <strong>${b.nombre}</strong> son ambas no polares (grasas o disolventes). En la cocina fría, las <strong>fuerzas de London</strong> las atraen débilmente pero son suficientes para que sean <strong>miscibles</strong>. Ejemplo: aceite de oliva y octano se mezclan perfectamente.`;
                    resMisc.className = 'res-misc m-si';
                    resMisc.textContent = '🥄 Miscibles — se integran como una vinagreta homogénea';
                } else if (am === 'po' && bm === 'po') {
                    resFranja.className = 'res-franja f-dipolar';
                    resTipo.className = 'res-tipo t-dipolar';
                    resTipo.textContent = '🔗 Dipolo-Dipolo + London — Buena mezcla fría';
                    resTexto.innerHTML = `<strong>${a.nombre}</strong> y <strong>${b.nombre}</strong> son polares. Actúan <strong>fuerzas dipolo-dipolo</strong> (atracción entre cargas parciales) además de London. En frío, el agua y el etanol siguen siendo miscibles, importante en la elaboración de salsas frías.`;
                    resMisc.className = 'res-misc m-si';
                    resMisc.textContent = '🥄 Miscibles — se combinan bien en coctelería molecular';
                } else {
                    const polar = am === 'po' ? a.nombre : b.nombre;
                    const noPolar = am === 'np' ? a.nombre : b.nombre;
                    resFranja.className = 'res-franja f-inmisc';
                    resTipo.className = 'res-tipo t-inmisc';
                    resTipo.textContent = '🧊 Fuerzas incompatibles — No se mezclan';
                    resTexto.innerHTML = `<strong>${polar}</strong> es polar y <strong>${noPolar}</strong> es no polar. Sus fuerzas son incompatibles: las polares se atraen por dipolo-dipolo, las no polares por London. Al igual que el aceite y el agua en una vinagreta, <strong>no forman mezcla homogénea</strong> en frío.`;
                    resMisc.className = 'res-misc m-no';
                    resMisc.textContent = '❌ Inmiscibles — se separan como aceite y agua';
                }
            }

            function limpiarExperimento() {
                seleccionados.forEach(s => {
                    if (s.elemento) {
                        s.elemento.classList.remove('sel');
                        s.elemento.setAttribute('aria-selected', 'false');
                    }
                });
                seleccionados = [];
                resPanel.classList.remove('vis');
            }

            const chips = document.querySelectorAll('.mol-chip');
            chips.forEach(chip => {
                const nombre = chip.getAttribute('data-nombre');
                const tipo = chip.getAttribute('data-tipo');
                chip.setAttribute('aria-selected', 'false');
                chip.addEventListener('click', (e) => {
                    e.preventDefault();
                    actualizarSeleccion(chip, nombre, tipo);
                });
                chip.addEventListener('keydown', (e) => {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        actualizarSeleccion(chip, nombre, tipo);
                    }
                });
            });
            btnLimpiar.addEventListener('click', limpiarExperimento);

            // ========== SPINNER EN BOTÓN QUIZ ==========
            const btnQuiz = document.getElementById('btnQuiz');
            if (btnQuiz) {
                btnQuiz.addEventListener('click', function (e) {
                    const originalText = this.innerHTML;
                    this.innerHTML = '⏳ Cargando...';
                    this.style.opacity = '0.7';
                    setTimeout(() => {
                        // No restaurar si la navegación ya ocurrió (es solo feedback)
                        // pero no interferimos con el href
                    }, 1500);
                });
            }

            // ========== SCROLL SUAVE PARA NAVEGACIÓN ==========
            document.querySelectorAll('.scroll-link').forEach(link => {
                link.addEventListener('click', (e) => {
                    e.preventDefault();
                    const targetId = link.getAttribute('data-target');
                    const targetElement = document.getElementById(targetId);
                    if (targetElement) {
                        targetElement.scrollIntoView({behavior: 'smooth'});
                    }
                });
            });

            // ========== MODO DÍA / NOCHE (con atajo de teclado) ==========
            const CLAVE = 'chefMolecularTema';
            const btnT = document.getElementById('btnTema');
            const icoP = document.getElementById('iconoPath');
            const textoT = document.getElementById('textoTema');

            const LUNA = 'M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9c0-.46-.04-.92-.1-1.36-.98 1.37-2.58 2.26-4.4 2.26-2.98 0-5.4-2.42-5.4-5.4 0-1.81.89-3.42 2.26-4.4-.44-.06-.9-.1-1.36-.1z';
            const SOL = 'M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z';

            function aplicarTema(esDia) {
                if (esDia) {
                    document.body.classList.add('dia');
                    icoP.setAttribute('d', LUNA);
                    textoT.textContent = 'Noche';
                } else {
                    document.body.classList.remove('dia');
                    icoP.setAttribute('d', SOL);
                    textoT.textContent = 'Día';
                }
            }

            function toggleTema() {
                const ahora = document.body.classList.contains('dia');
                const nuevo = !ahora;
                localStorage.setItem(CLAVE, nuevo ? 'dia' : 'noche');
                aplicarTema(nuevo);
            }

            (function () {
                const guardado = localStorage.getItem(CLAVE);
                if (guardado === 'dia')
                    aplicarTema(true);
            })();

            // ========== ATAJOS DE TECLADO ==========
            document.addEventListener('keydown', (e) => {
                if (e.key === 'd' || e.key === 'D') {
                    toggleTema();
                    e.preventDefault();
                }
                if (e.key === ' ' && document.activeElement?.tagName !== 'BUTTON' && document.activeElement?.tagName !== 'A' && document.activeElement?.tagName !== 'INPUT') {
                    if (corriendoAnim)
                        pausarAnim();
                    else
                        reanudarAnim();
                    e.preventDefault();
                }
            });
        </script>
    </body>
</html>