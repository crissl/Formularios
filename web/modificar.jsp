
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="espe.edu.ec.models.datoComun"%>
<%@page import="java.sql.SQLException"%>
<%@page import="espe.edu.ec.models.Cabecera"%>
<%@page import="espe.edu.ec.models.Matriz"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="espe.edu.ec.models.Valores"%>
<%@page import="espe.edu.ec.models.TipoPreguntas"%>
<%@page import="espe.edu.ec.models.Preguntas"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.Grupo"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Modificación-Formularios</title>
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
            request.setCharacterEncoding("UTF-8");
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();

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
            LinkedList<Formulario> listaF = new LinkedList<Formulario>();
            LinkedList<Grupo> listaG = new LinkedList<Grupo>();
            LinkedList<Preguntas> listaP = new LinkedList<Preguntas>();
            LinkedList<TipoPreguntas> listaTP = new LinkedList<TipoPreguntas>();
            LinkedList<Valores> listaV = new LinkedList<Valores>();
            LinkedList<datoComun> listaDC = new LinkedList<datoComun>();
            LinkedList<Valores> ListaVal = new LinkedList<Valores>();
            //LinkedList<Modificar> ListaM = new LinkedList<Modificar>();

            String codigoTP = request.getParameter("tipo");
            String NombreF = request.getParameter("Submit");
            int Cod = Integer.parseInt(NombreF);
            ResultSet rs = co.prepareStatement("SELECT * FROM UTIC.UZGTFORMULARIOS WHERE codigo_UZGTFORMULARIOS = '" + Cod + "'").executeQuery();
            while (rs.next()) {
                Formulario F = new Formulario();
                F.setCodigo_formulario(rs.getInt(1));
                F.setNombre_formulario(rs.getString(2));
                F.setDescripcion_formulario(rs.getString(3));
                F.setFecha_formulario(rs.getDate(4));
                F.setObjetivo_formulario(rs.getString(5));
                F.setBase_formulario(rs.getString(6));
                listaF.add(F);
            }
            rs.close();
            rs = co.prepareStatement("SELECT * FROM UTIC.UZGTGRUPO WHERE codigo_UZGTFORMULARIOS = '" + Cod + "' order by codigo_UZGTGRUPO ASC").executeQuery();
            while (rs.next()) {
                Grupo G = new Grupo();
                G.setCodigo_formulario(rs.getInt(1));
                G.setCodigo_grupo(rs.getInt(2));
                G.setNombre_grupo(rs.getString(3));
                G.setDescripcion_grupo(rs.getString(4));
                listaG.add(G);
            }
            rs.close();
            ResultSet rs1 = co.prepareStatement("SELECT * FROM UTIC.UZGTDATOSCOMUNES ORDER BY codigo_UZGTDATOSCOMUNES").executeQuery();
            while (rs1.next()) {
                datoComun DC = new datoComun();
                DC.setEtiqueta(rs1.getString(2));
                DC.setQuery(rs1.getString(3));
                listaDC.add(DC);
            }
            rs1.close();
            rs = co.prepareStatement("SELECT * FROM UTIC.UZGTPREGUNTAS WHERE codigo_UZGTFORMULARIOS = '" + Cod + "' order by codigo_UZGTPREGUNTAS ASC").executeQuery();
            while (rs.next()) {
                Preguntas P = new Preguntas();
                P.setCodigo_formulario(rs.getInt(1));
                P.setCodigo_grupo(rs.getInt(2));
                P.setCodigo_preguntas(rs.getInt(3));
                P.setCodigo_tipo_pregunta(rs.getInt(7));
                P.setLabel_pregunta(rs.getString(8));
                P.setVigente_pregunta(rs.getString(9));
                listaP.add(P);
            }
            rs.close();
            rs = co.prepareStatement("SELECT * FROM UTIC.UZGTVALORES WHERE codigo_UZGTFORMULARIOS = '" + Cod + "' order by codigo_UZGTVALORES").executeQuery();
            while (rs.next()) {
                Valores Val = new Valores();
                Val.setCodigo_Valores(rs.getInt(1));
                Val.setCodig_Formularios(rs.getInt(2));
                Val.setCodigo_Grupo(rs.getInt(3));
                Val.setCodigo_Preguntas(rs.getInt(4));
                Val.setValores(rs.getString(5));
                listaV.add(Val);
            }
            rs.close();
            rs = co.prepareStatement("SELECT * FROM UTIC.UZGTIPOPREGUNTAS ORDER BY codigo_UZGTIPOPREGUNTAS").executeQuery();
            while (rs.next()) {
                TipoPreguntas TP = new TipoPreguntas();
                TP.setCodigo_tipopregunta(rs.getInt(1));
                TP.setNombre_tipopregunta(rs.getString(2));
                listaTP.add(TP);
            }
            rs.close();
            ResultSet rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTIPOPREGUNTAS WHERE UZGTIPOPREGUNTAS_RESPUESTA = '" + codigoTP + "'").executeQuery();
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
        <%
            try {
        %> 
        <p></p><div class="container-fluid">
            <nav class="navbar navbar-default col-md-12" style='display:scroll; position:fixed; top:0px; '  role="tablist">
                <div>
                    <div class="navbar-header  ">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                                data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand"><b>Gestion de Formularios</b> </a>
                    </div>
                    <!-- Collect the nav links, forms, and other content for toggling -->
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav navbar-right">
                            <li role="presentation">
                                <a href="mostrarFormulario.jsp">
                                    <i class='fa fa-angle-double-left'>&nbsp</i>Volver</a>
                            </li>

                        </ul>

                        <ul class="nav navbar-nav navbar-right">
                            <li><a><% out.print(id);%></a></li>
                        </ul>
                    </div><!-- /.navbar-collapse -->
                </div><!-- /.container-fluid -->
            </nav> <br><br><br>
            <!-- -----------------------------Fin Navbar superior-------------------------------------------  -->

            <br>
            <form action="modificado.jsp" method="POST">
                <div class="container">
                    <%request.setCharacterEncoding("UTF-8");
                        out.println("</div></div><div class=\"row\">");
                        out.println("<input type=\"text\" class=\"col-md-offset-2 col-md-8 panel panel-info panel-heading text-center\" name=\"nombreF\" value=" + "\"" + listaF.getFirst().getNombre_formulario() + "\"/></center></div>");
                        out.println("</div>");
                        for (int i = 0; i < listaG.size(); i++) {
                            out.println("<div class=\"row\">");
                            out.println("<center><input class=\"col-md-offset-2 col-md-8 panel panel-info panel-heading text-center\" name=\"nomG" + i + "\"  value=" + "\"" + listaG.get(i).getNombre_grupo() + "\"/></center></div>");
                            out.println("</div>");
                            for (int j = 0; j < listaP.size(); j++) {
                                if (listaP.get(j).getCodigo_grupo() == listaG.get(i).getCodigo_grupo()) {
                                    out.println("<div class=\"row\">");
                                    out.println("<input class=\"col-md-offset-2 col-md-8 panel panel-info panel-heading text-center\" name=\"nomP" + i + "\" value=" + "\"" + listaP.get(j).getLabel_pregunta() + "\"/>");
                                    out.println("</div>");
                                    if (listaP.get(j).getCodigo_tipo_pregunta() == 1) {
                                    }
                                    if (listaP.get(j).getCodigo_tipo_pregunta() == 2) {
                                        out.println("</div>");
                                        for (int k = 0; k < listaV.size(); k++) {
                                            if (listaV.get(k).getCodigo_Preguntas() == listaP.get(j).getCodigo_preguntas()) {
                                                out.println("<div class=\"row\">");
                                                out.println("<div class=\"col-md-offset-2 col-md-8 \"><label><input type=\"text\" name=\"Seleccion" + k + "\" value=" + "\"" + listaV.get(k).getValores() + "\"/></input></label></div>");
                                                out.println("</div>");
                                            }
                                        }
                                    }
                                    if (listaP.get(j).getCodigo_tipo_pregunta() == 3) {
                                        out.println("</div>");
                                        for (int k = 0; k < listaV.size(); k++) {
                                            if (listaV.get(k).getCodigo_Preguntas() == listaP.get(j).getCodigo_preguntas()) {
                                                out.println("<div class=\"row\">");
                                                out.println("<div class=\"col-md-offset-2 col-md-8\"><input type=\"text\" name=\"seleccion" + k + "\" value=" + "\"" + listaV.get(k).getValores() + "\"/></input></div>");
                                                out.println("</div>");
                                            }
                                        }
                                    }
                                    if (listaP.get(j).getCodigo_tipo_pregunta() == 5) {
                                        out.println("<div class=\"row\">");
                                        out.println("<div class=\"col-md-offset-2 col-md-5\"><select type=\"text\" name=\"lista\">");
                                        for (int k = 0; k < listaV.size(); k++) {
                                            if (listaV.get(k).getCodigo_Preguntas() == listaP.get(j).getCodigo_preguntas()) {
                                                out.println("<option>" + listaV.get(k).getValores() + "</option>");
                                            }
                                        }
                                        out.println("</select></br>");
                                        out.println("</div></br>");
                                    }
                                    if (listaP.get(j).getCodigo_tipo_pregunta() == 4) {
                                        out.println("</br><div class=\"row\">");
                                        rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTMATRIZ WHERE codigo_UZGTPREGUNTAS = '" + listaP.get(j).getCodigo_preguntas() + "'order by codigo_uzgtmatriz ASC").executeQuery();
                                        LinkedList<Matriz> ListaMatriz = new LinkedList<Matriz>();
                                        LinkedList<Cabecera> ListaCabeceras = new LinkedList<Cabecera>();
                                        while (rs2.next()) {
                                            Matriz Mat = new Matriz(rs2.getInt(1), rs2.getInt(2), rs2.getInt(3), rs2.getInt(4), rs2.getInt(5), rs2.getInt(6), rs2.getString(7));
                                            ListaMatriz.add(Mat);
                                        }
                                        rs2.close();
                                        int mat = ListaMatriz.getFirst().getCodigo_matriz();
                                        int filas = ListaMatriz.getFirst().getFila() + 1;
                                        int columnas = ListaMatriz.getFirst().getColumna() + 1;
                                        ResultSet rs3 = co.prepareStatement("SELECT * FROM UTIC.UZGTCABECERAS WHERE codigo_UZGTMATRIZ = '" + mat + "' order by codigo_uzgtcabezera ASC").executeQuery();
                                        while (rs3.next()) {
                                            Cabecera Cab = new Cabecera(rs3.getInt(1), rs3.getInt(2), rs3.getString(3), rs3.getInt(4), rs3.getInt(5));
                                            ListaCabeceras.add(Cab);
                                        }
                                        rs3.close();
                                        out.println("<div class=\"col-md-offset-2 col-md-8 table-responsive\"><table class=\"table table-bordered\">");
                                        int puntero = 0;
                                        for (int n = 0; n < filas; n++) {
                                            out.println("<tr>");
                                            for (int m = 0; m < columnas; m++) {
                                                if (puntero < ListaCabeceras.size() && ListaCabeceras.get(puntero).getPosicionX() == n && ListaCabeceras.get(puntero).getPosicionY() == m) {
                                                    out.println("<th>" + ListaCabeceras.get(puntero).getValor_cabecera() + "</th>");
                                                    puntero++;
                                                } else {
                                                    out.println("<td><input type=\"text\" name=\"Texto\" placeholder=\"Texto\"'></td>");
                                                }
                                            }
                                            out.println("</tr>");
                                        }
                                        out.println("</table>");
                                        out.println("</div>");
                                    }
                                }
                            }
                        }
                        out.println("<div class=\"col-md-1\"></div>");
                        out.println("</div><div class=\"col-md-auto\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" value='" + Cod + "'><strong>Modificar</strong></button></center>");
                    %>
                </div>
            </form>
            <!--AQUI EMPIEZA PARA AGREGAR UNA pregunta-->
            <center><div class="col-md-12" align="center"><h4 class="text alert alert-success">Agregar pregunta.</h4></div></center></br>
            <form action="Npregunta.jsp" method="POST">  

                
              

                    <div class="col-md-auto"><center><button class="btn btn-success" type="submit" name="Submit" value="<%=Cod%>"><strong>AGREGAR</strong></button></center></div>
            

        </div>
    </form>                    







    <%            con.closeConexion();
        } catch (Exception e) {
            System.out.println("ERROR Modificar:  " + e);
        }
    %>
</body>
<script>
    function yesnoCheck(that) {
        if (that.value == "DATOS COMUNES") {
            document.getElementById("ifYes").style.display = "block";
        } else {
            document.getElementById("ifYes").style.display = "none";
        }
    }
</script>
</html>