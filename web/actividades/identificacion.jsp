<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.FenomenoPropiedad, com.chefmolecular.modelo.ActividadInteractiva, java.util.List" %>
<%
    List<FenomenoPropiedad> fenomenos = (List<FenomenoPropiedad>) request.getAttribute("fenomenos");
    int actividadIdx = (int) request.getAttribute("actividadIdx");
    int totalActividades = (int) request.getAttribute("totalActividades");
    int idEscenario = (int) request.getAttribute("idEscenario");
    ActividadInteractiva actividad = (ActividadInteractiva) request.getAttribute("actividad");
%>
<% if (fenomenos == null || fenomenos.isEmpty()) {%>
<div class="actividad-card"><p>No hay fenómenos disponibles.</p></div>
<% } else {%>
<style>
    .actividad-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 16px; padding: 32px; margin-bottom: 24px; }
    .actividad-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; margin-bottom: 8px; }
    .actividad-desc { color: var(--text-dim); font-size: 13px; margin-bottom: 24px; }
</style>
<div class="actividad-card">
    <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="actividad-desc">🔬 Observá la animación y elegí la propiedad del líquido que se está mostrando.</p>
    <div id="visorFenomeno" style="text-align:center; margin:20px 0;">
        <canvas id="canvasFenomeno" width="300" height="150" style="background:#e0f7fa; border-radius:12px;"></canvas>
        <p id="descripcionFenomeno" style="margin-top:10px;"></p>
        <div id="botonesPropiedades" style="margin-top:15px; display:flex; gap:12px; justify-content:center; flex-wrap:wrap;">
            <button class="btn-opcion" onclick="seleccionarPropiedad('TENSION_SUPERFICIAL')">🌊 Tensión superficial</button>
            <button class="btn-opcion" onclick="seleccionarPropiedad('VISCOSIDAD')">🍯 Viscosidad</button>
            <button class="btn-opcion" onclick="seleccionarPropiedad('CAPILARIDAD')">🧪 Capilaridad</button>
        </div>
    </div>
    <button class="btn-accion" id="btnSiguiente" disabled onclick="siguienteFenomeno()">Siguiente ➡️</button>
    <button class="btn-accion" id="btnEnviarPropiedades" style="display:none;" onclick="enviarRespuestas()">✅ Enviar todas las respuestas</button>
    <div id="feedbackFenomeno" style="margin-top:15px; color:#f44336;"></div>
</div>
<form id="formPropiedades" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
    <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
    <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
    <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
    <input type="hidden" name="respuestas" id="respuestasPropiedadesJson">
</form>

<script>
    const canvasFen=document.getElementById('canvasFenomeno');
    const ctxFen=canvasFen.getContext('2d');
    let fenomenos=[];
    <% for (int i=0;i<fenomenos.size();i++){%>
    fenomenos.push({id:<%= fenomenos.get(i).getIdFenomeno()%>,descripcion:"<%= fenomenos.get(i).getDescripcion().replace("\"","\\\"")%>",correcta:"<%= fenomenos.get(i).getPropiedadCorrecta()%>"});
    <% }%>
    let indiceActual=0, respuestasProp=[], seleccionActual=null;

    function dibujarFenomeno(propiedad) {
        ctxFen.clearRect(0,0,canvasFen.width,canvasFen.height);
        if (propiedad==='TENSION_SUPERFICIAL'){ctxFen.fillStyle='#0288d1';ctxFen.fillRect(0,100,canvasFen.width,2);ctxFen.fillStyle='#000';ctxFen.font='30px serif';ctxFen.fillText('🦗',120,95);}
        else if (propiedad==='VISCOSIDAD'){ctxFen.fillStyle='#f57c00';ctxFen.beginPath();ctxFen.arc(150,50,10,0,Math.PI);ctxFen.fill();ctxFen.fillRect(145,50,10,40);}
        else if (propiedad==='CAPILARIDAD'){ctxFen.fillStyle='#0277bd';ctxFen.fillRect(140,80,20,10);ctxFen.fillRect(148,30,4,50);}
    }

    function mostrarFenomeno(indice) {
        if (indice>=fenomenos.length){
            document.getElementById('btnSiguiente').style.display='none';
            document.getElementById('botonesPropiedades').style.display='none';
            document.getElementById('descripcionFenomeno').innerText='Todos los fenómenos fueron clasificados.';
            document.getElementById('btnEnviarPropiedades').style.display='inline-block';
            return;
        }
        const f=fenomenos[indice];
        document.getElementById('descripcionFenomeno').innerText=f.descripcion;
        dibujarFenomeno(f.correcta); seleccionActual=null;
        document.getElementById('btnSiguiente').disabled=true;
        document.querySelectorAll('.btn-opcion').forEach(b=>b.style.background='');
    }

    function seleccionarPropiedad(propiedad) {
        seleccionActual=propiedad; document.getElementById('btnSiguiente').disabled=false;
        document.querySelectorAll('.btn-opcion').forEach(b=>{ b.style.background=b.getAttribute('onclick').includes(propiedad)?'#c8e6c9':''; });
    }

    function siguienteFenomeno() {
        if (!seleccionActual) return;
        respuestasProp.push({idFenomeno:fenomenos[indiceActual].id,propiedad:seleccionActual});
        indiceActual++; mostrarFenomeno(indiceActual);
    }

    function enviarRespuestas() {
        document.getElementById('respuestasPropiedadesJson').value=JSON.stringify(respuestasProp);
        document.getElementById('formPropiedades').submit();
    }

    mostrarFenomeno(0);
</script>
<% }%>