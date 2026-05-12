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
        <title>Chef Molecular — Bar Molecular · Coctelería de vanguardia 🍸</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500;700;800&display=swap" rel="stylesheet">
        <style>
            /* ============================================
               ESTILOS BASE (mantenidos y mejorados)
            ============================================ */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            :root {
                --neon-pink: #F64B8A;
                --neon-gold: #FFB347;
                --bg-dark: #0A0A0F;
                --texto: #F5F5F5;
                --texto2: #C0C7D0;
                --focus-ring: 0 0 0 3px rgba(246,75,138,0.5);
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--bg-dark);
                color: var(--texto);
                min-height: 100vh;
                background-image: radial-gradient(circle at 10% 20%, rgba(255,70,120,0.08) 2%, transparent 2.5%),
                    radial-gradient(circle at 90% 80%, rgba(255,180,70,0.06) 1.5%, transparent 2%);
                background-size: 40px 40px, 35px 35px;
            }

            /* Elementos decorativos fijos (ocultables en móvil) */
            .sidebar-neon {
                position: fixed;
                left: 0;
                top: 0;
                width: 3px;
                height: 100%;
                background: linear-gradient(to bottom, transparent, var(--neon-pink), var(--neon-gold), var(--neon-pink), transparent);
                opacity: 0.8;
                pointer-events: none;
                z-index: 10;
            }

            .navbar {
                background: #11111A;
                backdrop-filter: blur(10px);
                border-bottom: 2px solid var(--neon-pink);
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
                box-shadow: 0 4px 20px rgba(0,0,0,0.5);
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
                font-size: 0.8rem;
                background: rgba(246,75,138,0.2);
                padding: 6px 12px;
                border-radius: 40px;
                color: var(--neon-pink);
                border: 1px solid var(--neon-pink);
                transition: all 0.2s;
                letter-spacing: 0.3px;
            }
            .nav-back:hover, .nav-back:focus-visible {
                background: var(--neon-pink);
                color: var(--bg-dark);
                transform: translateY(-1px);
                outline: none;
                box-shadow: var(--focus-ring);
            }

            .sep {
                width: 1px;
                height: 24px;
                background: rgba(246,75,138,0.4);
            }
            .nav-escenario-info {
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: wrap;
            }
            .nav-badge {
                font-size: 0.75rem;
                letter-spacing: 3px;
                text-transform: uppercase;
                color: var(--neon-gold);
                font-weight: 500;
            }
            .nav-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-weight: 700;
                color: var(--neon-gold); /* fallback */
                background: linear-gradient(135deg, var(--neon-pink), var(--neon-gold));
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
            }
            .navbar-der {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            /* SCROLL NAV */
            .scroll-nav {
                display: flex; justify-content: center; gap: 16px;
                padding: 10px 16px; background: var(--panel-color);
                border-bottom: 1px solid var(--borde-color);
                position: sticky; top: 64px; z-index: 90;
                backdrop-filter: blur(8px); flex-wrap: wrap;
                box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            }
            .scroll-link { font-size: 13px; font-weight: 500; color: var(--texto2-color); text-decoration: none; padding: 6px 14px; border-radius: 20px; transition: all var(--transicion); }
            .scroll-link:hover, .scroll-link.activo { color: var(--acento2-color); background: var(--escarcha-color); }

            .chip-completado {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 5px 12px;
                border-radius: 100px;
                background: rgba(246,75,138,0.2);
                border: 1px solid rgba(246,75,138,0.5);
                font-size: 0.75rem;
                color: var(--neon-pink);
            }
            .estrellas-nav {
                display: flex;
                gap: 3px;
            }
            .est {
                width: 10px;
                height: 10px;
                clip-path: polygon(50% 0%,61% 35%,98% 35%,68% 57%,79% 91%,50% 70%,21% 91%,32% 57%,2% 35%,39% 35%);
            }
            .est.on {
                background: var(--neon-pink);
            }
            .est.off {
                background: rgba(246,75,138,0.3);
            }
            .nav-temp {
                font-family: 'Playfair Display', serif;
                font-size: 0.9rem;
                font-style: italic;
                color: var(--neon-gold);
            }

            /* Hero */
            .hero {
                position: relative;
                padding: 60px 40px 52px;
                overflow: hidden;
                border-bottom: 1px solid rgba(246,75,138,0.3);
                background: rgba(10,10,15,0.7);
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
                font-size: 0.75rem;
                letter-spacing: 4px;
                text-transform: uppercase;
                color: var(--neon-pink);
                font-weight: 500;
                margin-bottom: 14px;
            }
            .hero-eyebrow::before {
                content: '';
                width: 24px;
                height: 1px;
                background: var(--neon-gold);
            }
            .hero-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2.8rem;
                font-weight: 700;
                color: var(--neon-gold);
                background: linear-gradient(135deg, var(--neon-pink), var(--neon-gold));
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
                line-height: 1.05;
                margin-bottom: 6px;
                text-shadow: 0 0 20px rgba(246,75,138,0.3);
            }
            .hero-titulo em {
                font-style: italic;
            }
            .hero-concepto {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-style: italic;
                color: var(--neon-gold);
                opacity: 0.9;
                margin-bottom: 16px;
            }
            .hero-desc {
                font-size: 0.85rem;
                color: var(--texto2);
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
                color: var(--neon-gold);
                background: linear-gradient(135deg, var(--neon-pink), var(--neon-gold));
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
            }
            .temp-barra-wrap {
                width: 6px;
                height: 80px;
                background: #2A2A3A;
                border-radius: 3px;
                overflow: hidden;
                position: relative;
            }
            .temp-barra-fill {
                position: absolute;
                bottom: 0;
                width: 100%;
                height: 70%;
                background: linear-gradient(to top, var(--neon-pink), var(--neon-gold));
                border-radius: 3px;
                animation: subirCoctel 4s ease-in-out infinite alternate;
            }
            @keyframes subirCoctel {
                from {
                    height: 30%;
                    opacity: 0.7;
                }
                to {
                    height: 80%;
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
                border: 1px solid rgba(246,75,138,0.3);
                border-radius: 5px;
                background: rgba(0,0,0,0.3);
                backdrop-filter: blur(4px);
                font-size: 0.85rem;
            }

            /* Contenido principal */
            .contenido {
                max-width: 1200px;
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
                width: 26px;
                height: 26px;
                border-radius: 50%;
                border: 1px solid var(--neon-pink);
                background: rgba(246,75,138,0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.75rem;
                color: var(--neon-gold);
                flex-shrink: 0;
            }
            .sec-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.1rem;
                font-weight: 700;
                color: var(--texto);
            }
            .sec-linea {
                flex: 1;
                height: 1px;
                background: rgba(246,75,138,0.3);
            }
            .sec-bloque {
                background: rgba(20, 20, 30, 0.8);
                backdrop-filter: blur(8px);
                border: 1px solid rgba(246,75,138,0.3);
                border-radius: 8px;
                overflow: visible;
                margin-bottom: 44px;
                position: relative;
                box-shadow: 0 8px 24px rgba(0,0,0,0.3);
            }
            .sec-bloque::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 2px;
                background: linear-gradient(to bottom, transparent, var(--neon-pink) 40%, var(--neon-gold) 60%, transparent);
                opacity: 0.8;
                border-radius: 2px;
            }

            /* Tarjetas técnicas */
            .tecnicas-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 28px;
                padding: 20px;
            }
            .tecnica-card {
                background: rgba(20, 20, 30, 0.8);
                backdrop-filter: blur(4px);
                border-radius: 32px;
                padding: 24px 16px;
                text-align: center;
                border: 1px solid rgba(246,75,138,0.3);
                box-shadow: 0 10px 25px rgba(0,0,0,0.3);
                transition: all 0.3s;
                position: relative;
                overflow: hidden;
            }
            .tecnica-card::before {
                content: "";
                position: absolute;
                top: -50%;
                left: -20%;
                width: 140%;
                height: 140%;
                background: radial-gradient(circle at 30% 20%, rgba(255,180,70,0.15), transparent 70%);
                pointer-events: none;
            }
            .tecnica-card:hover {
                transform: translateY(-8px);
                border-color: var(--neon-pink);
                box-shadow: 0 15px 30px rgba(246,75,138,0.2);
            }
            .tecnica-card h3 {
                font-size: 1.3rem;
                margin-bottom: 12px;
                color: var(--neon-gold);
            }
            .canvas-mol {
                background: #0D0D14;
                border-radius: 28px;
                margin: 16px auto;
                display: block;
                width: 100%;
                max-width: 220px;
                height: auto;
                box-shadow: inset 0 0 8px rgba(0,0,0,0.5), 0 4px 12px rgba(0,0,0,0.2);
            }
            .tecnica-card p {
                font-size: 0.85rem;
                color: var(--texto2);
                line-height: 1.4;
            }

            /* Drag & Drop */
            .drag-section {
                background: rgba(20, 15, 18, 0.92);
                backdrop-filter: blur(8px);
                border-radius: 48px;
                padding: 28px;
                margin: 0 20px 20px;
                border: 1px solid rgba(255,180,70,0.3);
                box-shadow: 0 8px 24px rgba(0,0,0,0.4), inset 0 1px 0 rgba(255,255,255,0.05);
                background-image: repeating-linear-gradient(45deg, rgba(255,180,70,0.03) 0px, rgba(255,180,70,0.03) 2px, transparent 2px, transparent 8px);
            }
            .drag-section h2 {
                font-size: 1.5rem;
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 6px;
                color: var(--neon-gold);
            }
            .drag-section h2:before {
                content: "🍸";
                font-size: 2rem;
            }
            .sub {
                color: var(--texto2);
                font-size: 0.85rem;
                margin-bottom: 24px;
                border-left: 3px solid var(--neon-pink);
                padding-left: 12px;
            }

            .ingredientes-pool {
                display: flex;
                flex-wrap: wrap;
                gap: 14px;
                background: #0A0A10;
                border-radius: 60px;
                padding: 20px 24px;
                margin-bottom: 28px;
                border: 1px solid #2A2A3A;
            }
            .ingrediente {
                background: linear-gradient(135deg, #2C2C3A, #1E1E2A);
                padding: 10px 22px;
                border-radius: 60px;
                font-size: 0.85rem;
                font-weight: 600;
                cursor: grab;
                user-select: none;
                transition: all 0.2s;
                border-left: 4px solid var(--neon-pink);
                color: #F0F0F0;
                box-shadow: 0 2px 6px rgba(0,0,0,0.3);
                position: relative;
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .ingrediente::before {
                content: "✋";
                font-size: 0.8rem;
                opacity: 0.7;
            }
            .ingrediente:active {
                cursor: grabbing;
            }
            .ingrediente:hover, .ingrediente:focus-visible {
                transform: scale(1.02);
                background: #3A3A4A;
                outline: none;
                box-shadow: var(--focus-ring);
            }
            .ingrediente[aria-selected="true"] {
                box-shadow: 0 0 0 3px var(--neon-gold);
                border-left-color: var(--neon-gold);
            }

            .zonas-tech {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-bottom: 24px;
            }
            .zona {
                flex: 1;
                min-width: 180px;
                background: #0D0D15;
                border-radius: 32px;
                padding: 18px;
                border: 2px dashed #3A3A50;
                transition: box-shadow 0.2s, border-color 0.2s;
                text-align: center;
                position: relative;
            }
            .zona:focus-within {
                border-color: var(--neon-pink);
            }
            .zona h3 {
                font-size: 0.9rem;
                margin-bottom: 12px;
                padding-bottom: 6px;
                border-bottom: 1px solid rgba(255,180,70,0.4);
                display: inline-block;
            }
            .zona.esferificacion h3 {
                color: var(--neon-pink);
            }
            .zona.emulsion h3 {
                color: var(--neon-gold);
            }
            .zona.gelificacion h3 {
                color: #4BC0C0;
            }
            .zona[dragover="true"] {
                box-shadow: 0 0 18px rgba(246,75,138,0.6), inset 0 0 8px rgba(255,180,70,0.3);
                border-color: var(--neon-pink);
            }
            .contador-zona {
                font-size: 0.7rem;
                color: var(--texto2);
                margin: 4px 0 8px;
            }
            .coctel-glass {
                position: relative;
                width: 70px;
                height: 80px;
                margin: 12px auto;
                background: rgba(255,255,240,0.08);
                border-radius: 0 0 35px 35px;
                border: 2px solid rgba(246,75,138,0.5);
                overflow: hidden;
                cursor: pointer;
                transition: all 0.2s;
            }
            .liquid {
                position: absolute;
                bottom: 0;
                width: 100%;
                background: linear-gradient(180deg, var(--neon-pink), var(--neon-gold));
                transition: height 0.4s cubic-bezier(0.2, 0.9, 0.4, 1.1);
            }
            .glass-overlay {
                position: relative;
                text-align: center;
                line-height: 80px;
                font-size: 2.2rem;
                mix-blend-mode: overlay;
                pointer-events: none;
            }
            .dropzone-inner {
                min-height: 30px;
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                justify-content: center;
                align-items: center;
                padding: 8px 4px;
            }
            .ingrediente.correcto {
                background: linear-gradient(135deg, #1E5631, #2A7A3A);
                border-left-color: #4ADE80;
            }
            .ingrediente.incorrecto {
                background: linear-gradient(135deg, #7A2E3A, #5A1E2A);
                border-left-color: var(--neon-pink);
                text-decoration: line-through;
            }
            .btns {
                display: flex;
                gap: 16px;
                margin-top: 20px;
                justify-content: center;
                flex-wrap: wrap;
            }
            .btn {
                padding: 10px 28px;
                border-radius: 60px;
                font-weight: bold;
                border: none;
                cursor: pointer;
                font-size: 0.85rem;
                transition: 0.2s;
            }
            .btn:focus-visible {
                outline: none;
                box-shadow: var(--focus-ring);
            }
            .btn-pink {
                background: var(--neon-pink);
                color: var(--bg-dark);
                box-shadow: 0 2px 8px rgba(246,75,138,0.4);
            }
            .btn-pink:hover {
                background: #FF6A9F;
                transform: translateY(-2px);
            }
            .btn-outline {
                background: transparent;
                border: 1px solid var(--neon-pink);
                color: var(--neon-pink);
            }
            .btn-outline:hover {
                background: rgba(246,75,138,0.2);
                transform: translateY(-2px);
            }

            .feedback {
                margin-top: 24px;
                background: rgba(0,0,0,0.7);
                backdrop-filter: blur(12px);
                padding: 14px 20px;
                border-radius: 40px;
                display: none;
                text-align: center;
                border-left: 4px solid var(--neon-gold);
                animation: surgirHumo 0.4s ease;
            }
            @keyframes surgirHumo {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                    filter: blur(4px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                    filter: blur(0);
                }
            }

            /* Bloque quiz */
            .quiz-wrap {
                padding: 24px;
            }
            .btn-quiz {
                background: var(--neon-pink);
                color: white;
                padding: 14px 38px;
                border-radius: 60px;
                text-decoration: none;
                font-weight: 800;
                font-size: 1rem;
                display: inline-block;
                transition: 0.2s;
                box-shadow: 0 6px 14px rgba(246,75,138,0.4);
                margin-top: 16px;
            }
            .btn-quiz:hover, .btn-quiz:focus-visible {
                background: #FF6A9F;
                transform: scale(1.02);
                outline: none;
                box-shadow: var(--focus-ring);
            }

            /* Decoraciones fijas (ocultas en móvil) */
            .bar-decor {
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                height: 60px;
                background: repeating-linear-gradient(90deg, #2A2A3A 0px, #2A2A3A 40px, #1E1E2A 40px, #1E1E2A 80px);
                z-index: 0;
                opacity: 0.5;
                pointer-events: none;
            }
            .bar-stools {
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                display: flex;
                justify-content: space-between;
                padding: 0 20px;
                pointer-events: none;
                z-index: 1;
            }
            .stool {
                font-size: 3.5rem;
                opacity: 0.25;
                filter: blur(3px);
                transform: scaleX(-1);
            }
            .neon-line {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 2px;
                background: linear-gradient(90deg, transparent, var(--neon-pink), var(--neon-gold), var(--neon-pink), transparent);
                z-index: 101;
                pointer-events: none;
            }

            footer {
                text-align: center;
                font-size: 0.75rem;
                color: #5A5A70;
                margin: 40px 0 20px;
            }

            /* ========== MEJORAS RESPONSIVE Y ACCESIBILIDAD ========== */
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
                .tecnicas-grid {
                    grid-template-columns: 1fr;
                }
            }
            @media (max-width: 600px) {
                .sidebar-neon, .neon-line, .bar-decor, .bar-stools {
                    display: none;
                }
                .hero-inner {
                    flex-direction: column;
                }
                .ingredientes-pool {
                    border-radius: 30px;
                    padding: 16px;
                }
                .ingrediente {
                    padding: 8px 16px;
                    font-size: 0.8rem;
                }
                .zona {
                    min-width: 140px;
                }
            }

            /* Prefiere reducción de movimiento */
            @media (prefers-reduced-motion: reduce) {
                .temp-barra-fill {
                    animation: none;
                    height: 60%;
                }
                .canvas-mol {
                    animation: none;
                }
                .feedback {
                    animation: none;
                }
            }

            /* Utilidad para lectores de pantalla */
            .sr-only {
                position: absolute;
                width: 1px;
                height: 1px;
                padding: 0;
                margin: -1px;
                overflow: hidden;
                clip: rect(0,0,0,0);
                white-space: nowrap;
                border: 0;
            }
        </style>
    </head>
    <body>
        <div class="neon-line" aria-hidden="true"></div>
        <div class="bar-decor" aria-hidden="true"></div>
        <div class="bar-stools" aria-hidden="true">
            <div class="stool">🪑</div><div class="stool">🪑</div><div class="stool">🪑</div>
        </div>
        <div class="sidebar-neon" aria-hidden="true"></div>

        <nav class="navbar" aria-label="Navegación principal">
            <div class="navbar-izq">
                <a href="${pageContext.request.contextPath}/menu" class="nav-back">
                    <svg viewBox="0 0 24 24" width="13" height="13" fill="currentColor" aria-hidden="true"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                    Volver
                </a>
                <div class="sep" aria-hidden="true"></div>
                <div class="nav-escenario-info">
                    <span class="nav-badge">Escenario 05 🍸</span>
                    <div class="sep" aria-hidden="true"></div>
                    <span class="nav-nombre">Bar Molecular</span>
                </div>
            </div>
            <div class="navbar-der">
                <span class="nav-temp" aria-label="Coctelería de vanguardia">🍹 Coctelería de vanguardia</span>
                <% if (completado) {%>
                <div class="chip-completado">✅ Completado</div>
                <div class="estrellas-nav" aria-label="<%= estrellas%> de 3 estrellas">
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
                    <div class="hero-eyebrow">🥼 Ciencia y sabor · Coctelería molecular</div>
                    <h1 class="hero-titulo">Bar <em>Molecular</em> 🍸</h1>
                    <p class="hero-concepto">Esferificación, emulsiones y gelificaciones</p>
                    <p class="hero-desc">
                        Descubre cómo la ciencia transforma líquidos en caviar, espumas y geles. Arrastra los ingredientes a la técnica adecuada y completa el coctel molecular.
                    </p>
                </div>
                <div class="hero-temp-panel" aria-hidden="true">
                    <div class="termometro">
                        <div class="temp-numero">🍸</div>
                        <div class="temp-barra-wrap"><div class="temp-barra-fill"></div></div>
                        <div class="temp-unidad" style="font-size:0.8rem; color:var(--texto2);">Coctel perfecto</div>
                    </div>
                    <div class="pasos-lista">
                        <div class="paso"><span>🔮</span> Esferificación</div>
                        <div class="paso"><span>🥛</span> Emulsión & Espumas</div>
                        <div class="paso"><span>🍮</span> Gelificación</div>
                    </div>
                </div>
            </div>
        </div>
            
            <!-- NAVEGACIÓN STICKY (MEJORA UX) -->
        <div class="scroll-nav">
            <a href="#seccion-anim" class="scroll-link" data-target="seccion-anim">🔮 Fuerzas</a>
            <a href="#seccion-exp" class="scroll-link" data-target="seccion-exp">🧪 Experimenta</a>
            <a href="#seccion-act" class="scroll-link" data-target="seccion-act">🎮 Actividad</a>
        </div>


        <main class="contenido">
            <!-- SECCIÓN 1: Técnicas moleculares -->
            <section aria-labelledby="sec1-titulo" class="sec-bloque" id="seccion-anim">
                <div class="sec-head">
                    <div class="sec-num" aria-hidden="true">1</div>
                    <span class="sec-titulo" id="sec1-titulo">🍸 Técnicas de coctelería molecular</span>
                    <div class="sec-linea" aria-hidden="true"></div>
                </div>
                <div class="tecnicas-grid">
                    <div class="tecnica-card">
                        <h3>🔮 Esferificación</h3>
                        <canvas id="canvasEsfera" width="200" height="140" class="canvas-mol" role="img" aria-label="Animación de gotas de esferificación"></canvas>
                        <p>Líquido envuelto en una membrana fina.<br>Alginato + calcio → caviar líquido para cocteles.</p>
                    </div>
                    <div class="tecnica-card">
                        <h3>🥛 Emulsión & Espumas</h3>
                        <canvas id="canvasEmulsion" width="200" height="140" class="canvas-mol" role="img" aria-label="Animación de burbujas de emulsión"></canvas>
                        <p>Mezcla de agua y grasa estable.<br>Lecitina de soja → espumas y aires aromáticos.</p>
                    </div>
                    <div class="tecnica-card">
                        <h3>🍮 Gelificación</h3>
                        <canvas id="canvasGel" width="200" height="140" class="canvas-mol" role="img" aria-label="Animación de textura gelificada"></canvas>
                        <p>Líquido a gel termo-irreversible.<br>Agar-agar, gellan gum para texturas sólidas.</p>
                    </div>
                </div>
            </section>

            <!-- SECCIÓN 2: Estación de la barra (drag & drop) -->
            <section aria-labelledby="sec2-titulo" class="sec-bloque" id="seccion-exp">
                <div class="sec-head">
                    <div class="sec-num" aria-hidden="true">2</div>
                    <span class="sec-titulo" id="sec2-titulo">🍹 Clasifica los ingredientes del bar</span>
                    <div class="sec-linea" aria-hidden="true"></div>
                </div>
                <div class="drag-section">
                    <h2 id="drag-title">Clasifica los ingredientes del bar</h2>
                    <div class="sub">Arrastra cada "botella" a la técnica molecular que la utiliza principalmente. <span class="sr-only">También puedes usar los botones táctiles: toca un ingrediente y luego toca una técnica.</span></div>

                    <div class="ingredientes-pool" id="pool-mol" role="listbox" aria-label="Ingredientes disponibles"
                         ondragover="allowDropMol(event)" ondrop="dropPoolMol(event)">
                        <div class="ingrediente" draggable="true" id="ing1" role="option" tabindex="0" aria-grabbed="false"
                             ondragstart="dragMol(event,'ing1')" data-tech="esferificacion"
                             onclick="seleccionarIngrediente('ing1')" onkeydown="handleKeyIng(event, 'ing1')">🧪 Alginato de sodio</div>
                        <div class="ingrediente" draggable="true" id="ing2" role="option" tabindex="0" aria-grabbed="false"
                             ondragstart="dragMol(event,'ing2')" data-tech="esferificacion"
                             onclick="seleccionarIngrediente('ing2')" onkeydown="handleKeyIng(event, 'ing2')">⚖️ Cloruro de calcio</div>
                        <div class="ingrediente" draggable="true" id="ing3" role="option" tabindex="0" aria-grabbed="false"
                             ondragstart="dragMol(event,'ing3')" data-tech="emulsion"
                             onclick="seleccionarIngrediente('ing3')" onkeydown="handleKeyIng(event, 'ing3')">🥚 Lecitina de soja</div>
                        <div class="ingrediente" draggable="true" id="ing4" role="option" tabindex="0" aria-grabbed="false"
                             ondragstart="dragMol(event,'ing4')" data-tech="emulsion"
                             onclick="seleccionarIngrediente('ing4')" onkeydown="handleKeyIng(event, 'ing4')">🍯 Xantana (estabilizante)</div>
                        <div class="ingrediente" draggable="true" id="ing5" role="option" tabindex="0" aria-grabbed="false"
                             ondragstart="dragMol(event,'ing5')" data-tech="gelificacion"
                             onclick="seleccionarIngrediente('ing5')" onkeydown="handleKeyIng(event, 'ing5')">🌿 Agar-agar</div>
                        <div class="ingrediente" draggable="true" id="ing6" role="option" tabindex="0" aria-grabbed="false"
                             ondragstart="dragMol(event,'ing6')" data-tech="gelificacion"
                             onclick="seleccionarIngrediente('ing6')" onkeydown="handleKeyIng(event, 'ing6')">🍮 Goma gelana</div>
                    </div>

                    <div class="zonas-tech">
                        <div class="zona esferificacion" id="zona-esferificacion" role="region" aria-label="Zona de esferificación"
                             ondragover="allowDropMol(event)" ondrop="dropMol(event, 'esferificacion')"
                             tabindex="0" onclick="moverSeleccionadoA('esferificacion')">
                            <h3>🔮 ESFERIFICACIÓN</h3>
                            <div class="contador-zona" id="cont-esferificacion">0/2 ingredientes</div>
                            <div class="coctel-glass" aria-hidden="true">
                                <div id="liquid-esferificacion" class="liquid" style="height: 0%;"></div>
                                <div class="glass-overlay">🍸</div>
                            </div>
                            <div class="dropzone-inner" id="inner-esferificacion"></div>
                        </div>
                        <div class="zona emulsion" id="zona-emulsion" role="region" aria-label="Zona de emulsión"
                             ondragover="allowDropMol(event)" ondrop="dropMol(event, 'emulsion')"
                             tabindex="0" onclick="moverSeleccionadoA('emulsion')">
                            <h3>🥛 EMULSIÓN / ESPUMAS</h3>
                            <div class="contador-zona" id="cont-emulsion">0/2 ingredientes</div>
                            <div class="coctel-glass" aria-hidden="true">
                                <div id="liquid-emulsion" class="liquid" style="height: 0%;"></div>
                                <div class="glass-overlay">🍸</div>
                            </div>
                            <div class="dropzone-inner" id="inner-emulsion"></div>
                        </div>
                        <div class="zona gelificacion" id="zona-gelificacion" role="region" aria-label="Zona de gelificación"
                             ondragover="allowDropMol(event)" ondrop="dropMol(event, 'gelificacion')"
                             tabindex="0" onclick="moverSeleccionadoA('gelificacion')">
                            <h3>🍮 GELIFICACIÓN</h3>
                            <div class="contador-zona" id="cont-gelificacion">0/2 ingredientes</div>
                            <div class="coctel-glass" aria-hidden="true">
                                <div id="liquid-gelificacion" class="liquid" style="height: 0%;"></div>
                                <div class="glass-overlay">🍸</div>
                            </div>
                            <div class="dropzone-inner" id="inner-gelificacion"></div>
                        </div>
                    </div>

                    <div class="btns">
                        <button class="btn btn-pink" onclick="verificarClasificacion()">✔ Verificar coctel</button>
                        <button class="btn btn-outline" onclick="reiniciarClasificacion()">↺ Reiniciar barra</button>
                    </div>
                    <div id="feedback-mol" class="feedback" role="status" aria-live="polite"></div>
                </div>
            </section>

            <!-- SECCIÓN 3 -->
            <section aria-labelledby="sec3-titulo" class="sec-bloque">
                <div class="sec-head" id="seccion-act">
                    <div class="sec-num" aria-hidden="true">3</div>
                    <span class="sec-titulo" id="sec3-titulo">🎮 Actividad de Bar molecular</span>
                    <div class="sec-linea" aria-hidden="true"></div>
                </div>
                <div class="quiz-wrap">
                    <div>
                        <div class="quiz-titulo" style="font-family:'Playfair Display',serif; font-size:1.1rem;">🧪 Clasifica las moléculas polares y no polares</div>
                        <p style="font-size:0.85rem; color: var(--texto2);">
                            <% if (completado) { %>
                            ✅ ¡Ya completaste este escenario! Puedes volver a practicar para mejorar tu puntuación.
                            <% } else { %>
                            🧂 Arrastra cada molécula a la categoría correcta (Polar o No polar). Completa la actividad para obtener tus estrellas.
                            <% }%>
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/actividad?escenario=<%= idEscenario%>" class="btn-quiz">
                        <% if (completado) { %> 🔁 Practicar de nuevo <% } else { %> 🎮 Comenzar actividad → <% }%>
                    </a>
                </div>
            </section>
        </main>

        <footer>© Chef Molecular · Experiencia interactiva</footer>

        <script>
            // ========== DRAG & DROP + ACCESIBILIDAD + MÓVIL ==========

            // Variable para modo táctil/teclado: ingrediente actualmente seleccionado
            let ingredienteSeleccionado = null;

            // ---------- Drag convencional ----------
            function dragMol(e, id) {
                e.dataTransfer.setData('text/plain', id);
                // Limpiar selección táctil si se arrastra
                if (ingredienteSeleccionado) {
                    document.getElementById(ingredienteSeleccionado)?.removeAttribute('aria-selected');
                    ingredienteSeleccionado = null;
                }
            }

            function allowDropMol(e) {
                e.preventDefault();
            }

            // Configurar zonas para drag visual y drops
            document.querySelectorAll('.zona').forEach(zone => {
                zone.addEventListener('dragover', (e) => {
                    e.preventDefault();
                    zone.setAttribute('dragover', 'true');
                });
                zone.addEventListener('dragleave', (e) => {
                    if (!zone.contains(e.relatedTarget)) {
                        zone.removeAttribute('dragover');
                    }
                });
                zone.addEventListener('drop', (e) => {
                    e.preventDefault();
                    zone.removeAttribute('dragover');
                    const dragId = e.dataTransfer.getData('text/plain');
                    const draggedEl = document.getElementById(dragId);
                    if (!draggedEl)
                        return;
                    // Mover siempre a la dropzone-inner de la zona
                    const inner = zone.querySelector('.dropzone-inner');
                    if (inner && draggedEl.parentElement !== inner) {
                        inner.appendChild(draggedEl);
                        draggedEl.classList.remove('correcto', 'incorrecto');
                        aplicarEfectoCoctelera(draggedEl);
                    }
                    actualizarVasos();
                });
            });

            // Pool también acepta drops (devolver ingredientes)
            const pool = document.getElementById('pool-mol');
            pool.addEventListener('dragover', (e) => e.preventDefault());
            pool.addEventListener('drop', (e) => {
                e.preventDefault();
                const dragId = e.dataTransfer.getData('text/plain');
                const draggedEl = document.getElementById(dragId);
                if (draggedEl) {
                    pool.appendChild(draggedEl);
                    draggedEl.classList.remove('correcto', 'incorrecto');
                }
                actualizarVasos();
            });

            // ---------- Selección táctil / teclado ----------
            function seleccionarIngrediente(id) {
                const el = document.getElementById(id);
                if (!el)
                    return;
                // Si ya estaba seleccionado, deseleccionar
                if (ingredienteSeleccionado === id) {
                    el.removeAttribute('aria-selected');
                    ingredienteSeleccionado = null;
                    return;
                }
                // Deseleccionar anterior
                if (ingredienteSeleccionado) {
                    const prev = document.getElementById(ingredienteSeleccionado);
                    if (prev)
                        prev.removeAttribute('aria-selected');
                }
                // Seleccionar nuevo
                el.setAttribute('aria-selected', 'true');
                ingredienteSeleccionado = id;
                // Anunciar selección para lectores de pantalla
                anunciar(`Seleccionado: ${el.textContent.trim()}. Toca una técnica para clasificarlo.`);
            }

            function moverSeleccionadoA(tech) {
                if (!ingredienteSeleccionado) {
                    // Si no hay selección previa, intentar seleccionar el primer ingrediente del pool
                    const primerIng = pool.querySelector('.ingrediente');
                    if (primerIng) {
                        seleccionarIngrediente(primerIng.id);
                    }
                    if (!ingredienteSeleccionado)
                        return; // aún nada
                }
                const el = document.getElementById(ingredienteSeleccionado);
                if (!el)
                    return;
                const zonaId = 'zona-' + tech;
                const zona = document.getElementById(zonaId);
                if (!zona)
                    return;
                const inner = zona.querySelector('.dropzone-inner');
                if (inner && el.parentElement !== inner) {
                    inner.appendChild(el);
                    el.classList.remove('correcto', 'incorrecto');
                    aplicarEfectoCoctelera(el);
                    actualizarVasos();
                    anunciar(`Movido a ${tech}`);
                }
                // Deseleccionar
                el.removeAttribute('aria-selected');
                ingredienteSeleccionado = null;
            }

            function handleKeyIng(event, id) {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    seleccionarIngrediente(id);
                }
            }

            // Anuncio para lectores de pantalla (live region)
            function anunciar(mensaje) {
                const fb = document.getElementById('feedback-mol');
                fb.style.display = 'block';
                fb.textContent = mensaje;
                setTimeout(() => {
                    if (fb.textContent === mensaje) {
                        fb.style.display = 'none';
                    }
                }, 2000);
            }

            // Permitir que las zonas reciban clic y muevan el ingrediente seleccionado
            document.querySelectorAll('.zona').forEach(z => {
                z.addEventListener('click', (e) => {
                    // Si el clic fue en un ingrediente dentro de la zona, no mover
                    if (e.target.classList.contains('ingrediente'))
                        return;
                    const tech = z.id.replace('zona-', '');
                    moverSeleccionadoA(tech);
                });
            });

            // ---------- Efecto coctelera ----------
            function aplicarEfectoCoctelera(el) {
                el.style.transform = 'scale(1.1) rotate(2deg)';
                setTimeout(() => el.style.transform = '', 200);
                const rect = el.getBoundingClientRect();
                const span = document.createElement('span');
                span.textContent = '🥤✨';
                span.setAttribute('aria-hidden', 'true');
                span.style.cssText = `
                    position: fixed;
                    left: ${rect.left + rect.width / 2}px;
                    top: ${rect.top - 20}px;
                    font-size: 1.5rem;
                    pointer-events: none;
                    opacity: 1;
                    transition: opacity 0.4s, transform 0.4s;
                    z-index: 9999;
                `;
                document.body.appendChild(span);
                requestAnimationFrame(() => {
                    span.style.opacity = '0';
                    span.style.transform = 'translateY(-20px)';
                });
                setTimeout(() => span.remove(), 450);
            }

            // ---------- Actualizar vasos y contadores ----------
            function actualizarVasos() {
                const tecnicas = ['esferificacion', 'emulsion', 'gelificacion'];
                const totalPorTech = {};
                document.querySelectorAll('.ingrediente').forEach(ing => {
                    const t = ing.dataset.tech;
                    totalPorTech[t] = (totalPorTech[t] || 0) + 1;
                });

                tecnicas.forEach(tech => {
                    const zona = document.getElementById('zona-' + tech);
                    const inner = zona.querySelector('.dropzone-inner');
                    const ingredientesEnZona = inner.querySelectorAll('.ingrediente');
                    let correctosEnZona = 0;
                    ingredientesEnZona.forEach(ing => {
                        if (ing.dataset.tech === tech)
                            correctosEnZona++;
                    });
                    const esperados = totalPorTech[tech] || 1;
                    const porcentaje = Math.min((correctosEnZona / esperados) * 100, 100);
                    const liquidId = 'liquid-' + tech;
                    const liquidDiv = document.getElementById(liquidId);
                    if (liquidDiv)
                        liquidDiv.style.height = porcentaje + '%';
                    // Actualizar contador
                    const contador = document.getElementById('cont-' + tech);
                    if (contador)
                        contador.textContent = `${correctosEnZona}/${esperados} ingredientes correctos`;
                });
            }

            // ---------- Verificar ----------
            function verificarClasificacion() {
                const ingredientes = document.querySelectorAll('.ingrediente');
                let correctos = 0;
                const total = ingredientes.length;
                ingredientes.forEach(ing => {
                    const techEsperada = ing.dataset.tech;
                    const parentZona = ing.closest('.zona');
                    const zonaId = parentZona ? parentZona.id.replace('zona-', '') : null;
                    const esCorrecto = (zonaId === techEsperada);
                    ing.classList.toggle('correcto', esCorrecto);
                    ing.classList.toggle('incorrecto', !esCorrecto);
                    if (esCorrecto)
                        correctos++;
                });
                actualizarVasos();
                const feedbackDiv = document.getElementById('feedback-mol');
                feedbackDiv.style.display = 'block';
                if (correctos === total) {
                    feedbackDiv.innerHTML = '<span style="color:#4ADE80;">✅ ¡Perfecto! Has armado el bar molecular correctamente. Todos los ingredientes en su técnica adecuada. 🍹✨</span>';
                } else {
                    feedbackDiv.innerHTML = `<span style="color:#FFB347;">⚠️ ${correctos}/${total} ingredientes bien colocados. Revisa los que están en rojo y reubícalos.</span>`;
                }
            }

            function reiniciarClasificacion() {
                document.querySelectorAll('.ingrediente').forEach(ing => {
                    ing.classList.remove('correcto', 'incorrecto');
                    pool.appendChild(ing);
                });
                document.getElementById('feedback-mol').style.display = 'none';
                document.querySelectorAll('.liquid').forEach(l => l.style.height = '0%');
                document.querySelectorAll('.contador-zona').forEach(c => c.textContent = '0/2 ingredientes');
                if (ingredienteSeleccionado) {
                    document.getElementById(ingredienteSeleccionado)?.removeAttribute('aria-selected');
                    ingredienteSeleccionado = null;
                }
            }

            // ========== CANVAS ANIMATIONS con IntersectionObserver y prefers-reduced-motion ==========
            const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

            function iniciarAnimacionesCanvas() {
                if (prefersReducedMotion) {
                    // Dibujar un frame estático y salir
                    dibujarFrameEstatico('canvasEsfera', 'esferificacion');
                    dibujarFrameEstatico('canvasEmulsion', 'emulsion');
                    dibujarFrameEstatico('canvasGel', 'gelificacion');
                    return;
                }
                // Animación normal con observador de visibilidad
                observarCanvas('canvasEsfera', animEsferificacion);
                observarCanvas('canvasEmulsion', animEmulsion);
                observarCanvas('canvasGel', animGel);
            }

            function dibujarFrameEstatico(canvasId, tipo) {
                const canvas = document.getElementById(canvasId);
                if (!canvas)
                    return;
                const ctx = canvas.getContext('2d');
                ctx.clearRect(0, 0, 200, 140);
                ctx.fillStyle = '#0D0D14';
                ctx.fillRect(0, 0, 200, 140);
                if (tipo === 'esferificacion') {
                    ctx.fillStyle = '#F64B8A';
                    ctx.fillRect(0, 70, 200, 70);
                    ctx.beginPath();
                    ctx.arc(60, 40, 10, 0, Math.PI * 2);
                    ctx.fillStyle = '#FFB347';
                    ctx.fill();
                } else if (tipo === 'emulsion') {
                    for (let i = 0; i < 12; i++) {
                        ctx.beginPath();
                        ctx.arc(20 + i * 15, 30 + (i % 3) * 20, 4, 0, Math.PI * 2);
                        ctx.fillStyle = i % 2 === 0 ? '#F64B8A' : '#FFB347';
                        ctx.fill();
                    }
                } else if (tipo === 'gelificacion') {
                    ctx.strokeStyle = '#4BC0C0';
                    ctx.lineWidth = 2;
                    for (let i = 0; i < 8; i++) {
                        let x = 20 + i * 20;
                        ctx.beginPath();
                        ctx.moveTo(x, 40);
                        ctx.lineTo(x + 12, 50);
                        ctx.lineTo(x + 6, 60);
                        ctx.fillStyle = '#5FD9D9';
                        ctx.fill();
                    }
                }
            }

            function observarCanvas(canvasId, animLoop) {
                const canvas = document.getElementById(canvasId);
                if (!canvas)
                    return;
                let animFrameId = null;
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            if (!animFrameId)
                                animLoop(canvas);
                        } else {
                            if (animFrameId) {
                                cancelAnimationFrame(animFrameId);
                                animFrameId = null;
                            }
                        }
                    });
                }, {threshold: 0.1});
                observer.observe(canvas);

                function animLoopFn(c) {
                    function frame() {
                        if (!document.hidden) {
                            animLoop(c);
                        }
                        animFrameId = requestAnimationFrame(frame);
                    }
                    frame();
                }
            }

            function animEsferificacion(canvas) {
                const ctx = canvas.getContext('2d');
                ctx.clearRect(0, 0, 200, 140);
                ctx.fillStyle = '#0D0D15';
                ctx.fillRect(0, 0, 200, 140);
                ctx.fillStyle = '#F64B8A';
                ctx.fillRect(0, 70, 200, 70);
                let y = 40 + Math.sin(Date.now() * 0.005) * 6;
                ctx.beginPath();
                ctx.arc(60, y, 10, 0, Math.PI * 2);
                ctx.fillStyle = '#FFB347';
                ctx.fill();
                for (let i = 0; i < 6; i++) {
                    ctx.beginPath();
                    ctx.arc(130 + i * 11, 95 + Math.sin(Date.now() * 0.003 + i) * 4, 5, 0, Math.PI * 2);
                    ctx.fillStyle = '#FF8C42';
                    ctx.fill();
                }
            }

            function animEmulsion(canvas) {
                const ctx = canvas.getContext('2d');
                ctx.clearRect(0, 0, 200, 140);
                ctx.fillStyle = '#1A1A24';
                ctx.fillRect(0, 0, 200, 140);
                for (let i = 0; i < 22; i++) {
                    let x = 15 + (i * 12 + Date.now() * 0.002) % 170;
                    let y = 25 + (i * 7) % 100;
                    ctx.beginPath();
                    ctx.arc(x, y, 4, 0, Math.PI * 2);
                    ctx.fillStyle = i % 2 === 0 ? '#F64B8A' : '#FFB347';
                    ctx.fill();
                }
            }

            function animGel(canvas) {
                const ctx = canvas.getContext('2d');
                ctx.clearRect(0, 0, 200, 140);
                ctx.fillStyle = '#0F0F18';
                ctx.fillRect(0, 0, 200, 140);
                ctx.strokeStyle = '#4BC0C0';
                ctx.lineWidth = 2;
                for (let i = 0; i < 12; i++) {
                    let x = 20 + (i * 14);
                    let y = 40 + Math.sin(Date.now() * 0.002 + i) * 10;
                    ctx.beginPath();
                    ctx.moveTo(x, y);
                    ctx.lineTo(x + 12, y + 8);
                    ctx.lineTo(x + 6, y + 18);
                    ctx.fillStyle = '#5FD9D9';
                    ctx.fill();
                }
            }

            iniciarAnimacionesCanvas();

            // Inicializar vasos y contadores al cargar
            actualizarVasos();

            // Limpiar selección al hacer clic fuera
            document.addEventListener('click', function (e) {
                if (!e.target.closest('.ingrediente') && !e.target.closest('.zona')) {
                    if (ingredienteSeleccionado) {
                        document.getElementById(ingredienteSeleccionado)?.removeAttribute('aria-selected');
                        ingredienteSeleccionado = null;
                    }
                }
            });
        </script>
    </body>
</html>