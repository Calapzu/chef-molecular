<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.Estudiante, com.chefmolecular.modelo.ProgresoEscenario, java.util.List" %>
<%
    Estudiante est = (Estudiante) session.getAttribute("estudiante");
    List<ProgresoEscenario> progresos = (List<ProgresoEscenario>) request.getAttribute("progresos");
    String rangoTexto = (String) request.getAttribute("rangoTexto");

    int totalEstrellas = est != null ? est.getTotalEstrellas() : 0;

    String[] nombresEscenario = {
        "La Cocina Fría",
        "La Sala de Salsas",
        "El Taller del Merengue",
        "El Horno y el Congelador",
        "El Bar Molecular",
        "La Olla a Presión"
    };
    String[] conceptosEscenario = {
        "Dispersión de London",
        "Atracciones dipolo-dipolo",
        "Puentes de hidrógeno",
        "Estados de la materia",
        "Propiedades de los líquidos",
        "Presión de vapor y ebullición"
    };
    String[] iconosEscenario = {
        "M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z",
        "M20 3H4v10c0 2.21 1.79 4 4 4h6c2.21 0 4-1.79 4-4v-3h2c1.11 0 2-.89 2-2V5c0-1.11-.89-2-2-2zm0 5h-2V5h2v3z",
        "M18.06 22.99h1.66c.84 0 1.53-.64 1.63-1.46L23 5.05h-5V1h-1.97v4.05h-4.97l.3 2.34c1.71.47 3.31 1.32 4.27 2.26 1.44 1.42 2.43 2.89 2.43 5.29v8.05zM1 21.99V21h15.03v.99c0 .55-.45 1-1.01 1H2.01c-.56 0-1.01-.45-1.01-1zm15.03-7c0-4.5-6.72-5.5-8.49-5.5-1.5 0-8.54 1-8.54 5.5v2h17.03v-2z",
        "M17 12h-5v5h5v-5zM16 1v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2h-1V1h-2zm3 18H5V8h14v11z",
        "M20 3H4v10c0 2.21 1.79 4 4 4h6c2.21 0 4-1.79 4-4v-3h2c1.11 0 2-.89 2-2V5c0-1.11-.89-2-2-2zm0 5h-2V5h2v3z",
        "M13.49 5.48c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm-3.6 13.9l1-4.4 2.1 2v6h2v-7.5l-2.1-2 .6-3c1.3 1.5 3.3 2.5 5.5 2.5v-2c-1.9 0-3.5-1-4.3-2.4l-1-1.6c-.4-.6-1-1-1.7-1-.3 0-.5.1-.8.1l-5.2 2.2v4.7h2v-3.4l1.8-.7-1.6 8.1-4.9-1-.4 2 7 1.4z"
    };
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chef Molecular — Cocinas del Chef</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            /* ═══ VARIABLES DE TEMA ═══ */
            :root {
                --bg-base:    #0C0702;
                --bg-panel:   #110D06;
                --border:     #2E2010;
                --border-in:  #1E1508;
                --text-ppal:  #F5ECD7;
                --text-dim:   rgba(245,236,215,0.3);
                --text-muted: rgba(245,236,215,0.2);
                --text-nav:   rgba(245,236,215,0.5);
                --cobre:      #C87A2C;
                --dorado:     #D4A438;
                --card-num:   rgba(200,122,44,0.12);
                --grid-line:  #1E1508;
            }

            body.dia {
                --bg-base:    #F2EBD9;
                --bg-panel:   #FBF6ED;
                --border:     #D5C4A1;
                --border-in:  #E8DCBF;
                --text-ppal:  #1E1208;
                --text-dim:   rgba(30,18,8,0.45);
                --text-muted: rgba(30,18,8,0.35);
                --text-nav:   rgba(30,18,8,0.55);
                --cobre:      #9B5515;
                --dorado:     #8A6A00;
                --card-num:   rgba(155,85,21,0.10);
                --grid-line:  #D5C4A1;
            }

            /* Transición suave global */
            body, .navbar, .hero, .escenario-card,
            .progreso-total, .chef-rango, .card-div,
            .seccion-linea, .progreso-track {
                transition: background 0.3s ease, border-color 0.3s ease, color 0.2s ease;
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--bg-base);
                color: var(--text-ppal);
                min-height: 100vh;
            }

            /* ═══ NAVBAR ═══ */
            .navbar {
                background: var(--bg-panel);
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
                color: var(--text-ppal);
                font-weight: 700;
                letter-spacing: 0.5px;
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
                font-weight: 400;
                color: var(--text-nav);
                letter-spacing: 0.3px;
                border: 1px solid transparent;
                transition: all 0.2s;
            }
            .nav-link:hover {
                color: var(--text-ppal);
                background: rgba(128,80,20,0.06);
                border-color: var(--border);
            }
            .nav-link.activo {
                color: var(--dorado);
                border-color: rgba(212,164,56,0.25);
                background: rgba(212,164,56,0.05);
            }
            .nav-link svg {
                width: 14px;
                height: 14px;
                fill: currentColor;
                flex-shrink: 0;
            }
            .nav-salir {
                color: rgba(200,122,44,0.7);
                border-color: rgba(200,122,44,0.2);
            }
            .nav-salir:hover {
                color: var(--cobre);
                background: rgba(200,122,44,0.06);
                border-color: rgba(200,122,44,0.4);
            }

            /* ═══ BOTÓN TEMA (integrado en navbar) ═══ */
            .btn-tema {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 7px 14px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 400;
                font-family: 'DM Sans', sans-serif;
                letter-spacing: 0.3px;
                color: var(--text-nav);
                background: none;
                border: 1px solid var(--border);
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
                color: var(--dorado);
                border-color: rgba(212,164,56,0.35);
                background: rgba(212,164,56,0.06);
            }

            /* ═══ HERO ═══ */
            .hero {
                background: var(--bg-panel);
                border-bottom: 1px solid var(--border);
                padding: 48px 40px 40px;
                position: relative;
                overflow: hidden;
            }
            .hero::before {
                content: '';
                position: absolute;
                inset: 0;
                background-image:
                    linear-gradient(var(--grid-line) 1px, transparent 1px),
                    linear-gradient(90deg, var(--grid-line) 1px, transparent 1px);
                background-size: 52px 52px;
                opacity: 0.45;
            }
            .hero::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 15%;
                width: 300px;
                height: 200px;
                background: radial-gradient(circle, rgba(200,122,44,0.08) 0%, transparent 70%);
                filter: blur(30px);
                pointer-events: none;
                animation: vaporHero 12s ease-in-out infinite;
            }
            @keyframes vaporHero {
                0%   {
                    transform: translateY(0) scale(1);
                    opacity: 0.2;
                }
                50%  {
                    transform: translateY(-30px) scale(1.3);
                    opacity: 0.5;
                }
                100% {
                    transform: translateY(0) scale(1);
                    opacity: 0.2;
                }
            }
            .hero-inner {
                position: relative;
                z-index: 2;
                max-width: 1100px;
                margin: 0 auto;
                display: flex;
                align-items: flex-end;
                justify-content: space-between;
                gap: 32px;
            }
            .hero-texto {
                flex: 1;
            }
            .hero-eyebrow {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 10px;
                letter-spacing: 3px;
                text-transform: uppercase;
                color: var(--cobre);
                font-weight: 500;
                margin-bottom: 12px;
            }
            .hero-eyebrow::before {
                content: '';
                width: 20px;
                height: 1px;
                background: var(--cobre);
            }
            .hero-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2.4rem;
                font-weight: 700;
                color: var(--text-ppal);
                line-height: 1.1;
                margin-bottom: 8px;
            }
            .hero-titulo em {
                color: var(--cobre);
                font-style: italic;
            }
            .hero-sub {
                font-size: 13px;
                color: var(--text-dim);
                font-weight: 300;
                line-height: 1.6;
                max-width: 380px;
            }
            .hero-chef {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                gap: 10px;
                flex-shrink: 0;
            }
            .chef-rango {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 16px;
                background: rgba(200,122,44,0.07);
                border: 1px solid rgba(200,122,44,0.18);
                border-radius: 6px;
            }
            .rango-icono {
                width: 28px;
                height: 28px;
                border-radius: 50%;
                background: rgba(200,122,44,0.12);
                border: 1px solid rgba(200,122,44,0.25);
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .rango-icono svg {
                width: 14px;
                height: 14px;
                fill: var(--cobre);
            }
            .rango-info {
                text-align: right;
            }
            .rango-label {
                font-size: 9px;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: rgba(200,122,44,0.5);
                display: block;
                margin-bottom: 2px;
            }
            .rango-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 0.95rem;
                color: var(--dorado);
                font-weight: 700;
            }
            .chef-estrellas {
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .estrellas-num {
                font-family: 'Playfair Display', serif;
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--dorado);
                line-height: 1;
            }
            .estrellas-fila {
                display: flex;
                flex-direction: column;
                gap: 2px;
            }
            .estrellas-label {
                font-size: 9px;
                letter-spacing: 1.5px;
                text-transform: uppercase;
                color: var(--text-muted);
            }
            .estrellas-dots {
                display: flex;
                gap: 3px;
            }
            .dot-estrella {
                width: 8px;
                height: 8px;
                clip-path: polygon(50% 0%,61% 35%,98% 35%,68% 57%,79% 91%,50% 70%,21% 91%,32% 57%,2% 35%,39% 35%);
                background: var(--dorado);
            }

            /* ═══ CONTENIDO ═══ */
            .contenido {
                max-width: 1100px;
                margin: 0 auto;
                padding: 48px 40px 80px;
            }
            .seccion-head {
                display: flex;
                align-items: center;
                gap: 16px;
                margin-bottom: 28px;
            }
            .seccion-eyebrow {
                font-size: 9px;
                letter-spacing: 3px;
                text-transform: uppercase;
                color: var(--text-muted);
                font-weight: 500;
            }
            .seccion-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.15rem;
                font-weight: 700;
                color: var(--text-ppal);
            }
            .seccion-linea {
                flex: 1;
                height: 1px;
                background: var(--border);
            }

            /* ═══ GRID DE ESCENARIOS ═══ */
            .escenarios-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 16px;
            }
            .escenario-card {
                background: var(--bg-panel);
                border: 1px solid var(--border);
                border-radius: 6px;
                overflow: hidden;
                text-decoration: none;
                color: inherit;
                display: block;
                transition: border-color 0.25s, transform 0.25s, background 0.3s;
                position: relative;
            }
            .escenario-card.desbloqueado:hover::before {
                content: '🔥';
                position: absolute;
                top: -8px;
                left: 12px;
                font-size: 18px;
                opacity: 0;
                animation: llamaCard 0.3s forwards;
                pointer-events: none;
                z-index: 2;
            }
            @keyframes llamaCard {
                0%   {
                    opacity: 0;
                    transform: translateY(4px) scale(0.8);
                }
                100% {
                    opacity: 0.9;
                    transform: translateY(0) scale(1);
                }
            }
            .escenario-card.desbloqueado:hover {
                border-color: rgba(200,122,44,0.45);
                transform: translateY(-3px);
            }
            .escenario-card.bloqueado {
                opacity: 0.45;
                cursor: default;
                pointer-events: none;
            }
            .card-franja {
                height: 3px;
                background: var(--cobre);
            }
            .escenario-card.bloqueado .card-franja {
                background: var(--border);
            }
            .card-cuerpo {
                padding: 20px 22px;
            }
            .card-header {
                display: flex;
                align-items: flex-start;
                justify-content: space-between;
                margin-bottom: 14px;
            }
            .card-num {
                font-family: 'Playfair Display', serif;
                font-size: 2.2rem;
                font-weight: 700;
                color: var(--card-num);
                line-height: 1;
            }
            .card-icono {
                width: 32px;
                height: 32px;
                border-radius: 6px;
                background: rgba(200,122,44,0.08);
                border: 1px solid rgba(200,122,44,0.14);
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
            }
            .card-icono svg {
                width: 15px;
                height: 15px;
                fill: rgba(200,122,44,0.6);
            }
            .escenario-card.bloqueado .card-icono {
                background: rgba(128,80,20,0.04);
                border-color: var(--border);
            }
            .escenario-card.bloqueado .card-icono svg {
                fill: var(--text-muted);
            }
            .card-concepto {
                font-size: 9px;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: rgba(200,122,44,0.6);
                font-weight: 500;
                margin-bottom: 5px;
            }
            .escenario-card.bloqueado .card-concepto {
                color: var(--text-muted);
            }
            .card-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-weight: 700;
                color: var(--text-ppal);
                line-height: 1.25;
                margin-bottom: 14px;
            }
            .escenario-card.bloqueado .card-nombre {
                color: var(--text-muted);
            }
            .card-div {
                height: 1px;
                background: var(--border-in);
                margin-bottom: 14px;
            }
            .card-footer {
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .card-estrellas {
                display: flex;
                gap: 3px;
            }
            .estrella-card {
                width: 9px;
                height: 9px;
                clip-path: polygon(50% 0%,61% 35%,98% 35%,68% 57%,79% 91%,50% 70%,21% 91%,32% 57%,2% 35%,39% 35%);
            }
            .estrella-card.on  {
                background: var(--dorado);
            }
            .estrella-card.off {
                background: rgba(212,164,56,0.12);
            }
            .card-estado {
                font-size: 10px;
                font-weight: 400;
                letter-spacing: 0.3px;
                padding: 3px 9px;
                border-radius: 100px;
            }
            .estado-completado {
                background: rgba(74,222,128,0.07);
                color: rgba(74,222,128,0.7);
                border: 1px solid rgba(74,222,128,0.15);
            }
            .estado-disponible {
                background: rgba(200,122,44,0.07);
                color: rgba(200,122,44,0.7);
                border: 1px solid rgba(200,122,44,0.15);
            }
            .estado-bloqueado {
                background: rgba(128,80,20,0.04);
                color: var(--text-muted);
                border: 1px solid var(--border-in);
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .candado-mini {
                position: relative;
                width: 8px;
                height: 7px;
                background: var(--text-muted);
                border-radius: 1.5px;
                display: inline-block;
            }
            .candado-mini::before {
                content: '';
                position: absolute;
                top: -4px;
                left: 50%;
                transform: translateX(-50%);
                width: 6px;
                height: 5px;
                border: 1.5px solid var(--text-muted);
                border-bottom: none;
                border-radius: 3px 3px 0 0;
            }

            /* ═══ BARRA DE PROGRESO ═══ */
            .progreso-total {
                margin-top: 40px;
                padding: 24px 28px;
                background: var(--bg-panel);
                border: 1px solid var(--border);
                border-radius: 6px;
                display: flex;
                align-items: center;
                gap: 24px;
            }
            .progreso-texto {
                flex: 1;
            }
            .progreso-titulo {
                font-size: 10px;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: var(--text-muted);
                margin-bottom: 8px;
            }
            .progreso-track {
                height: 3px;
                background: var(--border);
                border-radius: 2px;
                overflow: hidden;
            }
            .progreso-fill {
                height: 100%;
                background: var(--cobre);
                border-radius: 2px;
                transition: width 1s ease;
            }
            .progreso-num {
                font-family: 'Playfair Display', serif;
                font-size: 1.6rem;
                font-weight: 700;
                color: var(--text-muted);
                white-space: nowrap;
            }
            .progreso-num span {
                color: var(--cobre);
            }
        </style>
    </head>
    <body>

        <!-- ══ NAVBAR ══ -->
        <nav class="navbar">
            <div class="navbar-marca">
                <div class="marca-icono">
                    <svg viewBox="0 0 24 24"><path d="M18.06 22.99h1.66c.84 0 1.53-.64 1.63-1.46L23 5.05h-5V1h-1.97v4.05h-4.97l.3 2.34c1.71.47 3.31 1.32 4.27 2.26 1.44 1.42 2.43 2.89 2.43 5.29v8.05zM1 21.99V21h15.03v.99c0 .55-.45 1-1.01 1H2.01c-.56 0-1.01-.45-1.01-1zm15.03-7c0-4.5-6.72-5.5-8.49-5.5-1.5 0-8.54 1-8.54 5.5v2h17.03v-2z"/></svg>
                </div>
                <span class="marca-nombre">Chef <span>Molecular</span></span>
            </div>
            <div class="navbar-nav">
                <a href="${pageContext.request.contextPath}/menu" class="nav-link activo">
                    <svg viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Menú
                </a>
                <a href="${pageContext.request.contextPath}/perfil" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M12 12c2.7 0 4.8-2.1 4.8-4.8S14.7 2.4 12 2.4 7.2 4.5 7.2 7.2 9.3 12 12 12zm0 2.4c-3.2 0-9.6 1.6-9.6 4.8v2.4h19.2v-2.4c0-3.2-6.4-4.8-9.6-4.8z"/></svg>
                    Perfil
                </a>
                <a href="${pageContext.request.contextPath}/libroRecetas" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 14H7v-2h10v2zm0-4H7v-2h10v2zm0-4H7V6h10v2z"/></svg>
                    Recetas
                </a>
                <a href="${pageContext.request.contextPath}/ranking" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M7 21H3V9h4v12zm7 0h-4V3h4v18zm7 0h-4v-9h4v9z"/></svg>
                    Ranking
                </a>

                <!-- ══ BOTÓN MODO DÍA / NOCHE ══ -->
                <button class="btn-tema" id="btnTema" onclick="toggleTema()" title="Cambiar modo de color">
                    <svg viewBox="0 0 24 24" id="iconoTema">
                    <!-- Sol (modo noche activo → click lleva a día) -->
                    <path id="iconoPath" d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z"/>
                    </svg>
                    <span id="textoTema">Día</span>
                </button>

                <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-salir">
                    <svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5-5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    Salir
                </a>
            </div>
        </nav>

        <!-- ══ HERO ══ -->
        <div class="hero">
            <div class="hero-inner">
                <div class="hero-texto">
                    <div class="hero-eyebrow">🍽️ Cocinas del Chef</div>
                    <h1 class="hero-titulo">Bienvenido,<br><em><%= est != null ? est.getNombreCompleto() : "Chef"%></em></h1>
                    <!--<p style="color:red; background:white;">
                        ID estudiante: <%= est != null ? est.getIdEstudiante() : "no hay sesión"%><br/>
                        Progresos: <%= progresos != null ? progresos.size() : "null"%>
                    </p>-->
                    <p class="hero-sub">Selecciona un escenario para continuar tu formación. Cada cocina guarda un secreto molecular 🔥</p>
                </div>
                <div class="hero-chef">
                    <div class="chef-rango">
                        <div class="rango-icono">
                            <svg viewBox="0 0 24 24"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z"/></svg>
                        </div>
                        <div class="rango-info">
                            <span class="rango-label">Rango culinario</span>
                            <span class="rango-nombre"><%= rangoTexto != null ? rangoTexto : "Aprendiz"%></span>
                        </div>
                    </div>
                    <div class="chef-estrellas">
                        <span class="estrellas-num"><%= totalEstrellas%></span>
                        <div class="estrellas-fila">
                            <span class="estrellas-label">Estrellas Michelín</span>
                            <div class="estrellas-dots">
                                <div class="dot-estrella"></div>
                                <div class="dot-estrella"></div>
                                <div class="dot-estrella"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ══ CONTENIDO: ESCENARIOS ══ -->
        <div class="contenido">

            <div class="seccion-head">
                <span class="seccion-eyebrow">🧂 Las seis cocinas</span>
                <span class="seccion-titulo">El menú de escenarios</span>
                <div class="seccion-linea"></div>
            </div>

            <div class="escenarios-grid">
                <%
                    if (progresos != null) {
                        for (int i = 0; i < progresos.size(); i++) {
                            ProgresoEscenario p = progresos.get(i);
                            boolean des = p.isDesbloqueado();
                            boolean comp = p.isCompletado();
                            int orden = p.getOrdenEscenario();
                            int idxArr = orden - 1;
                            String nombreMostrar = (idxArr >= 0 && idxArr < nombresEscenario.length)
                                    ? nombresEscenario[idxArr] : p.getNombreEscenario();
                            String conceptoMostrar = (idxArr >= 0 && idxArr < conceptosEscenario.length)
                                    ? conceptosEscenario[idxArr] : "";
                            String iconoPath = (idxArr >= 0 && idxArr < iconosEscenario.length)
                                    ? iconosEscenario[idxArr] : iconosEscenario[0];
                            int estrellas = p.getEstrellas();
                %>
                <% if (des) {%>
                <a class="escenario-card desbloqueado"
                   href="${pageContext.request.contextPath}/escenario?id=<%= p.getIdEscenario()%>">
                    <% } else { %>
                    <div class="escenario-card bloqueado">
                        <% }%>

                        <div class="card-franja"></div>
                        <div class="card-cuerpo">
                            <div class="card-header">
                                <span class="card-num">0<%= orden%></span>
                                <div class="card-icono">
                                    <svg viewBox="0 0 24 24"><path d="<%= iconoPath%>"/></svg>
                                </div>
                            </div>
                            <div class="card-concepto"><%= conceptoMostrar%></div>
                            <div class="card-nombre"><%= nombreMostrar%></div>
                            <div class="card-div"></div>
                            <div class="card-footer">
                                <div class="card-estrellas">
                                    <div class="estrella-card <%= estrellas >= 1 ? "on" : "off"%>"></div>
                                    <div class="estrella-card <%= estrellas >= 2 ? "on" : "off"%>"></div>
                                    <div class="estrella-card <%= estrellas >= 3 ? "on" : "off"%>"></div>
                                </div>
                                <% if (!des) { %>
                                <span class="card-estado estado-bloqueado">
                                    <span class="candado-mini"></span>
                                    Bloqueado
                                </span>
                                <% } else if (comp) { %>
                                <span class="card-estado estado-completado">Completado ✅</span>
                                <% } else { %>
                                <span class="card-estado estado-disponible">Disponible 🔥</span>
                                <% } %>
                            </div>
                        </div>

                    <% if (des) { %></a><% } else { %></div><% } %>
                    <%
                            }
                        }
                    %>
        </div>

        <%
            int completados = 0;
            int totalEsc = progresos != null ? progresos.size() : 6;
            if (progresos != null) {
                for (ProgresoEscenario p : progresos) {
                    if (p.isCompletado()) {
                        completados++;
                    }
                }
            }
            int pctProgreso = totalEsc > 0 ? (completados * 100 / totalEsc) : 0;
        %>
        <div class="progreso-total">
            <div class="progreso-texto">
                <div class="progreso-titulo">🧑‍🍳 Progreso general del restaurante</div>
                <div class="progreso-track">
                    <div class="progreso-fill" style="width: <%= pctProgreso%>%"></div>
                </div>
            </div>
            <div class="progreso-num"><span><%= completados%></span>/<%= totalEsc%></div>
        </div>

    </div>

    <!-- ══ SCRIPT MODO DÍA / NOCHE ══ -->
    <script>
        // ── MEDICION JSP ──
        window.addEventListener('load', function () {
            const nav = performance.getEntriesByType('navigation')[0];
            if (nav) {
                console.log('\n========== MEDICION JSP: Menú ==========');
                console.log('[JSP] Tiempo hasta primer byte: ' + Math.round(nav.responseStart - nav.requestStart) + ' ms');
                console.log('[JSP] Tiempo respuesta servidor: ' + Math.round(nav.responseEnd - nav.requestStart) + ' ms');
                console.log('[JSP] Tiempo renderizado página: ' + Math.round(nav.loadEventEnd - nav.responseEnd) + ' ms');
                console.log('[JSP] Tiempo TOTAL (clic→página lista): ' + Math.round(nav.loadEventEnd - nav.startTime) + ' ms');
                console.log('=============================================\n');
            }
        });
        const CLAVE = 'chefMolecularTema';
        const btnT = document.getElementById('btnTema');
        const icoP = document.getElementById('iconoPath');
        const textoT = document.getElementById('textoTema');

        /* Icono luna  — se muestra cuando el modo DÍA está activo (clic → volver a noche) */
        const LUNA = 'M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9c0-.46-.04-.92-.1-1.36-' +
                '.98 1.37-2.58 2.26-4.4 2.26-2.98 0-5.4-2.42-5.4-5.4 0-1.81.89-3.42 2.26-4.4-.44-.06-.9-.1-1.36-.1z';

        /* Icono sol — se muestra cuando el modo NOCHE está activo (clic → ir a día) */
        const SOL = 'M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5z' +
                'M2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1z' +
                'm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1z' +
                'M11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1z' +
                'm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1z' +
                'M5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58z' +
                'm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06z' +
                'm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z' +
                'M7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z';

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

        /* Cargar preferencia guardada al iniciar la página */
        (function () {
            const guardado = localStorage.getItem(CLAVE);
            if (guardado === 'dia')
                aplicarTema(true);
        })();
    </script>

</body>
</html>