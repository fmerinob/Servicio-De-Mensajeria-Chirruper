
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro</title>
    </head>
    <body>
        <%
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper","root","root"); 
            Statement query = con.createStatement();
            if(request.getParameter("agregar")!=null){
                if(request.getParameter("contrasena").equals(request.getParameter("contrasenaVerificar"))){
                    ResultSet rs = query.executeQuery("SELECT * FROM USUARIOS WHERE USUARIO = '" + request.getParameter("usuario") + "'");
                    if(rs.next()) {
                        out.println("Este usuario ya existe");
                    }
                    else{
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
