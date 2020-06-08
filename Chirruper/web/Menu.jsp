<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Menu</title>
    </head>
    <body style="background-color:grey;">
        <%
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper", "root", "root");
            Statement query = con.createStatement();
            if (request.getParameter("contrasena") != null && request.getParameter("usuario") != null) {
                ResultSet rs = query.executeQuery("SELECT * FROM USUARIOS WHERE USUARIO = '" + request.getParameter("usuario") + "' AND CONTRASENA = '" + request.getParameter("contrasena") + "'");
                if (rs.next()) {
                    HttpSession mySession = request.getSession();
                    mySession.setAttribute("usuario", request.getParameter("usuario"));
                    mySession.setAttribute("contrasena", request.getParameter("contrasena"));
                    out.println("<center><a href = 'Publicar.jsp'>Publicar un chirrup</a></center><br>");
                    out.println("<center><a href = 'Consultar.jsp'>Administra los usuarios que sigues </a></center><br>");
                    out.println("<center><a href = 'Publicaciones.jsp'>Ver chirrups</a></center>");
                } else {
                    response.sendRedirect("Inicio.jsp");
                }
            } else {
                response.sendRedirect("Inicio.jsp");
            }
        %>
    </body>
</html>
