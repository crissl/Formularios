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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

            //Obtecion de los valores de los formularios
            String nomF = request.getParameter("Submit");
            int CodT = Integer.parseInt(nomF);
            String Email = request.getParameter("emaili");
            String par_emailp = request.getParameter("emailp");
            String Radio = request.getParameter("optradioa");
            String Cedula = request.getParameter("cedula");
            String Nombres = request.getParameter("nombres");
            String Tema = request.getParameter("tema");
            String Optradio = request.getParameter("optradio");
            String Nrcd = request.getParameter("nrcd");
            String Nrcdr = request.getParameter("nrcdr");
            String Lugar = request.getParameter("lugar");
            String Aula = request.getParameter("aula");
            String Hinicia = request.getParameter("hinicia");
            String Hfin = request.getParameter("hfin");
            String Observaciones = request.getParameter("observaciones");
            String fecharegistro = request.getParameter("fecharegistro");
            String fecha = request.getParameter("fecha");
            String LUGAR = "";
            String EstadoT = "A"; //A= Estado de la Tutoria ACTIVA
            String TPersonaD = "DOCENTE"; //
            String TTutoriaA = "ACOMPAÑAMIENTO"; //
            String TTutoriaR = "REFORZAMIENTO"; //
            String Razon = "Prueba";
            //Funcion para obtener la fecha actual
            java.util.Date date = new java.util.Date();
            long t = date.getTime();
            java.sql.Date sqlDate = new java.sql.Date(t);
            //Funcion para convertir el formato de fecha a dd/MM/yyyy
            DateFormat originalFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date Fechare = originalFormat.parse(fecharegistro);
            DateFormat targetFormat = new SimpleDateFormat("dd/MM/yyyy");
            Date Fecha = originalFormat.parse(fecha);
            String FECHA = targetFormat.format(Fecha);
            String FECHARE = targetFormat.format(Fechare);

            if (Aula == null) {
                LUGAR = Lugar;
            } else {
                LUGAR = Aula;
            }
            LinkedList<Uztasistentes> listaA = new LinkedList<Uztasistentes>();
            LinkedList<PlanificacionTutorias> listaPT = new LinkedList<PlanificacionTutorias>();
            LinkedList<Uztasistentes> listaAs = new LinkedList<Uztasistentes>();
            try {
                ResultSet rs1 = co.prepareStatement("SELECT * FROM UTIC.UZTPLANIF ORDER BY CODIGO_UZTPLANIF ASC").executeQuery();
                while (rs1.next()) {
                    PlanificacionTutorias pt = new PlanificacionTutorias();
                    pt.setCodigo_planificacion(rs1.getInt(1));
                    pt.setCodigo_formularios(rs1.getInt(2));
                    pt.setIteracion(rs1.getInt(3));
                    pt.setFecha_formulario(rs1.getString(4));
                    pt.setTipoPersona(rs1.getString(5));
                    pt.setTipoTutoria(rs1.getString(6));
                    pt.setSpridenPidm(rs1.getInt(7));
                    pt.setTema(rs1.getString(8));
                    pt.setNrc(rs1.getString(9));
                    pt.setCodAsignatura(rs1.getString(10));
                    pt.setAsignatura(rs1.getString(11));
                    pt.setPeriodo(rs1.getString(12));
                    pt.setNivel(rs1.getString(13));
                    pt.setObservacion(rs1.getString(14));
                    pt.setEstado(rs1.getString(15));
                    listaPT.add(pt);
                }
                rs1.close();
            } catch (Exception e) {
                System.out.println("Error select: " + e);
            }
            try {
                ResultSet rs2 = co.prepareStatement("SELECT * FROM UTIC.UZTASISTENTES ORDER BY UZTASISTENTES_CODIGO ASC").executeQuery();
                while (rs2.next()) {
                    Uztasistentes as = new Uztasistentes();
                    as.setCodigoAsiste(rs2.getInt(1));
                    as.setCodigoUztplanif(rs2.getInt(2));
                    as.setCodigoUzgtformularios(rs2.getInt(3));
                    as.setIteracion(rs2.getInt(4));
                    as.setSpridenPidm(rs2.getInt(5));
                    as.setUztasistentesFechatutoria(rs2.getString(6));
                    as.setUztasistentesFecharegistro(rs2.getString(7));
                    as.setUztasistentesAsiste(rs2.getString(8));
                    as.setUztasistentesComentario(rs2.getString(9));
                    as.setObservacion(rs2.getString(10));
                    listaAs.add(as);
                }
                rs2.close();
            } catch (Exception e) {
                System.out.println("Error select: " + e);
            }
            //Autoincrementable iteracion
            /*int itr = 0;
            if (listaPT.isEmpty()) {
                itr = 1;
            } else {
                itr = listaPT.getLast().getIteracion() + 1;
            }*/
            // Auto Incrementable PK TABLA UZTPLANIF 
            int cod = 0;
            if (listaPT.isEmpty()) {
                cod = 1;
            } else {
                cod = listaPT.getLast().getCodigo_planificacion() + 1;
            }
            //

            int codtaf = 0;
            //SWITCH FORMULARIO
            switch (CodT) {
                /////////////////////////PLANIFICACION DE REFORZAMIENTO/////////////////
                case 1:
                    //Funcion split para separar la cadena en campos
                    String stringd = Nrcd;
                    String[] partsd = stringd.split(" - ");
                    String nrcd = partsd[0]; // 123
                    String codasignaturad = partsd[1];
                    String asignaturad = partsd[2]; // 123
                    String campusd = partsd[3];
                    String periodod = partsd[4];

                    if (Optradio.equalsIgnoreCase("M")) {
                        //Selects para los estudiantes que tienen notas <14
                        ResultSet rsAs = co.prepareStatement("SELECT DISTINCT SFRSTCR_PIDM AS PIDM,"
                                + "SUBSTR(f_getspridenid(SFRSTCR_PIDM),1,12) AS ID,\n"
                                + "SPBPERS_SSN AS CEDULA,\n"
                                + "SUBSTR(f_format_name(SFRSTCR_PIDM,'LFMI'),1,30) AS NOMBRES,\n"
                                + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                                + "FROM GOREMAL\n"
                                + "WHERE GOREMAL.GOREMAL_PIDM = SFRSTCR_PIDM\n"
                                + "AND GOREMAL.GOREMAL_EMAL_CODE = 'STAN'), '') AS CORREO_INSTITUCIONAL,\n"
                                + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                                + "FROM GOREMAL\n"
                                + "WHERE GOREMAL.GOREMAL_PIDM = SFRSTCR_PIDM\n"
                                + "AND GOREMAL.GOREMAL_EMAL_CODE = 'PERS'), '') AS CORREO_PERSONAL\n"
                                + "FROM SFRSTCR, SPBPERS\n"
                                + "WHERE SFRSTCR_TERM_CODE =  '" + periodod + "'\n"
                                + "AND SFRSTCR_CRN = '" + nrcd + "'\n"
                                + "AND SFRSTCR_PIDM = SPBPERS_PIDM\n"
                                + "AND SFRSTCR_PIDM IN (SELECT DISTINCT SHRMRKS_PIDM\n"
                                + "FROM SHRMRKS\n"
                                + "WHERE SHRMRKS_TERM_CODE =  '" + periodod + "'\n"
                                + "AND SHRMRKS_CRN = '" + nrcd + "'\n"
                                + "AND SHRMRKS_SCORE <= 14\n"
                                + "AND SHRMRKS_COMPLETED_DATE = (SELECT MAX(SHRMRKS_COMPLETED_DATE)\n"
                                + "FROM SHRMRKS\n"
                                + "WHERE SHRMRKS_COMPLETED_DATE <= SYSDATE\n"
                                + "AND SHRMRKS_TERM_CODE = '" + periodod + "' \n"
                                + "AND SHRMRKS_CRN = '" + nrcd + "' ))").executeQuery();
                        while (rsAs.next()) {
                            Uztasistentes asistentes = new Uztasistentes();
                            asistentes.setSpridenPidm(rsAs.getInt(1));
                            asistentes.setUztasistentesId(rsAs.getString(2));
                            asistentes.setUztasistentesCedula(rsAs.getString(3));
                            asistentes.setUztasistentesNombre(rsAs.getString(4));
                            asistentes.setUztasistentesEmails(rsAs.getString(5));
                            asistentes.setUztasistentesEmailp(rsAs.getString(6));
                            listaA.add(asistentes);
                            System.out.println("lISTA MENOS <14 REFORZAMIENTO " + asistentes.getUztasistentesNombre() + " pidm " + asistentes.getSpridenPidm());
                        }
                        rsAs.close();

                    } else if (Optradio.equalsIgnoreCase("T")) {
                        ResultSet rsAs = co.prepareStatement("SELECT DISTINCT SFRSTCR_PIDM AS PIDM,\n"
                                + "SUBSTR(f_getspridenid(SFRSTCR_PIDM),1,12) AS ID,\n"
                                + "SPBPERS_SSN AS CEDULA,\n"
                                + "SUBSTR(f_format_name(SFRSTCR_PIDM,'LFMI'),1,30) AS NOMBRES,\n"
                                + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                                + "FROM GOREMAL\n"
                                + "WHERE GOREMAL.GOREMAL_PIDM = SFRSTCR_PIDM\n"
                                + "AND GOREMAL.GOREMAL_EMAL_CODE = 'STAN'),'') AS CORREO_INSTITUCIONAL,\n"
                                + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                                + "FROM GOREMAL\n"
                                + "WHERE GOREMAL.GOREMAL_PIDM = SFRSTCR_PIDM\n"
                                + "AND GOREMAL.GOREMAL_EMAL_CODE = 'PERS'),'') AS CORREO_PERSONAL\n"
                                + "FROM SFRSTCR, SPBPERS\n"
                                + "WHERE SFRSTCR_TERM_CODE = '" + periodod + "'\n"
                                + "AND SFRSTCR_CRN = '" + nrcd + "' \n"
                                + "AND SFRSTCR_PIDM = SPBPERS_PIDM").executeQuery();
                        while (rsAs.next()) {
                            Uztasistentes asistentes = new Uztasistentes();
                            asistentes.setSpridenPidm(rsAs.getInt(1));
                            asistentes.setUztasistentesId(rsAs.getString(2));
                            asistentes.setUztasistentesCedula(rsAs.getString(3));
                            asistentes.setUztasistentesNombre(rsAs.getString(4));
                            asistentes.setUztasistentesEmails(rsAs.getString(5));
                            asistentes.setUztasistentesEmailp(rsAs.getString(6));
                            listaA.add(asistentes);
                            System.out.println("lISTA TODOS REFORZAMIENTO " + asistentes.getUztasistentesNombre() + " pidm " + asistentes.getSpridenPidm());
                        }
                    } else if (Optradio.equalsIgnoreCase("S")) {
                        ResultSet rsS = co.prepareStatement("SELECT DISTINCT SPRIDEN_PIDM AS PIDM,\n"
                                + "SUBSTR(f_getspridenid(SPRIDEN_PIDM),1,12) AS ID,\n"
                                + "SPBPERS_SSN AS CEDULA,\n"
                                + "SUBSTR(f_format_name(SPRIDEN_PIDM,'LFMI'),1,30) AS NOMBRES,\n"
                                + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                                + "FROM GOREMAL\n"
                                + "WHERE GOREMAL.GOREMAL_PIDM = SPRIDEN_PIDM\n"
                                + "AND GOREMAL.GOREMAL_EMAL_CODE = 'STAN'), '') AS CORREO_INSTITUCIONAL,\n"
                                + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                                + "FROM GOREMAL\n"
                                + "WHERE GOREMAL.GOREMAL_PIDM = SPRIDEN_PIDM\n"
                                + "AND GOREMAL.GOREMAL_EMAL_CODE = 'PERS'), '') AS CORREO_PERSONAL\n"
                                + "FROM UTIC.UZTPLANIF, SPBPERS\n"
                                + "WHERE UZTPLANIF_TIPOPERSONA = 'ESTUDIANTE'\n"
                                + "AND UZTPLANIF_TITOTUTORIA = 'REFORZAMIENTO'\n"
                                + "AND UZTPLANIF_NRC = '" + nrcd + "'\n"
                                + "AND UZTPLANIF_PERIODO = '" + periodod + "'\n"
                                + "AND UZTPLANIF_ESTADO = 'A'\n"
                                + "AND SPRIDEN_PIDM=SPBPERS_PIDM").executeQuery();
                        while (rsS.next()) {
                            Uztasistentes asistentes = new Uztasistentes();
                            asistentes.setSpridenPidm(rsS.getInt(1));
                            asistentes.setUztasistentesId(rsS.getString(2));
                            asistentes.setUztasistentesCedula(rsS.getString(3));
                            asistentes.setUztasistentesNombre(rsS.getString(4));
                            asistentes.setUztasistentesEmails(rsS.getString(5));
                            asistentes.setUztasistentesEmailp(rsS.getString(6));
                            listaA.add(asistentes);
                            System.out.println("lISTA SOLICITUDES REFORZAMIENTO " + asistentes.getUztasistentesNombre() + " pidm " + asistentes.getSpridenPidm());
                        }
                    }
                    if (listaA.isEmpty()) { %>
        <div class="container">
            <div class="text alert alert-danger" style="text-align: center;">
                <strong>
                    <p>   NO EXISTEN SOLICITANTES A TUTORIAS DE ACOMPAÑAMIENTO ACTIVOS,  </p>
                    <p>   NO SE GUARDO LA PLANIFICACIÓN,  </p>

                </strong> 
            </div>
        </div>
        <%     } else {
            try {
                String sql = "INSERT INTO UTIC.UZTPLANIF(CODIGO_UZTPLANIF,CODIGO_UZGTFORMULARIOS,UZGTRESPUESTAS_ITERACION,UZTPLANIF_FECHAFORM,UZTPLANIF_TIPOPERSONA,UZTPLANIF_TITOTUTORIA,SPRIDEN_PIDM,UZTPLANIF_TEMA,UZTPLANIF_PUBLICO,UZTPLANIF_NRC,UZTPLANIF_CODIGO_ASIGNATURA,UZTPLANIF_ASIGNATURA,UZTPLANIF_PERIODO,UZTPLANIF_AULA,UZTPLANIF_FECHATUTORIA,UZTPLANIF_HORAINICIO,UZTPLANIF_HORAFIN,UZTPLANIF_OBSERVACION,UZTPLANIF_ESTADO,UZTPLANIF_FECHA_CREA,UZTPLANIF_USUA_CREA,UZTPLANIF_CAMP_CODE)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                PreparedStatement ps = co.prepareStatement(sql);
                ps.setInt(1, cod);
                ps.setInt(2, CodT);
                ps.setInt(3, 0);
                ps.setString(4, FECHARE);
                ps.setString(5, TPersonaD);
                ps.setString(6, TTutoriaR);
                ps.setInt(7, PIDMS);
                ps.setString(8, Tema);
                ps.setString(9, Optradio);
                ps.setString(10, nrcd);
                ps.setString(11, codasignaturad);
                ps.setString(12, asignaturad);
                ps.setString(13, periodod);
                ps.setString(14, LUGAR);
                ps.setString(15, FECHA);
                ps.setString(16, Hinicia);
                ps.setString(17, Hfin);
                ps.setString(18, Observaciones);
                ps.setString(19, EstadoT);
                ps.setDate(20, sqlDate);
                ps.setString(21, pidm);
                ps.setString(22, campusd);
                ps.executeUpdate();
                System.out.println(" insertado correctamente formulario: 1");
            } catch (SQLException e) {
                System.out.println("Error insertar tutoria FORMULARIO 1: " + "" + fecha);
            }

            //Mensaje de confirmacion
            try {

                String par_mensaje = " la planificacíon fue enviada a los estudiantes ";
                String par_mensajeprincipal = " La misma que fue establecida para el " + FECHA + ", ";
                String par_notificacion1 = "con el tema  " + Tema + " y la siguiente observación " + Observaciones + "";
                String par_notificacion2 = ", la solicitud de planificación de la Tutoria de " + TTutoriaR + " fue llenada exitosamente, ";

                coWF.prepareStatement("CALL wfobjects.wzwkreport.P_Envio_Emails('" + par_mensaje + "'" + ",'" + Cedula + "'" + ",'" + Nombres + "'"
                        + ",'" + Email + "'" + ",'" + par_emailp + "'" + ",'" + par_mensajeprincipal + "'" + ",'" + par_notificacion1 + "'" + ",'" + par_notificacion2 + "'"
                        + ")").executeQuery();

                System.out.println("Correo del formulario #1 enviado exitosamente");
            } catch (SQLException e) {
                System.out.println("Error envio mail del TUTOR formulario #1: " + e);
            }

            if (listaAs.isEmpty()) {
                codtaf = 0;
            } else {
                codtaf = listaAs.getLast().getCodigoAsiste();
            }
            for (int j = 0; j < listaA.size(); j++) {
                codtaf = codtaf + 1;

                try {
                    String sql1 = "INSERT INTO UTIC.UZTASISTENTES(UZTASISTENTES_CODIGO,CODIGO_UZTPLANIF,CODIGO_UZGTFORMULARIOS,UZTASISTENTES_ITERACION,SPRIDEN_PIDM,UZTASISTENTES_FECHATUTORIA,UZTASISTENTES_FECHAREGISTRO,UZTASISTENTES_ASISTESN,UZTASISTENTES_COMENTARIO,UZTASISTENTES_OBSERVACION,UZTASISTENTES_FECHA_CREA,UZTASISTENTES_USUA_CREA,UZTASISTENTES_ESTADO,UZTASISTENTES_ID,UZTASISTENTES_ESTUDIANTE,UZTASISTENTES_EMAIL,UZTASISTENTES_CEDULA)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    PreparedStatement ps1 = co.prepareStatement(sql1);
                    ps1.setInt(1, codtaf);
                    ps1.setInt(2, cod);
                    ps1.setInt(3, CodT);
                    ps1.setInt(4, 0);
                    ps1.setInt(5, listaA.get(j).getSpridenPidm());  //cambiar string a int// x prueba
                    ps1.setString(6, FECHA);
                    ps1.setString(7, "");
                    ps1.setString(8, "");
                    ps1.setString(9, "");
                    ps1.setString(10, "");
                    ps1.setDate(11, sqlDate);
                    ps1.setString(12, pidm);
                    ps1.setString(13, EstadoT);
                    ps1.setString(14, listaA.get(j).getUztasistentesId());
                    ps1.setString(15, listaA.get(j).getUztasistentesNombre());
                    ps1.setString(16, listaA.get(j).getUztasistentesEmails());
                    ps1.setString(17, listaA.get(j).getUztasistentesCedula());
                    ps1.executeUpdate();
                    System.out.println("Extito formulario asiste 1: ");
                } catch (SQLException e) {
                    System.out.println("Error asiste formualrio 1: " + e);
                }

                try {
                    String par_mensaje = " usted ha sido notificado para asistir a una tutoria de " + TTutoriaR + "";
                    String par_mensajeprincipal = " fue establecida para la fecha " + FECHA + ", ha dictarse en el Lugar/Aula y hora  " + LUGAR + " ";
                    String par_notificacion1 = " , con el tema " + Tema + " y con la siguiente observación " + Observaciones + "";
                    String par_notificacion2 = " la solicitud de tutoria de " + TTutoriaR;

                    //Procedimiento Almacenado que envia el email al usuario
                    coWF.prepareStatement("CALL wfobjects.wzwkreport.P_Envio_Emails('" + par_mensaje + "'" + ",'" + listaA.get(j).getUztasistentesCedula() + "'" + ",'" + listaA.get(j).getUztasistentesNombre() + "'"
                            + ",'" + listaA.get(j).getUztasistentesEmails() + "'" + ",'" + listaA.get(j).getUztasistentesEmailp() + "'" + ",'" + par_mensajeprincipal + "'" + ",'" + par_notificacion1 + "'" + ",'" + par_notificacion2 + "'"
                            + ")").executeQuery();

                    System.out.println("Correo de confirmacion del estudiante enviado exitosamente");
                } catch (SQLException e) {
                    System.out.println("Error envio mail del conf del estudiant " + e);
                }

            }
            coWF.close();%>
        <br>
        <div class="container">
            <div class="text alert alert-success" style="text-align: center;">
                <strong><p>
                        LA PLANIFICACIÓN DE TUTORIA DE ACOMPAÑAMIENTO HA SIDO LLENADA EXITOSAMENTE.
                    </p>
                    <% }%>
                </strong> 
            </div>
        </div> 
        <%
                out.println("<meta http-equiv='refresh' content='1;URL=https://miespe.espe.edu.ec/'>");//redirects after 4 seconds    
                break;
////////////////////////////////////////////PLANIFICACION ACOMPAÑAMIENTO/////////////////////////////////////
            case 3:
                if (Optradio.equalsIgnoreCase("T")) {
                    //Selects para los estudiantes que tienen notas <14
                    try {
                        ResultSet rsAs = co.prepareStatement("SELECT DISTINCT SPBPERS_PIDM AS PIDM,\n"
                                + "SUBSTR(f_getspridenid(SGRADVR_PIDM),1,12) AS ID,\n"
                                + "SPBPERS_SSN AS CEDULA,\n"
                                + "SUBSTR(f_format_name(SGRADVR_PIDM,'LFMI'),1,30) AS NOMBRES,\n"
                                + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                                + "FROM GOREMAL\n"
                                + "WHERE GOREMAL.GOREMAL_PIDM = SGRADVR_PIDM\n"
                                + "AND GOREMAL.GOREMAL_EMAL_CODE = 'STAN'), '') AS CORREO_INSTITUCIONAL,\n"
                                + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                                + "FROM GOREMAL\n"
                                + "WHERE GOREMAL.GOREMAL_PIDM = SGRADVR_PIDM\n"
                                + "AND GOREMAL.GOREMAL_EMAL_CODE = 'PERS'), '') AS CORREO_PERSONAL\n"
                                + "FROM SGRADVR, SPBPERS\n"
                                + "WHERE SGRADVR_ADVR_PIDM = " + pidm + "\n"
                                + "AND SGRADVR_ADVR_CODE = 'TACO'\n"
                                + "AND SGRADVR_PIDM = SPBPERS_PIDM").executeQuery();
                        while (rsAs.next()) {
                            Uztasistentes asistentes = new Uztasistentes();
                            asistentes.setSpridenPidm(rsAs.getInt(1));
                            asistentes.setUztasistentesId(rsAs.getString(2));
                            asistentes.setUztasistentesCedula(rsAs.getString(3));
                            asistentes.setUztasistentesNombre(rsAs.getString(4));
                            asistentes.setUztasistentesEmails(rsAs.getString(5));
                            asistentes.setUztasistentesEmailp(rsAs.getString(6));
                            listaA.add(asistentes);
                            System.out.println("lISTA TODOS ACOMPAÑAMIENTO " + asistentes.getUztasistentesNombre() + " pidm " + asistentes.getSpridenPidm());
                        }
                        rsAs.close();
                    } catch (Exception e) {
                        System.out.println("Error select todos " + e);
                    }

                } else if (Optradio.equalsIgnoreCase("S")) {
                    ResultSet rsS = co.prepareStatement("SELECT DISTINCT SFRSTCR_PIDM AS PIDM,\n"
                            + "SUBSTR(f_getspridenid(SFRSTCR_PIDM),1,12) AS ID,\n"
                            + "SPBPERS_SSN AS CEDULA,\n"
                            + "SUBSTR(f_format_name(SFRSTCR_PIDM,'LFMI'),1,30) AS NOMBRES,\n"
                            + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                            + "FROM GOREMAL\n"
                            + "WHERE GOREMAL.GOREMAL_PIDM = SFRSTCR_PIDM\n"
                            + "AND GOREMAL.GOREMAL_EMAL_CODE = 'STAN'), '') AS CORREO_INSTITUCIONAL,\n"
                            + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                            + "FROM GOREMAL\n"
                            + "WHERE GOREMAL.GOREMAL_PIDM = SFRSTCR_PIDM\n"
                            + "AND GOREMAL.GOREMAL_EMAL_CODE = 'PERS'), '') AS CORREO_PERSONAL\n"
                            + "FROM UTIC.UZTPLANIF, SATURN.SFRSTCR, SATURN.SPBPERS\n"
                            + "WHERE UZTPLANIF_TIPOPERSONA = 'ESTUDIANTE'\n"
                            + "AND SPRIDEN_PIDM = SFRSTCR_PIDM\n"
                            + "AND SPRIDEN_PIDM = SPBPERS_PIDM\n"
                            + "AND UZTPLANIF_TITOTUTORIA = 'ACOMPAÑAMIENTO'\n"
                            + "AND UZTPLANIF_ESTADO = 'A'").executeQuery();
                    while (rsS.next()) {
                        Uztasistentes asistentes = new Uztasistentes();
                        asistentes.setSpridenPidm(rsS.getInt(1));
                        asistentes.setUztasistentesId(rsS.getString(2));
                        asistentes.setUztasistentesCedula(rsS.getString(3));
                        asistentes.setUztasistentesNombre(rsS.getString(4));
                        asistentes.setUztasistentesEmails(rsS.getString(5));
                        asistentes.setUztasistentesEmailp(rsS.getString(6));
                        listaA.add(asistentes);
                        System.out.println("lISTA SOLICITADOS ACOMPAÑAMIENTO: " + asistentes.getUztasistentesNombre() + " pidm " + asistentes.getSpridenPidm());
                    }
                }
                Date Fecha1 = originalFormat.parse(fecha);
                String FECHA1 = targetFormat.format(Fecha1);
                if (Aula == null) {
                    LUGAR = Lugar;
                } else {
                    LUGAR = Aula;
                }
                if (listaA.isEmpty()) { %>
        <div class="container">
            <div class="text alert alert-danger" style="text-align: center;">
                <strong>
                    <p>   NO EXISTEN SOLICITANTES A TUTORIAS DE ACOMPAÑAMIENTO ACTIVOS </p>
                </strong> 
            </div>
        </div>
        <%     } else {
            try {
                String sql = "INSERT INTO UTIC.UZTPLANIF(CODIGO_UZTPLANIF,CODIGO_UZGTFORMULARIOS,UZGTRESPUESTAS_ITERACION,UZTPLANIF_FECHAFORM,UZTPLANIF_TIPOPERSONA,UZTPLANIF_TITOTUTORIA,SPRIDEN_PIDM,UZTPLANIF_TEMA,UZTPLANIF_PUBLICO,UZTPLANIF_NRC,UZTPLANIF_CODIGO_ASIGNATURA,UZTPLANIF_ASIGNATURA,UZTPLANIF_PERIODO,UZTPLANIF_AULA,UZTPLANIF_FECHATUTORIA,UZTPLANIF_HORAINICIO,UZTPLANIF_HORAFIN,UZTPLANIF_OBSERVACION,UZTPLANIF_ESTADO,UZTPLANIF_FECHA_CREA,UZTPLANIF_USUA_CREA,UZTPLANIF_CAMP_CODE)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                PreparedStatement ps = co.prepareStatement(sql);
                ps.setInt(1, cod);
                ps.setInt(2, CodT);
                ps.setInt(3, 0);
                ps.setString(4, FECHARE);
                ps.setString(5, TPersonaD);
                ps.setString(6, TTutoriaA);
                ps.setInt(7, PIDMS);
                ps.setString(8, Tema);
                ps.setString(9, Optradio);
                ps.setString(10, null);
                ps.setString(11, null);
                ps.setString(12, null);
                ps.setString(13, null);
                ps.setString(14, LUGAR);
                ps.setString(15, FECHA1);
                ps.setString(16, Hinicia);
                ps.setString(17, Hfin);
                ps.setString(18, Observaciones);
                ps.setString(19, EstadoT);
                ps.setDate(20, sqlDate);
                ps.setString(21, pidm);
                ps.setString(22, null);
                ps.executeUpdate();
                System.out.println(" insertado correctamente formulario: 3");
            } catch (SQLException e) {
                System.out.println("Error insertar tutoria FORMULARIO 3: " + e);
            }
/////////////CORREO QUE LE LLEGA AL DOCENTE /////////
            try {
                String par_mensaje = ", usted ha sido notificado para asistir a una tutoria de " + TTutoriaA + "";
                String par_mensajeprincipal = " fue establecida para la fecha " + FECHA + ", ha dictarse en el  " + LUGAR + " ";
                String par_notificacion1 = " , con el tema " + Tema + " y con la siguiente observación " + Observaciones + "";
                String par_notificacion2 = " la solicitud de tutoria de " + TTutoriaA;

                coWF.prepareStatement("CALL wfobjects.wzwkreport.P_Envio_Emails('" + par_mensaje + "'" + ",'" + Cedula + "'" + ",'" + Nombres + "'"
                        + ",'" + Email + "'" + ",'" + par_emailp + "'" + ",'" + par_mensajeprincipal + "'" + ",'" + par_notificacion1 + "'" + ",'" + par_notificacion2 + "'"
                        + ")").executeQuery();

                System.out.println("Correo del formulario #3 enviado exitosamente");
            } catch (SQLException e) {
                System.out.println("Error envio mail del formulario #3: " + e);
            }
            coWF.close();

            if (listaAs.isEmpty()) {
                codtaf = 0;
            } else {
                codtaf = listaAs.getLast().getCodigoAsiste();
            }
            for (int i = 0; i < listaA.size(); i++) {
                codtaf = codtaf + 1;

                try {

                    String sql1 = "INSERT INTO UTIC.UZTASISTENTES(UZTASISTENTES_CODIGO,CODIGO_UZTPLANIF,CODIGO_UZGTFORMULARIOS,UZTASISTENTES_ITERACION,SPRIDEN_PIDM,UZTASISTENTES_FECHATUTORIA,UZTASISTENTES_FECHAREGISTRO,UZTASISTENTES_ASISTESN,UZTASISTENTES_COMENTARIO,UZTASISTENTES_OBSERVACION,UZTASISTENTES_FECHA_CREA,UZTASISTENTES_USUA_CREA,UZTASISTENTES_ESTADO,UZTASISTENTES_ID,UZTASISTENTES_ESTUDIANTE,UZTASISTENTES_EMAIL,UZTASISTENTES_CEDULA)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                    PreparedStatement ps1 = co.prepareStatement(sql1);
                    ps1.setInt(1, codtaf);
                    ps1.setInt(2, cod);
                    ps1.setInt(3, CodT);
                    ps1.setInt(4, 0);
                    ps1.setInt(5, listaA.get(i).getSpridenPidm());  //cambiar string a int// x prueba
                    ps1.setString(6, FECHA1);
                    ps1.setString(7, "");
                    ps1.setString(8, "");
                    ps1.setString(9, "");
                    ps1.setString(10, "");
                    ps1.setDate(11, sqlDate);
                    ps1.setString(12, pidm);
                    ps1.setString(13, EstadoT);
                    ps1.setString(14, listaA.get(i).getUztasistentesId());
                    ps1.setString(15, listaA.get(i).getUztasistentesNombre());
                    ps1.setString(16, listaA.get(i).getUztasistentesEmails());
                    ps1.setString(17, listaA.get(i).getUztasistentesCedula());
                    ps1.executeUpdate();
                    System.out.println("Exito formulario asiste 3: ");
                } catch (SQLException e) {
                    System.out.println("Error asiste formualario 3: " + e);
                }
////////////////////////COFRREO QUE  LE LLEGA AL ESTUDIANTE////////////////////////
                try {
                    String par_mensaje = " usted ha sido notificado para asistir a una tutoria de " + TTutoriaA + "";
                    String par_mensajeprincipal = " fue establecida para la fecha " + FECHA + ", ha dictarse en el Lugar/Aula y hora  " + LUGAR + " ";
                    String par_notificacion1 = " , con el tema " + Tema + " y con la siguiente observación " + Observaciones + "";
                    String par_notificacion2 = " la solicitud de tutoria de " + TTutoriaA;

                    //Procedimiento Almacenado que envia el email al usuario
                    coWF.prepareStatement("CALL wfobjects.wzwkreport.P_Envio_Emails('" + par_mensaje + "'" + ",'" + listaA.get(i).getUztasistentesCedula() + "'" + ",'" + listaA.get(i).getUztasistentesNombre() + "'"
                            + ",'" + listaA.get(i).getUztasistentesEmails() + "'" + ",'" + listaA.get(i).getUztasistentesEmails() + "'" + ",'" + par_mensajeprincipal + "'" + ",'" + par_notificacion1 + "'" + ",'" + par_notificacion2 + "'"
                            + ")").executeQuery();

                    System.out.println("Correo de confirmacion del estudiante enviado exitosamente 3");
                } catch (SQLException e) {
                    System.out.println("Error envio mail del confirmacion del estudiante 3: " + e);
                }
            }
            coWF.close();%>
        <div class="container">
            <div class="text alert alert-success" style="text-align: center;">
                <strong><p>
                        LA PLANIFICACIÓN DE TUTORIA DE ACOMPAÑAMIENTO HA SIDO LLENADA EXITOSAMENTE.
                    </p>
                    <% }%>
                </strong> 
            </div>
        </div>  
        <%
                    out.println("<meta http-equiv='refresh' content='2;URL=https://miespe.espe.edu.ec/'>");//redirects after 4 seconds     
                    break;
            }
            co.close();
            con.closeConexion();
            conWF.closeConexionWF();%>
    </body>
</html>