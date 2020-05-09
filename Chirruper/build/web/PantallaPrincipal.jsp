<%-- 
    Document   : PantallaPrincipal
    Created on : 9/05/2020, 12:11:15 PM
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
            if (request.getParameter("contrasena")!= null && request.getParameter("usuario")!= null){
                ResultSet rs = query.executeQuery("SELECT * FROM USUARIOS WHERE USUARIO = '" + request.getParameter("usuario") + "' AND CONTRASENA = '" + request.getParameter("contrasena") + "'");
                if(rs.next()) {
                    HttpSession mySession = request.getSession();
                    mySession.setAttribute("usuario", request.getParameter("usuario"));
                    mySession.setAttribute("contrasena", request.getParameter("contrasena"));
                    out.println("<a href = 'PantallaPublicacion.jsp'>¡Cuentanos lo que piensas!</a><br>");
                    out.println("<a href = 'PantallaUsuarios.jsp'>Busca nuevos usuarios, administra los ya existentes y mira quienes te siguen </a><br>");
                    out.println("<a href = 'PantallaChirrupeo.jsp'>¡Mira lo que tus chirrupers han puesto!</a>");
                }
                else{
                    response.sendRedirect("PantallaInicioSesion.jsp");
                }   
            } 
            else{
                response.sendRedirect("PantallaInicioSesion.jsp");
            }
        %>
    </body>
</html>
