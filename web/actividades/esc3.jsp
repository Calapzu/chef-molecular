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
    /* ===== ESTILOS MEJORADOS ===== */
    .merengue-card { background: linear-gradient(135deg, #f0f8ff, #e8f4fd); border: 2px solid #b3d9f5; border-radius: 20px; padding: 32px; margin-bottom: 24px; }
    .merengue-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: #1a4a6b; margin-bottom: 8px; }
    .merengue-desc { color: #4a7fa5; font-size: 13px; margin-bottom: 24px; }

    /* Barra de progreso */
    .progreso-wrapper { margin-bottom: 20px; }
    .progreso-texto { font-size: 13px; color: #4a7fa5; margin-bottom: 6px; display: flex; justify-content: space-between; }
    .progreso-texto span { font-weight: 600; color: #1a7abf; }
    .progreso-barra-bg { background: rgba(26,122,191,0.15); border-radius: 99px; height: 8px; overflow: hidden; }
    .progreso-barra-fill { height: 100%; background: linear-gradient(90deg, #1a7abf, #4a9fd4); border-radius: 99px; width: 0%; transition: width 0.4s ease; }

    /* Nodos */
    .nodos-container { display: flex; gap: 40px; justify-content: center; flex-wrap: wrap; margin: 20px 0; }
    .nodos-col { display: flex; flex-direction: column; gap: 16px; align-items: center; }
    .nodos-col h4 { color: #1a4a6b; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; }
    .nodo { background: white; border: 2px solid #b3d9f5; border-radius: 50px; padding: 12px 20px; cursor: pointer; font-size: 14px; color: #1a4a6b; transition: all 0.2s; box-shadow: 0 2px 8px rgba(100,180,255,0.15); min-width: 120px; text-align: center; user-select: none; }
    .nodo:hover { border-color: #4a9fd4; background: #e0f2ff; transform: scale(1.02); }
    .nodo:focus-visible { outline: 2px solid #1a7abf; outline-offset: 2px; }
    .nodo.seleccionado { border-color: #1a7abf; background: #cce8ff; box-shadow: 0 0 0 3px rgba(26,122,191,0.3); animation: pulseSelect 0.3s ease; }
    .nodo.conectado { border-color: #4caf50; background: #e8f5e9; color: #2e7d32; cursor: default; pointer-events: none; }
    @keyframes pulseSelect { 0% { transform: scale(1); } 50% { transform: scale(1.02); } 100% { transform: scale(1); } }

    /* Lista de conexiones */
    .conexiones-lista { margin-top: 24px; display: flex; flex-wrap: wrap; gap: 10px; justify-content: center; }
    .conexion-item { background: #1a7abf; color: white; padding: 8px 16px; border-radius: 20px; font-size: 13px; display: flex; align-items: center; gap: 8px; animation: fadeInUp 0.25s ease; }
    @keyframes fadeInUp { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }
    .btn-quitar-conexion { background: none; border: none; color: white; cursor: pointer; font-size: 14px; opacity: 0.7; padding: 4px 6px; border-radius: 20px; transition: all 0.2s; }
    .btn-quitar-conexion:hover, .btn-quitar-conexion:focus { opacity: 1; background: rgba(0,0,0,0.2); outline: none; }

    /* Barra de acciones – botones alineados */
    .acciones-bar { display: flex; justify-content: flex-end; gap: 16px; margin-top: 28px; flex-wrap: wrap; }
    .btn-merengue, .btn-reiniciar { padding: 10px 24px; border-radius: 40px; font-weight: 600; cursor: pointer; transition: all 0.2s; font-size: 14px; border: none; font-family: 'DM Sans', sans-serif; }
    .btn-merengue { background: #1a7abf; color: white; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
    .btn-merengue:hover:not(:disabled) { background: #155d94; transform: translateY(-2px); box-shadow: 0 6px 14px rgba(0,0,0,0.15); }
    .btn-merengue:disabled { background: #b3d9f5; cursor: not-allowed; transform: none; }
    .btn-reiniciar { background: transparent; border: 1px solid #b3d9f5; color: #1a4a6b; }
    .btn-reiniciar:hover { border-color: #1a7abf; background: rgba(26,122,191,0.05); color: #155d94; }

    /* Feedback */
    .feedback-merengue { margin-top: 16px; padding: 12px 16px; border-radius: 8px; font-size: 13px; display: none; }
    .feedback-merengue.success { background: #e8f5e9; border-left: 4px solid #4caf50; color: #2e7d32; display: block; }
    .feedback-merengue.error { background: #ffebee; border-left: 4px solid #f44336; color: #c62828; display: block; }

    /* Responsive */
    @media (max-width: 600px) {
        .merengue-card { padding: 20px; }
        .nodos-container { flex-direction: column; align-items: stretch; gap: 24px; }
        .nodos-col { width: 100%; }
        .nodo { width: 100%; box-sizing: border-box; }
        .acciones-bar { justify-content: stretch; }
        .acciones-bar button { flex: 1; text-align: center; }
    }

    /* Accesibilidad */
    .sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); border: 0; }
</style>

<div class="merengue-card">
    <h2 class="merengue-titulo">🍦 Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="merengue-desc">Haz clic en un elemento de la izquierda y luego en su categoría correcta para conectarlos.</p>

    <!-- Barra de progreso -->
    <div class="progreso-wrapper">
        <div class="progreso-texto">
            <span id="progresoLabel">0 de <%= elementos.size() %> conectados</span>
            <span id="progresoPorc">0%</span>
        </div>
        <div class="progreso-barra-bg">
            <div class="progreso-barra-fill" id="progresoBarra"></div>
        </div>
    </div>

    <div class="nodos-container">
        <div class="nodos-col">
            <h4>📦 Elementos</h4>
            <% for (ElementoArrastrable e : elementos) { %>
                <div class="nodo" id="elem_<%= e.getIdElemento() %>"
                     data-id="<%= e.getIdElemento() %>"
                     data-nombre="<%= e.getNombre() %>"
                     data-categoria-correcta="<%= e.getCategoriaCorrecta() %>"
                     data-tipo="elemento"
                     tabindex="0"
                     role="button"
                     aria-label="Elemento: <%= e.getNombre() %>">
                    <%= e.getNombre() %>
                </div>
            <% } %>
        </div>
        <div class="nodos-col">
            <h4>🎯 Categorías</h4>
            <% for (CategoriaActividad cat : categorias) { %>
                <div class="nodo" id="cat_<%= cat.getIdCategoria() %>"
                     data-nombre="<%= cat.getNombreCategoria() %>"
                     data-tipo="categoria"
                     tabindex="0"
                     role="button"
                     aria-label="Categoría: <%= cat.getNombreCategoria() %>">
                    <%= cat.getNombreCategoria() %>
                </div>
            <% } %>
        </div>
    </div>

    <div class="conexiones-lista" id="conexionesMerengue"></div>

    <div class="acciones-bar">
        <button class="btn-reiniciar" id="btnReiniciarMerengue" aria-label="Reiniciar actividad">🔄 Reiniciar</button>
        <button class="btn-merengue" id="btnEnviarMerengue" disabled aria-label="Enviar respuestas">✅ Enviar conexiones</button>
    </div>
    <div class="feedback-merengue" id="feedbackMerengue" role="status"></div>

    <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario %>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad() %>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx %>">
        <input type="hidden" name="respuestas" id="respuestasJsonDnD">
    </form>
</div>

<script>
    let asignacionesMerengue = {};
    let elementoSeleccionado = null;
    let totalElementosMerengue = <%= elementos != null ? elementos.size() : 0 %>;
    let feedbackTimeout = null;
    let enviando = false;

    // ----- Funciones auxiliares -----
    function mostrarFeedbackMerengue(mensaje, tipo) {
        const fb = document.getElementById('feedbackMerengue');
        if (!fb) return;
        if (feedbackTimeout) clearTimeout(feedbackTimeout);
        fb.textContent = mensaje;
        fb.className = 'feedback-merengue ' + tipo;
        feedbackTimeout = setTimeout(() => { fb.className = 'feedback-merengue'; }, 3000);
    }

    function actualizarProgreso() {
        const conectados = Object.keys(asignacionesMerengue).length;
        const pct = Math.round((conectados / totalElementosMerengue) * 100);
        document.getElementById('progresoLabel').textContent = conectados + ' de ' + totalElementosMerengue + ' conectados';
        document.getElementById('progresoPorc').textContent = pct + '%';
        document.getElementById('progresoBarra').style.width = pct + '%';
        const btnEnviar = document.getElementById('btnEnviarMerengue');
        if (btnEnviar && !enviando) btnEnviar.disabled = (conectados !== totalElementosMerengue);
    }

    // Agregar conexión a la lista (sin innerHTML)
    function agregarConexionVisual(idElemento, nombreElemento, categoriaDestino) {
        const contenedor = document.getElementById('conexionesMerengue');
        const div = document.createElement('div');
        div.className = 'conexion-item';
        div.setAttribute('data-id', idElemento);
        const texto = document.createTextNode(nombreElemento + ' → ' + categoriaDestino + ' ');
        const btn = document.createElement('button');
        btn.textContent = '✖';
        btn.className = 'btn-quitar-conexion';
        btn.setAttribute('aria-label', 'Quitar conexión de ' + nombreElemento);
        btn.onclick = (function(id, button) {
            return function() { quitarConexion(id, button.parentElement); };
        })(idElemento, div);
        div.appendChild(texto);
        div.appendChild(btn);
        contenedor.appendChild(div);
    }

    function quitarConexion(idElemento, elementoDOM) {
        if (!asignacionesMerengue[idElemento]) return;
        delete asignacionesMerengue[idElemento];
        const nodoElemento = document.getElementById('elem_' + idElemento);
        if (nodoElemento) {
            nodoElemento.classList.remove('conectado');
            nodoElemento.setAttribute('aria-label', 'Elemento: ' + nodoElemento.dataset.nombre);
        }
        if (elementoDOM) elementoDOM.remove();
        document.getElementById('btnEnviarMerengue').disabled = true;
        actualizarProgreso();
        mostrarFeedbackMerengue('✓ Conexión eliminada', 'success');
    }

    // ----- Selección y conexión (con animación y seguridad) -----
    function seleccionarNodo(nodo) {
        if (!nodo) return;
        const tipo = nodo.dataset.tipo;
        if (tipo === 'elemento') {
            // Si ya está conectado, no se puede seleccionar
            if (nodo.classList.contains('conectado')) {
                mostrarFeedbackMerengue('Este elemento ya está conectado.', 'error');
                return;
            }
            // Remover selección de otros elementos
            document.querySelectorAll('.nodo[data-tipo="elemento"]').forEach(n => n.classList.remove('seleccionado'));
            if (elementoSeleccionado === nodo) {
                elementoSeleccionado.classList.remove('seleccionado');
                elementoSeleccionado = null;
            } else {
                elementoSeleccionado = nodo;
                nodo.classList.add('seleccionado');
                // Anuncio para lectores de pantalla
                const anuncio = document.createElement('div');
                anuncio.className = 'sr-only';
                anuncio.textContent = 'Seleccionado: ' + nodo.dataset.nombre;
                document.body.appendChild(anuncio);
                setTimeout(() => anuncio.remove(), 1000);
            }
        } else if (tipo === 'categoria') {
            if (!elementoSeleccionado) {
                mostrarFeedbackMerengue('Primero selecciona un elemento.', 'error');
                return;
            }
            const idElemento = elementoSeleccionado.dataset.id;
            const nombreElemento = elementoSeleccionado.dataset.nombre;
            const categoriaCorrecta = elementoSeleccionado.dataset.categoriaCorrecta;
            const categoriaDestino = nodo.dataset.nombre;

            if (asignacionesMerengue[idElemento]) {
                mostrarFeedbackMerengue('Este elemento ya está conectado.', 'error');
                elementoSeleccionado.classList.remove('seleccionado');
                elementoSeleccionado = null;
                return;
            }
            if (categoriaDestino !== categoriaCorrecta) {
                // Error: shake en el elemento seleccionado
                elementoSeleccionado.classList.add('shake');
                setTimeout(() => elementoSeleccionado.classList.remove('shake'), 400);
                mostrarFeedbackMerengue('"' + nombreElemento + '" no pertenece a ' + categoriaDestino, 'error');
                elementoSeleccionado.classList.remove('seleccionado');
                elementoSeleccionado = null;
                return;
            }

            // Conexión correcta
            asignacionesMerengue[idElemento] = categoriaDestino;
            elementoSeleccionado.classList.remove('seleccionado');
            elementoSeleccionado.classList.add('conectado');
            elementoSeleccionado.setAttribute('aria-label', 'Conectado a ' + categoriaDestino);
            agregarConexionVisual(idElemento, nombreElemento, categoriaDestino);
            mostrarFeedbackMerengue('✓ "' + nombreElemento + '" conectado correctamente.', 'success');
            elementoSeleccionado = null;
            actualizarProgreso();
            if (Object.keys(asignacionesMerengue).length === totalElementosMerengue) {
                mostrarFeedbackMerengue('✅ ¡Felicidades! Conectaste todos los elementos.', 'success');
            }
        }
    }

    // ----- Reiniciar con confirmación -----
    function reiniciarActividad() {
        if (Object.keys(asignacionesMerengue).length > 0 && !confirm('¿Seguro que quieres reiniciar la actividad? Se perderán todas las conexiones.')) {
            return;
        }
        if (feedbackTimeout) clearTimeout(feedbackTimeout);
        asignacionesMerengue = {};
        elementoSeleccionado = null;
        // Limpiar clases visuales de todos los nodos
        document.querySelectorAll('.nodo').forEach(n => {
            n.classList.remove('seleccionado', 'conectado', 'shake');
            if (n.dataset.tipo === 'elemento') {
                n.setAttribute('aria-label', 'Elemento: ' + n.dataset.nombre);
            } else {
                n.setAttribute('aria-label', 'Categoría: ' + n.dataset.nombre);
            }
        });
        // Vaciar lista de conexiones
        const contenedor = document.getElementById('conexionesMerengue');
        while (contenedor.firstChild) contenedor.removeChild(contenedor.firstChild);
        document.getElementById('btnEnviarMerengue').disabled = true;
        document.getElementById('feedbackMerengue').className = 'feedback-merengue';
        actualizarProgreso();
        mostrarFeedbackMerengue('Actividad reiniciada', 'success');
    }

    // ----- Envío con prevención de duplicados -----
    function enviarMerengue() {
        if (enviando) return;
        if (Object.keys(asignacionesMerengue).length !== totalElementosMerengue) {
            mostrarFeedbackMerengue('❌ Conecta todos los elementos antes de enviar.', 'error');
            return;
        }
        enviando = true;
        const btn = document.getElementById('btnEnviarMerengue');
        btn.disabled = true;
        btn.innerHTML = '⏳ Enviando...';
        const respuestas = Object.entries(asignacionesMerengue).map(([idElemento, categoria]) => ({
            idElemento: parseInt(idElemento), categoria
        }));
        document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
        // Enviar formulario (la página recargará)
        document.getElementById('formDnD').submit();
    }

    // ----- Asignar eventos después de que el DOM cargue -----
    document.addEventListener('DOMContentLoaded', function() {
        // Asignar eventos de clic a todos los nodos
        document.querySelectorAll('.nodo').forEach(nodo => {
            nodo.addEventListener('click', () => seleccionarNodo(nodo));
            nodo.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    seleccionarNodo(nodo);
                }
            });
        });
        document.getElementById('btnReiniciarMerengue').addEventListener('click', reiniciarActividad);
        document.getElementById('btnEnviarMerengue').addEventListener('click', enviarMerengue);
        actualizarProgreso();
    });
</script>