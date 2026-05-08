<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.MoleculaPuenteH, com.chefmolecular.modelo.ActividadInteractiva, java.util.List" %>
<%
    List<MoleculaPuenteH> moleculas = (List<MoleculaPuenteH>) request.getAttribute("moleculas");
    int actividadIdx = (int) request.getAttribute("actividadIdx");
    int totalActividades = (int) request.getAttribute("totalActividades");
    int idEscenario = (int) request.getAttribute("idEscenario");
    ActividadInteractiva actividad = (ActividadInteractiva) request.getAttribute("actividad");
%>
<style>
    .actividad-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 16px; padding: 32px; margin-bottom: 24px; }
    .actividad-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; margin-bottom: 8px; }
    .actividad-desc { color: var(--text-dim); font-size: 13px; margin-bottom: 24px; }
    .laboratorio-puentes { display: flex; gap: 24px; align-items: flex-start; flex-wrap: wrap; margin: 20px 0; }
    .moleculas-pool { display: flex; flex-wrap: wrap; gap: 12px; flex: 1; min-width: 200px; }
    .mol-chip { padding: 10px 16px; border-radius: 30px; cursor: pointer; font-weight: 500; border: 2px solid; transition: transform 0.2s; text-align: center; }
    .mol-chip.seleccionada { transform: scale(1.05); box-shadow: 0 0 0 3px rgba(0,0,0,0.2); }
    .zona-pares { flex: 1; min-width: 250px; display: flex; flex-direction: column; align-items: center; }
    .pares-formados { margin-top: 20px; }
    .pares-formados h4 { margin-bottom: 10px; }
    .par-item { display: flex; align-items: center; gap: 8px; background: var(--cobre); color: white; padding: 8px 12px; border-radius: 8px; margin-bottom: 8px; }
    .btn-limpiar { background: none; border: 1px solid var(--border); color: var(--text-dim); border-radius: 8px; padding: 8px 16px; font-size: 13px; cursor: pointer; margin-top: 10px; transition: all 0.2s; }
    .btn-limpiar:hover { color: var(--text-ppal); border-color: var(--cobre); }
    .btn-quitar { background: none; border: none; color: white; cursor: pointer; font-size: 14px; opacity: 0.7; }
    .btn-quitar:hover { opacity: 1; }
</style>

<div class="actividad-card">
    <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="actividad-desc">⚛️ Seleccioná dos moléculas que puedan formar un <strong>puente de hidrógeno</strong> (H unido a F, O o N).</p>
    <div class="laboratorio-puentes">
        <div class="moleculas-pool" id="moleculasPool">
            <% for (MoleculaPuenteH m : moleculas) {%>
            <div class="mol-chip" data-id="<%= m.getIdMolecula()%>" data-nombre="<%= m.getNombre()%>"
                 style="background:<%= m.isPuedeFormar() ? "#e8f5e9" : "#ffebee"%>; border-color:<%= m.isPuedeFormar() ? "#4caf50" : "#f44336"%>;">
                <%= m.getNombre()%>
            </div>
            <% }%>
        </div>
        <div class="zona-pares">
            <canvas id="canvasPuente" width="300" height="150" style="background:#fafafa; border-radius:12px; margin-bottom:10px;"></canvas>
            <button class="btn-accion" id="btnFormarPar" disabled>🔗 Formar par</button>
            <button class="btn-limpiar" id="btnLimpiarSeleccion">🧹 Limpiar selección</button>
        </div>
    </div>
    <div class="pares-formados" id="paresFormados"><h4>Pares formados:</h4><div id="listaPares"></div></div>
    <button class="btn-accion" id="btnEnviar" disabled>✅ Enviar respuestas</button>
    <div class="feedback" id="feedback"></div>
    <form id="formMatchPuentes" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
        <input type="hidden" name="respuestas" id="respuestasJsonPuentes">
    </form>
</div>

