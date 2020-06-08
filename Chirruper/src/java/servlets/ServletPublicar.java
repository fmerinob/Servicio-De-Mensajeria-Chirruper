package servlets;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.jms.*;
import org.apache.activemq.ActiveMQConnection;
import org.apache.activemq.ActiveMQConnectionFactory;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ServletPublicar extends HttpServlet {

    private static String url = ActiveMQConnection.DEFAULT_BROKER_URL;

    // default broker URL is : tcp://localhost:61616"

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        MessageProducer messageProducer;
        TextMessage textMessage;
        response.setContentType("text/html;charset=UTF-8");
        try {
            String subject = request.getParameter("usuario");
            ConnectionFactory connectionFactory = new ActiveMQConnectionFactory(url);
            javax.jms.Connection connection = connectionFactory.createConnection();
            connection.start();
            Session session = connection.createSession(false /*Transacter*/, Session.AUTO_ACKNOWLEDGE);
            Destination destination = session.createTopic(subject);
            messageProducer = session.createProducer(destination);
            textMessage = session.createTextMessage();
            textMessage.setText(request.getParameter("mensaje"));
            messageProducer.send(textMessage);
            messageProducer.close();
            session.close();
            connection.close();
            
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            java.sql.Connection con2 = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper", "root", "root");
            java.sql.Connection con3 = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper", "root", "root");
            Statement query = con2.createStatement();
            Statement query2 = con3.createStatement();
            ResultSet rs = query2.executeQuery("SELECT * FROM SUSCRIPCIONES WHERE SUSCRITO = '" + subject + "'");
            while(rs.next()){
            query.executeUpdate("INSERT INTO MENSAJES VALUES ('" + subject + "', '" + textMessage.getText() + "', '" + new java.sql.Timestamp(textMessage.getJMSTimestamp()).toString() + "', '" + rs.getString("SUSCRIBIDO") + "')");
            }
        }
        catch (JMSException e) {
        } 
        catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(ServletPublicar.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
