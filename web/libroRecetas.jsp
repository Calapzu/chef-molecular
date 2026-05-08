<%-- 
    Document   : libroRecetas
    Created on : 12/04/2026, 3:59:46 p. m.
    Author     : Usuario
    Modified   : Versión con temática inmersiva de cocina molecular + toggle modo noche/día
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.Receta, java.util.List" %>
<%
    List<Receta> desbloqueadas = (List<Receta>) request.getAttribute("recetasDesbloqueadas");
    List<Receta> bloqueadas = (List<Receta>) request.getAttribute("recetasBloqueadas");
    int totalDesb = desbloqueadas != null ? desbloqueadas.size() : 0;
    int totalBloq = bloqueadas != null ? bloqueadas.size() : 0;
    int total = totalDesb + totalBloq;
    int pct = total > 0 ? (totalDesb * 100 / total) : 0;
    String[] conceptos = {
        "Dispersión de London",
        "Atracciones dipolo-dipolo",
        "Puentes de hidrógeno",
        "Estados de la materia",
        "Propiedades de los líquidos",
        "Presión de vapor y ebullición"
    };
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chef Molecular — Libro de Recetas</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            /* ══ VARIABLES DE MODO ══ */
            :root {
                --body-bg: #0C0702;
                --body-color: #F5ECD7;
                --navbar-bg: #110D06;
                --navbar-border: #2E2010;
                --nav-link-color: rgba(245,236,215,0.5);
                --nav-link-hover: #F5ECD7;
                --nav-link-hover-bg: rgba(255,255,255,0.04);
                --nav-link-hover-border: #2E2010;
                --portada-bg: #110D06;
                --portada-border: #2E2010;
                --portada-marco: rgba(200,122,44,0.25);
                --portada-desc: rgba(245,236,215,0.25);
                --portada-progreso-track: #2E2010;
                --seccion-bg: #110D06;
                --seccion-border: #2E2010;
                --receta-hover: rgba(200,122,44,0.04);
                --receta-borde: #1E1508;
                --item-nombre: #F5ECD7;
                --item-numero: rgba(200,122,44,0.5);
                --item-desc: rgba(245,236,215,0.3);
                --item-subtitulo: rgba(200,122,44,0.7);
                --detalle-etiqueta: rgba(200,122,44,0.55);
                --detalle-contenido: rgba(245,236,215,0.4);
                --detalle-borde: #1E1508;
                --toggle-btn: rgba(200,122,44,0.55);
                --bloq-nombre: rgba(245,236,215,0.2);
                --bloq-numero: rgba(245,236,215,0.08);
                --candado-color: rgba(245,236,215,0.2);
                --candado-txt: rgba(245,236,215,0.2);
                --ornamento-color: rgba(200,122,44,0.2);
                --pie-bg: #110D06;
                --pie-border: #2E2010;
                --pie-color: rgba(245,236,215,0.15);
                --pie-strong: rgba(200,122,44,0.4);
                --vacio-color: rgba(245,236,215,0.25);
                --divisor-trazo: #2E2010;
                --portada-desc-color: rgba(245,236,215,0.25);
                --portada-resta: rgba(200,122,44,0.7);
                --portada-progreso-label: rgba(245,236,215,0.2);
                --seccion-categoria: rgba(200,122,44,0.3);
                --seccion-nombre: #F5ECD7;
                --estrella-off: rgba(212,164,56,0.12);
            }

            /* ══ MODO DÍA ══ */
            body.modo-dia {
                --body-bg: #EDE8DF;
                --body-color: #1C1208;
                --navbar-bg: #FFFFFF;
                --navbar-border: #D8CDB8;
                --nav-link-color: rgba(28,18,8,0.45);
                --nav-link-hover: #1C1208;
                --nav-link-hover-bg: rgba(0,0,0,0.03);
                --nav-link-hover-border: #C8B89A;
                --portada-bg: #FFFFFF;
                --portada-border: #D8CDB8;
                --portada-marco: rgba(200,122,44,0.2);
                --portada-desc: rgba(28,18,8,0.35);
                --portada-progreso-track: #D8CDB8;
                --seccion-bg: #FFFFFF;
                --seccion-border: #D8CDB8;
                --receta-hover: rgba(200,122,44,0.04);
                --receta-borde: #E8DED0;
                --item-nombre: #1C1208;
                --item-numero: rgba(160,90,10,0.6);
                --item-desc: rgba(28,18,8,0.45);
                --item-subtitulo: #A06010;
                --detalle-etiqueta: rgba(160,90,10,0.7);
                --detalle-contenido: rgba(28,18,8,0.55);
                --detalle-borde: #E8DED0;
                --toggle-btn: rgba(160,90,10,0.6);
                --bloq-nombre: rgba(28,18,8,0.2);
                --bloq-numero: rgba(28,18,8,0.1);
                --candado-color: rgba(28,18,8,0.2);
                --candado-txt: rgba(28,18,8,0.3);
                --ornamento-color: rgba(200,122,44,0.25);
                --pie-bg: #FFFFFF;
                --pie-border: #D8CDB8;
                --pie-color: rgba(28,18,8,0.2);
                --pie-strong: rgba(160,90,10,0.6);
                --vacio-color: rgba(28,18,8,0.3);
                --divisor-trazo: #D8CDB8;
                --portada-desc-color: rgba(28,18,8,0.35);
                --portada-resta: #A06010;
                --portada-progreso-label: rgba(28,18,8,0.3);
                --seccion-categoria: rgba(160,90,10,0.4);
                --seccion-nombre: #1C1208;
                --estrella-off: rgba(180,130,20,0.15);
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--body-bg);
                color: var(--body-color);
                min-height: 100vh;
                transition: background 0.4s, color 0.4s;
            }

            /* ═══ NAVBAR ═══ */
            .navbar {
                background: var(--navbar-bg);
                border-bottom: 1px solid var(--navbar-border);
                padding: 0 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 64px;
                position: sticky;
                top: 0;
                z-index: 100;
                transition: background 0.4s, border-color 0.4s;
            }

            .navbar-marca {
                display: flex;
                align-items: center;
                gap: 14px;
            }

            .marca-icono {
                width: 34px;
                height: 34px;
                background: #C87A2C;
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
                color: var(--body-color);
                font-weight: 700;
                letter-spacing: 0.5px;
                transition: color 0.4s;
            }

            .marca-nombre span {
                color: #C87A2C;
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
                color: var(--nav-link-color);
                letter-spacing: 0.3px;
                border: 1px solid transparent;
                transition: all 0.2s;
            }

            .nav-link:hover {
                color: var(--nav-link-hover);
                background: var(--nav-link-hover-bg);
                border-color: var(--nav-link-hover-border);
            }

            .nav-link.activo {
                color: #D4A438;
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
                color: #C87A2C;
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
                color: var(--nav-link-color);
                background: none;
                border: 1px solid var(--navbar-border);
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
                color: var(--nav-link-hover);
                border-color: var(--nav-link-hover-border);
                background: var(--nav-link-hover-bg);
            }

            /* ═══ WRAPPER GENERAL ═══ */
            .pagina {
                max-width: 900px;
                margin: 0 auto;
                padding: 48px 24px 80px;
            }

            /* ═══ PORTADA ═══ */
            .menu-portada {
                text-align: center;
                padding: 56px 40px 48px;
                border: 1px solid var(--portada-border);
                border-radius: 4px;
                background: var(--portada-bg);
                position: relative;
                margin-bottom: 0;
                overflow: hidden;
                transition: background 0.4s, border-color 0.4s;
            }

            .menu-portada::after {
                content: '';
                position: absolute;
                top: -20px;
                right: 10%;
                width: 180px;
                height: 160px;
                background: radial-gradient(circle, rgba(200,122,44,0.08) 0%, transparent 70%);
                filter: blur(20px);
                pointer-events: none;
                animation: vapor 8s ease-in-out infinite;
                z-index: 0;
            }

            @keyframes vapor {
                0%   {
                    transform: translateY(0) scale(1);
                    opacity: 0.2;
                }
                50%  {
                    transform: translateY(-15px) scale(1.2);
                    opacity: 0.5;
                }
                100% {
                    transform: translateY(0) scale(1);
                    opacity: 0.2;
                }
            }

            .menu-portada::before {
                content: '';
                position: absolute;
                inset: 10px;
                border: 1px solid var(--portada-marco);
                border-radius: 2px;
                pointer-events: none;
                z-index: 0;
                transition: border-color 0.4s;
            }

            .portada-ornamento {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 14px;
                margin-bottom: 28px;
                position: relative;
                z-index: 1;
            }

            .ornamento-linea {
                height: 1px;
                width: 60px;
                background: linear-gradient(90deg, transparent, #C87A2C);
            }

            .ornamento-linea.derecha {
                background: linear-gradient(90deg, #C87A2C, transparent);
            }

            .ornamento-centro {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #C87A2C;
                font-size: 13px;
                letter-spacing: 3px;
                text-transform: uppercase;
                font-weight: 300;
            }

            .estrella-svg {
                width: 12px;
                height: 12px;
                clip-path: polygon(50% 0%,61% 35%,98% 35%,68% 57%,79% 91%,50% 70%,21% 91%,32% 57%,2% 35%,39% 35%);
                background: #C87A2C;
                flex-shrink: 0;
            }

            .portada-restaurante {
                font-family: 'Playfair Display', serif;
                font-size: 0.65rem;
                letter-spacing: 5px;
                text-transform: uppercase;
                color: var(--portada-resta);
                font-weight: 400;
                margin-bottom: 14px;
                transition: color 0.4s;
            }

            .portada-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 3rem;
                font-weight: 700;
                color: var(--body-color);
                line-height: 1;
                margin-bottom: 6px;
                transition: color 0.4s;
            }

            .portada-subtitulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.4rem;
                font-style: italic;
                color: #C87A2C;
                font-weight: 400;
                margin-bottom: 28px;
            }

            .portada-divisor {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
                margin-bottom: 22px;
            }

            .divisor-trazo {
                width: 80px;
                height: 1px;
                background: var(--divisor-trazo);
                transition: background 0.4s;
            }

            .divisor-rombo {
                width: 5px;
                height: 5px;
                background: #C87A2C;
                transform: rotate(45deg);
            }

            .portada-desc {
                font-size: 12px;
                color: var(--portada-desc-color);
                font-weight: 300;
                letter-spacing: 1px;
                font-style: italic;
                transition: color 0.4s;
            }

            .portada-progreso {
                margin-top: 32px;
                padding-top: 24px;
                border-top: 1px solid var(--portada-border);
                display: flex;
                align-items: center;
                gap: 16px;
                transition: border-color 0.4s;
            }

            .portada-progreso-label {
                font-size: 10px;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: var(--portada-progreso-label);
                white-space: nowrap;
                transition: color 0.4s;
            }

            .portada-progreso-track {
                flex: 1;
                height: 2px;
                background: var(--portada-progreso-track);
                border-radius: 1px;
                overflow: hidden;
                transition: background 0.4s;
            }

            .portada-progreso-fill {
                height: 100%;
                background: #C87A2C;
                border-radius: 1px;
                transition: width 1s ease;
            }

            .portada-progreso-num {
                font-family: 'Playfair Display', serif;
                font-size: 1.1rem;
                color: #C87A2C;
                font-weight: 700;
                min-width: 36px;
                text-align: right;
            }

            /* ═══ SECCIONES ═══ */
            .menu-seccion {
                background: var(--seccion-bg);
                border: 1px solid var(--seccion-border);
                border-top: none;
                padding: 36px 44px;
                position: relative;
                transition: background 0.4s, border-color 0.4s;
            }

            .menu-seccion:last-child {
                border-radius: 0 0 4px 4px;
            }

            .seccion-head {
                text-align: center;
                margin-bottom: 32px;
            }

            .seccion-categoria {
                font-size: 9px;
                letter-spacing: 4px;
                text-transform: uppercase;
                color: #C87A2C;
                font-weight: 500;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                margin-bottom: 8px;
            }

            .seccion-categoria::before,
            .seccion-categoria::after {
                content: '';
                width: 30px;
                height: 1px;
                background: var(--seccion-categoria);
                transition: background 0.4s;
            }

            .seccion-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--seccion-nombre);
                transition: color 0.4s;
            }

            /* ═══ ÍTEMS DE RECETA ═══ */
            .receta-item {
                padding: 20px 8px;
                border-bottom: 1px solid var(--receta-borde);
                cursor: pointer;
                transition: background 0.2s, border-color 0.4s;
                border-radius: 4px;
                margin: 0 -8px;
                position: relative;
            }

            .receta-item:last-child {
                border-bottom: none;
            }

            .receta-item:hover {
                background: var(--receta-hover);
            }

            .receta-item:not(.bloqueada):hover::before {
                content: '🔥';
                position: absolute;
                left: -18px;
                top: 18px;
                font-size: 14px;
                opacity: 0;
                animation: llamaFlicker 0.3s forwards;
                pointer-events: none;
            }

            @keyframes llamaFlicker {
                0%   {
                    opacity: 0;
                    transform: translateX(-4px);
                }
                100% {
                    opacity: 0.7;
                    transform: translateX(0);
                }
            }

            .receta-item-cabecera {
                display: flex;
                align-items: baseline;
                gap: 0;
                margin-bottom: 6px;
            }

            .item-numero {
                font-family: 'Playfair Display', serif;
                font-size: 0.7rem;
                color: var(--item-numero);
                font-style: italic;
                font-weight: 400;
                min-width: 32px;
                flex-shrink: 0;
                transition: color 0.4s;
            }

            .item-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1.05rem;
                font-weight: 700;
                color: var(--item-nombre);
                flex: 1;
                transition: color 0.4s;
            }

            .item-puntos {
                flex: 1;
                border-bottom: 1px dotted rgba(245,236,215,0.1);
                margin: 0 10px;
                min-width: 30px;
                align-self: center;
                height: 1px;
                position: relative;
                top: -3px;
            }

            body.modo-dia .item-puntos {
                border-bottom-color: rgba(28,18,8,0.1);
            }

            .item-estrellas {
                display: flex;
                gap: 3px;
                align-items: center;
                flex-shrink: 0;
            }

            .estrella-item {
                width: 9px;
                height: 9px;
                clip-path: polygon(50% 0%,61% 35%,98% 35%,68% 57%,79% 91%,50% 70%,21% 91%,32% 57%,2% 35%,39% 35%);
            }

            .estrella-item.on  {
                background: #D4A438;
            }
            .estrella-item.off {
                background: var(--estrella-off);
            }

            .item-subtitulo {
                font-size: 11px;
                font-style: italic;
                color: var(--item-subtitulo);
                font-family: 'Playfair Display', serif;
                font-weight: 400;
                margin-left: 32px;
                margin-bottom: 6px;
                transition: color 0.4s;
            }

            .item-desc {
                font-size: 12px;
                color: var(--item-desc);
                font-weight: 300;
                line-height: 1.6;
                margin-left: 32px;
                transition: color 0.4s;
            }

            .item-detalle {
                display: none;
                margin-left: 32px;
                margin-top: 14px;
                padding-top: 14px;
                border-top: 1px solid var(--detalle-borde);
                transition: border-color 0.4s;
            }

            .item-detalle.visible {
                display: block;
                animation: fadeSlide 0.22s ease;
            }

            @keyframes fadeSlide {
                from {
                    opacity: 0;
                    transform: translateY(-4px);
                }
                to   {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .detalle-col {
                margin-bottom: 12px;
            }

            .detalle-etiqueta {
                font-size: 9px;
                letter-spacing: 2.5px;
                text-transform: uppercase;
                color: var(--detalle-etiqueta);
                font-weight: 500;
                margin-bottom: 5px;
                transition: color 0.4s;
            }

            .detalle-contenido {
                font-size: 12px;
                color: var(--detalle-contenido);
                font-weight: 300;
                line-height: 1.75;
                white-space: pre-line;
                transition: color 0.4s;
            }

            .item-toggle-btn {
                background: none;
                border: none;
                cursor: pointer;
                font-family: 'DM Sans', sans-serif;
                font-size: 10px;
                color: var(--toggle-btn);
                letter-spacing: 1px;
                text-transform: uppercase;
                display: flex;
                align-items: center;
                gap: 6px;
                margin-left: 32px;
                margin-top: 10px;
                padding: 0;
                transition: color 0.2s;
            }

            .item-toggle-btn:hover {
                color: #C87A2C;
            }

            .toggle-chevron {
                width: 8px;
                height: 8px;
                border-right: 1.5px solid currentColor;
                border-bottom: 1.5px solid currentColor;
                transform: rotate(45deg);
                transition: transform 0.2s;
                flex-shrink: 0;
            }

            .toggle-chevron.abierto {
                transform: rotate(-135deg);
            }

            /* ═══ BLOQUEADAS ═══ */
            .receta-item.bloqueada {
                cursor: default;
                opacity: 0.6;
            }

            .receta-item.bloqueada:hover {
                background: none;
            }

            .receta-item.bloqueada .item-nombre {
                color: var(--bloq-nombre);
            }
            .receta-item.bloqueada .item-numero {
                color: var(--bloq-numero);
            }

            .candado-inline {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-size: 10px;
                color: var(--candado-txt);
                font-weight: 300;
                font-style: normal;
                margin-left: 32px;
                transition: color 0.4s;
            }

            .candado-svg {
                width: 9px;
                height: 11px;
                position: relative;
                display: inline-block;
            }

            .candado-cuerpo {
                position: absolute;
                bottom: 0;
                width: 9px;
                height: 7px;
                background: var(--candado-color);
                border-radius: 2px;
                transition: background 0.4s;
            }

            .candado-arco {
                position: absolute;
                top: 0;
                left: 1.5px;
                width: 6px;
                height: 6px;
                border: 1.5px solid var(--candado-color);
                border-bottom: none;
                border-radius: 3px 3px 0 0;
                transition: border-color 0.4s;
            }

            .ornamento-divisor {
                text-align: center;
                padding: 24px 0 0;
                color: var(--ornamento-color);
                font-size: 18px;
                letter-spacing: 10px;
                border-top: 1px solid var(--portada-border);
                transition: color 0.4s, border-color 0.4s;
            }

            .vacio-menu {
                text-align: center;
                padding: 28px;
                color: var(--vacio-color);
                font-size: 13px;
                font-weight: 300;
                font-style: italic;
                font-family: 'Playfair Display', serif;
                transition: color 0.4s;
            }

            .menu-pie {
                background: var(--pie-bg);
                border: 1px solid var(--pie-border);
                border-top: none;
                padding: 24px 44px;
                text-align: center;
                border-radius: 0 0 4px 4px;
                transition: background 0.4s, border-color 0.4s;
            }

            .pie-texto {
                font-family: 'Playfair Display', serif;
                font-size: 11px;
                font-style: italic;
                color: var(--pie-color);
                letter-spacing: 0.5px;
                transition: color 0.4s;
            }

            .pie-texto strong {
                color: var(--pie-strong);
                font-style: normal;
                transition: color 0.4s;
            }
        </style>
    </head>
    <body>

        <!-- ══ NAVBAR COCINA MOLECULAR ══ -->
        <nav class="navbar">
            <div class="navbar-marca">
                <div class="marca-icono">
                    <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 14H9V8h2v8zm4 0h-2V8h2v8z"/></svg>
                </div>
                <span class="marca-nombre">Chef <span>Molecular</span></span>
            </div>
            <div class="navbar-nav">
                <a href="${pageContext.request.contextPath}/menu" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Menú
                </a>
                <a href="${pageContext.request.contextPath}/perfil" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M12 12c2.7 0 4.8-2.1 4.8-4.8S14.7 2.4 12 2.4 7.2 4.5 7.2 7.2 9.3 12 12 12zm0 2.4c-3.2 0-9.6 1.6-9.6 4.8v2.4h19.2v-2.4c0-3.2-6.4-4.8-9.6-4.8z"/></svg>
                    Perfil
                </a>
                <a href="${pageContext.request.contextPath}/libroRecetas" class="nav-link activo">
                    <svg viewBox="0 0 24 24"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 14H7v-2h10v2zm0-4H7v-2h10v2zm0-4H7V6h10v2z"/></svg>
                    Recetas
                </a>
                <a href="${pageContext.request.contextPath}/ranking" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M7 21H3V9h4v12zm7 0h-4V3h4v18zm7 0h-4v-9h4v9z"/></svg>
                    Ranking
                </a>

                <!-- ══ BOTÓN MODO DÍA / NOCHE (integrado en navbar) ══ -->
                <button class="btn-tema" id="btnModo" title="Cambiar entre modo noche y día">
                    <svg viewBox="0 0 24 24" id="iconoTema" width="14" height="14">
                    <path id="iconoPath" d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z"/>
                    </svg>
                    <span id="textoModo">Día</span>
                </button>

                <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-salir">
                    <svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5-5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    Salir
                </a>
            </div>
        </nav>

        <!-- ══ MENÚ COCINA MOLECULAR ══ -->
        <div class="pagina">

            <div class="menu-portada">
                <div class="portada-ornamento">
                    <div class="ornamento-linea"></div>
                    <div class="ornamento-centro">
                        <div class="estrella-svg"></div>
                        <span>Alta Cocina Molecular 🔪</span>
                        <div class="estrella-svg"></div>
                    </div>
                    <div class="ornamento-linea derecha"></div>
                </div>

                <p class="portada-restaurante">Restaurante Molecular · Florencia, Caquetá</p>
                <h1 class="portada-titulo">Carte</h1>
                <p class="portada-subtitulo">des Recettes Moléculaires 🍽️</p>

                <div class="portada-divisor">
                    <div class="divisor-trazo"></div>
                    <div class="divisor-rombo"></div>
                    <div class="divisor-trazo"></div>
                </div>

                <p class="portada-desc">Cada preparación revela un secreto de la materia.<br>Completa los escenarios para desbloquear la colección completa.</p>

                <div class="portada-progreso">
                    <span class="portada-progreso-label">Colección</span>
                    <div class="portada-progreso-track">
                        <div class="portada-progreso-fill" style="width: <%= pct%>%"></div>
                    </div>
                    <span class="portada-progreso-num"><%= totalDesb%>/<%= total%></span>
                </div>
            </div>

            <!-- SECCIÓN: RECETAS DESBLOQUEADAS -->
            <div class="menu-seccion">
                <div class="seccion-head">
                    <div class="seccion-categoria">Recetas desbloqueadas 🧪</div>
                    <h2 class="seccion-nombre">Los Platos de la Colección</h2>
                </div>

                <% if (desbloqueadas == null || desbloqueadas.isEmpty()) { %>
                <p class="vacio-menu">🧂 Completa tu primer escenario para revelar tu primera receta.</p>
                <% } else { %>
                <% int idx = 0;
                    for (Receta r : desbloqueadas) {
                        idx++;%>
                <div class="receta-item" onclick="toggleItem(this)">
                    <div class="receta-item-cabecera">
                        <span class="item-numero">0<%= idx%></span>
                        <span class="item-nombre"><%= r.getNombre()%></span>
                        <span class="item-puntos"></span>
                        <span class="item-estrellas">
                            <span class="estrella-item on"></span>
                            <span class="estrella-item on"></span>
                            <span class="estrella-item on"></span>
                        </span>
                    </div>
                    <div class="item-subtitulo">🍽️ Escenario <%= idx%> · <%= (idx <= conceptos.length) ? conceptos[idx - 1] : "Química molecular"%></div>
                    <p class="item-desc"><%= r.getDescripcion()%></p>

                    <div class="item-detalle">
                        <div class="detalle-col">
                            <div class="detalle-etiqueta">Ingredientes moleculares</div>
                            <p class="detalle-contenido"><%= r.getIngredientes() != null ? r.getIngredientes() : "—"%></p>
                        </div>
                        <div class="detalle-col">
                            <div class="detalle-etiqueta">Preparación 👨‍🍳</div>
                            <p class="detalle-contenido"><%= r.getPasos() != null ? r.getPasos() : "—"%></p>
                        </div>
                    </div>

                    <button class="item-toggle-btn">
                        <span class="toggle-txt">Ver preparación</span>
                        <span class="toggle-chevron"></span>
                    </button>
                </div>
                <% } %>
                <% } %>
            </div>

            <!-- SECCIÓN: RECETAS BLOQUEADAS -->
            <% if (bloqueadas != null && !bloqueadas.isEmpty()) { %>
            <div class="menu-seccion">
                <div class="seccion-head">
                    <div class="seccion-categoria">Por descubrir 🔒</div>
                    <h2 class="seccion-nombre">Preparaciones Reservadas</h2>
                </div>

                <% int bidx = totalDesb;
                    for (Receta r : bloqueadas) {
                        bidx++;%>
                <div class="receta-item bloqueada">
                    <div class="receta-item-cabecera">
                        <span class="item-numero">0<%= bidx%></span>
                        <span class="item-nombre"><%= r.getNombre()%></span>
                        <span class="item-puntos"></span>
                        <span class="item-estrellas">
                            <span class="estrella-item off"></span>
                            <span class="estrella-item off"></span>
                            <span class="estrella-item off"></span>
                        </span>
                    </div>
                    <div class="item-subtitulo" style="color:rgba(245,236,215,0.1)">🔐 Escenario <%= bidx%></div>
                    <span class="candado-inline">
                        <span class="candado-svg">
                            <span class="candado-arco"></span>
                            <span class="candado-cuerpo"></span>
                        </span>
                        Completa el escenario para revelar esta receta
                    </span>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="menu-seccion">
                <div style="text-align:center; padding: 8px 0 4px; display:flex; align-items:center; justify-content:center; gap:14px;">
                    <div style="width:22px;height:22px;border-radius:50%;border:1.5px solid #C87A2C;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                        <div style="width:5px;height:9px;border-right:1.5px solid #C87A2C;border-bottom:1.5px solid #C87A2C;transform:rotate(45deg) translate(-1px,-1px);"></div>
                    </div>
                    <p style="font-family:'Playfair Display',serif;font-size:1rem;color:rgba(245,236,215,0.5);font-style:italic;">
                        🍾 Colección completa. Todas las recetas han sido reveladas.
                    </p>
                </div>
            </div>
            <% }%>

            <!-- PIE DEL MENÚ -->
            <div class="menu-pie">
                <p class="pie-texto">
                    <strong>Chef Molecular</strong> · Universidad de la Amazonia ·
                    Departamento de Química · Florencia, Caquetá
                </p>
            </div>

        </div>

        <script>
            // ── MEDICION JSP ──
            window.addEventListener('load', function () {
                const nav = performance.getEntriesByType('navigation')[0];
                if (nav) {
                    console.log('\n========== MEDICION JSP: Libro de Recetas ==========');
                    console.log('[JSP] Tiempo hasta primer byte: ' + Math.round(nav.responseStart - nav.requestStart) + ' ms');
                    console.log('[JSP] Tiempo respuesta servidor: ' + Math.round(nav.responseEnd - nav.requestStart) + ' ms');
                    console.log('[JSP] Tiempo renderizado página: ' + Math.round(nav.loadEventEnd - nav.responseEnd) + ' ms');
                    console.log('[JSP] Tiempo TOTAL (clic→página lista): ' + Math.round(nav.loadEventEnd - nav.startTime) + ' ms');
                    console.log('=============================================\n');
                }
            });
            // ══ TOGGLE MODO NOCHE/DÍA ══
            const CLAVE = 'chefModo';
            const btn = document.getElementById('btnModo');
            const iconoPath = document.getElementById('iconoPath');
            const textoModo = document.getElementById('textoModo');
            const body = document.body;

            // Icono luna (modo día activo)
            const LUNA = 'M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9c0-.46-.04-.92-.1-1.36-.98 1.37-2.58 2.26-4.4 2.26-2.98 0-5.4-2.42-5.4-5.4 0-1.81.89-3.42 2.26-4.4-.44-.06-.9-.1-1.36-.1z';
            // Icono sol (modo noche activo)
            const SOL = 'M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z';

            function aplicarTema(esDia) {
                if (esDia) {
                    body.classList.add('modo-dia');
                    iconoPath.setAttribute('d', LUNA);
                    textoModo.textContent = 'Noche';
                } else {
                    body.classList.remove('modo-dia');
                    iconoPath.setAttribute('d', SOL);
                    textoModo.textContent = 'Día';
                }
            }

            const modoGuardado = localStorage.getItem(CLAVE);
            if (modoGuardado === 'dia') {
                aplicarTema(true);
            }

            btn.addEventListener('click', function () {
                const esDia = body.classList.contains('modo-dia');
                const nuevoEsDia = !esDia;
                localStorage.setItem(CLAVE, nuevoEsDia ? 'dia' : 'noche');
                aplicarTema(nuevoEsDia);
            });

            // ══ TOGGLE DETALLE DE RECETAS ══
            function toggleItem(item) {
                if (event && event.target.closest('.item-toggle-btn')) {
                    event.stopPropagation();
                }

                if (item.classList.contains('bloqueada'))
                    return;

                const detalle = item.querySelector('.item-detalle');
                const chevron = item.querySelector('.toggle-chevron');
                const txtSpan = item.querySelector('.toggle-txt');
                if (!detalle)
                    return;

                const abierto = detalle.classList.toggle('visible');
                if (chevron)
                    chevron.classList.toggle('abierto', abierto);
                if (txtSpan)
                    txtSpan.textContent = abierto ? 'Ocultar preparación' : 'Ver preparación';
            }

            document.querySelectorAll('.item-toggle-btn').forEach(btn => {
                btn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    const recetaItem = this.closest('.receta-item');
                    if (recetaItem && !recetaItem.classList.contains('bloqueada')) {
                        const detalle = recetaItem.querySelector('.item-detalle');
                        const chevron = this.querySelector('.toggle-chevron');
                        const txtSpan = this.querySelector('.toggle-txt');
                        if (detalle) {
                            const abierto = detalle.classList.toggle('visible');
                            if (chevron)
                                chevron.classList.toggle('abierto', abierto);
                            if (txtSpan)
                                txtSpan.textContent = abierto ? 'Ocultar preparación' : 'Ver preparación';
                        }
                    }
                });
            });
        </script>
    </body>
</html>