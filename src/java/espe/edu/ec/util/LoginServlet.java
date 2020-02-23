/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package espe.edu.ec.util;

import espe.edu.ec.connection.DB2;
import espe.edu.ec.decrypt.DecryptSmAtrix;
import espe.edu.ec.models.Usuario;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.Cookie;
import espe.edu.ec.constant.ConstantesForm;

/**
 *
 * @author D4ve
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final static Logger LOGGER = Logger.getLogger("bitacora.subnivel.Control");

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
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out;
        out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        } finally {
            out.close();
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
        Cookie[] requestCookies = request.getCookies();
        String str = null;
        for (Cookie c : requestCookies) {
            if (c.getName().equals("user")) {
                str = c.getValue();
            }
        }
        System.out.println(str);
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
        Usuario user = new Usuario();
        DecryptSmAtrix dec = new DecryptSmAtrix();
        try {
            String id = null;
            int PIDM = 0;
            String param = request.getParameter("param");
            String type = request.getParameter("type");

            if (param.equalsIgnoreCase("null")) { //LOCAL
                PIDM = ConstantesForm.pidmUser;
                param = "bccd67a1d7973a4109ab65c82680c115";
                id = ConstantesForm.id;
                LOGGER.log(Level.INFO, "LOCAL");
                LOGGER.log(Level.INFO, "ADMIN: " + ConstantesForm.admin);
                LOGGER.log(Level.INFO, "HD: " + ConstantesForm.helpDesk);

            } else {//PROD
                id = new String(dec.decrypt(param));
                PIDM = obtenerPIDM(id);
                LOGGER.log(Level.INFO, "PROD");

            }
            LOGGER.log(Level.INFO, "ID" + id);
            user.setPIDM(PIDM);
            String pidm = Integer.toString(PIDM);
            String action = (request.getPathInfo() != null ? request.getPathInfo() : "");
            Cookie pidmCookie = new Cookie("pidm", pidm);
            Cookie idCookie = new Cookie("id", id);
            LOGGER.log(Level.INFO, "pidm" + pidm);
            response.addCookie(pidmCookie);
            response.addCookie(idCookie);
            if (param != null && type != null) {
                System.out.println("tutorias");
                switch (type) {
                    case "pr":
                        System.out.println("planificacion de tutoria de reforzamiento");
                        response.sendRedirect("planificacioReforzamiento.jsp");
                        break;
                    case "sr":
                        System.out.println("solicitid de tutoria de reforzamiento");
                        response.sendRedirect("solicitudReforzamiento.jsp");

                        break;
                    case "pa":
                        System.out.println("planificacion de tutoria de acompanamiento");
                        response.sendRedirect("planificacionAcompanamiento.jsp");

                        break;
                    case "r":
                        System.out.println("registro");
                        response.sendRedirect("registroAsistencia.jsp");

                        break;
                    case "sa":
                        System.out.println("solicitud de tutoria de acompanamiento");
                        response.sendRedirect("solicitudAcompanamiento.jsp");

                        break;
                    case "c":
                        System.out.println("confirmacion");
                        response.sendRedirect("confirmacionTutoria.jsp");

                        break;

                }
            }
            if (ConstantesForm.admin.contains(PIDM)) {
                response.sendRedirect("mostrarFormulario.jsp"); //logged-in page   
            } else if (ConstantesForm.helpDesk.contains(PIDM)) {       //if (isValid(user)) {
                response.sendRedirect("mostrarFormulario.jsp"); //logged-in page   
            } else {
                response.sendRedirect("GRes_Usuarios.jsp?param=" + param);
            }//error page 

            if (action.equals("uploadServlet")) {
                response.sendRedirect("mostrarGRes.jsp");
            }
        } catch (Exception e) {
            System.out.println("EXCEPTION: " + e);
            LOGGER.log(Level.WARNING, "theException" + e);
        }
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

    public boolean isValid(Usuario user) throws Exception {
        boolean isValid = false;
        try {
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            Integer pidm = user.getPIDM();
            if (pidm != null) {
                ResultSet rs = co.prepareStatement("SELECT COUNT(UZTUSER_PIDM) FROM UTIC.UZTPRUS WHERE UZTUSER_PIDM = " + pidm + "AND UZTPROC_ID=1 AND UZTPRUS_ESTADO='A' AND UZTSIST_ID=6").executeQuery();

                LOGGER.log(Level.INFO, "user.getPIDM() {}" + user.getPIDM());

                int rows = 0;

                if (rs.next()) {
                    rows = rs.getInt(1);
                }
                LOGGER.log(Level.INFO, "ROWS {0}", rows);
                if (rows > 0) {
                    isValid = true;
                    LOGGER.log(Level.INFO, "Usuario Administrador");
                } else {
                    LOGGER.log(Level.INFO, "Usuario comun");
                }
            } else {
                LOGGER.log(Level.INFO, "Pidem nulo");
            }
            con.closeConexion();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "not isValid" + e);
        }

        return isValid;
    }

    public int obtenerPIDM(String id) throws SQLException, Exception {
        int PIDM = 0;
        LOGGER.log(Level.INFO, "obtenerPIDM id: " + id);
        DB2 con = DB2.getInstancia();
        LOGGER.log(Level.INFO, "Conexion: " + con);

        try {
            if (!id.isEmpty()) {

                LOGGER.log(Level.INFO, "obtenerPIDM2: {0}", PIDM);

                Connection co = con.getConnection();
                LOGGER.log(Level.INFO, "conexion2: {0}", co);

                ResultSet rs = co.prepareStatement("SELECT DISTINCT SPRIDEN_PIDM as estPIDM FROM SATURN.SPRIDEN WHERE SPRIDEN.SPRIDEN_ID = '" + id + "' AND SPRIDEN.SPRIDEN_CHANGE_IND IS NULL").executeQuery();
                LOGGER.log(Level.INFO, "select : {0}", rs);

                if (rs.next()) {
                    PIDM = rs.getInt(1);
                    LOGGER.log(Level.INFO, "selectPIDM : {0}" + PIDM);

                }
                LOGGER.log(Level.INFO, "PIDM: {0}", PIDM);

            } else {
                LOGGER.log(Level.INFO, "Id es nulo: {0}", id);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "obtenerPIDM: {0}", e);
        } finally {
            con.closeConexion();
        }
        return PIDM;
    }
}
