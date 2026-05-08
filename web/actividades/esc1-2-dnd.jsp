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
    .actividad-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 16px; padding: 32px; margin-bottom: 24px; }
    .actividad-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; margin-bottom: 8px; }
    .actividad-desc { color: var(--text-dim); font-size: 13px; margin-bottom: 24px; }
    .drag-container { display: flex; gap: 32px; flex-wrap: wrap; }
    .elementos-origen { flex: 1; min-width: 200px; background: rgba(200,122,44,0.05); border-radius: 12px; padding: 16px; }
    .elemento-drag { background: var(--cobre); color: white; padding: 12px 16px; margin: 8px 0; border-radius: 8px; cursor: grab; text-align: center; transition: transform 0.2s; }
    .elemento-drag:active { cursor: grabbing; }
    .elemento-drag.dragging { opacity: 0.5; }
    .zonas-container { flex: 1; min-width: 200px; display: flex; flex-direction: column; gap: 16px; }
    .zona-destino { background: rgba(200,122,44,0.05); border: 2px dashed var(--border); border-radius: 12px; padding: 16px; min-height: 150px; }
    .zona-destino h4 { font-size: 14px; margin-bottom: 12px; color: var(--dorado); }
    .zona-destino.drag-over { border-color: var(--cobre); background: rgba(200,122,44,0.1); }
    .elemento-ubicado { background: var(--cobre); color: white; padding: 8px 12px; margin: 6px 0; border-radius: 6px; font-size: 13px; display: flex; justify-content: space-between; align-items: center; }
    .btn-quitar { background: none; border: none; color: white; cursor: pointer; font-size: 14px; opacity: 0.7; }
    .btn-quitar:hover { opacity: 1; }
</style>

<div class="actividad-card">
    <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="actividad-desc">Arrastra cada elemento a la categoría correcta.</p>
    <div class="drag-container">
        <div class="elementos-origen" id="elementosOrigen">
            <h4>📦 Elementos para clasificar</h4>
            <div id="listaElementos">
                <% for (ElementoArrastrable e : elementos) {%>
                <div class="elemento-drag" draggable="true"
                     data-id="<%= e.getIdElemento()%>"
                     data-nombre="<%= e.getNombre()%>"
                     data-categoria-correcta="<%= e.getCategoriaCorrecta()%>">
                    <%= e.getNombre()%>
                </div>
                <% }%>
            </div>
        </div>
        <div class="zonas-container" id="zonasDestino">
            <% for (CategoriaActividad cat : categorias) {%>
            <div class="zona-destino" data-categoria="<%= cat.getNombreCategoria()%>">
                <h4><%= cat.getNombreCategoria()%></h4>
                <div class="elementos-colocados" id="zona_<%= cat.getIdCategoria()%>"></div>
            </div>
            <% }%>
        </div>
    </div>
    <button class="btn-accion" id="btnEnviar" disabled>✅ Enviar respuestas</button>
    <div class="feedback" id="feedback"></div>
    <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
        <input type="hidden" name="respuestas" id="respuestasJsonDnD">
    </form>
</div>

<script>
    let asignaciones = {};
    let elementosOriginalesDnD = [];
    let elementoDragActual = null;

    function mostrarFeedback(mensaje, tipo) {
        const fb = document.getElementById('feedback');
        if (!fb) return;
        fb.textContent = mensaje; fb.className = 'feedback ' + tipo;
        setTimeout(() => { fb.className = 'feedback'; }, 3000);
    }

    document.querySelectorAll('.elemento-drag').forEach(el => {
        elementosOriginalesDnD.push({ id: el.dataset.id, nombre: el.dataset.nombre, elemento: el, categoriaCorrecta: el.dataset.categoriaCorrecta });
        el.addEventListener('dragstart', function(e) { elementoDragActual = this; e.dataTransfer.setData('text/plain', this.dataset.id); this.classList.add('dragging'); });
        el.addEventListener('dragend', function() { this.classList.remove('dragging'); elementoDragActual = null; });
    });

    document.querySelectorAll('.zona-destino').forEach(zona => {
        zona.addEventListener('dragover', function(e) { e.preventDefault(); this.classList.add('drag-over'); });
        zona.addEventListener('dragleave', function() { this.classList.remove('drag-over'); });
        zona.addEventListener('drop', function(e) {
            e.preventDefault(); this.classList.remove('drag-over');
            if (!elementoDragActual) return;
            const idElemento = elementoDragActual.dataset.id;
            const nombreElemento = elementoDragActual.dataset.nombre;
            const categoriaCorrecta = elementoDragActual.dataset.categoriaCorrecta;
            const categoriaDestino = this.dataset.categoria;
            if (asignaciones[idElemento]) { mostrarFeedback('Este elemento ya fue colocado.', 'error'); return; }
            if (categoriaDestino !== categoriaCorrecta) { mostrarFeedback('"' + nombreElemento + '" no pertenece aquí.', 'error'); return; }
            asignaciones[idElemento] = categoriaDestino;
            elementoDragActual.style.display = 'none';
            const div = document.createElement('div');
            div.className = 'elemento-ubicado';
            div.innerHTML = nombreElemento + ' <button class="btn-quitar" data-id="' + idElemento + '">✖</button>';
            this.querySelector('.elementos-colocados').appendChild(div);
            div.querySelector('.btn-quitar').addEventListener('click', function(e) {
                e.stopPropagation();
                const orig = elementosOriginalesDnD.find(el => el.id === this.dataset.id);
                if (orig) orig.elemento.style.display = 'block';
                delete asignaciones[this.dataset.id];
                this.parentElement.remove();
                document.getElementById('btnEnviar').disabled = (Object.keys(asignaciones).length !== elementosOriginalesDnD.length);
            });
            mostrarFeedback('✓ "' + nombreElemento + '" colocado.', 'success');
            if (Object.keys(asignaciones).length === elementosOriginalesDnD.length) {
                document.getElementById('btnEnviar').disabled = false;
                mostrarFeedback('✅ ¡Todos clasificados!', 'success');
            }
        });
    });

    document.getElementById('btnEnviar').addEventListener('click', function() {
        if (Object.keys(asignaciones).length !== elementosOriginalesDnD.length) { mostrarFeedback('❌ Clasificá todos los elementos.', 'error'); return; }
        const respuestas = Object.entries(asignaciones).map(([idElemento, categoria]) => ({idElemento: parseInt(idElemento), categoria}));
        document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
        document.getElementById('formDnD').submit();
    });
</script>
