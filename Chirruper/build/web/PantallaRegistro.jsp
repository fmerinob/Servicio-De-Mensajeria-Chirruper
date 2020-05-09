<%-- 
    Document   : PantallaRegistro
    Created on : 9/05/2020, 12:12:33 PM
    Author     : Polupero
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper","root","root"); 
            Statement query = con.createStatement();
            if(request.getParameter("agregar")!=null){
                if(request.getParameter("contrasena").equals(request.getParameter("contrasenaVerificar"))){
                    System.out.println("h");
                    ResultSet rs = query.executeQuery("SELECT * FROM USUARIOS WHERE USUARIO = '" + request.getParameter("usuario") + "'");
                    System.out.println("ho");
                    if(rs.next()) {
                        System.out.println("jeje");
                        out.println("Este usuario ya existe");
                    }
                    else{
                        System.out.println("jaja");
                        query.executeUpdate("INSERT INTO USUARIOS VALUES ('"+request.getParameter("usuario")+"', '"+request.getParameter("contrasena")+"')");
                        out.println("Usuario registrado con éxito");
                    }
                }
                else{
                    out.println("Las contraseñas no coinciden");
                }
            }
        %>

        
        <form action="PantallaRegistro.jsp">
            <h1>¡Crea una cuenta con nosotros!</h1>
            <p>Introduce tu nuevo usuario: </p><input type="text" name="usuario" value="" /><br>
            <p>Introduce tu contraseña: </p><input type="password" name="contrasena" value="" /><br>
            <p>Repite tu contraseña: </p><input type="password" name="contrasenaVerificar" value="" /><br>
            <input type="submit" value="ok" name="agregar"/>
        </form>
        <form action="PantallaInicioSesion.jsp">
            <input type="submit" value="Volver" name="Volver"/>
        </form>
    </body>
</html>
