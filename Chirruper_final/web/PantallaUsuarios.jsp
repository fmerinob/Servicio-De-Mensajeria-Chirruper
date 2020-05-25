
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Usuarios que sigues</title>
    </head>
    <body>
        <%
            HttpSession mySession = request.getSession();
            if (mySession.getAttribute("usuario") == null) {
                response.sendRedirect("PantallaPrincipal.jsp");
            }

            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper", "root", "root");
            Statement query = con.createStatement();
            if (request.getParameter("chirps") != null) {
                query.executeUpdate("INSERT INTO SEGUIDORES VALUES ('" + request.getParameter("usuario") + "', '" + request.getParameter("chirps") + "')");
            }
            if (request.getParameter("userSeguidor") != null) {
                query.executeUpdate("DELETE FROM SEGUIDORES WHERE SEGUIDOR='" + mySession.getAttribute("usuario") + "' AND CHIRRUPER='" + request.getParameter("userSeguidor") + "'");
            }


        %>
        <h2>Estos son los usuarios que sigues</h2>
        <script>
            function Seguir(id, chirruper) {
                var ajaxRequest;
                if (window.XMLHttpRequest) {
                    ajaxRequest = new XMLHttpRequest();
                } else {
                    ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
                }

                ajaxRequest.onreadystatechange = function () {
                    if (ajaxRequest.readyState == 4 && ajaxRequest.status == 200) {
                        document.getElementById(id).innerHTML = ajaxRequest.responseText;
                    }
                }

                ajaxRequest.open("GET", "Seguir?chirruper=" + chirruper, true);
                ajaxRequest.send();
            }
        </script>

        <%            ResultSet rs = query.executeQuery("SELECT * FROM SEGUIDORES WHERE SEGUIDOR = '" + mySession.getAttribute("usuario") + "'");

            out.println("<table>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<form action='PantallaUsuarios.jsp'>");
                out.println("<td>");
                out.println(rs.getString("CHIRRUPER"));
                out.println("<input type='hidden' name='userSeguidor' value='" + rs.getString("CHIRRUPER") + "' />");
                out.println("</td>");
                out.println("<td>");
                out.println("<input type='submit' value='Dejar de seguir'/>");
                out.println("</td>");
                out.println("</tr>");
                out.println("</form>");
            }
            out.println("</table>");
        %>
        <h2>Los usuarios que te siguen: </h2>
        <%
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            rs = query.executeQuery("SELECT * FROM SEGUIDORES WHERE CHIRRUPER = '" + mySession.getAttribute("usuario") + "'");

            while (rs.next()) {
                out.println(rs.getString("SEGUIDOR") + "<br>");
            }

        %>
        <h2>¿Quieres seguir a un usuario?</h2>
        <form action="PantallaUsuarios.jsp">
            Ingresa el nombre del usuario a seguir:
            <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
            <input type="hidden" name="contrasena" value="<%=mySession.getAttribute("contrasena")%>" />
            <input type="text" name="chirps" value=""  onkeyup="Seguir('chips', this.value);"/>
            <input type="submit" value="Suscribir" />
        </form>


        <span id = "chips"></span>


        <br>

        <!-- Botón para regresar -->
        <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
        <form action="PantallaPrincipal.jsp">
            <input type="hidden" name="usuario" value="<%=mySession.getAttribute("usuario")%>" />
            <input type="hidden" name="contrasena" value="<%=mySession.getAttribute("contrasena")%>" />
            <input type="submit" value="Volver" />
        </form>
    </body>
</html>
