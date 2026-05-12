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
    /* ===== ESTILOS BASE ===== */
    .actividad-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 16px; padding: 32px; margin-bottom: 24px; }
    .actividad-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; margin-bottom: 8px; }
    .actividad-desc { color: var(--text-dim); font-size: 13px; margin-bottom: 24px; }

    /* ── 1. CONTADOR DE PROGRESO ── */
    .progreso-wrapper { margin-bottom: 20px; }
    .progreso-texto { font-size: 13px; color: var(--text-dim); margin-bottom: 6px; display: flex; justify-content: space-between; }
    .progreso-texto span { font-weight: 600; color: var(--dorado); }
    .progreso-barra-bg { background: rgba(200,122,44,0.15); border-radius: 99px; height: 8px; overflow: hidden; }
    .progreso-barra-fill { height: 100%; background: linear-gradient(90deg, var(--cobre), var(--dorado)); border-radius: 99px; width: 0%; transition: width 0.4s ease; }

    /* ── DRAG & DROP ── */
    .drag-container { display: flex; gap: 32px; flex-wrap: wrap; }
    .elementos-origen { flex: 1; min-width: 200px; background: rgba(200,122,44,0.05); border-radius: 12px; padding: 16px; }
    .elemento-drag { background: var(--cobre); color: white; padding: 12px 16px; margin: 8px 0; border-radius: 8px; cursor: grab; text-align: center; transition: transform 0.2s, box-shadow 0.2s; user-select: none; }
    .elemento-drag:active { cursor: grabbing; }
    .elemento-drag.dragging { opacity: 0.4; transform: scale(0.97); }
    .elemento-drag:focus-visible { outline: 2px solid var(--dorado); outline-offset: 2px; }

    /* Animación shake */
    .elemento-drag.shake { animation: shake 0.35s ease; }
    @keyframes shake { 0%,100% { transform: translateX(0); } 20% { transform: translateX(-6px); } 40% { transform: translateX(6px); } 60% { transform: translateX(-4px); } 80% { transform: translateX(4px); } }

    /* Zonas destino */
    .zona-destino { background: rgba(200,122,44,0.05); border: 2px dashed var(--border); border-radius: 12px; padding: 16px; min-height: 150px; transition: border-color 0.2s, background 0.2s; }
    .zona-destino h4 { font-size: 14px; margin-bottom: 12px; color: var(--dorado); }
    .zona-destino.drag-over { border-color: var(--cobre); background: rgba(200,122,44,0.1); }
    .zona-destino.drop-ok { border-color: #4caf50; background: rgba(76,175,80,0.1); animation: pulseOk 0.4s ease; }
    .zona-destino.drop-error { border-color: #e53935; background: rgba(229,57,53,0.1); animation: pulseError 0.35s ease; }
    @keyframes pulseOk { 0% { box-shadow: 0 0 0 0 rgba(76,175,80,0.4); } 70% { box-shadow: 0 0 0 8px rgba(76,175,80,0); } 100% { box-shadow: none; } }
    @keyframes pulseError { 0% { box-shadow: 0 0 0 0 rgba(229,57,53,0.4); } 70% { box-shadow: 0 0 0 8px rgba(229,57,53,0); } 100% { box-shadow: none; } }

    .zonas-container { flex: 1; min-width: 200px; display: flex; flex-direction: column; gap: 16px; }

    /* Elementos ya colocados */
    .elemento-ubicado { background: var(--cobre); color: white; padding: 8px 12px; margin: 6px 0; border-radius: 6px; font-size: 13px; display: flex; justify-content: space-between; align-items: center; animation: aparecer 0.25s ease; transition: opacity 0.2s, transform 0.2s; }
    @keyframes aparecer { from { opacity: 0; transform: translateY(-6px); } to { opacity: 1; transform: translateY(0); } }

    .btn-quitar { background: none; border: none; color: white; cursor: pointer; font-size: 14px; opacity: 0.7; padding: 4px 8px; border-radius: 4px; transition: all 0.2s; }
    .btn-quitar:hover, .btn-quitar:focus { opacity: 1; background: rgba(0,0,0,0.2); outline: none; }

    /* ── BARRA DE ACCIONES (botones alineados) ── */
    .acciones-bar { display: flex; justify-content: flex-end; gap: 16px; margin-top: 28px; flex-wrap: wrap; }
    .btn-accion, .btn-reiniciar { padding: 10px 24px; border-radius: 40px; font-weight: 500; cursor: pointer; transition: all 0.2s; font-size: 14px; border: none; }
    .btn-accion { background: linear-gradient(135deg, var(--cobre), #b45f2b); color: white; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
    .btn-accion:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 6px 14px rgba(0,0,0,0.15); }
    .btn-accion:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }
    .btn-reiniciar { background: transparent; border: 1px solid var(--border); color: var(--text-dim); }
    .btn-reiniciar:hover { border-color: var(--cobre); color: var(--cobre); background: rgba(200,122,44,0.05); }

    /* ── FEEDBACK ── */
    .feedback { margin-top: 16px; font-size: 13px; padding: 8px 12px; border-radius: 8px; transition: all 0.2s; }
    .feedback.success { background: #4caf5022; color: #2e7d32; border-left: 3px solid #4caf50; }
    .feedback.error { background: #e5393522; color: #c62828; border-left: 3px solid #e53935; }

    /* ── ACCESIBILIDAD (oculto visualmente pero para lectores) ── */
    .sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); border: 0; }

    /* ── RESPONSIVE ── */
    @media (max-width: 600px) {
        .actividad-card { padding: 18px; }
        .drag-container { flex-direction: column; gap: 20px; }
        .elemento-drag { padding: 14px 12px; font-size: 15px; touch-action: none; }
        .zona-destino { min-height: 100px; }
        .acciones-bar { justify-content: stretch; }
        .acciones-bar button { flex: 1; text-align: center; }
    }
</style>

<div class="actividad-card">
    <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="actividad-desc">Arrastra cada elemento a la categoría correcta.</p>

    <!-- Barra de progreso -->
    <div class="progreso-wrapper">
        <div class="progreso-texto">
            <span id="progresoLabel">0 de <%= elementos.size() %> clasificados</span>
            <span id="progresoPorc">0%</span>
        </div>
        <div class="progreso-barra-bg">
            <div class="progreso-barra-fill" id="progresoBarra"></div>
        </div>
    </div>

    <div class="drag-container">
        <div class="elementos-origen" id="elementosOrigen">
            <h4>📦 Elementos para clasificar</h4>
            <div id="listaElementos">
                <% for (ElementoArrastrable e : elementos) { %>
                    <div class="elemento-drag" draggable="true"
                         data-id="<%= e.getIdElemento() %>"
                         data-nombre="<%= e.getNombre() %>"
                         data-categoria-correcta="<%= e.getCategoriaCorrecta() %>"
                         role="button"
                         tabindex="0"
                         aria-label="Elemento arrastrable: <%= e.getNombre() %>">
                        <%= e.getNombre() %>
                    </div>
                <% } %>
            </div>
        </div>
        <div class="zonas-container" id="zonasDestino">
            <% for (CategoriaActividad cat : categorias) { %>
                <div class="zona-destino" data-categoria="<%= cat.getNombreCategoria() %>" aria-label="Zona para <%= cat.getNombreCategoria() %>">
                    <h4><%= cat.getNombreCategoria() %></h4>
                    <div class="elementos-colocados" id="zona_<%= cat.getIdCategoria() %>"></div>
                </div>
            <% } %>
        </div>
    </div>

    <div class="acciones-bar">
        <button class="btn-reiniciar" id="btnReiniciar" aria-label="Reiniciar actividad">🔄 Reiniciar</button>
        <button class="btn-accion" id="btnEnviar" disabled aria-label="Enviar respuestas">✅ Enviar respuestas</button>
    </div>

    <div class="feedback" id="feedback" role="status"></div>
    <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario %>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad() %>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx %>">
        <input type="hidden" name="respuestas" id="respuestasJsonDnD">
    </form>
</div>

<script>
    const TOTAL_ELEMENTOS = <%= elementos.size() %>;
    let asignaciones = {};
    let elementosOriginalesDnD = [];
    let elementoDragActual = null;
    let feedbackTimeout = null;
    let enviando = false;  // Prevenir envíos duplicados

    // ── Utilidades ──────────────────────────────────────────────────────────
    function mostrarFeedback(mensaje, tipo) {
        const fb = document.getElementById('feedback');
        if (!fb) return;
        if (feedbackTimeout) clearTimeout(feedbackTimeout);
        fb.textContent = mensaje;
        fb.className = 'feedback ' + tipo;
        feedbackTimeout = setTimeout(() => { fb.className = 'feedback'; }, 3000);
    }

    function actualizarProgreso() {
        const colocados = Object.keys(asignaciones).length;
        const pct = Math.round((colocados / TOTAL_ELEMENTOS) * 100);
        document.getElementById('progresoLabel').textContent = colocados + ' de ' + TOTAL_ELEMENTOS + ' clasificados';
        document.getElementById('progresoPorc').textContent = pct + '%';
        document.getElementById('progresoBarra').style.width = pct + '%';
        const btnEnviar = document.getElementById('btnEnviar');
        if (btnEnviar && !enviando) btnEnviar.disabled = (colocados !== TOTAL_ELEMENTOS);
    }

    function flashZona(zona, tipo) {
        zona.classList.remove('drop-ok', 'drop-error');
        void zona.offsetWidth;
        zona.classList.add(tipo === 'ok' ? 'drop-ok' : 'drop-error');
        setTimeout(() => zona.classList.remove('drop-ok', 'drop-error'), 500);
    }

    // Crear elemento ubicado de forma segura (sin innerHTML)
    function crearElementoUbicado(id, nombre, zonaDestino) {
        const contenedor = zonaDestino.querySelector('.elementos-colocados');
        if (!contenedor) return;

        const div = document.createElement('div');
        div.className = 'elemento-ubicado';
        div.setAttribute('data-id', id);
        
        const spanNombre = document.createElement('span');
        spanNombre.textContent = nombre;
        
        const btnQuitar = document.createElement('button');
        btnQuitar.textContent = '✖';
        btnQuitar.className = 'btn-quitar';
        btnQuitar.setAttribute('aria-label', 'Quitar ' + nombre);
        btnQuitar.setAttribute('data-id', id);
        
        btnQuitar.addEventListener('click', function(e) {
            e.stopPropagation();
            // Animación de salida
            div.style.opacity = '0';
            div.style.transform = 'scale(0.9)';
            setTimeout(() => {
                const orig = elementosOriginalesDnD.find(el => el.id === id);
                if (orig) orig.elemento.style.display = 'block';
                delete asignaciones[id];
                div.remove();
                actualizarProgreso();
                mostrarFeedback('✓ Elemento devuelto', 'success');
            }, 150);
        });
        
        div.appendChild(spanNombre);
        div.appendChild(btnQuitar);
        contenedor.appendChild(div);
    }

    // Colocar elemento (unificado para drag y touch)
    function colocarElemento(zona, elOrig) {
        if (!zona || !elOrig) return;
        const idElemento = elOrig.dataset.id;
        const nombreElemento = elOrig.dataset.nombre;
        const categoriaCorrecta = elOrig.dataset.categoriaCorrecta;
        const categoriaDestino = zona.dataset.categoria;

        if (asignaciones[idElemento]) {
            mostrarFeedback('Este elemento ya fue colocado.', 'error');
            return;
        }
        if (categoriaDestino !== categoriaCorrecta) {
            elOrig.classList.remove('shake');
            void elOrig.offsetWidth;
            elOrig.classList.add('shake');
            setTimeout(() => elOrig.classList.remove('shake'), 400);
            flashZona(zona, 'error');
            mostrarFeedback('"' + nombreElemento + '" no pertenece aquí.', 'error');
            return;
        }

        // Colocación correcta
        asignaciones[idElemento] = categoriaDestino;
        elOrig.style.display = 'none';
        flashZona(zona, 'ok');
        crearElementoUbicado(idElemento, nombreElemento, zona);
        mostrarFeedback('✓ "' + nombreElemento + '" colocado.', 'success');
        actualizarProgreso();

        if (Object.keys(asignaciones).length === TOTAL_ELEMENTOS) {
            mostrarFeedback('✅ ¡Todos clasificados!', 'success');
        }
    }

    // ── DRAG & DROP (desktop) ────────────────────────────────────────────────
    document.querySelectorAll('.elemento-drag').forEach(el => {
        elementosOriginalesDnD.push({
            id: el.dataset.id,
            nombre: el.dataset.nombre,
            elemento: el,
            categoriaCorrecta: el.dataset.categoriaCorrecta
        });
        
        el.addEventListener('dragstart', function(e) {
            if (asignaciones[this.dataset.id]) {
                e.preventDefault();
                return false;
            }
            elementoDragActual = this;
            e.dataTransfer.setData('text/plain', this.dataset.id);
            this.classList.add('dragging');
        });
        el.addEventListener('dragend', function() {
            this.classList.remove('dragging');
            elementoDragActual = null;
        });
        // Soporte teclado (simular arrastre con Enter - simplificado)
        el.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                // Opcional: mostrar tooltip indicando que use ratón/táctil
                mostrarFeedback('Usa el ratón o la pantalla táctil para arrastrar', 'info');
            }
        });
    });

    document.querySelectorAll('.zona-destino').forEach(zona => {
        zona.addEventListener('dragover', function(e) { e.preventDefault(); this.classList.add('drag-over'); });
        zona.addEventListener('dragleave', function() { this.classList.remove('drag-over'); });
        zona.addEventListener('drop', function(e) {
            e.preventDefault();
            this.classList.remove('drag-over');
            if (!elementoDragActual) return;
            colocarElemento(this, elementoDragActual);
        });
    });

    // ── TOUCH (móvil) ──────────────────────────────────────────────────────
    document.querySelectorAll('.elemento-drag').forEach(el => {
        let touchClone = null;
        let offsetX = 0, offsetY = 0;

        el.addEventListener('touchstart', function(e) {
            if (asignaciones[this.dataset.id]) return;
            const touch = e.touches[0];
            const rect = this.getBoundingClientRect();
            offsetX = touch.clientX - rect.left;
            offsetY = touch.clientY - rect.top;
            touchClone = this.cloneNode(true);
            touchClone.style.cssText = 'position:fixed;z-index:9999;pointer-events:none;opacity:0.85;width:' + rect.width + 'px;';
            document.body.appendChild(touchClone);
            touchClone.style.left = (touch.clientX - offsetX) + 'px';
            touchClone.style.top  = (touch.clientY - offsetY) + 'px';
            this.style.opacity = '0.4';
            elementoDragActual = this;
        }, { passive: false });

        el.addEventListener('touchmove', function(e) {
            if (!touchClone) return;
            e.preventDefault();
            const touch = e.touches[0];
            touchClone.style.left = (touch.clientX - offsetX) + 'px';
            touchClone.style.top  = (touch.clientY - offsetY) + 'px';
        }, { passive: false });

        el.addEventListener('touchend', function(e) {
            if (!touchClone) return;
            touchClone.remove(); touchClone = null;
            this.style.opacity = '';
            const touch = e.changedTouches[0];
            const zonas = document.querySelectorAll('.zona-destino');
            let zonaTarget = null;
            zonas.forEach(z => {
                const r = z.getBoundingClientRect();
                if (touch.clientX >= r.left && touch.clientX <= r.right &&
                    touch.clientY >= r.top  && touch.clientY <= r.bottom) {
                    zonaTarget = z;
                }
            });
            if (zonaTarget) colocarElemento(zonaTarget, this);
            elementoDragActual = null;
        });
    });

    // ── REINICIAR CON CONFIRMACIÓN ─────────────────────────────────────────
    document.getElementById('btnReiniciar').addEventListener('click', function() {
        if (Object.keys(asignaciones).length > 0 && !confirm('¿Seguro que quieres reiniciar la actividad? Perderás todo el progreso actual.')) {
            return;
        }
        // Cancelar cualquier timeout de feedback
        if (feedbackTimeout) clearTimeout(feedbackTimeout);
        asignaciones = {};
        elementosOriginalesDnD.forEach(orig => {
            orig.elemento.style.display = 'block';
            orig.elemento.classList.remove('shake', 'dragging');
        });
        document.querySelectorAll('.elementos-colocados').forEach(c => c.innerHTML = '');
        document.querySelectorAll('.zona-destino').forEach(z => z.classList.remove('drop-ok','drop-error','drag-over'));
        document.getElementById('btnEnviar').disabled = true;
        document.getElementById('feedback').className = 'feedback';
        actualizarProgreso();
        mostrarFeedback('Actividad reiniciada', 'success');
    });

    // ── ENVÍO (con prevención de duplicados) ──────────────────────────────
    document.getElementById('btnEnviar').addEventListener('click', function(e) {
        if (enviando) return;
        if (Object.keys(asignaciones).length !== TOTAL_ELEMENTOS) {
            mostrarFeedback('❌ Clasificá todos los elementos antes de enviar.', 'error');
            return;
        }
        enviando = true;
        const btn = this;
        const textoOriginal = btn.innerHTML;
        btn.innerHTML = '⏳ Enviando...';
        btn.disabled = true;
        
        const respuestas = Object.entries(asignaciones).map(([idElemento, categoria]) => ({
            idElemento: parseInt(idElemento), categoria
        }));
        document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
        
        // Enviar formulario (la página recargará, así que no es necesario restaurar el botón)
        document.getElementById('formDnD').submit();
    });

    // Inicializar progreso
    actualizarProgreso();
</script>