<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chirrupeo</title>
    </head>
    <body >

        <%
            HttpSession mySession = request.getSession();
            if (mySession.getAttribute("usuario") == null) {
                response.sendRedirect("PantallaPrincipal.jsp");
            }

            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper", "root", "root");
            Statement query = con.createStatement();
            ResultSet rs = query.executeQuery("SELECT * FROM SEGUIDORES WHERE SEGUIDOR = '" + mySession.getAttribute("usuario") + "'");

            out.write("<h2>Esto es lo que otros chirrupers estan diciendo: </h2>");
            while(rs.next()){
                Statement query2 = con.createStatement();
                ResultSet rs2 = query2.executeQuery("SELECT * FROM MENSAJES WHERE CHIRRUP = '" + rs.getString("CHIRRUPER")+"' AND RECEPTOR='"+mySession.getAttribute("usuario") + "'");
                
                out.write("<h3>"+ rs.getString("CHIRRUPER")+ " dice: "+"</h3>");
               
                out.write("<table>");
                
                while(rs2.next()){
                    out.write("<tr>");
                    out.write("<td>");
                    out.write(rs2.getString("MSG")+"");
                    out.write("</td>");
                    out.write("<td>");
                    out.write("Enviado el " + rs2.getString("TIME"));
                    out.write("</td>");
                    out.write("</tr>");
                    Statement query3 = con.createStatement();
                    query3.executeUpdate("DELETE FROM MENSAJES WHERE MSG='"+rs2.getString("MSG")+"' AND TIME='"+rs2.getString("TIME")+"' AND RECEPTOR='"+mySession.getAttribute("usuario")+"'");
                }
                out.write("</table>");
                
                }
  
        %>

        <form action="PantallaPrincipal.jsp">
            <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
            <input type="hidden" name="contrasena" value="<%=mySession.getAttribute("contrasena")%>" />
            <input type="submit" value="Volver" />
        </form>

    </body>
</html>