<%-- 
    Document   : PantallaInicioSesion
    Created on : 9/05/2020, 12:12:19 PM
    Author     : Polupero
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="PantallaPrincipal.jsp">
            <p>Introduce tu usuario: </p><input type="text" name="usuario" value="" />
            <p>Introduce tu contraseña: </p><input type="password" name="contrasena" value="" /><br>
            <input type="submit" value="Iniciar Sesión" />
        </form>
        <form action="PantallaRegistro.jsp">
            <input type="submit" value="No tengo una cuenta" />
        </form>
    </body>
</html>
