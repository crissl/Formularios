<%@page import="espe.edu.ec.util.Uztasistentes"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <%
            //conexion a la base de datos
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            //Conexion WF
            DB2 conWF = DB2.getInstancia();
            Connection coWF = conWF.getConnectionWF();
            //Llamadas de libreias
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);

            //Obtencion de los valores de las cookies
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
            //Obtecion de los valores de los formularios
            String nomF = request.getParameter("Submit");
            int CodT = Integer.parseInt(nomF);
            String Cedula = request.getParameter("cedula");
            String Nombres = request.getParameter("nombres");
            String Tema = request.getParameter("tema");
            String Nrc = request.getParameter("nrc");
            String Nrcd = request.getParameter("ncrdc");
            String resultados = request.getParameter("resultados");
            String Email = request.getParameter("emaili");
            String par_emailp = request.getParameter("emailp");
            String comentariost = request.getParameter("comentariot");
            String OptRadio = request.getParameter("optradio");
            String fecharegistro = request.getParameter("fecharegistro");
            String Observaciones = request.getParameter("observaciones");

            String EstadoT = "A"; //A= Estado de la Tutoria ACTIVA
            String TPersonaE = "ESTUDIANTE"; //
            String TTutoriaA = "ACOMPAÑAMIENTO"; //
            String TTutoriaR = "REFORZAMIENTO"; //
            String Razon = "Prueba";

            //Funcion para convertir el formato de fecha a dd/MM/yyyy
            java.util.Date date = new java.util.Date();
            long t = date.getTime();
            java.sql.Date sqlDate = new java.sql.Date(t);
            DateFormat originalFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date Fechare = originalFormat.parse(fecharegistro);
            DateFormat targetFormat = new SimpleDateFormat("dd/MM/yyyy");
            String FECHARE = targetFormat.format(Fechare);
            //Conversion de String a Int
            int PIDMS = Integer.parseInt(pidm);

            LinkedList<PlanificacionTutorias> listaPT = new LinkedList<PlanificacionTutorias>();
            LinkedList<Uztasistentes> listaA = new LinkedList<Uztasistentes>();

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
            ResultSet rs2 = co.prepareStatement("SELECT DISTINCT SPBPERS_PIDM AS PIDM,\n"
                    + "SUBSTR(f_getspridenid(SGRADVR_ADVR_PIDM),1,12) AS ID,\n"
                    + "SPBPERS_SSN AS CEDULA,\n"
                    + "SUBSTR(f_format_name(SGRADVR_ADVR_PIDM,'LFMI'),1,30) AS NOMBRES,\n"
                    + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                    + "FROM GOREMAL\n"
                    + "WHERE GOREMAL.GOREMAL_PIDM = SGRADVR_ADVR_PIDM\n"
                    + "AND GOREMAL.GOREMAL_EMAL_CODE = 'STAN'), '') AS CORREO_INSTITUCIONAL,\n"
                    + "NVL((SELECT DISTINCT MAX (GOREMAL.GOREMAL_EMAIL_ADDRESS)\n"
                    + "FROM GOREMAL\n"
                    + "WHERE GOREMAL.GOREMAL_PIDM = SGRADVR_ADVR_PIDM\n"
                    + "AND GOREMAL.GOREMAL_EMAL_CODE = 'PERS'), '') AS CORREO_PERSONAL\n"
                    + "FROM SGRADVR, SPBPERS\n"
                    + "WHERE SGRADVR_PIDM = '"+pidm+"'\n"
                    + "AND SGRADVR_ADVR_CODE = 'TACO'\n"
                    + "AND SGRADVR_ADVR_PIDM = SPBPERS_PIDM").executeQuery();
            while (rs2.next()) {
                Uztasistentes asistentes = new Uztasistentes();
                asistentes.setSpridenPidm(rs2.getInt(1));
                asistentes.setUztasistentesId(rs2.getString(2));
                asistentes.setUztasistentesCedula(rs2.getString(3));
                asistentes.setUztasistentesNombre(rs2.getString(4));
                asistentes.setUztasistentesEmails(rs2.getString(5));
                asistentes.setUztasistentesEmailp(rs2.getString(6));
                listaA.add(asistentes);
                System.out.println("lISTA DATOS DEL DOCENTE"+ asistentes.getSpridenPidm());
            }
            rs2.close();
            int itr = 0;
            if (listaPT.isEmpty()) {
                itr = 1;
            } else {
                itr = listaPT.getLast().getIteracion() + 1;
            }
            // Auto Incrementable PK TABLA UZTPLANIF 
            int cod = 0;
            if (listaPT.isEmpty()) {
                cod = 1;
            } else {
                cod = listaPT.getLast().getCodigo_planificacion() + 1;
            };
            //SWITCH FORMULARIO
            switch (CodT) {

                case 2:
                    //Funcion para separar los valores del Nrc
                    String string = Nrc;
                    String[] parts = string.split(" - ");
                    String nrc = parts[0]; // 123
                    String codasignatura = parts[1];
                    String asignatura = parts[2]; // 123
                    String campus = parts[3];
                    String periodo = parts[4]; // 123
                    String nivel = parts[5];

                    try {
                        String sql = "INSERT INTO UTIC.UZTPLANIF(CODIGO_UZTPLANIF,CODIGO_UZGTFORMULARIOS,UZGTRESPUESTAS_ITERACION,UZTPLANIF_FECHAFORM,UZTPLANIF_TIPOPERSONA,UZTPLANIF_TITOTUTORIA,SPRIDEN_PIDM,UZTPLANIF_TEMA,UZTPLANIF_NRC,UZTPLANIF_CODIGO_ASIGNATURA,UZTPLANIF_ASIGNATURA,UZTPLANIF_PERIODO,UZTPLANIF_NIVEL,UZTPLANIF_OBSERVACION,UZTPLANIF_ESTADO,UZTPLANIF_FECHA_CREA,UZTPLANIF_USUA_CREA)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                        PreparedStatement ps = co.prepareStatement(sql);
                        ps.setInt(1, cod);
                        ps.setInt(2, CodT);
                        ps.setInt(3, 0);
                        ps.setString(4, FECHARE);
                        ps.setString(5, TPersonaE);
                        ps.setString(6, TTutoriaR);
                        ps.setInt(7, PIDMS);
                        ps.setString(8, Tema);
                        ps.setString(9, nrc);
                        ps.setString(10, codasignatura);
                        ps.setString(11, asignatura);
                        ps.setString(12, periodo);
                        ps.setString(13, nivel);
                        ps.setString(14, Observaciones);
                        ps.setString(15, EstadoT);
                        ps.setDate(16, sqlDate);
                        ps.setString(17, pidm);
                        ps.executeUpdate();
                        System.out.println(" insertado correctamente");
                    } catch (SQLException e) {
                        System.out.println("Error insertar tutoria en formulario 2: " + e);
                    }

                    try {
                        String par_mensaje = " la solicitud fue procesada el ";
                        String par_mensajeprincipal = " ";
                        String par_notificacion1 = " la tutoria " + Tema + " consta de la siguiente observacion " + Observaciones + " ";
                        String par_notificacion2 = " la Solicitud de Tutoria de " + TTutoriaR + " fue llenada exitosamente. ";

                        coWF.prepareStatement("CALL wfobjects.wzwkreport.P_Envio_Emails('" + par_mensaje + "'" + ",'" + Cedula + "'" + ",'" + Nombres + "'"
                                + ",'" + Email + "'" + ",'" + par_emailp + "'" + ",'" + par_mensajeprincipal + "'" + ",'" + par_notificacion1 + "'" + ",'" + par_notificacion2 + "'"
                                + ")").executeQuery();
                        System.out.println("Correo del formulario #2 estudiante enviado exitosamente");
                    } catch (SQLException e) {
                        System.out.println("Error envio mail  estudiante del formulario #2: " + e);
                    }
//////////////////////////////CORREO QUE LLEGA AL DOCENTE REFORZAMIENTO////
                    for (int i = 0; i < listaA.size(); i++) {
                    try {
                        String par_mensaje = " la solicitud fue procesada el ";
                        String par_mensajeprincipal = " el estudiante " + Nombres + " ";
                        String par_notificacion1 = " El tema que necesita tratar es " + Tema + " con la siguiente observacion " + Observaciones + " ";
                        String par_notificacion2 = " Tiene una solicitud de Tutoria de " + TTutoriaR + " que  fue envieda por";

                            coWF.prepareStatement("CALL wfobjects.wzwkreport.P_Envio_Emails('" + par_mensaje + "'" + ",'" + listaA.get(i).getUztasistentesCedula() + "'" + ",'" + listaA.get(i).getUztasistentesNombre() + "'"
                                    + ",'" + listaA.get(i).getUztasistentesEmails() + "'" + ",'" + listaA.get(i).getUztasistentesEmailp() + "'" + ",'" + par_mensajeprincipal + "'" + ",'" + par_notificacion1 + "'" + ",'" + par_notificacion2 + "'"
                                    + ")").executeQuery();
                             System.out.println("Correo del formulario docente #2 enviado exitosamente");
                        
                        
                    } catch (SQLException e) {
                        System.out.println("Error envio mail del formulario docente #2: " + e);}
                    }
                    coWF.close();

        %>
        <div class="container"                       
             >
             <div class="text alert alert-success" style="text-align: center;">
                <strong>
                    <p>
                        LA SOLICITUD DE REFORZAMIENO HA SIDO LLENADA EXITOSAMENTE
                    </p>
                </strong> 
            </div>
        </div>   
        <%      out.println("<meta http-equiv='refresh' content='1;URL=https://miespe.espe.edu.ec/'>");//redirects after 4 seconds    
                break;
            case 5:

                try {
                    String sql = "INSERT INTO UTIC.UZTPLANIF(CODIGO_UZTPLANIF,CODIGO_UZGTFORMULARIOS,UZGTRESPUESTAS_ITERACION,UZTPLANIF_FECHAFORM,UZTPLANIF_TIPOPERSONA,UZTPLANIF_TITOTUTORIA,SPRIDEN_PIDM,UZTPLANIF_TEMA,UZTPLANIF_OBSERVACION,UZTPLANIF_ESTADO,UZTPLANIF_FECHA_CREA,UZTPLANIF_USUA_CREA)VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
                    PreparedStatement ps = co.prepareStatement(sql);
                    ps.setInt(1, cod);
                    ps.setInt(2, CodT);
                    ps.setInt(3, 0);
                    ps.setString(4, FECHARE);
                    ps.setString(5, TPersonaE);
                    ps.setString(6, TTutoriaA);
                    ps.setInt(7, PIDMS);
                    ps.setString(8, Tema);
                    ps.setString(9, Observaciones);
                    ps.setString(10, EstadoT);
                    ps.setDate(11, sqlDate);
                    ps.setString(12, pidm);
                    ps.executeUpdate();
                    System.out.println(" insertado correctamente f5");
                } catch (SQLException e) {
                    System.out.println("Error insertar tutoria FORMULARIO 5: " + e);
                }

                try {
                    String par_mensaje = " la solicitud fue procesada el ";
                    String par_mensajeprincipal = " ";
                    String par_notificacion1 = " La tutoria " + Tema + " consta de la siguiente observacion " + Observaciones + "";
                    String par_notificacion2 = " La Solicitud de Tutoria de " + TTutoriaA + " fue llenada exitosamente. ";

                    coWF.prepareStatement("CALL wfobjects.wzwkreport.P_Envio_Emails('" + par_mensaje + "'" + ",'" + Cedula + "'" + ",'" + Nombres + "'"
                            + ",'" + Email + "'" + ",'" + par_emailp + "'" + ",'" + par_mensajeprincipal + "'" + ",'" + par_notificacion1 + "'" + ",'" + par_notificacion2 + "'"
                            + ")").executeQuery();
                } catch (SQLException e) {
                    System.out.println("Error envio mail del formulario #5: " + e);
                }
                //////////////////Correo que le llega al Docente acompanamiento//////////////
                 for (int i = 0; i < listaA.size(); i++) {
                try {
                    String par_mensaje = " la solicitud fue procesada el ";
                    String par_mensajeprincipal = " el estudiante " + Nombres + " ";
                    String par_notificacion1 = " El tema que necesita tratar es " + Tema + " con la siguiente observacion " + Observaciones + " ";
                    String par_notificacion2 = " Tiene una solicitud de Tutoria de " + TTutoriaA+ " que  fue envieda por";
                        coWF.prepareStatement("CALL wfobjects.wzwkreport.P_Envio_Emails('" + par_mensaje + "'" + ",'" + listaA.get(i).getUztasistentesCedula() + "'" + ",'" + listaA.get(i).getUztasistentesNombre() + "'"
                                + ",'" + listaA.get(i).getUztasistentesEmails() + "'" + ",'" + listaA.get(i).getUztasistentesEmailp() + "'" + ",'" + par_mensajeprincipal + "'" + ",'" + par_notificacion1 + "'" + ",'" + par_notificacion2 + "'"
                                + ")").executeQuery();
                  
                    System.out.println("Correo del formulario docente #5 enviado exitosamente");
                } catch (SQLException e) {
                    System.out.println("Error envio mail docente del formulario #5: " + e);
                }
                }  coWF.close();
        %>
        <div class="container">
            <div class="text alert alert-success" style="text-align: center;">
                <strong>
                    <p>
                        LA SOLICITUD DE ACOMPAÑAMIENTO HA SIDO LLENADA EXITOSAMENTE 
                    </p>
                </strong> 
            </div>
        </div>  
        <%  out.println("<meta http-equiv='refresh' content='1;URL=https://miespe.espe.edu.ec/'>");//redirects after 4 seconds              
                break;

            case 6:

                String tutoria = Nrcd;
                String stringd = tutoria;
                String[] partsd = stringd.split(" - ");
                String codpla = partsd[0];
                String tema = partsd[1];
                String codasis = partsd[2];

                try {
                    co.prepareStatement("UPDATE UTIC.UZTASISTENTES SET UZTASISTENTES_FECHAREGISTRO='" + FECHARE + "' ,UZTASISTENTES_CONFIRMACION='" + OptRadio + "' ,UZTASISTENTES_COMENTARIO='" + comentariost + "' ,UZTASISTENTES_OBSERVACION='" + Observaciones + "' ,UZTASISTENTES_ESTADO='C' WHERE UZTASISTENTES_CODIGO ='" + codasis + "' ").executeUpdate();
                    System.out.println("Actualizado exitosamente");
                } catch (Exception e) {
                    System.out.println("Error update confirmacion tutotia estudiante: " + e);
                }

                try {
                    String par_mensaje = "";
                    String par_mensajeprincipal = "";
                    String par_notificacion1 = " Ha confirmado que " + OptRadio + " ha recibido la tutoria " + tema + " el día " + FECHARE + "";
                    String par_notificacion2 = " Usted ";

                    coWF.prepareStatement("CALL wfobjects.wzwkreport.P_Envio_Emails('" + par_mensaje + "'" + ",'" + Cedula + "'" + ",'" + Nombres + "'"
                            + ",'" + Email + "'" + ",'" + par_emailp + "'" + ",'" + par_mensajeprincipal + "'" + ",'" + par_notificacion1 + "'" + ",'" + par_notificacion2 + "'"
                            + ")").executeQuery();
                    System.out.println("Exito al enviar email de confirmacion al estudiante: ");
                } catch (Exception e) {
                    System.out.println("Error enviar email de confirmacion de tutoria estudiante: " + e);
                }
                coWF.close();

        %>
        <br>
        <div class="container">
            <div class="text alert alert-success" style="text-align: center;">
                <strong>
                    <p>
                        LA CONFIRMACION DE LA TUTORIA HA SIDO LLENADA EXITOSAMENTE 
                    </p>
                </strong> 
            </div>
        </div>  
        <%  out.println("<meta http-equiv='refresh' content='1;URL=https://miespe.espe.edu.ec/'>");//redirects after 4 seconds     
                    break;
            }
            co.close();
            con.closeConexion();
            conWF.closeConexionWF();%>
    </body>
</html>