<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.ElementoArrastrable, com.chefmolecular.modelo.CategoriaActividad, java.util.List" %>
<%
    List<ElementoArrastrable> elementos = (List<ElementoArrastrable>) request.getAttribute("elementos");
    List<CategoriaActividad> categorias = (List<CategoriaActividad>) request.getAttribute("categorias");
    int actividadIdx = (int) request.getAttribute("actividadIdx");
    int totalActividades = (int) request.getAttribute("totalActividades");
    int idEscenario = (int) request.getAttribute("idEscenario");
    com.chefmolecular.modelo.ActividadInteractiva actividad = (com.chefmolecular.modelo.ActividadInteractiva) request.getAttribute("actividad");
%>
<style>
    /* ===== ESTILOS BASE MEJORADOS ===== */
    .horno-card { background: linear-gradient(135deg, #1a0a0a, #0a0a1a); border: 2px solid #5a2a2a; border-radius: 20px; padding: 32px; margin-bottom: 24px; }
    .horno-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: #ffcccc; margin-bottom: 8px; }
    .horno-desc { color: rgba(255,200,200,0.6); font-size: 13px; margin-bottom: 24px; }

    /* Barra de progreso */
    .progreso-wrapper { margin-bottom: 20px; }
    .progreso-texto { font-size: 13px; color: rgba(255,200,200,0.7); margin-bottom: 6px; display: flex; justify-content: space-between; }
    .progreso-texto span { font-weight: 600; color: #ff9999; }
    .progreso-barra-bg { background: rgba(200,100,100,0.2); border-radius: 99px; height: 8px; overflow: hidden; }
    .progreso-barra-fill { height: 100%; background: linear-gradient(90deg, #c0392b, #e74c3c); border-radius: 99px; width: 0%; transition: width 0.4s ease; }

    /* Tarjetas flip */
    .horno-grid { display: flex; gap: 16px; flex-wrap: wrap; justify-content: center; margin: 20px 0; }
    .tarjeta-flip { width: 150px; height: 100px; perspective: 1000px; cursor: pointer; }
    .tarjeta-inner { position: relative; width: 100%; height: 100%; transition: transform 0.6s; transform-style: preserve-3d; }
    .tarjeta-flip.volteada .tarjeta-inner { transform: rotateY(180deg); }
    .tarjeta-frente, .tarjeta-dorso { position: absolute; width: 100%; height: 100%; backface-visibility: hidden; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 600; text-align: center; padding: 10px; }
    .tarjeta-frente { background: linear-gradient(135deg, #c0392b, #1a6699); color: white; border: 2px solid #e74c3c; font-size: 24px; }
    .tarjeta-dorso { background: #1a1a2e; color: #a0c4ff; border: 2px solid #4a90d9; transform: rotateY(180deg); font-size: 12px; }
    .tarjeta-flip.asignada .tarjeta-frente { opacity: 0.4; pointer-events: none; }
    .tarjeta-flip.asignada { cursor: default; }
    .tarjeta-flip.shake { animation: shake 0.35s ease; }
    @keyframes shake { 0%,100% { transform: translateX(0); } 20% { transform: translateX(-5px); } 40% { transform: translateX(5px); } 60% { transform: translateX(-3px); } 80% { transform: translateX(3px); } }

    /* Zonas de destino */
    .zonas-horno { display: flex; gap: 16px; flex-wrap: wrap; justify-content: center; margin-top: 24px; }
    .zona-horno { flex: 1; min-width: 150px; border-radius: 12px; padding: 16px; min-height: 120px; border: 2px dashed; text-align: center; transition: all 0.2s; cursor: pointer; }
    .zona-horno.caliente { background: rgba(231,76,60,0.1); border-color: #e74c3c; }
    .zona-horno.frio { background: rgba(74,144,217,0.1); border-color: #4a90d9; }
    .zona-horno h4 { margin-bottom: 10px; font-size: 13px; }
    .zona-horno.caliente h4 { color: #e74c3c; }
    .zona-horno.frio h4 { color: #4a90d9; }
    .zona-horno.activa { transform: scale(1.02); background: rgba(255,255,255,0.05); }
    .zona-horno.drop-ok { animation: pulseOk 0.4s ease; border-color: #4caf50; background: rgba(76,175,80,0.1); }
    .zona-horno.drop-error { animation: pulseError 0.35s ease; border-color: #e53935; background: rgba(229,57,53,0.1); }
    @keyframes pulseOk { 0% { box-shadow: 0 0 0 0 rgba(76,175,80,0.4); } 70% { box-shadow: 0 0 0 8px rgba(76,175,80,0); } 100% { box-shadow: none; } }
    @keyframes pulseError { 0% { box-shadow: 0 0 0 0 rgba(229,57,53,0.4); } 70% { box-shadow: 0 0 0 8px rgba(229,57,53,0); } 100% { box-shadow: none; } }

    /* Elementos asignados dentro de zonas */
    .elem-asignado-horno { padding: 6px 10px; border-radius: 6px; font-size: 12px; margin: 4px; display: inline-block; color: white; animation: fadeInUp 0.25s ease; }
    .elem-asignado-horno.caliente { background: #c0392b; }
    .elem-asignado-horno.frio { background: #1a6699; }
    @keyframes fadeInUp { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }

    /* Botones de acción alineados */
    .acciones-bar { display: flex; justify-content: flex-end; gap: 16px; margin-top: 28px; flex-wrap: wrap; }
    .btn-horno, .btn-reiniciar { padding: 10px 24px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.2s; font-size: 14px; border: none; font-family: 'DM Sans', sans-serif; }
    .btn-horno { background: linear-gradient(135deg, #c0392b, #1a6699); color: white; }
    .btn-horno:hover:not(:disabled) { opacity: 0.9; transform: translateY(-2px); }
    .btn-horno:disabled { opacity: 0.4; cursor: not-allowed; transform: none; }
    .btn-reiniciar { background: transparent; border: 1px solid #5a2a2a; color: #ffcccc; }
    .btn-reiniciar:hover { border-color: #e74c3c; background: rgba(231,76,60,0.1); color: #ff9999; }

    /* Feedback */
    .feedback-horno { margin-top: 16px; padding: 12px 16px; border-radius: 8px; font-size: 13px; display: none; }
    .feedback-horno.success { background: rgba(76,175,80,0.15); border-left: 4px solid #4caf50; color: #4caf50; display: block; }
    .feedback-horno.error { background: rgba(231,76,60,0.15); border-left: 4px solid #e74c3c; color: #e74c3c; display: block; }

    /* Responsive */
    @media (max-width: 600px) {
        .horno-card { padding: 20px; }
        .horno-grid { justify-content: center; }
        .tarjeta-flip { width: 130px; height: 90px; }
        .zonas-horno { flex-direction: column; }
        .acciones-bar { justify-content: stretch; }
        .acciones-bar button { flex: 1; text-align: center; }
    }

    /* Accesibilidad */
    .sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); border: 0; }
    .tarjeta-flip:focus-visible { outline: 2px solid #ff9999; outline-offset: 2px; }
    .zona-horno:focus-visible { outline: 2px solid #ff9999; outline-offset: 2px; }
</style>

<div class="horno-card">
    <h2 class="horno-titulo">🔥❄️ Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="horno-desc">Haz clic en cada tarjeta para revelar el elemento. Luego haz clic en la zona correcta para asignarlo.</p>

    <!-- Barra de progreso -->
    <div class="progreso-wrapper">
        <div class="progreso-texto">
            <span id="progresoLabel">0 de <%= elementos.size() %> asignados</span>
            <span id="progresoPorc">0%</span>
        </div>
        <div class="progreso-barra-bg">
            <div class="progreso-barra-fill" id="progresoBarra"></div>
        </div>
    </div>

    <div class="horno-grid" id="hornoGrid">
        <% for (ElementoArrastrable e : elementos) { %>
            <div class="tarjeta-flip" id="tarjeta_<%= e.getIdElemento() %>"
                 data-id="<%= e.getIdElemento() %>"
                 data-nombre="<%= e.getNombre() %>"
                 data-categoria-correcta="<%= e.getCategoriaCorrecta() %>"
                 role="button"
                 tabindex="0"
                 aria-label="Tarjeta. Haz clic para ver el elemento.">
                <div class="tarjeta-inner">
                    <div class="tarjeta-frente">🃏</div>
                    <div class="tarjeta-dorso"><%= e.getNombre() %></div>
                </div>
            </div>
        <% } %>
    </div>

    <div class="zonas-horno">
        <% for (CategoriaActividad cat : categorias) {
            String claseZona = cat.getNombreCategoria().toLowerCase().contains("calor")
                || cat.getNombreCategoria().toLowerCase().contains("caliente")
                || cat.getNombreCategoria().toLowerCase().contains("alto")
                || cat.getNombreCategoria().toLowerCase().contains("gas")
                ? "caliente" : "frio";
        %>
            <div class="zona-horno <%= claseZona %>" id="zonaH_<%= cat.getIdCategoria() %>"
                 data-categoria="<%= cat.getNombreCategoria() %>"
                 data-clase="<%= claseZona %>"
                 role="button"
                 tabindex="0"
                 aria-label="Zona para categoría <%= cat.getNombreCategoria() %>">
                <h4><%= cat.getNombreCategoria() %></h4>
                <div id="elemsZonaH_<%= cat.getIdCategoria() %>" class="contenedor-asignados"></div>
            </div>
        <% } %>
    </div>

    <div class="acciones-bar">
        <button class="btn-reiniciar" id="btnReiniciarHorno" aria-label="Reiniciar actividad">🔄 Reiniciar</button>
        <button class="btn-horno" id="btnEnviarHorno" disabled aria-label="Enviar respuestas">✅ Enviar clasificación</button>
    </div>
    <div class="feedback-horno" id="feedbackHorno" role="status"></div>

    <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario %>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad() %>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx %>">
        <input type="hidden" name="respuestas" id="respuestasJsonDnD">
    </form>
</div>

<script>
    let asignacionesHorno = {};
    let tarjetaSeleccionada = null;
    let totalElementosHorno = <%= elementos != null ? elementos.size() : 0 %>;
    let feedbackTimeout = null;
    let enviando = false;

    // ----- Funciones auxiliares -----
    function mostrarFeedbackHorno(mensaje, tipo) {
        const fb = document.getElementById('feedbackHorno');
        if (!fb) return;
        if (feedbackTimeout) clearTimeout(feedbackTimeout);
        fb.textContent = mensaje;
        fb.className = 'feedback-horno ' + tipo;
        feedbackTimeout = setTimeout(() => { fb.className = 'feedback-horno'; }, 3000);
    }

    function actualizarProgreso() {
        const asignados = Object.keys(asignacionesHorno).length;
        const pct = Math.round((asignados / totalElementosHorno) * 100);
        document.getElementById('progresoLabel').textContent = asignados + ' de ' + totalElementosHorno + ' asignados';
        document.getElementById('progresoPorc').textContent = pct + '%';
        document.getElementById('progresoBarra').style.width = pct + '%';
        const btnEnviar = document.getElementById('btnEnviarHorno');
        if (btnEnviar && !enviando) btnEnviar.disabled = (asignados !== totalElementosHorno);
    }

    // Añadir elemento asignado a una zona (sin innerHTML)
    function agregarElementoZona(zonaId, nombre, claseColor) {
        const contenedor = document.getElementById('elemsZonaH_' + zonaId);
        if (!contenedor) return;
        const span = document.createElement('span');
        span.className = 'elem-asignado-horno ' + claseColor;
        span.textContent = nombre;
        contenedor.appendChild(span);
    }

    // Quitar todos los elementos visuales de una zona (para reinicio)
    function limpiarZonasVisuales() {
        document.querySelectorAll('.contenedor-asignados').forEach(cont => {
            while (cont.firstChild) cont.removeChild(cont.firstChild);
        });
    }

    // Efecto flash en zona
    function flashZona(zona, tipo) {
        zona.classList.remove('drop-ok', 'drop-error');
        void zona.offsetWidth;
        zona.classList.add(tipo === 'ok' ? 'drop-ok' : 'drop-error');
        setTimeout(() => zona.classList.remove('drop-ok', 'drop-error'), 500);
    }

    // ----- Voltear tarjeta -----
    function voltearTarjeta(tarjeta) {
        if (tarjeta.classList.contains('asignada')) {
            mostrarFeedbackHorno('Esta tarjeta ya fue asignada.', 'error');
            return;
        }
        // Si hay otra tarjeta volteada, la cerramos
        if (tarjetaSeleccionada && tarjetaSeleccionada !== tarjeta) {
            tarjetaSeleccionada.classList.remove('volteada');
        }
        tarjeta.classList.toggle('volteada');
        if (tarjeta.classList.contains('volteada')) {
            tarjetaSeleccionada = tarjeta;
            // Resaltar zonas activas
            document.querySelectorAll('.zona-horno').forEach(z => z.classList.add('activa'));
            // Anuncio para lectores de pantalla
            const anuncio = document.createElement('div');
            anuncio.className = 'sr-only';
            anuncio.textContent = 'Tarjeta volteada: ' + tarjeta.dataset.nombre + '. Selecciona una zona.';
            document.body.appendChild(anuncio);
            setTimeout(() => anuncio.remove(), 2000);
        } else {
            tarjetaSeleccionada = null;
            document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa'));
        }
    }

    // ----- Asignar a zona -----
    function asignarAZonaHorno(zona) {
        if (!tarjetaSeleccionada) {
            mostrarFeedbackHorno('Primero haz clic en una tarjeta para revelar el elemento.', 'error');
            return;
        }
        const tarjeta = tarjetaSeleccionada;
        const idElemento = tarjeta.dataset.id;
        const nombreElemento = tarjeta.dataset.nombre;
        const categoriaCorrecta = tarjeta.dataset.categoriaCorrecta;
        const categoriaDestino = zona.dataset.categoria;

        // Validar si ya está asignada (por si acaso)
        if (asignacionesHorno[idElemento]) {
            mostrarFeedbackHorno('Este elemento ya fue asignado.', 'error');
            tarjeta.classList.remove('volteada');
            tarjetaSeleccionada = null;
            document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa'));
            return;
        }

        if (categoriaDestino !== categoriaCorrecta) {
            // Error: shake en tarjeta y flash rojo en zona
            tarjeta.classList.add('shake');
            setTimeout(() => tarjeta.classList.remove('shake'), 400);
            flashZona(zona, 'error');
            mostrarFeedbackHorno('"' + nombreElemento + '" no pertenece a ' + categoriaDestino, 'error');
            // Cerrar tarjeta y limpiar selección
            tarjeta.classList.remove('volteada');
            tarjetaSeleccionada = null;
            document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa'));
            return;
        }

        // Asignación correcta
        asignacionesHorno[idElemento] = categoriaDestino;
        tarjeta.classList.add('asignada');
        tarjeta.classList.remove('volteada');
        tarjetaSeleccionada = null;
        document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa'));
        flashZona(zona, 'ok');

        // Obtener ID de la zona (numérico) desde el id de la zona: "zonaH_123"
        const zonaId = zona.id.replace('zonaH_', '');
        agregarElementoZona(zonaId, nombreElemento, zona.dataset.clase);

        mostrarFeedbackHorno('✓ "' + nombreElemento + '" asignado correctamente.', 'success');
        actualizarProgreso();

        if (Object.keys(asignacionesHorno).length === totalElementosHorno) {
            mostrarFeedbackHorno('✅ ¡Felicidades! Asignaste todos los elementos.', 'success');
        }
    }

    // ----- Reiniciar actividad -----
    function reiniciarActividad() {
        if (Object.keys(asignacionesHorno).length > 0 && !confirm('¿Seguro que quieres reiniciar la actividad? Se perderán todas las asignaciones.')) {
            return;
        }
        if (feedbackTimeout) clearTimeout(feedbackTimeout);
        // Reiniciar estado
        asignacionesHorno = {};
        tarjetaSeleccionada = null;
        // Limpiar tarjetas
        document.querySelectorAll('.tarjeta-flip').forEach(t => {
            t.classList.remove('asignada', 'volteada', 'shake');
            t.setAttribute('aria-label', 'Tarjeta. Haz clic para ver el elemento.');
        });
        // Limpiar zonas visualmente
        limpiarZonasVisuales();
        // Quitar resaltado de zonas
        document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa', 'drop-ok', 'drop-error'));
        // Deshabilitar botón enviar
        document.getElementById('btnEnviarHorno').disabled = true;
        // Resetear feedback
        document.getElementById('feedbackHorno').className = 'feedback-horno';
        actualizarProgreso();
        mostrarFeedbackHorno('Actividad reiniciada', 'success');
    }

    // ----- Envío con prevención de duplicados -----
    function enviarHorno() {
        if (enviando) return;
        if (Object.keys(asignacionesHorno).length !== totalElementosHorno) {
            mostrarFeedbackHorno('❌ Asigna todos los elementos antes de enviar.', 'error');
            return;
        }
        enviando = true;
        const btn = document.getElementById('btnEnviarHorno');
        btn.disabled = true;
        btn.innerHTML = '⏳ Enviando...';
        const respuestas = Object.entries(asignacionesHorno).map(([idElemento, categoria]) => ({
            idElemento: parseInt(idElemento), categoria
        }));
        document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
        document.getElementById('formDnD').submit();
    }

    // ----- Asignar eventos después de cargar el DOM -----
    document.addEventListener('DOMContentLoaded', function() {
        // Eventos para tarjetas
        document.querySelectorAll('.tarjeta-flip').forEach(tarjeta => {
            tarjeta.addEventListener('click', (e) => {
                e.stopPropagation();
                voltearTarjeta(tarjeta);
            });
            tarjeta.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    voltearTarjeta(tarjeta);
                }
            });
        });
        // Eventos para zonas
        document.querySelectorAll('.zona-horno').forEach(zona => {
            zona.addEventListener('click', (e) => {
                e.stopPropagation();
                asignarAZonaHorno(zona);
            });
            zona.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    asignarAZonaHorno(zona);
                }
            });
        });
        // Botón reiniciar
        document.getElementById('btnReiniciarHorno').addEventListener('click', reiniciarActividad);
        // Botón enviar
        document.getElementById('btnEnviarHorno').addEventListener('click', enviarHorno);
        // Inicializar progreso
        actualizarProgreso();
    });
</script>