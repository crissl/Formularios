/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package espe.edu.ec.connection;

import java.sql.Connection;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author david
 */
public class DB2 {

    private Connection connection;
    private static DB2 instancia;
    private final static Logger LOGGER = Logger.getLogger("bitacora.subnivel.Control");

    public Connection getConnection() throws Exception {

        Context initContext;
        try {
            initContext = new InitialContext();
            connection = null;

            Context envContext = (Context) initContext.lookup("java:/comp/env");
            LOGGER.log(Level.INFO, "enviar conexion: " + envContext);

            DataSource dsd = (DataSource) envContext.lookup("jdbc/USERFORM");
            LOGGER.log(Level.INFO, "enviar conexion: " + dsd);

            try {
                connection = dsd.getConnection();
            } catch (SQLException ex) {
                Logger.getLogger(DB2.class.getName()).log(Level.SEVERE, null, ex);
                LOGGER.log(Level.INFO, "SQLException: " + ex);
            }
            LOGGER.log(Level.INFO, "connection: " + connection);
        } catch (NamingException ex) {
            Logger.getLogger(DB2.class.getName()).log(Level.SEVERE, null, ex);
            LOGGER.log(Level.INFO, "NamingException: " + ex);
        }
        return connection;
    }

    public void closeConexion() throws Exception {
        connection.close();
    }

    public Connection getConnectionWF() throws Exception {

        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            DataSource dsd = (DataSource) envContext.lookup("jdbc/USERFORM");
            connection = dsd.getConnection();
        } catch (NamingException | SQLException ex) {
            System.err.println(ex);
        }
        return connection;
    }

    public void closeConexionWF() throws Exception {
        connection.close();
        LOGGER.log(Level.INFO, " closeConexionWF: " + instancia);

    }

    public static DB2 getInstancia() throws Exception {
        LOGGER.log(Level.INFO, "INSTANCIA DB2 : " + instancia);
        if (instancia == null) {
            LOGGER.log(Level.INFO, "1er if de verificacion si instancia es vacia: " + instancia);
            synchronized (DB2.class) {
                if (instancia == null) {
                    LOGGER.log(Level.INFO, "2da if de verifiacion si instancia es vacia: " + instancia);
                    instancia = new DB2();
                    LOGGER.log(Level.INFO, "creacion de una instancia: " + instancia);
                } else {
                    instancia.closeConexion();
                    LOGGER.log(Level.INFO, "CIERRA la conexion:1 " + instancia);
                    instancia = new DB2();
                    LOGGER.log(Level.INFO, "nueva INSTANCIA DB2 :1 " + instancia);
                }
            }
        } else if (instancia.getConnection().isClosed()) {
            LOGGER.log(Level.INFO, "CIERRA la conexion:2 " + instancia);
            instancia = new DB2();
            LOGGER.log(Level.INFO, "nueva INSTANCIA DB2 :2 " + instancia);

        } else {
            instancia.closeConexion();
            LOGGER.log(Level.INFO, "CIERRA la conexion:3 " + instancia);
            instancia = new DB2();
            LOGGER.log(Level.INFO, "nueva INSTANCIA DB2 :3 " + instancia);
        }
        return instancia;
    }
}