<script>
    let seleccionadas = [];
    let paresConfirmados = [];
    const canvas = document.getElementById('canvasPuente');
    const ctx = canvas.getContext('2d');
    const btnFormar = document.getElementById('btnFormarPar');
    const btnLimpiar = document.getElementById('btnLimpiarSeleccion');
    const listaPares = document.getElementById('listaPares');
    const btnEnviar = document.getElementById('btnEnviar');

    function mostrarFeedback(mensaje, tipo) {
        const fb = document.getElementById('feedback');
        if (!fb) return;
        fb.textContent = mensaje; fb.className = 'feedback ' + tipo;
        setTimeout(() => { fb.className = 'feedback'; }, 3000);
    }

    function dibujarCanvas(m1, m2, conectado) {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.strokeStyle = '#aaa'; ctx.lineWidth = 1;
        ctx.beginPath(); ctx.arc(80, 75, 30, 0, Math.PI*2); ctx.fillStyle = '#e3f2fd'; ctx.fill(); ctx.stroke();
        if (m1) { ctx.fillStyle='#333'; ctx.font='11px sans-serif'; ctx.textAlign='center'; ctx.fillText(m1.nombre.length>10?m1.nombre.substring(0,9)+'…':m1.nombre, 80, 79); }
        ctx.beginPath(); ctx.arc(220, 75, 30, 0, Math.PI*2); ctx.fillStyle='#e3f2fd'; ctx.fill(); ctx.stroke();
        if (m2) { ctx.fillStyle='#333'; ctx.textAlign='center'; ctx.fillText(m2.nombre.length>10?m2.nombre.substring(0,9)+'…':m2.nombre, 220, 79); }
        if (conectado) { ctx.beginPath(); ctx.moveTo(110,75); ctx.lineTo(190,75); ctx.strokeStyle='#4caf50'; ctx.lineWidth=3; ctx.setLineDash([5,3]); ctx.stroke(); ctx.setLineDash([]); }
    }

    document.querySelectorAll('.mol-chip').forEach(chip => {
        chip.addEventListener('click', function() {
            const id=parseInt(this.dataset.id), nombre=this.dataset.nombre;
            if (paresConfirmados.some(p=>p.id1===id||p.id2===id)) { mostrarFeedback('Esa molécula ya está en un par.', 'error'); return; }
            if (seleccionadas.length>=2) { mostrarFeedback('Solo podés seleccionar dos.', 'error'); return; }
            if (seleccionadas.find(m=>m.id===id)) { seleccionadas=seleccionadas.filter(m=>m.id!==id); this.classList.remove('seleccionada'); }
            else { seleccionadas.push({id,nombre,elemento:this}); this.classList.add('seleccionada'); }
            btnFormar.disabled=(seleccionadas.length!==2);
            btnLimpiar.disabled=(seleccionadas.length===0);
            dibujarCanvas(seleccionadas[0]||null, seleccionadas[1]||null, seleccionadas.length===2);
        });
    });

    btnLimpiar.addEventListener('click', () => { seleccionadas.forEach(m=>m.elemento.classList.remove('seleccionada')); seleccionadas=[]; btnFormar.disabled=true; dibujarCanvas(null,null,false); });

    btnFormar.addEventListener('click', () => {
        if (seleccionadas.length!==2) return;
        const [m1,m2]=seleccionadas;
        if (paresConfirmados.some(p=>(p.id1===m1.id&&p.id2===m2.id)||(p.id1===m2.id&&p.id2===m1.id))) { mostrarFeedback('Ese par ya fue formado.', 'error'); return; }
        paresConfirmados.push({id1:m1.id,id2:m2.id,nombre1:m1.nombre,nombre2:m2.nombre});
        const divPar=document.createElement('div'); divPar.className='par-item';
        divPar.innerHTML='<span>'+m1.nombre+'</span> ↔ <span>'+m2.nombre+'</span><button class="btn-quitar" data-id1="'+m1.id+'" data-id2="'+m2.id+'">✖</button>';
        listaPares.appendChild(divPar);
        divPar.querySelector('.btn-quitar').addEventListener('click', function(e) {
            e.stopPropagation();
            const i1=parseInt(this.dataset.id1), i2=parseInt(this.dataset.id2);
            paresConfirmados=paresConfirmados.filter(p=>!(p.id1===i1&&p.id2===i2));
            this.parentElement.remove(); btnEnviar.disabled=(paresConfirmados.length===0);
        });
        seleccionadas.forEach(m=>m.elemento.classList.remove('seleccionada'));
        seleccionadas=[]; btnFormar.disabled=true; dibujarCanvas(null,null,false); btnEnviar.disabled=false;
    });

    btnEnviar.addEventListener('click', () => {
        if (paresConfirmados.length===0) { mostrarFeedback('Debés formar al menos un par.', 'error'); return; }
        document.getElementById('respuestasJsonPuentes').value=JSON.stringify(paresConfirmados.map(p=>({idMolecula1:p.id1,idMolecula2:p.id2})));
        document.getElementById('formMatchPuentes').submit();
    });
</script>