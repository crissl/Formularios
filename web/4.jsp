<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="espe.edu.ec.util.Uztasistentes"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="espe.edu.ec.models.PlanificacionTutorias"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    </head>
    <body>
        <%
                //conexion a la base de datos
                DB2 con = DB2.getInstancia();
                Connection co = con.getConnection();
                //Conexion WF
                DB2 conWF = DB2.getInstancia();
                Connection coWF = conWF.getConnectionWF();
                //importacion de librerias
                out.println(ConstantesForm.Css);
                out.println(ConstantesForm.js);

                Cookie cookie = null;
                Cookie[] cookies = null;
                String pidm = null;
                String id = null;
                cookies = request.getCookies();
                if (cookies != null) {
                    for (int i = 0; i < cookies.length; i++) {
                        cookie = cookies[i];
                        if (cookie.getName().equals("pidm")) {
                            pidm = cookie.getValue();
                        } else if (cookie.getName().equals("id")) {
                            id = cookie.getValue();
                        }
                    }
                } else {
                    out.println("<h2>No cookies founds</h2>");
                }

                int PIDMS = Integer.parseInt(pidm);
                LinkedList<Uztasistentes> listaAs = new LinkedList<Uztasistentes>();

                //Obtecion de los valores de los formularios
                String nomF = request.getParameter("Submit");
                int CodT = Integer.parseInt(nomF);
                String observaciones = request.getParameter("observaciones");
                String Nrcdr = request.getParameter("nrcdr");
                String var = request.getParameter("var");
                String resultados = request.getParameter("resultados");

                String CEDULA = request.getParameter("cedula");
                String NOMBRES = request.getParameter("nombres");
                String EMAIL = request.getParameter("emaili");
                String PAREMAIL = request.getParameter("emailp");

                String optradio = null;
                String stringdr = Nrcdr;
                String[] partsdr = stringdr.split(" - ");
                String codr = partsdr[0]; // 123

                ResultSet rs1 = co.prepareStatement("SELECT * FROM UTIC.UZTASISTENTES WHERE CODIGO_UZTPLANIF='" + codr + "'").executeQuery();
                while (rs1.next()) {
                    Uztasistentes asistentes = new Uztasistentes();
                    asistentes.setSpridenPidm(rs1.getInt(5));
                    listaAs.add(asistentes);
                }
                rs1.close();

                for (int i = 0; i < Integer.parseInt(var); i++) {
                    String name = "optradio_" + i;
                    optradio = request.getParameter(name);
                    try {
                        co.prepareStatement("UPDATE UTIC.UZTASISTENTES SET UZTASISTENTES_ASISTESN='" + optradio + "',UZTASISTENTES_OBSERVACION='" + observaciones + "' WHERE CODIGO_UZTPLANIF='" + codr + "' AND SPRIDEN_PIDM='" + listaAs.get(i).getSpridenPidm() + "' ").executeUpdate();
                        System.out.println("update confirmacion tutoria acompañamiento exitosamente");
                    } catch (SQLException r) {
                        System.out.println("Error update asistentes confirmacion tutoria acompañamiento");
                    }
                }

                try {
                    PreparedStatement ps = co.prepareStatement("UPDATE UTIC.UZTPLANIF SET UZTPLANIF_ESTADO=? WHERE CODIGO_UZTPLANIF='" + codr + "'");
                    ps.setString(1, "C");
                    ps.executeUpdate();
                } catch (Exception e) {
                    System.out.println("Error update uztplanif confirmacion tutoria acompañamiento: " + e);
                }
                
                String par_mensaje = " Se ha confirmado que usted " + optradio + " asistido a la tutoria";
                String par_mensajeprincipal = "";
                String par_notificacion1 = "";
                String par_notificacion2 = "";

                //Procedimiento Almacenado que envia el email al usuario
                coWF.prepareStatement("CALL wfobjects.wzwkreport.P_Envio_Emails('" + par_mensaje + "'" + ",'" + CEDULA + "'" + ",'" + NOMBRES + "'"
                        + ",'" + EMAIL + "'" + ",'" + PAREMAIL + "'" + ",'" + par_mensajeprincipal + "'" + ",'" + par_notificacion1 + "'" + ",'" + par_notificacion2 + "'"
                        + ")").executeQuery();
              
        %>
        <br>
        <div class="container">
            <div class="text alert alert-success" style="text-align: center;">
                <strong>
                    <p>
                        EL REGISTRO DE ASISTENCIA DE LA TUTORIA HA SIDO LLENADA EXITOSAMENTE.
                    </p>
                </strong> 
            </div>
        </div> 
        <%  out.println (

            "<meta http-equiv='refresh' content='1;URL=https://miespe.espe.edu.ec/'>");//redirects after 4 seconds  
            co.close ();

            con.closeConexion ();

            conWF.closeConexionWF ();%>
    </body>
</html>