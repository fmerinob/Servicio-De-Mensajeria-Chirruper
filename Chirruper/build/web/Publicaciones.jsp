<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Publicaciones</title>
    </head>
    <body style="background-color:grey;">

        <%
            HttpSession mySession = request.getSession();
            if (mySession.getAttribute("usuario") == null) {
                response.sendRedirect("Menu.jsp");
            }
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper", "root", "root");
            Statement query = con.createStatement();
            ResultSet rs = query.executeQuery("SELECT * FROM SUSCRIPCIONES WHERE SUSCRIBIDO = '" + mySession.getAttribute("usuario") + "'");
            while(rs.next()){
                Statement query2 = con.createStatement();
                ResultSet rs2 = query2.executeQuery("SELECT * FROM MENSAJES WHERE EMISOR = '" + rs.getString("SUSCRITO")+"' AND RECEPTOR='"+mySession.getAttribute("usuario") + "'");
                out.write("<p>Chirrups de: "+ rs.getString("SUSCRITO")+"</p>");
                out.write("<table>");
                while(rs2.next()){
                    out.write("<tr>");
                    out.write("<td>");
                    out.write(rs2.getString("MENSAJE")+"");
                    out.write("</td>");
                    out.write("<td>");
                    out.write("Este mensaje se publicó en: " + rs2.getString("TIMESTAMP"));
                    out.write("</td>");
                    out.write("</tr>");
                    Statement query3 = con.createStatement();
                    query3.executeUpdate("DELETE FROM MENSAJES WHERE MENSAJE='"+rs2.getString("MENSAJE")+"' AND TIMESTAMP='"+rs2.getString("TIMESTAMP")+"' AND RECEPTOR='"+mySession.getAttribute("usuario")+"'");
                }
                out.write("</table>");
                }
        %>

        <form action="Menu.jsp">
            <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
            <input type="hidden" name="contrasena" value="<%=mySession.getAttribute("contrasena")%>" />
            <input type="submit" value="Volver" />
        </form>

    </body>
</html>