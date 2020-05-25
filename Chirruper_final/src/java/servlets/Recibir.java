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
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.activemq.ActiveMQConnection;
import org.apache.activemq.ActiveMQConnectionFactory;

/**
 *
 * @author Polupero
 */
public class Recibir extends HttpServlet {
    
    private static String url = ActiveMQConnection.DEFAULT_BROKER_URL;

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
        
        boolean goodByeReceived = false;
        
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            System.out.println(request.getParameter("parametro"));
            String subject = request.getParameter("parametro");
            ConnectionFactory connectionFactory = new ActiveMQConnectionFactory(url);
            javax.jms.Connection connection = connectionFactory.createConnection();
            connection.start();

            Session session = connection.createSession(false /*Transacter*/, Session.AUTO_ACKNOWLEDGE);

            System.out.println(subject);
            
            Destination destination = session.createTopic(subject);

            System.out.println(destination);
            
            MessageConsumer messageConsumer = session.createConsumer(destination);
            while (!goodByeReceived) {
                System.out.println("Waiting for messages...");
                TextMessage textMessage = (TextMessage) messageConsumer.receive();
                
                if (textMessage != null) {
                    System.out.print("Received the following message: ");
                    System.out.println(textMessage.getText());
                    System.out.println();
                    
                    
                    
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    java.sql.Connection con2 = DriverManager.getConnection("jdbc:derby://localhost:1527/Chirruper", "root", "root");
                    Statement query = con2.createStatement();
                    
                    query.executeUpdate("INSERT INTO MENSAJES VALUES ('" + subject + "', '" + textMessage.getText() + "', '" + textMessage.getJMSTimestamp() + "')");
            
        
                }
                if (textMessage.getText() != null && textMessage.getText().equals("Good bye!")) {
                    goodByeReceived = true;
                }
            }
            messageConsumer.close();
            session.close();
            connection.close();
        }
        catch (JMSException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Recibir.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Recibir.class.getName()).log(Level.SEVERE, null, ex);
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
