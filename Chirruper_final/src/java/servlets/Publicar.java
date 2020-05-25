/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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

/**
 *
 * @author Polupero
 */
public class Publicar extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            String subject = request.getParameter("parametro2");
            ConnectionFactory connectionFactory = new ActiveMQConnectionFactory(url);
            javax.jms.Connection connection = connectionFactory.createConnection();
            connection.start();

            Session session = connection.createSession(false /*Transacter*/, Session.AUTO_ACKNOWLEDGE);
            Destination destination = session.createTopic(subject);

            messageProducer = session.createProducer(destination);
            textMessage = session.createTextMessage();

            textMessage.setText(request.getParameter("parametro"));
            System.out.println("Sending the following message: " + textMessage.getText());
            messageProducer.send(textMessage);

            //Quitar esto en la versión final, solo es para no dejar al escucha corriendo como loco
            //textMessage.setText("Good bye!");
            //System.out.println("Sending the following message: " + textMessage.getText());
            //messageProducer.send(textMessage);
            messageProducer.close();
            session.close();
            connection.close();
            
            
            
            
            
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            java.sql.Connection con2 = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper", "root", "root");
            Statement query = con2.createStatement();
            java.sql.Connection con3 = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper", "root", "root");
            Statement query2 = con3.createStatement();
            ResultSet rs = query2.executeQuery("SELECT * FROM SEGUIDORES WHERE CHIRRUPER = '" + subject + "'");
            while(rs.next()){
            query.executeUpdate("INSERT INTO MENSAJES VALUES ('" + subject + "', '" 
                    + textMessage.getText() + "', '" 
                    + new java.sql.Timestamp(textMessage.getJMSTimestamp()).toString() 
                    + "', '" + rs.getString("SEGUIDOR") + "')");
            }
            
        }
        catch (JMSException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Publicar.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Publicar.class.getName()).log(Level.SEVERE, null, ex);
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
