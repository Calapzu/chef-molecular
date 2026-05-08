<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.ParDipolo, com.chefmolecular.modelo.ActividadInteractiva, java.util.List" %>
<%
    List<ParDipolo> pares = (List<ParDipolo>) request.getAttribute("pares");
    java.util.Set<String> positivos = new java.util.LinkedHashSet<>();
    java.util.Set<String> negativos = new java.util.LinkedHashSet<>();
    if (pares != null) { for (ParDipolo p : pares) { positivos.add(p.getExtremoPositivo()); negativos.add(p.getExtremoNegativo()); } }
    int actividadIdx = (int) request.getAttribute("actividadIdx");
    int totalActividades = (int) request.getAttribute("totalActividades");
    int idEscenario = (int) request.getAttribute("idEscenario");
    ActividadInteractiva actividad = (ActividadInteractiva) request.getAttribute("actividad");
%>
<style>
    .actividad-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 16px; padding: 32px; margin-bottom: 24px; }
    .actividad-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; margin-bottom: 8px; }
    .actividad-desc { color: var(--text-dim); font-size: 13px; margin-bottom: 24px; }
    .mol-drag { padding: 12px 18px; border: 2px solid var(--cobre); border-radius: 60px; cursor: grab; font-size: 0.9rem; text-align: center; color: var(--text-ppal); transition: all 0.2s; box-shadow: 3px 3px 0 rgba(200,122,44,0.3); }
    .mol-drag:hover { transform: scale(1.02); }
    .zona-alineacion { background: rgba(210,150,100,0.05); border-radius: 16px; padding: 20px; border: 1px dashed var(--cobre); }
    .drag-over { background: rgba(200,122,44,0.15) !important; }
    .btn-verificar { background: var(--cobre); color: white; border: none; padding: 10px 24px; border-radius: 40px; cursor: pointer; font-weight: 600; font-family: 'DM Sans', sans-serif; margin-top: 20px; transition: all 0.2s; font-size: 0.85rem; }
    .btn-verificar:hover { background: #A93226; transform: translateY(-2px); }
    .btn-quitar { background: none; border: none; color: white; cursor: pointer; font-size: 14px; opacity: 0.7; }
    .btn-quitar:hover { opacity: 1; }
</style>

<div class="actividad-card">
    <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="actividad-desc">🥄 Arrastra cada extremo δ⁺ sobre el δ⁻ correcto para formar el par dipolo.</p>
    <div style="display:flex; gap:32px; align-items:flex-start; flex-wrap:wrap;">
        <div style="flex:1; min-width:180px;">
            <h4 style="color:var(--cobre);">Extremos δ⁺</h4>
            <div id="positivos-pool" style="display:flex; flex-direction:column; gap:12px; margin-top:12px;">
                <% for (String pos : positivos) {%>
                <div class="mol-drag" draggable="true" data-extremo="<%= pos%>" data-tipo="positivo" style="background:#FFE0C0; border-color:var(--incorrecto);"><%= pos%></div>
                <% }%>
            </div>
        </div>
        <div style="flex:1; min-width:180px;">
            <h4 style="color:var(--cobre);">Extremos δ⁻</h4>
            <div id="negativos-pool" style="display:flex; flex-direction:column; gap:12px; margin-top:12px;">
                <% for (String neg : negativos) {%>
                <div class="mol-drag" draggable="true" data-extremo="<%= neg%>" data-tipo="negativo" style="background:#D5F0E0; border-color:#2C7A4D;"><%= neg%></div>
                <% }%>
            </div>
        </div>
    </div>
    <div class="zona-alineacion" style="margin-top:24px;">
        <h4 style="color:var(--cobre);">Pares formados (arrastra aquí):</h4>
        <div id="pares-formados" style="display:flex; flex-wrap:wrap; gap:16px; min-height:80px; background:rgba(210,150,100,0.1); border-radius:12px; padding:16px; border:2px dashed var(--cobre);"></div>
        <button class="btn-verificar" onclick="prepararEnvioDipolos()">✅ Verificar pares</button>
        <div class="feedback" id="feedback"></div>
    </div>
    <form id="formMatch" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
        <input type="hidden" name="respuestas" id="respuestasJsonMatch">
    </form>
</div>

<script>
    let paresColocados = [];
    const paresFormadosDiv = document.getElementById('pares-formados');

    function mostrarFeedback(mensaje, tipo) {
        const fb = document.getElementById('feedback');
        if (!fb) return;
        fb.textContent = mensaje; fb.className = 'feedback ' + tipo;
        setTimeout(() => { fb.className = 'feedback'; }, 3000);
    }

    document.querySelectorAll('.mol-drag').forEach(el => {
        el.addEventListener('dragstart', function(e) { e.dataTransfer.setData('text/plain', JSON.stringify({extremo: this.dataset.extremo, tipo: this.dataset.tipo})); this.style.opacity = '0.4'; });
        el.addEventListener('dragend', function() { this.style.opacity = '1'; });
    });

    paresFormadosDiv.addEventListener('dragover', function(e) { e.preventDefault(); this.classList.add('drag-over'); });
    paresFormadosDiv.addEventListener('dragleave', function() { this.classList.remove('drag-over'); });
    paresFormadosDiv.addEventListener('drop', function(e) {
        e.preventDefault(); this.classList.remove('drag-over');
        try {
            const data = JSON.parse(e.dataTransfer.getData('text/plain'));
            if (!data.extremo || !data.tipo) return;
            if (paresColocados.some(p => (data.tipo==='positivo'&&p.positivo===data.extremo)||(data.tipo==='negativo'&&p.negativo===data.extremo))) { alert('Ese extremo ya fue emparejado.'); return; }
            const parIncompleto = paresColocados.find(p => (data.tipo==='positivo'&&!p.positivo)||(data.tipo==='negativo'&&!p.negativo));
            if (parIncompleto) { if (data.tipo==='positivo') parIncompleto.positivo=data.extremo; else parIncompleto.negativo=data.extremo; }
            else { paresColocados.push({positivo: data.tipo==='positivo'?data.extremo:null, negativo: data.tipo==='negativo'?data.extremo:null}); }
            actualizarParesUI();
        } catch(err) {}
    });

    function actualizarParesUI() {
        paresFormadosDiv.innerHTML = '';
        paresColocados.forEach((par, idx) => {
            const div = document.createElement('div');
            div.style.cssText = 'display:flex;align-items:center;gap:8px;background:var(--cobre);color:white;padding:8px 12px;border-radius:8px;';
            div.innerHTML = '<span>'+(par.positivo||'?')+'</span> ↔ <span>'+(par.negativo||'?')+'</span>';
            const btn = document.createElement('button');
            btn.textContent = '✖'; btn.className = 'btn-quitar';
            btn.onclick = () => { paresColocados.splice(idx, 1); actualizarParesUI(); };
            div.appendChild(btn); paresFormadosDiv.appendChild(div);
        });
    }

    function prepararEnvioDipolos() {
        const completos = paresColocados.filter(p => p.positivo && p.negativo);
        if (completos.length === 0) { mostrarFeedback('Debés formar al menos un par.', 'error'); return; }
        document.getElementById('respuestasJsonMatch').value = JSON.stringify(completos.map(p => ({extremoPositivo: p.positivo, extremoNegativo: p.negativo})));
        document.getElementById('formMatch').submit();
    }
</script>