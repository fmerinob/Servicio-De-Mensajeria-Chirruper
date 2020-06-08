<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Consultar</title>
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
            if (request.getParameter("usuarios") != null) {
                query.executeUpdate("INSERT INTO SUSCRIPCIONES VALUES ('" + request.getParameter("usuario") + "', '" + request.getParameter("usuarios") + "')");
            }
            if (request.getParameter("seguidores") != null) {
                query.executeUpdate("DELETE FROM SUSCRIPCIONES WHERE SUSCRIBIDO='" + mySession.getAttribute("usuario") + "' AND SUSCRITO='" + request.getParameter("seguidores") + "'");
            }
        %>
        <p>Suscripciones:</p>
        <script>
            function Seguir(chirruper) {
                var ajaxRequest;
                if (window.XMLHttpRequest) {
                    ajaxRequest = new XMLHttpRequest();
                } else {
                    ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
                }
                ajaxRequest.onreadystatechange = function () {
                    if (ajaxRequest.readyState == 4 && ajaxRequest.status == 200) {
                        document.getElementById("resultado").innerHTML = ajaxRequest.responseText;
                    }
                }
                ajaxRequest.open("GET", "ServletConsultar?chirruper=" + chirruper, true);
                ajaxRequest.send();
            }
        </script>

        <%
            ResultSet rs = query.executeQuery("SELECT * FROM SUSCRIPCIONES WHERE SUSCRIBIDO = '" + mySession.getAttribute("usuario") + "'");
            out.println("<table>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<form action='Consultar.jsp'>");
                out.println("<td>");
                out.println(rs.getString("SUSCRITO"));
                out.println("<input type='hidden' name='seguidores' value='" + rs.getString("SUSCRITO") + "' />");
                out.println("</td>");
                out.println("<td>");
                out.println("<input type='submit' value='Desuscribirme'/>");
                out.println("</td>");
                out.println("</tr>");
                out.println("</form>");
            }
            out.println("</table>");
        %>
        <p></p>
        <p>Suscritos:</p>
        <%
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            rs = query.executeQuery("SELECT * FROM SUSCRIPCIONES WHERE SUSCRITO = '" + mySession.getAttribute("usuario") + "'");
            while (rs.next()) {
                out.println(rs.getString("SUSCRIBIDO") + "<br>");
            }
        %>
        <p></p>
        <p>Para suscribirte a otro chirruper, escribe su nombre completo: </p>
        <form action="Consultar.jsp">
            <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
            <input type="hidden" name="contrasena" value="<%=mySession.getAttribute("contrasena")%>" />
            <input type="text" name="usuarios" value=""  onkeyup="Seguir(this.value);"/>
            <input type="submit" value="Suscribir" />
        </form>
        <span id = "resultado"></span>
        <br>

        <!-- Botón para regresar -->
        <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
        <form action="Menu.jsp">
            <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
            <input type="hidden" name="contrasena" value="<%=mySession.getAttribute("contrasena")%>" />
            <input type="submit" value="Volver" />
        </form>
    </body>
</html>
