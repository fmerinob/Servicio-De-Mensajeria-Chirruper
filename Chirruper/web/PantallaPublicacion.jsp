<%-- 
    Document   : PantallaPublicacion
    Created on : 9/05/2020, 12:13:02 PM
    Author     : Polupero
Se que parece inutl tener 2 veces el mismo input hidden para usuario, pero uno
es para el topic y otro es para el botón de regresar, investigar si hay una
mejor manera de regresar
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            HttpSession mySession = request.getSession();
            if(mySession.getAttribute("usuario")==null){
                response.sendRedirect("PantallaInicioSesion.jsp");
            }
        %>
        <script>
            function Publicar(param, param2) {
                var ajaxRequest;
                if (window.XMLHttpRequest){
                    ajaxRequest=new XMLHttpRequest();
                } else {
                    ajaxRequest=new ActiveXObject("Microsoft.XMLHTTP");
                }
                ajaxRequest.onreadystatechange = function(){
                    if (ajaxRequest.readyState==4 && ajaxRequest.status==200){
                        document.getElementById("divResultado").innerHTML="Se publicó con éxito tu mensaje";
                    }
                }
                ajaxRequest.open("GET", "Publicar?parametro=" + param + "&parametro2="+ param2, true /*async*/);
                ajaxRequest.send();
            }
            </script>
        <textarea id="mensaje" name="mensaje" value="¡Cuentanos que estas pensando!" style="width:300px; height:150px;"></textarea>
        <input type="submit" value="Publicar" onclick="Publicar(mensaje.value, usuario.value)"/>
        <div id = divResultado></div>
        <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
        <form action="PantallaPrincipal.jsp">
            <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
            <input type="hidden" name="contrasena" value="<%=mySession.getAttribute("contrasena")%>" />
            <input type="submit" value="Volver" />
        </form>
    </body>
</html>
