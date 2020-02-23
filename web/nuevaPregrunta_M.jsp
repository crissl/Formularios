<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.models.datoComun"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.IOException"%>
<%@page import="java.sql.SQLException"%>
<%@page import="espe.edu.ec.models.Valores"%>
<%@page import="espe.edu.ec.models.TipoPreguntas"%>
<%@page import="espe.edu.ec.models.Preguntas"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.Grupo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.models.ParametrosBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pregunta-Formularios</title>
        <%
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
            String currentUser = pidm;
            String nombreg = request.getParameter("codg");
            int codgf = Integer.parseInt(nombreg);
            String NombreF = request.getParameter("Submit");
            int Cod = Integer.parseInt(NombreF);
            java.util.Date date = new java.util.Date();
            long t = date.getTime();
            java.sql.Date sqlDate = new java.sql.Date(t);
            request.setCharacterEncoding("UTF-8");
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            String codigoTP = request.getParameter("tipo");
            LinkedList<Grupo> listaG = new LinkedList<Grupo>();
            LinkedList<Preguntas> listaP = new LinkedList<Preguntas>();
            LinkedList<TipoPreguntas> listaTP = new LinkedList<TipoPreguntas>();
            LinkedList<Valores> ListaVal = new LinkedList<Valores>();
            ResultSet rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTGRUPO  WHERE CODIGO_UZGTGRUPO = '"+codgf+"' ORDER BY codigo_UZGTGRUPO ASC").executeQuery();
            while (rs2.next()) {
                Grupo G = new Grupo();
                G.setCodigo_formulario(rs2.getInt(1));
                G.setCodigo_grupo(rs2.getInt(2));
                G.setNombre_grupo(rs2.getString(3));
                G.setDescripcion_grupo(rs2.getString(4));

                listaG.add(G);
            }
            rs2.close();
            rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTPREGUNTAS ORDER BY codigo_UZGTPREGUNTAS ASC").executeQuery();
            while (rs2.next()) {
                Preguntas P = new Preguntas();
                P.setCodigo_formulario(rs2.getInt(1));
                P.setCodigo_grupo(rs2.getInt(2));
                P.setCodigo_preguntas(rs2.getInt(3));
                //P.setCodigo_formulario_anidado(rs3.getInt(4));
                //P.setCodigo_grupo_anidado(rs3.getInt(5));
                //P.setCodigo_pregunta_anidada(rs3.getInt(6));
                P.setCodigo_tipo_pregunta(rs2.getInt(7));
                P.setLabel_pregunta(rs2.getString(8));
                P.setVigente_pregunta(rs2.getString(9));
                listaP.add(P);
            }
            rs2.close();
            rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTIPOPREGUNTAS WHERE UZGTIPOPREGUNTAS_RESPUESTA = '" + codigoTP + "'").executeQuery();
            while (rs2.next()) {
                TipoPreguntas TP = new TipoPreguntas();
                TP.setCodigo_tipopregunta(rs2.getInt(1));
                TP.setNombre_tipopregunta(rs2.getString(2));
                listaTP.add(TP);
            }
            rs2.close();


        %>
    </head>
    <body>
        <%             try {

                String pregunta = "";
                request.setCharacterEncoding("UTF-8");
                pregunta = request.getParameter("pregunta");

                System.out.println("Antes del Upper" + pregunta);
                pregunta = pregunta.toUpperCase();
                System.out.println("Despues del Upper" + pregunta);

                String vigente = "<" + request.getParameter("vigente") + ">";
                System.out.println("codigo fomulario fk: " + Cod);
                int codg = listaG.getLast().getCodigo_grupo();
                System.out.println("codigo grupo" + codg);
                //  JOptionPane.showMessageDialog(null, request.getParameter("etiqueta"));
                int codp = 0;
                if (listaP.isEmpty()) {
                    codp = 0;
                } else {
                    codp = listaP.getLast().getCodigo_preguntas() + 1;
                }
                System.out.println("fk rpregunta" + codp);
                int codtp = 0;
                int codval = 0;
                codtp = listaTP.getFirst().getCodigo_tipopregunta();
                try {
                    try {
                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTPREGUNTAS(codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS,uti_codigo_UZGTFORMULARIOS,uti_codigo_UZGTGRUPO,uti_codigo_UZGTPREGUNTAS,codigo_UZGTIPOPREGUNTAS,UZGTPREGUNTAS_pregunta,UZGTPREGUNTAS_vigente,UZGTPREGUNTAS_FECHA_CREA,UZGTPREGUNTAS_USUA_CREA)"
                                + " VALUES (?,?,?,?,?,?,?,?,?,?,?)");
                        ps.setInt(1, Cod);
                        ps.setInt(2, codgf);
                        ps.setInt(3, codp);
                        ps.setString(4, null);
                        ps.setString(5, null);
                        ps.setString(6, null);
                        ps.setInt(7, codtp);
                        ps.setString(8, pregunta);
                        ps.setString(9, vigente);
                        ps.setDate(10, sqlDate);
                        ps.setString(11, pidm);
                        ps.executeUpdate();
                        ps.close();
                    } catch (Exception e) {

                        System.out.println("error nPregunta " + e);
                    }
                    System.out.println(pregunta);
                    //////////////////////////////////////////////////////////////////INSERT VALOR DATO COMUN
                    ResultSet rs4 = co.prepareStatement("SELECT * FROM UTIC.UZGTVALORES ORDER BY codigo_UZGTVALORES ASC").executeQuery();
                    while (rs4.next()) {
                        Valores Val = new Valores();
                        Val.setCodigo_Valores(rs4.getInt(1));
                        Val.setCodig_Formularios(rs4.getInt(2));
                        Val.setCodigo_Grupo(rs4.getInt(3));
                        Val.setCodigo_Preguntas(rs4.getInt(4));
                        Val.setValores(rs4.getString(5));
                        ListaVal.add(Val);
                    }
                    rs4.close();

                    if (ListaVal.isEmpty()) {
                        codval = 1;
                    } else {
                        codval = ListaVal.getLast().getCodigo_Valores() + 1;
                    }
                    //////////////////////////////////////////////////////
                    if (codtp == 2 || codtp == 3) {
                        // out.println("<input type=\"hidden\" name=\"preguntas\" value=\""+pregunta+"\"></div>");
                        out.println("<script type=\"text/javascript\">window.location=\"Valores.jsp\";</script>");

                    }
                    if (codtp == 5) {
                        out.println("<script type=\"text/javascript\">window.location=\"listadatos.jsp\";</script>");
                    }
                    if (codtp == 6) {
                        out.println("<script type=\"text/javascript\">window.location=\"pregunta.jsp\";</script>");
                    }
                    if (codtp == 7) {
                        out.println("<script type=\"text/javascript\">window.location=\"pregunta.jsp\";</script>");
                    }
                    if (codtp == 8) {
                        out.println("<script type=\"text/javascript\">window.location=\"pregunta.jsp\";</script>");
                    }
                    if (codtp == 4) {
                        out.println("<script type=\"text/javascript\">window.location=\"Matriz.jsp\";</script>");
                    }
                    if (codtp == 1) {
                        out.println("<script type=\"text/javascript\">window.location=\"pregunta.jsp\";</script>");
                    }
                    if (codtp == 9) {
                        //JOptionPane.showMessageDialog(null, request.getParameter("etiqueta"));
                        /*DATOS COMUNES*/
                        LinkedList<datoComun> listaDC = new LinkedList<datoComun>();
                        ResultSet rs1 = co.prepareStatement("SELECT * FROM UTIC.UZGTDATOSCOMUNES ORDER BY codigo_UZGTDATOSCOMUNES").executeQuery();
                        while (rs1.next()) {
                            datoComun DC = new datoComun();
                            DC.setEtiqueta(rs1.getString(2));
                            DC.setQuery(rs1.getString(3));
                            listaDC.add(DC);
                        }
                        rs1.close();
                        for (int i = 0; i < listaDC.size(); i++) {
                            if (request.getParameter("etiqueta").equals(listaDC.get(i).getEtiqueta())) {
                                try {
                                    String Val = request.getParameter("etiqueta");
                                    PreparedStatement ps1 = co.prepareStatement("INSERT INTO UTIC.UZGTVALORES(codigo_UZGTVALORES,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS,"
                                            + "UZGTTIPOPREGUNTAS_valor,UZGTVALORES_FECHA_CREA,UZGTVALORES_USUA_CREA)"
                                            + " VALUES (?,?,?,?,?,?,?)");
                                    ps1.setInt(1, codval);
                                    ps1.setInt(2, Cod);
                                    ps1.setInt(3, codg);
                                    ps1.setInt(4, codp);
                                    ps1.setString(5, listaDC.get(i).getEtiqueta());
                                    ps1.setDate(6, sqlDate);
                                    ps1.setString(7, pidm);
                                    ps1.executeUpdate();
                                    ps1.close();
                                } catch (Exception e) {
                                    System.out.println("error insert valores nPREGUBTA" + e);
                                }
                            }
                        }
                        out.println("<script type=\"text/javascript\">window.location=\"Npregunta.jsp\";</script>");
                    }
                } catch (Exception ex) {
                    out.println(ex);
                }
                con.closeConexion();
        %>
        <%             } catch (Exception e) {
                System.out.println("ERROR Nueva Pregunta: " + e);

            }
        %>
 
    </body>
</html>
