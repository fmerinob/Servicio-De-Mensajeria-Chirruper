<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CrearCuenta</title>
    </head>
    <body style="background-color:grey;">
        <%
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper","root","root"); 
            Statement query = con.createStatement();
            if(request.getParameter("agregar")!=null){
                if(request.getParameter("contrasena").equals(request.getParameter("contrasenaVerificar"))){
                    ResultSet rs = query.executeQuery("SELECT * FROM USUARIOS WHERE USUARIO = '" + request.getParameter("usuario") + "'");
                    if(rs.next()) {
                        out.println("Este nombre de usuario ya esta ocupado");
                    }
                    else{
                        query.executeUpdate("INSERT INTO USUARIOS VALUES ('"+request.getParameter("usuario")+"', '"+request.getParameter("contrasena")+"')");
                        out.println("Se ha registrado exitosamente");
                    }
                }
                else{
                    out.println("Las contraseñas no coinciden");
                }
            }
        %>
        
        <form action="CrearCuenta.jsp">
            <p>Usuario: </p><input type="text" name="usuario" value="" /><br>
            <p>Contraseña: </p><input type="password" name="contrasena" value="" /><br>
            <p>Confirma tu contraseña: </p><input type="password" name="contrasenaVerificar" value="" /><br>
            <p></p>
            <input type="submit" value="Crear cuenta" name="agregar"/>
        </form>
        <form action="Inicio.jsp">
            <p></p>
            <input type="submit" value="Volver" name="Volver"/>
        </form>
    </body>
</html>
