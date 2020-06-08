<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Publicar</title>
    </head>
    <body style="background-color:grey;">
        <%
            HttpSession mySession = request.getSession();
            if(mySession.getAttribute("usuario")==null){
                response.sendRedirect("Inicio.jsp");
            }
        %>
        <script>
            function Publicar(mensaje, usuario) {
                var ajaxRequest;
                if (window.XMLHttpRequest){
                    ajaxRequest=new XMLHttpRequest();
                } else {
                    ajaxRequest=new ActiveXObject("Microsoft.XMLHTTP");
                }
                ajaxRequest.onreadystatechange = function(){
                    if (ajaxRequest.readyState==4 && ajaxRequest.status==200){
                        document.getElementById("confirmacion").innerHTML="Se publicó con éxito tu mensaje";
                    }
                }
                ajaxRequest.open("GET", "ServletPublicar?mensaje=" + mensaje + "&usuario="+ usuario, true /*async*/);
                ajaxRequest.send();
            }
        </script>
        <h3>Escribir un chirrup</h3>
        <textarea id="mensaje" name="mensaje" style="width:300px; height:150px;"></textarea><br>
        <input type="submit" value="Publicar" onclick="Publicar(mensaje.value, usuario.value)"/>
        <p></p>
        <div id = confirmacion></div>
        <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
        <form action="Menu.jsp">
            <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
            <input type="hidden" name="contrasena" value="<%=mySession.getAttribute("contrasena")%>" />
            <input type="submit" value="Volver" />
        </form>
    </body>
</html>
