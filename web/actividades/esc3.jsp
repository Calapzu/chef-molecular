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
    .merengue-card { background: linear-gradient(135deg, #f0f8ff, #e8f4fd); border: 2px solid #b3d9f5; border-radius: 20px; padding: 32px; margin-bottom: 24px; }
    .merengue-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: #1a4a6b; margin-bottom: 8px; }
    .merengue-desc { color: #4a7fa5; font-size: 13px; margin-bottom: 24px; }
    .nodos-container { display: flex; gap: 40px; justify-content: center; flex-wrap: wrap; margin: 20px 0; }
    .nodos-col { display: flex; flex-direction: column; gap: 16px; align-items: center; }
    .nodos-col h4 { color: #1a4a6b; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; }
    .nodo { background: white; border: 2px solid #b3d9f5; border-radius: 50px; padding: 12px 20px; cursor: pointer; font-size: 14px; color: #1a4a6b; transition: all 0.2s; box-shadow: 0 2px 8px rgba(100,180,255,0.15); min-width: 120px; text-align: center; }
    .nodo:hover { border-color: #4a9fd4; background: #e0f2ff; transform: scale(1.03); }
    .nodo.seleccionado { border-color: #1a7abf; background: #cce8ff; box-shadow: 0 0 0 3px rgba(26,122,191,0.3); }
    .nodo.conectado { border-color: #4caf50; background: #e8f5e9; color: #2e7d32; pointer-events: none; }
    .conexiones-lista { margin-top: 24px; display: flex; flex-wrap: wrap; gap: 10px; justify-content: center; }
    .conexion-item { background: #1a7abf; color: white; padding: 8px 16px; border-radius: 20px; font-size: 13px; display: flex; align-items: center; gap: 8px; }
    .btn-quitar-conexion { background: none; border: none; color: white; cursor: pointer; font-size: 14px; opacity: 0.7; }
    .btn-quitar-conexion:hover { opacity: 1; }
    .btn-merengue { background: #1a7abf; color: white; border: none; border-radius: 50px; padding: 12px 28px; font-size: 14px; font-weight: 600; cursor: pointer; margin-top: 24px; transition: all 0.2s; font-family: 'DM Sans', sans-serif; }
    .btn-merengue:hover { background: #155d94; transform: translateY(-1px); }
    .btn-merengue:disabled { background: #b3d9f5; cursor: not-allowed; transform: none; }
    .feedback-merengue { margin-top: 16px; padding: 12px 16px; border-radius: 8px; font-size: 13px; display: none; }
    .feedback-merengue.success { background: #e8f5e9; border-left: 4px solid #4caf50; color: #2e7d32; display: block; }
    .feedback-merengue.error { background: #ffebee; border-left: 4px solid #f44336; color: #c62828; display: block; }
</style>

<div class="merengue-card">
    <h2 class="merengue-titulo">🍦 Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="merengue-desc">Haz clic en un elemento de la izquierda y luego en su categoría correcta para conectarlos.</p>
    <div class="nodos-container">
        <div class="nodos-col">
            <h4>📦 Elementos</h4>
            <% for (ElementoArrastrable e : elementos) {%>
            <div class="nodo" id="elem_<%= e.getIdElemento()%>"
                 data-id="<%= e.getIdElemento()%>"
                 data-nombre="<%= e.getNombre()%>"
                 data-categoria-correcta="<%= e.getCategoriaCorrecta()%>"
                 data-tipo="elemento"
                 onclick="seleccionarNodo(this)">
                <%= e.getNombre()%>
            </div>
            <% }%>
        </div>
        <div class="nodos-col">
            <h4>🎯 Categorías</h4>
            <% for (CategoriaActividad cat : categorias) {%>
            <div class="nodo" id="cat_<%= cat.getIdCategoria()%>"
                 data-nombre="<%= cat.getNombreCategoria()%>"
                 data-tipo="categoria"
                 onclick="seleccionarNodo(this)">
                <%= cat.getNombreCategoria()%>
            </div>
            <% }%>
        </div>
    </div>
    <div class="conexiones-lista" id="conexionesMerengue"></div>
    <br>
    <button class="btn-merengue" id="btnEnviarMerengue" disabled onclick="enviarMerengue()">✅ Enviar conexiones</button>
    <div class="feedback-merengue" id="feedbackMerengue"></div>
    <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
        <input type="hidden" name="respuestas" id="respuestasJsonDnD">
    </form>
</div>

<script>
    let asignacionesMerengue = {};
    let elementoSeleccionado = null;
    let totalElementosMerengue = <%= elementos != null ? elementos.size() : 0%>;

    function seleccionarNodo(nodo) {
        const tipo = nodo.dataset.tipo;
        if (tipo === 'elemento') {
            if (nodo.classList.contains('conectado')) return;
            document.querySelectorAll('.nodo[data-tipo="elemento"]').forEach(n => n.classList.remove('seleccionado'));
            if (elementoSeleccionado === nodo) { elementoSeleccionado = null; return; }
            elementoSeleccionado = nodo;
            nodo.classList.add('seleccionado');
        } else if (tipo === 'categoria') {
            if (!elementoSeleccionado) { mostrarFeedbackMerengue('Primero selecciona un elemento.', 'error'); return; }
            const idElemento = elementoSeleccionado.dataset.id;
            const nombreElemento = elementoSeleccionado.dataset.nombre;
            const categoriaCorrecta = elementoSeleccionado.dataset.categoriaCorrecta;
            const categoriaDestino = nodo.dataset.nombre;
            if (categoriaDestino !== categoriaCorrecta) {
                mostrarFeedbackMerengue('"' + nombreElemento + '" no pertenece aquí.', 'error');
                elementoSeleccionado.classList.remove('seleccionado');
                elementoSeleccionado = null;
                return;
            }
            asignacionesMerengue[idElemento] = categoriaDestino;
            elementoSeleccionado.classList.remove('seleccionado');
            elementoSeleccionado.classList.add('conectado');
            elementoSeleccionado = null;
            const div = document.createElement('div');
            div.className = 'conexion-item';
            div.innerHTML = nombreElemento + ' → ' + categoriaDestino + ' <button class="btn-quitar-conexion" onclick="quitarConexion(\'' + idElemento + '\', this)">✖</button>';
            document.getElementById('conexionesMerengue').appendChild(div);
            mostrarFeedbackMerengue('✓ "' + nombreElemento + '" conectado.', 'success');
            if (Object.keys(asignacionesMerengue).length === totalElementosMerengue) {
                document.getElementById('btnEnviarMerengue').disabled = false;
                mostrarFeedbackMerengue('✅ ¡Todos conectados!', 'success');
            }
        }
    }

    function quitarConexion(idElemento, btn) {
        delete asignacionesMerengue[idElemento];
        const nodo = document.getElementById('elem_' + idElemento);
        if (nodo) nodo.classList.remove('conectado');
        btn.parentElement.remove();
        document.getElementById('btnEnviarMerengue').disabled = true;
    }

    function mostrarFeedbackMerengue(mensaje, tipo) {
        const fb = document.getElementById('feedbackMerengue');
        fb.textContent = mensaje; fb.className = 'feedback-merengue ' + tipo;
        setTimeout(() => { fb.className = 'feedback-merengue'; }, 3000);
    }

    function enviarMerengue() {
        const respuestas = Object.entries(asignacionesMerengue).map(([idElemento, categoria]) => ({idElemento: parseInt(idElemento), categoria}));
        document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
        document.getElementById('formDnD').submit();
    }
</script>
