<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.Instant"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.models.FormPersona"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="espe.edu.ec.models.Usuario"%> <!-- import de Usuario -->
<%@page session="true" %> <!-- Se agrega a modo de validacion -->
<!DOCTYPE html>
<%
    Cookie cookie = null;
    Cookie[] cookies = null;
    String pidm = null;
    String id = null;
    cookies = request.getCookies();
    if (cookies
            != null) {
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
    //PAS8
    DB2 con2 = DB2.getInstancia();
    Connection co2 = con2.getConnection();
    //request publicar Usuario
    String query = request.getParameter("query");
    String query1 = request.getParameter("query1");
    String fechaInicio = request.getParameter("fechaInicio");
    String fechaFin = request.getParameter("fechaFin");
    String tF = request.getParameter("tipoFormulario");
    String eF = request.getParameter("estadoSeg");
    String EO = request.getParameter("estadoPublicacion");
    String nomF = request.getParameter("Submit");
    int codF = Integer.parseInt(nomF);
    java.util.Date date = new java.util.Date();
    //  Instant time = Instant.now();
    long t = date.getTime();
    java.sql.Date sqlDate = new java.sql.Date(t);
    String queryF = "\"" + query + "\"";

    DateFormat originalFormat = new SimpleDateFormat("yyyy-MM-dd");
    DateFormat targetFormat = new SimpleDateFormat("dd/MM/yyyy");
    Date FechaInicio = originalFormat.parse(fechaInicio);
    String FECHAINICIO = targetFormat.format(FechaInicio);
    Date FechaFin = originalFormat.parse(fechaFin);
    String FECHAFIN = targetFormat.format(FechaFin);

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /*EJ-ECUCION QUERY PARA EXTRAER PIDM*/
    LinkedList<Integer> listaPIDM = new LinkedList<Integer>();
    LinkedList<Integer> PIDM = new LinkedList<Integer>();
    LinkedList<Integer> PIDMvalidacion = new LinkedList<Integer>();
    LinkedList<FormPersona> listaFP = new LinkedList<FormPersona>();
    LinkedList<FormPersona> listaValidacion = new LinkedList<FormPersona>();
    LinkedList<String> pidmID = new LinkedList<String>();

    int PIDMS = Integer.parseInt(pidm);
    if (ConstantesForm.admin.contains(PIDMS)) { %>
<html>
    <head>
        <title>Estado Publicación</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
        %>    </head>
    <body>
        <div>
            <div class="row bg-default">
                <!-- <div class="col-md-2"><center><img src="espelogo.jpg"/></center></div> -->
                <div class="col-md-8"><center><h1>Gestion de Formularios</h1></center></div>
                <div class="col-md-2"></div>
            </div>
        </div>
        <%
            request.setCharacterEncoding("UTF-8");
            if (query.isEmpty()) {
                //query != null && !query.isEmpty(
                try {
                    ResultSet rs2 = co2.prepareStatement(query1).executeQuery();
                    int codPIDM = 0;
                    while (rs2.next()) {
                        codPIDM = (rs2.getInt(1));
                        listaPIDM.add(codPIDM);
                    }
                    rs2.close();
                } catch (Exception ex) {
                    out.println("Error en sacar pidms" + ex);
                }
                /*obtenemos los datos de la tabla formulario_persona para hacer el codigo sin repeticion*/
                ResultSet rs1 = co2.prepareStatement("SELECT * FROM UTIC.UZGTFORMULARIO_PERSONA order by codigo_UZGTFORMULARIOS_PERSONA ASC").executeQuery();
                while (rs1.next()) {
                    FormPersona fp = new FormPersona();
                    fp.setPidm(rs1.getInt(1));
                    fp.setCodFormP(rs1.getInt(2));
                    listaFP.add(fp);
                }
                rs1.close();
                ///////////////////////////////////////////////
                /*INSERT TABLA PIDM*/
                Date Fecha = new Date();
                java.sql.Date FechaSql = new java.sql.Date(Fecha.getYear(), Fecha.getMonth(), Fecha.getDate());
                //////////////////////////////////////////////
                /*INSERT FORMULARIO -PERSONA*/
                int cod = 0;
                if (listaFP.isEmpty()) {
                    cod = 1;
                } else {
                    cod = listaFP.getLast().getCodFormP() + 1;
                }
                try {

                    String sql = "INSERT INTO UTIC.UZGTFORMULARIO_PERSONA (SPRIDEN_PIDM,CODIGO_UZGTFORMULARIOS_PERSONA,CODIGO_UZGTFORMULARIOS,UZGTFORMULARIOS_PERSONA_FECHA,UZGTFORMULARIOS_ESTADO_SEG,UZGTFORMULARIOS_ESTADO_LLENADO,UZGTFORMULARIOS_FECHA_CREA,UZGTFORMULARIOS_USUA_CREA) VALUES (?,?,?,?,?,?,?,?)";
                    PreparedStatement ps = co2.prepareStatement(sql);
                    for (int i = 0; i < listaPIDM.size(); i++) {
                        ps.setInt(1, listaPIDM.get(i));
                        ps.setInt(2, cod + i);
                        ps.setInt(3, codF);
                        ps.setDate(4, sqlDate);
                        ps.setString(5, eF);
                        ps.setString(6, "N");
                        ps.setDate(7, sqlDate);
                        ps.setInt(8, listaPIDM.get(i));
                        ps.executeUpdate();
                    }
                } catch (Exception e) {
                    System.out.println("Error auditoria insert en formulario persona  ESTADO PUBLICACION MULTIPLES: " + e);
                }
                //////////////////////////////////////////////////////////////////////////////////
                /*UPDATE TABLA FORMULARIOS*/
                try {
                    String cadena = query1;
                    String aux = "";
                    String apos = "'";
                    for (int i = 0; i < cadena.length(); i++) {
                        if (cadena.charAt(i) == apos.charAt(0)) {
                            aux = aux + cadena.charAt(i) + "'";
                        } else {
                            aux = aux + cadena.charAt(i);
                        }
                    }
                    co2.prepareStatement("UPDATE UTIC.UZGTFORMULARIOS SET  UZGTFORMULARIOS_FECHA_INICIO='" + FECHAINICIO + "', UZGTFORMULARIOS_FECHA_FIN='" + FECHAFIN + "', UZGTFORMULARIOS_ESTADO=" + 1 + ", UZGTFORMULARIOS_EO=" + tF + ", UZGTFORMULARIOS_QUERY_P= '" + aux + "' WHERE CODIGO_UZGTFORMULARIOS =" + codF + "").executeUpdate();
                    try {
                        PreparedStatement ps = co2.prepareStatement("UPDATE UTIC.UZGTFORMULARIOS SET UZGTFORMULARIOS_FECHA_MODIF= ?,UZGTFORMULARIOS_USUA_MODIF=? WHERE CODIGO_UZGTFORMULARIOS =" + codF + "");
                        ps.setDate(1, sqlDate);
                        ps.setString(2, pidm);
                        ps.executeUpdate();
                    } catch (Exception e) {
                        System.out.println("Auditoria modificar formularioS ESTADO PUBLICACION MULTIPLES: " + e);
                    }
                } catch (Exception ex) {
                    out.println("Error update " + ex);
                }
                out.println("<meta http-equiv='refresh' content='2;URL=mostrarFormulario.jsp'>");//redirects after 2 seconds    

        %> 
        <div class="container">
            <div class="text alert alert-success" style="text-align: center;">
                <strong>
                    <p>
                        Formularios Publicados Exitosamente
                    </p>
                </strong> 
            </div>
        </div>        
        <%        } else {
            try {
                ResultSet rs2 = co2.prepareStatement("SELECT DISTINCT  SPRIDEN_PIDM, SPRIDEN_ID "
                        + "FROM SPRIDEN WHERE SPRIDEN_CHANGE_IND IS NULL AND SPRIDEN_ID IN('" + query + "')").executeQuery();
                int codPIDM = 1;
                String pidmId = "";
                while (rs2.next()) {
                    codPIDM = (rs2.getInt(1));
                    pidmId = (rs2.getString(2));
                    listaPIDM.add(codPIDM);
                    pidmID.add(pidmId);
                }
                rs2.close();
            } catch (Exception ex) {
                out.println("Error en sacar pidms" + ex);
            }
            /*obtenemos los datos de la tabla formulario_persona para hacer el codigo sin repeticion*/
            ResultSet rs1 = co2.prepareStatement("SELECT * FROM UTIC.UZGTFORMULARIO_PERSONA "
                    + "order by codigo_UZGTFORMULARIOS_PERSONA ASC").executeQuery();
            while (rs1.next()) {
                FormPersona fp = new FormPersona();
                fp.setPidm(rs1.getInt(1));
                fp.setCodFormP(rs1.getInt(2));
                listaFP.add(fp);
            }
            rs1.close();
            ///////////////////////////////////////////////
            Date Fecha = new Date();
            java.sql.Date FechaSql = new java.sql.Date(Fecha.getYear(), Fecha.getMonth(), Fecha.getDate());
            /*INSERT FORMULARIO -PERSONA*/
            int cod = 0;

            if (listaFP.isEmpty()) {
                cod = 1;
            } else {
                cod = listaFP.getLast().getCodFormP() + 1;
            }
            int pidmP = 0;
            int codPIDM = 0;
            //String idP = "";

            for (int i = 0;
                    i < listaPIDM.size();
                    i++) {
                pidmP = listaPIDM.get(i);
                try {
                    ResultSet rsValidacion = co2.prepareStatement("SELECT * "
                            + " FROM UTIC.UZGTFORMULARIO_PERSONA p,UTIC.UZGTFORMULARIOS f"
                            + " WHERE p.CODIGO_UZGTFORMULARIOS='" + codF + "'"
                            + " AND p.SPRIDEN_PIDM = '" + pidmP + "'"
                            + " AND f.UZGTFORMULARIOS_FECHA_INICIO >= '" + FECHAINICIO + "'"
                            + " AND f.UZGTFORMULARIOS_FECHA_FIN <= '" + FECHAFIN + "'"
                            + " and p.uzgtformularios_estado_llenado = 'N'"
                    ).executeQuery();
                    while (rsValidacion.next()) {
                        codPIDM = rsValidacion.getInt(1);
                        System.out.println(codPIDM);
                        PIDMvalidacion.add(codPIDM);
                        System.out.println("----------------");
                        System.out.println(PIDMvalidacion.getFirst());
                    }
                    rsValidacion.close();
                    if (PIDMvalidacion.size() >= 1) {
                        PIDMvalidacion.remove(0);
                        out.println("<meta http-equiv='refresh' content='2;URL=mostrarFormulario.jsp'>");//redirects after 4 seconds    


        %>
        <div class="container">
            <div class="text alert alert-warning" style = "text-align: center;"><strong> 
                    <p> Usuario con ID <%= pidmID.get(i)%> tiene Formulario Previamente Publicado   
                    </p> </strong>
                <!--<h1> //=codPIDM  </h1>
                <h1> //=PIDMvalidacion.size()  </h1>-->
            </div>
            <%
            } else {
                try {
                    String sql = "INSERT INTO UTIC.UZGTFORMULARIO_PERSONA "
                            + "(SPRIDEN_PIDM,"
                            + "CODIGO_UZGTFORMULARIOS_PERSONA,"
                            + "CODIGO_UZGTFORMULARIOS,"
                            + "UZGTFORMULARIOS_PERSONA_FECHA,"
                            + "UZGTFORMULARIOS_ESTADO_SEG, "
                            + "UZGTFORMULARIOS_ESTADO_LLENADO,UZGTFORMULARIOS_FECHA_CREA,UZGTFORMULARIOS_USUA_CREA) "
                            + "VALUES (?,?,?,?,?,?,?,?)";
                    PreparedStatement ps = co2.prepareStatement(sql);
                    ps.setInt(1, pidmP);
                    ps.setInt(2, cod + i);
                    ps.setInt(3, codF);
                    ps.setDate(4, sqlDate);
                    ps.setString(5, eF);
                    ps.setString(6, "N");
                    ps.setDate(7, sqlDate);
                    ps.setInt(8, listaPIDM.get(i));
                    ps.executeUpdate();
                } catch (Exception e) {
                    System.out.println("Error auditoria insert en formulario persona: " + e);
                }
                try {
                    String cadena = "SELECT DISTINCT SPRIDEN_PIDM FROM SPRIDEN WHERE SPRIDEN_CHANGE_IND IS NULL AND SPRIDEN_ID IN('" + query + "')";
                    String aux = "";
                    String apos = "'";
                    try {
                        for (int j = 0; j < cadena.length(); j++) {
                            if (cadena.charAt(j) == apos.charAt(0)) {
                                aux = aux + cadena.charAt(j) + "'";
                            } else {
                                aux = aux + cadena.charAt(j);
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("error cadena" + e);
                    }
                    co2.prepareStatement("UPDATE UTIC.UZGTFORMULARIOS SET UZGTFORMULARIOS_FECHA_INICIO='" + FECHAINICIO + "', UZGTFORMULARIOS_FECHA_FIN='" + FECHAFIN + "', UZGTFORMULARIOS_ESTADO=" + 1 + ", UZGTFORMULARIOS_EO= '" + tF + "', UZGTFORMULARIOS_QUERY_P= '" + aux + "' WHERE CODIGO_UZGTFORMULARIOS =" + codF + "").executeUpdate();
                    try {
                        PreparedStatement ps = co2.prepareStatement("UPDATE UTIC.UZGTFORMULARIOS SET UZGTFORMULARIOS_FECHA_MODIF= ?,UZGTFORMULARIOS_USUA_MODIF=? WHERE CODIGO_UZGTFORMULARIOS =" + codF + "");
                        ps.setDate(1, sqlDate);
                        ps.setString(2, pidm);
                        ps.executeUpdate();
                    } catch (Exception e) {
                        System.out.println("Auditoria modificar formulario persona:" + e);
                    }
                    out.println("<meta http-equiv='refresh' content='4;URL=mostrarFormulario.jsp'>");//redirects after 4 seconds*/
                } catch (Exception e) {
                    System.out.println("Error :" + e);
                }
            %>
            <div class="container">
                <div class="text alert alert-success" style="text-align: center;">
                    <strong>
                        <p>
                            Usuario con ID <%= pidmID.get(i)%> ha Publicado Exitosamente 
                        </p>
                    </strong> 
                </div>
            </div>        
            <%
                            }
                        } catch (Exception ex) {
                            out.println("Error en formulario-persona" + ex);
                        }
                    }
                }
            %>
    </body>
</html>
<% } else //----------------------------------ESTADO PUBLICACIONHD----------------------
//----------------------------------ESTADO PUBLICACIONHD----------------------
{ %>
<html>
    <head>
        <title>Estado Publicación</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
        %>    </head>
    <body>
        <%
            try {
                ResultSet rs2 = co2.prepareStatement("SELECT DISTINCT  SPRIDEN_PIDM, SPRIDEN_ID "
                        + "FROM SPRIDEN WHERE SPRIDEN_CHANGE_IND IS NULL AND SPRIDEN_ID IN('" + query + "')").executeQuery();
                int codPIDM = 1;
                String pidmId = "";
                while (rs2.next()) {
                    codPIDM = (rs2.getInt(1));
                    pidmId = (rs2.getString(2));
                    listaPIDM.add(codPIDM);
                    pidmID.add(pidmId);
                }
                rs2.close();
            } catch (Exception ex) {
                out.println("Error en sacar pidms" + ex);
            }
            /*obtenemos los datos de la tabla formulario_persona para hacer el codigo sin repeticion*/
            ResultSet rs1 = co2.prepareStatement("SELECT * FROM UTIC.UZGTFORMULARIO_PERSONA "
                    + "order by codigo_UZGTFORMULARIOS_PERSONA ASC").executeQuery();
            while (rs1.next()) {
                FormPersona fp = new FormPersona();
                fp.setPidm(rs1.getInt(1));
                fp.setCodFormP(rs1.getInt(2));
                listaFP.add(fp);
            }
            rs1.close();
            ///////////////////////////////////////////////
            Date Fecha = new Date();
            java.sql.Date FechaSql = new java.sql.Date(Fecha.getYear(), Fecha.getMonth(), Fecha.getDate());
            /*INSERT FORMULARIO -PERSONA*/
            int cod = 0;

            if (listaFP.isEmpty()) {
                cod = 1;
            } else {
                cod = listaFP.getLast().getCodFormP() + 1;
            }
            int pidmP = 0;
            int codPIDM = 0;
            //String idP = "";

            for (int i = 0;
                    i < listaPIDM.size();
                    i++) {
                pidmP = listaPIDM.get(i);
                try {
                    ResultSet rsValidacion = co2.prepareStatement("SELECT * "
                            + " FROM UTIC.UZGTFORMULARIO_PERSONA p,UTIC.UZGTFORMULARIOS f"
                            + " WHERE p.CODIGO_UZGTFORMULARIOS='" + codF + "'"
                            + " AND p.SPRIDEN_PIDM = '" + pidmP + "'"
                            + " AND f.UZGTFORMULARIOS_FECHA_INICIO >= '" + FECHAINICIO + "'"
                            + " AND f.UZGTFORMULARIOS_FECHA_FIN <= '" + FECHAFIN + "'"
                            + " and p.uzgtformularios_estado_llenado = 'N'"
                    ).executeQuery();
                    while (rsValidacion.next()) {
                        codPIDM = rsValidacion.getInt(1);
                        System.out.println(codPIDM);
                        PIDMvalidacion.add(codPIDM);
                        System.out.println("----------------");
                        System.out.println(PIDMvalidacion.getFirst());
                    }
                    rsValidacion.close();
                    if (PIDMvalidacion.size() >= 1) {
                        PIDMvalidacion.remove(0);
                        out.println("<meta http-equiv='refresh' content='2;URL=mostrarFormulario.jsp'>");//redirects after 4 seconds    

        %>

        <div class="container">
            <div class="text alert alert-warning" style = "text-align: center;"><strong> 
                    <p> Usuario con ID <%= pidmID.get(i)%> tiene Formulario Previamente Publicado   
                 </p> </strong>
                <!--<h1> //=codPIDM  </h1>
                <h1> //=PIDMvalidacion.size()  </h1>-->

            </div>

            <%
            } else {
                try {
                    String sql = "INSERT INTO UTIC.UZGTFORMULARIO_PERSONA "
                            + "(SPRIDEN_PIDM,"
                            + "CODIGO_UZGTFORMULARIOS_PERSONA,"
                            + "CODIGO_UZGTFORMULARIOS,"
                            + "UZGTFORMULARIOS_PERSONA_FECHA,"
                            + "UZGTFORMULARIOS_ESTADO_SEG, "
                            + "UZGTFORMULARIOS_ESTADO_LLENADO,UZGTFORMULARIOS_FECHA_CREA,UZGTFORMULARIOS_USUA_CREA) "
                            + "VALUES (?,?,?,?,?,?,?,?)";
                    PreparedStatement ps = co2.prepareStatement(sql);
                    ps.setInt(1, pidmP);
                    ps.setInt(2, cod + i);
                    ps.setInt(3, codF);
                    ps.setDate(4, sqlDate);
                    ps.setString(5, eF);
                    ps.setString(6, "N");
                    ps.setDate(7, sqlDate);
                    ps.setInt(8, listaPIDM.get(i));
                    ps.executeUpdate();
                } catch (Exception e) {
                    System.out.println("Error auditoria insert en formulario persona: " + e);
                }
                try {
                    String cadena = "SELECT DISTINCT SPRIDEN_PIDM FROM SPRIDEN WHERE SPRIDEN_CHANGE_IND IS NULL AND SPRIDEN_ID IN('" + query + "')";
                    String aux = "";
                    String apos = "'";
                    try {
                        for (int j = 0; j < cadena.length(); j++) {
                            if (cadena.charAt(j) == apos.charAt(0)) {
                                aux = aux + cadena.charAt(j) + "'";
                            } else {
                                aux = aux + cadena.charAt(j);
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("error cadena" + e);
                    }
                    co2.prepareStatement("UPDATE UTIC.UZGTFORMULARIOS SET UZGTFORMULARIOS_FECHA_INICIO='" + FECHAINICIO + "', UZGTFORMULARIOS_FECHA_FIN='" + FECHAFIN + "', UZGTFORMULARIOS_ESTADO=" + 1 + ", UZGTFORMULARIOS_EO= '" + tF + "', UZGTFORMULARIOS_QUERY_P= '" + aux + "' WHERE CODIGO_UZGTFORMULARIOS =" + codF + "").executeUpdate();
                    try {
                        PreparedStatement ps = co2.prepareStatement("UPDATE UTIC.UZGTFORMULARIOS SET UZGTFORMULARIOS_FECHA_MODIF= ?,UZGTFORMULARIOS_USUA_MODIF=? WHERE CODIGO_UZGTFORMULARIOS =" + codF + "");
                        ps.setDate(1, sqlDate);
                        ps.setString(2, pidm);
                        ps.executeUpdate();
                    } catch (Exception e) {
                        System.out.println("Auditoria modificar formulario persona:" + e);
                    }
                    out.println("<meta http-equiv='refresh' content='4;URL=mostrarFormulario.jsp'>");//redirects after 4 seconds*/
                } catch (Exception e) {
                    System.out.println("Error :" + e);
                }
            %>
            <div class="container">
                <div class="text alert alert-success" style="text-align: center;">
                    <strong>
                        <p>
                            Usuario con ID <%= pidmID.get(i)%> ha Publicado Exitosamente 
                        </p>
                    </strong> 
                </div>
            </div>        
            <%
                        }
                    } catch (Exception ex) {
                        out.println("Error en formulario-persona" + ex);
                    }
                }
                con2.closeConexion();%>
    </body>
</html>
<% }
%>