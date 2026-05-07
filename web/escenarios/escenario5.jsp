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
           ESTILOS ORIGINALES DEL ESCENARIO 5 (BAR MOLECULAR)
           Solo se reorganiza la estructura HTML
        ============================================ */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: #0A0A0F;
            color: #F5F5F5;
            min-height: 100vh;
            background-image: radial-gradient(circle at 10% 20%, rgba(255,70,120,0.08) 2%, transparent 2.5%),
                              radial-gradient(circle at 90% 80%, rgba(255,180,70,0.06) 1.5%, transparent 2%);
            background-size: 40px 40px, 35px 35px;
        }

        /* Barra lateral decorativa (similar a escenario1, pero con neón) */
        .sidebar-neon {
            position: fixed;
            left: 0;
            top: 0;
            width: 3px;
            height: 100%;
            background: linear-gradient(to bottom, transparent, #F64B8A, #FFB347, #F64B8A, transparent);
            opacity: 0.8;
            pointer-events: none;
            z-index: 10;
        }

        /* ========== NAVBAR (estructura escenario1, colores de bar) ========== */
        .navbar {
            background: #11111A;
            backdrop-filter: blur(10px);
            border-bottom: 2px solid #F64B8A;
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
            font-size: 12px;
            background: rgba(246,75,138,0.2);
            padding: 6px 12px;
            border-radius: 40px;
            color: #F64B8A;
            border: 1px solid #F64B8A;
            transition: all 0.2s;
            letter-spacing: 0.3px;
        }
        .nav-back:hover {
            background: #F64B8A;
            color: #0A0A0F;
            transform: translateY(-1px);
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
            font-size: 9px;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: #FFB347;
            font-weight: 500;
        }
        .nav-nombre {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 700;
            background: linear-gradient(135deg, #F64B8A, #FFB347);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
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
            background: rgba(246,75,138,0.2);
            border: 1px solid rgba(246,75,138,0.5);
            font-size: 11px;
            color: #F64B8A;
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
        .est.on  { background: #F64B8A; }
        .est.off { background: rgba(246,75,138,0.3); }
        .nav-temp {
            font-family: 'Playfair Display', serif;
            font-size: 0.85rem;
            font-style: italic;
            color: #FFB347;
        }

        /* ========== HERO (termómetro y pasos) adaptado a Bar ========== */
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
            font-size: 10px;
            letter-spacing: 4px;
            text-transform: uppercase;
            color: #F64B8A;
            font-weight: 500;
            margin-bottom: 14px;
        }
        .hero-eyebrow::before {
            content: '';
            width: 24px;
            height: 1px;
            background: #FFB347;
        }
        .hero-titulo {
            font-family: 'Playfair Display', serif;
            font-size: 2.8rem;
            font-weight: 700;
            background: linear-gradient(135deg, #F64B8A, #FFB347);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
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
            color: #FFB347;
            opacity: 0.9;
            margin-bottom: 16px;
        }
        .hero-desc {
            font-size: 13px;
            color: #B0B7C3;
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
            background: linear-gradient(135deg, #F64B8A, #FFB347);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
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
            background: linear-gradient(to top, #F64B8A, #FFB347);
            border-radius: 3px;
            animation: subirCoctel 4s ease-in-out infinite alternate;
        }
        @keyframes subirCoctel {
            from { height: 30%; opacity: 0.7; }
            to   { height: 80%; opacity: 1; }
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
        }

        /* ========== CONTENIDO PRINCIPAL (secciones estilo escenario1) ========== */
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
            width: 24px;
            height: 24px;
            border-radius: 50%;
            border: 1px solid #F64B8A;
            background: rgba(246,75,138,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            color: #FFB347;
            flex-shrink: 0;
        }
        .sec-titulo {
            font-family: 'Playfair Display', serif;
            font-size: 1.05rem;
            font-weight: 700;
            color: #F5F5F5;
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
            overflow: hidden;
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
            background: linear-gradient(to bottom, transparent, #F64B8A 40%, #FFB347 60%, transparent);
            opacity: 0.8;
        }

        /* ========== CONTENIDO ORIGINAL DEL ESCENARIO 5 (sin cambios) ========== */
        .tecnicas-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 28px;
            margin-bottom: 0;
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
        .tecnica-card:hover { transform: translateY(-8px); border-color: #F64B8A; box-shadow: 0 15px 30px rgba(246,75,138,0.2); }
        .tecnica-card h3 { font-size: 1.4rem; margin-bottom: 12px; color: #FFB347; }
        .canvas-mol { background: #0D0D14; border-radius: 28px; margin: 16px auto; display: block; width: 100%; max-width: 220px; height: auto; box-shadow: inset 0 0 8px rgba(0,0,0,0.5), 0 4px 12px rgba(0,0,0,0.2); }
        .tecnica-card p { font-size: 0.85rem; color: #C0C7D0; line-height: 1.4; }

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
        .drag-section h2 { font-size: 1.6rem; display: flex; align-items: center; gap: 12px; margin-bottom: 6px; color: #FFB347; }
        .drag-section h2:before { content: "🍸"; font-size: 2rem; }
        .sub { color: #B0B7C3; font-size: 0.85rem; margin-bottom: 24px; border-left: 3px solid #F64B8A; padding-left: 12px; }

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
            border-left: 4px solid #F64B8A;
            color: #F0F0F0;
            box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        }
        .ingrediente:active { cursor: grabbing; opacity: 0.7; }
        .ingrediente:hover { transform: scale(1.02); background: #3A3A4A; }

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
        .zona h3 { font-size: 1rem; margin-bottom: 16px; padding-bottom: 6px; border-bottom: 1px solid rgba(255,180,70,0.4); display: inline-block; }
        .zona.esferificacion h3 { color: #F64B8A; }
        .zona.emulsion h3 { color: #FFB347; }
        .zona.gelificacion h3 { color: #4BC0C0; }
        .zona[dragover="true"] { box-shadow: 0 0 18px rgba(246,75,138,0.6), inset 0 0 8px rgba(255,180,70,0.3); border-color: #F64B8A; }

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
            background: linear-gradient(180deg, #F64B8A, #FFB347);
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
        .ingrediente.correcto { background: linear-gradient(135deg, #1E5631, #2A7A3A); border-left-color: #4ADE80; opacity: 0.9; }
        .ingrediente.incorrecto { background: linear-gradient(135deg, #7A2E3A, #5A1E2A); border-left-color: #F64B8A; text-decoration: line-through; opacity: 0.7; }
        .btns { display: flex; gap: 16px; margin-top: 20px; justify-content: center; }
        .btn { padding: 10px 28px; border-radius: 60px; font-weight: bold; border: none; cursor: pointer; font-size: 0.85rem; transition: 0.2s; }
        .btn-pink { background: #F64B8A; color: #0A0A0F; box-shadow: 0 2px 8px rgba(246,75,138,0.4); }
        .btn-pink:hover { background: #FF6A9F; transform: translateY(-2px); }
        .btn-outline { background: transparent; border: 1px solid #F64B8A; color: #F64B8A; }
        .btn-outline:hover { background: rgba(246,75,138,0.2); }
        .feedback { margin-top: 24px; background: rgba(0,0,0,0.7); backdrop-filter: blur(12px); padding: 14px 20px; border-radius: 40px; display: none; text-align: center; border-left: 4px solid #FFB347; animation: surgirHumo 0.4s ease; }
        @keyframes surgirHumo { from { opacity: 0; transform: translateY(10px); filter: blur(4px); } to { opacity: 1; transform: translateY(0); filter: blur(0); } }

        .quiz-block {
            background: linear-gradient(145deg, #171722, #111118);
            border-radius: 48px;
            padding: 32px;
            text-align: center;
            border: 1px solid rgba(255,180,70,0.3);
            margin: 20px;
        }
        .quiz-block h3 { font-size: 1.5rem; margin-bottom: 8px; color: #FFB347; }
        .btn-quiz { background: #F64B8A; color: white; padding: 14px 38px; border-radius: 60px; text-decoration: none; font-weight: 800; font-size: 1rem; display: inline-block; transition: 0.2s; box-shadow: 0 6px 14px rgba(246,75,138,0.4); margin-top: 16px; }
        .btn-quiz:hover { background: #FF6A9F; transform: scale(1.02); }

        /* Decoraciones de bar (mantenidas) */
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
        .stool { font-size: 3.5rem; opacity: 0.25; filter: blur(3px); transform: scaleX(-1); transition: all 0.2s; }
        .neon-line {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 2px;
            background: linear-gradient(90deg, transparent, #F64B8A, #FFB347, #F64B8A, transparent);
            z-index: 101;
        }
        footer { text-align: center; font-size: 0.7rem; color: #5A5A70; margin: 40px 0 20px; }

        @media (max-width: 800px) {
            .navbar { padding: 0 20px; }
            .hero { padding: 40px 20px; }
            .contenido { padding: 30px 20px 60px; }
            .tecnicas-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="neon-line"></div>
    <div class="bar-decor"></div>
    <div class="bar-stools">
        <div class="stool">🪑</div>
        <div class="stool">🪑</div>
        <div class="stool">🪑</div>
    </div>
    <div class="sidebar-neon"></div>

    <nav class="navbar">
        <div class="navbar-izq">
            <a href="${pageContext.request.contextPath}/menu" class="nav-back">
                <svg viewBox="0 0 24 24" width="13" height="13" fill="currentColor"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                Volver
            </a>
            <div class="sep"></div>
            <div class="nav-escenario-info">
                <span class="nav-badge">Escenario 05 🍸</span>
                <div class="sep"></div>
                <span class="nav-nombre">Bar Molecular</span>
            </div>
        </div>
        <div class="navbar-der">
            <span class="nav-temp">🍹 Coctelería de vanguardia</span>
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
                <div class="hero-eyebrow">🥼 Ciencia y sabor · Coctelería molecular</div>
                <h1 class="hero-titulo">Bar <em>Molecular</em> 🍸</h1>
                <p class="hero-concepto">Esferificación, emulsiones y gelificaciones</p>
                <p class="hero-desc">
                    Descubre cómo la ciencia transforma líquidos en caviar, espumas y geles. Arrastra los ingredientes a la técnica adecuada y completa el coctel molecular.
                </p>
            </div>
            <div class="hero-temp-panel">
                <div class="termometro">
                    <div class="temp-numero">🍸</div>
                    <div class="temp-barra-wrap"><div class="temp-barra-fill"></div></div>
                    <div class="temp-unidad">Coctel perfecto</div>
                </div>
                <div class="pasos-lista">
                    <div class="paso"><span>🔮</span> Esferificación</div>
                    <div class="paso"><span>🥛</span> Emulsión & Espumas</div>
                    <div class="paso"><span>🍮</span> Gelificación</div>
                </div>
            </div>
        </div>
    </div>

    <div class="contenido">
        <!-- SECCIÓN 1: Técnicas moleculares (tarjetas) -->
        <div class="sec-head">
            <div class="sec-num">1</div>
            <span class="sec-titulo">🍸 Técnicas de coctelería molecular</span>
            <div class="sec-linea"></div>
        </div>
        <div class="sec-bloque">
            <div class="tecnicas-grid">
                <div class="tecnica-card">
                    <h3>🔮 Esferificación</h3>
                    <canvas id="canvasEsfera" width="200" height="140" class="canvas-mol"></canvas>
                    <p>Líquido envuelto en una membrana fina.<br>Alginato + calcio → caviar líquido para cocteles.</p>
                </div>
                <div class="tecnica-card">
                    <h3>🥛 Emulsión & Espumas</h3>
                    <canvas id="canvasEmulsion" width="200" height="140" class="canvas-mol"></canvas>
                    <p>Mezcla de agua y grasa estable.<br>Lecitina de soja → espumas y aires aromáticos.</p>
                </div>
                <div class="tecnica-card">
                    <h3>🍮 Gelificación</h3>
                    <canvas id="canvasGel" width="200" height="140" class="canvas-mol"></canvas>
                    <p>Líquido a gel termo-irreversible.<br>Agar-agar, gellan gum para texturas sólidas.</p>
                </div>
            </div>
        </div>

        <!-- SECCIÓN 2: Estación de la barra (drag & drop) -->
        <div class="sec-head">
            <div class="sec-num">2</div>
            <span class="sec-titulo">🍹 Clasifica los ingredientes del bar</span>
            <div class="sec-linea"></div>
        </div>
        <div class="sec-bloque">
            <div class="drag-section">
                <h2>Clasifica los ingredientes del bar</h2>
                <div class="sub">Arrastra cada "botella" a la técnica molecular que la utiliza principalmente</div>

                <div class="ingredientes-pool" id="pool-mol"
                     ondragover="allowDropMol(event)" ondrop="dropPoolMol(event)">
                    <div class="ingrediente" draggable="true" id="ing1"
                         ondragstart="dragMol(event,'ing1')" data-tech="esferificacion">🧪 Alginato de sodio</div>
                    <div class="ingrediente" draggable="true" id="ing2"
                         ondragstart="dragMol(event,'ing2')" data-tech="esferificacion">⚖️ Cloruro de calcio</div>
                    <div class="ingrediente" draggable="true" id="ing3"
                         ondragstart="dragMol(event,'ing3')" data-tech="emulsion">🥚 Lecitina de soja</div>
                    <div class="ingrediente" draggable="true" id="ing4"
                         ondragstart="dragMol(event,'ing4')" data-tech="emulsion">🍯 Xantana (estabilizante)</div>
                    <div class="ingrediente" draggable="true" id="ing5"
                         ondragstart="dragMol(event,'ing5')" data-tech="gelificacion">🌿 Agar-agar</div>
                    <div class="ingrediente" draggable="true" id="ing6"
                         ondragstart="dragMol(event,'ing6')" data-tech="gelificacion">🍮 Goma gelana</div>
                </div>

                <div class="zonas-tech">
                    <div class="zona esferificacion" id="zona-esferificacion"
                         ondragover="allowDropMol(event)" ondrop="dropMol(event, 'esferificacion')">
                        <h3>🔮 ESFERIFICACIÓN</h3>
                        <div class="coctel-glass">
                            <div id="liquid-esferificacion" class="liquid" style="height: 0%;"></div>
                            <div class="glass-overlay">🍸</div>
                        </div>
                        <div class="dropzone-inner"></div>
                    </div>
                    <div class="zona emulsion" id="zona-emulsion"
                         ondragover="allowDropMol(event)" ondrop="dropMol(event, 'emulsion')">
                        <h3>🥛 EMULSIÓN / ESPUMAS</h3>
                        <div class="coctel-glass">
                            <div id="liquid-emulsion" class="liquid" style="height: 0%;"></div>
                            <div class="glass-overlay">🍸</div>
                        </div>
                        <div class="dropzone-inner"></div>
                    </div>
                    <div class="zona gelificacion" id="zona-gelificacion"
                         ondragover="allowDropMol(event)" ondrop="dropMol(event, 'gelificacion')">
                        <h3>🍮 GELIFICACIÓN</h3>
                        <div class="coctel-glass">
                            <div id="liquid-gelificacion" class="liquid" style="height: 0%;"></div>
                            <div class="glass-overlay">🍸</div>
                        </div>
                        <div class="dropzone-inner"></div>
                    </div>
                </div>

                <div class="btns">
                    <button class="btn btn-pink" onclick="verificarClasificacion()">✔ Verificar coctel</button>
                    <button class="btn btn-outline" onclick="reiniciarClasificacion()">↺ Reiniciar barra</button>
                </div>
                <div id="feedback-mol" class="feedback"></div>
            </div>
        </div>

        <!-- SECCIÓN 3: Quiz -->
        <div class="sec-head">
            <div class="sec-num">3</div>
            <span class="sec-titulo">📝 Pon a prueba tu conocimiento</span>
            <div class="sec-linea"></div>
        </div>
        <div class="sec-bloque">
            <div class="quiz-block">
                <h3>✨ Evaluación molecular ✨</h3>
                <p>Responde 5 preguntas sobre técnicas moleculares y propiedades de los líquidos en coctelería.</p>
                <a href="${pageContext.request.contextPath}/quiz?escenario=<%= idEscenario %>" class="btn-quiz">Ir al Quiz Molecular →</a>
            </div>
            <footer>🍹 Laboratorio de coctelería molecular · Ciencia y sabor en cada trago</footer>
        </div>
    </div>

    <script>
        // ========== DRAG & DROP (código original sin cambios) ==========
        let draggingId = null;

        function dragMol(e, id) {
            draggingId = id;
            e.dataTransfer.setData('text/plain', id);
        }
        function allowDropMol(e) {
            e.preventDefault();
            const targetZone = e.target.closest('.zona');
            if (targetZone && !targetZone.hasAttribute('dragover')) {
                document.querySelectorAll('.zona').forEach(z => z.removeAttribute('dragover'));
                targetZone.setAttribute('dragover', 'true');
            }
        }
        document.querySelectorAll('.zona').forEach(zone => {
            zone.addEventListener('dragleave', () => { zone.removeAttribute('dragover'); });
        });

        function dropMol(e, targetTech) {
            e.preventDefault();
            const dragId = e.dataTransfer.getData('text/plain');
            const draggedEl = document.getElementById(dragId);
            if (!draggedEl) return;
            const targetZone = document.getElementById(`zona-${targetTech}`);
            if (targetZone && draggedEl.parentElement !== targetZone) {
                targetZone.appendChild(draggedEl);
                draggedEl.classList.remove('correcto', 'incorrecto');
                aplicarEfectoCoctelera(draggedEl);
            }
            document.querySelectorAll('.zona').forEach(z => z.removeAttribute('dragover'));
            actualizarVasos();
        }

        function dropPoolMol(e) {
            e.preventDefault();
            const dragId = e.dataTransfer.getData('text/plain');
            const draggedEl = document.getElementById(dragId);
            if (draggedEl) {
                document.getElementById('pool-mol').appendChild(draggedEl);
                draggedEl.classList.remove('correcto', 'incorrecto');
            }
            document.querySelectorAll('.zona').forEach(z => z.removeAttribute('dragover'));
            actualizarVasos();
        }

        function aplicarEfectoCoctelera(el) {
            el.style.transform = 'scale(1.1) rotate(2deg)';
            setTimeout(() => el.style.transform = '', 150);
            const span = document.createElement('span');
            span.textContent = '🥤✨';
            span.style.position = 'absolute';
            span.style.left = (el.offsetLeft + el.offsetWidth / 2) + 'px';
            span.style.top = (el.offsetTop - 15) + 'px';
            span.style.fontSize = '1.5rem';
            span.style.pointerEvents = 'none';
            span.style.opacity = '1';
            span.style.transition = 'all 0.3s';
            span.style.zIndex = '200';
            document.body.appendChild(span);
            setTimeout(() => span.style.opacity = '0', 300);
            setTimeout(() => span.remove(), 350);
        }

        function actualizarVasos() {
            const zonas = ['zona-esferificacion', 'zona-emulsion', 'zona-gelificacion'];
            zonas.forEach(zonaId => {
                const zona = document.getElementById(zonaId);
                const ingredientesEnZona = zona.querySelectorAll('.ingrediente');
                let esperados = 0;
                let correctos = 0;
                ingredientesEnZona.forEach(ing => {
                    const techEsperada = ing.dataset.tech;
                    let esCorrecto = false;
                    if (zonaId === 'zona-esferificacion' && techEsperada === 'esferificacion') esCorrecto = true;
                    if (zonaId === 'zona-emulsion' && techEsperada === 'emulsion') esCorrecto = true;
                    if (zonaId === 'zona-gelificacion' && techEsperada === 'gelificacion') esCorrecto = true;
                    if (esCorrecto) correctos++;
                    if ((zonaId === 'zona-esferificacion' && techEsperada === 'esferificacion') ||
                        (zonaId === 'zona-emulsion' && techEsperada === 'emulsion') ||
                        (zonaId === 'zona-gelificacion' && techEsperada === 'gelificacion')) {
                        esperados++;
                    }
                });
                const porcentaje = esperados === 0 ? 0 : (correctos / esperados) * 100;
                const liquidId = zonaId.replace('zona-', 'liquid-');
                const liquidDiv = document.getElementById(liquidId);
                if (liquidDiv) liquidDiv.style.height = porcentaje + '%';
            });
        }

        function verificarClasificacion() {
            const ingredientes = document.querySelectorAll('.ingrediente');
            let correctos = 0;
            const total = ingredientes.length;
            ingredientes.forEach(ing => {
                const techEsperada = ing.dataset.tech;
                const zonaActual = ing.parentElement.id;
                let esCorrecto = false;
                if (techEsperada === 'esferificacion' && zonaActual === 'zona-esferificacion') esCorrecto = true;
                if (techEsperada === 'emulsion' && zonaActual === 'zona-emulsion') esCorrecto = true;
                if (techEsperada === 'gelificacion' && zonaActual === 'zona-gelificacion') esCorrecto = true;
                ing.classList.toggle('correcto', esCorrecto);
                ing.classList.toggle('incorrecto', !esCorrecto && zonaActual !== 'pool-mol');
                if (esCorrecto) correctos++;
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
            const pool = document.getElementById('pool-mol');
            const allIngredientes = document.querySelectorAll('.ingrediente');
            allIngredientes.forEach(ing => {
                ing.classList.remove('correcto', 'incorrecto');
                pool.appendChild(ing);
            });
            document.getElementById('feedback-mol').style.display = 'none';
            document.querySelectorAll('.liquid').forEach(l => l.style.height = '0%');
        }

        // ========== ANIMACIONES DE CANVAS (originales) ==========
        const canvasEsf = document.getElementById('canvasEsfera');
        const ctxEsf = canvasEsf.getContext('2d');
        function animEsferificacion() {
            ctxEsf.clearRect(0, 0, 200, 140);
            ctxEsf.fillStyle = '#0D0D15';
            ctxEsf.fillRect(0, 0, 200, 140);
            ctxEsf.fillStyle = '#F64B8A';
            ctxEsf.fillRect(0, 70, 200, 70);
            let y = 40 + Math.sin(Date.now() * 0.005) * 6;
            ctxEsf.beginPath();
            ctxEsf.arc(60, y, 10, 0, Math.PI * 2);
            ctxEsf.fillStyle = '#FFB347';
            ctxEsf.fill();
            for (let i = 0; i < 6; i++) {
                ctxEsf.beginPath();
                ctxEsf.arc(130 + i * 11, 95 + Math.sin(Date.now() * 0.003 + i) * 4, 5, 0, Math.PI * 2);
                ctxEsf.fillStyle = '#FF8C42';
                ctxEsf.fill();
            }
            requestAnimationFrame(animEsferificacion);
        }
        animEsferificacion();

        const canvasEmul = document.getElementById('canvasEmulsion');
        const ctxEmul = canvasEmul.getContext('2d');
        function animEmulsion() {
            ctxEmul.clearRect(0, 0, 200, 140);
            ctxEmul.fillStyle = '#1A1A24';
            ctxEmul.fillRect(0, 0, 200, 140);
            for (let i = 0; i < 22; i++) {
                let x = 15 + (i * 12 + Date.now() * 0.002) % 170;
                let y = 25 + (i * 7) % 100;
                ctxEmul.beginPath();
                ctxEmul.arc(x, y, 4, 0, Math.PI * 2);
                ctxEmul.fillStyle = i % 2 === 0 ? '#F64B8A' : '#FFB347';
                ctxEmul.fill();
            }
            requestAnimationFrame(animEmulsion);
        }
        animEmulsion();

        const canvasGel = document.getElementById('canvasGel');
        const ctxGel = canvasGel.getContext('2d');
        function animGel() {
            ctxGel.clearRect(0, 0, 200, 140);
            ctxGel.fillStyle = '#0F0F18';
            ctxGel.fillRect(0, 0, 200, 140);
            ctxGel.strokeStyle = '#4BC0C0';
            ctxGel.lineWidth = 2;
            for (let i = 0; i < 12; i++) {
                let x = 20 + (i * 14);
                let y = 40 + Math.sin(Date.now() * 0.002 + i) * 10;
                ctxGel.beginPath();
                ctxGel.moveTo(x, y);
                ctxGel.lineTo(x + 12, y + 8);
                ctxGel.lineTo(x + 6, y + 18);
                ctxGel.fillStyle = '#5FD9D9';
                ctxGel.fill();
            }
            requestAnimationFrame(animGel);
        }
        animGel();

        actualizarVasos();
    </script>
</body>
</html>