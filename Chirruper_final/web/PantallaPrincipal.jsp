
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inicio</title>
    </head>
    <body>
        <%
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper", "root", "root");
            Statement query = con.createStatement();
            List<String> list1 = new ArrayList();
            if (request.getParameter("contrasena") != null && request.getParameter("usuario") != null) {
                ResultSet rs = query.executeQuery("SELECT * FROM USUARIOS WHERE USUARIO = '" + request.getParameter("usuario") + "' AND CONTRASENA = '" + request.getParameter("contrasena") + "'");
                if (rs.next()) {
                    HttpSession mySession = request.getSession();
                    mySession.setAttribute("usuario", request.getParameter("usuario"));
                    mySession.setAttribute("contrasena", request.getParameter("contrasena"));
                    out.println("<a href = 'PantallaPublicacion.jsp'>¡Cuentanos lo que piensas!</a><br>");
                    out.println("<a href = 'PantallaUsuarios.jsp'>Busca nuevos usuarios, administra los ya existentes y mira quienes te siguen </a><br>");
                    out.println("<a href = 'PantallaChirrupeo.jsp' >¡Mira lo que tus chirrupers han puesto!</a>");
                } else {
                    response.sendRedirect("PantallaInicioSesion.jsp");
                }

                rs = query.executeQuery("SELECT * FROM SEGUIDORES WHERE SEGUIDOR = '" + request.getParameter("usuario") + "'");

                String chirruper;
                
                while (rs.next()) {
                    String usuario = rs.getString("CHIRRUPER");
                    list1.add(usuario);
                }
                System.out.println(list1);

            } else {
                response.sendRedirect("PantallaInicioSesion.jsp");
            }
        %>

        <script>
            function Recibir() {
                var idArray = <%=list1.toString().replace("[", "['").replace(", ", "', '").replace("]", "']")%>;
                var len2 = idArray.length;
                if (len2 != 0) {
                    for (index = 0; index < len2; index = index + 1) {
                        var nombreUsuario = idArray[index];
                        var ajaxRequest;
                        if (window.XMLHttpRequest) {
                            ajaxRequest = new XMLHttpRequest();
                        } else {
                            ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
                        }
                        ajaxRequest.onreadystatechange = function () {
                            if (ajaxRequest.readyState == 4 && ajaxRequest.status == 200) {
                                document.getElementById(nombreUsuario).innerHTML = ajaxRequest.responseText;
                                console.log(ajaxRequest.responseText);
                            }
                        }
                        ajaxRequest.open("GET", "Recibir?parametro=" + nombreUsuario, true);
                        ajaxRequest.send();
                    }
                }
            }
        </script>
    </body>
</html>
