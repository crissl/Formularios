<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="java.sql.SQLException"%>
<%@page import="espe.edu.ec.util.BorrarFormulario"%>
<%@page import="espe.edu.ec.models.FormPersona"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="espe.edu.ec.models.Cabecera"%>
<%@page import="espe.edu.ec.models.Matriz"%>
<%@page import="espe.edu.ec.models.TipoPreguntas"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="espe.edu.ec.models.Grupo"%>
<%@page import="espe.edu.ec.models.Preguntas"%>
<%@page import="espe.edu.ec.models.Valores"%>
<%@page import="espe.edu.ec.models.Respuestas"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%  DB2 con = DB2.getInstancia();
    Connection co = con.getConnection();
    Cookie cookie = null;
    Cookie[] cookies = null;
    String pidms = null;
    String id = null;
    cookies = request.getCookies();
    if (cookies != null) {
        for (int i = 0; i < cookies.length; i++) {
            cookie = cookies[i];
            if (cookie.getName().equals("pidm")) {
                pidms = cookie.getValue();
            } else if (cookie.getName().equals("id")) {
                id = cookie.getValue();
            }
        }
    } else {
        out.println("<h2>No cookies founds</h2>");
    }

    int PIDM = Integer.parseInt(pidms);
    out.println(ConstantesForm.Css);
    out.println(ConstantesForm.js);

    LinkedList<Formulario> listaF = new LinkedList<Formulario>();
    LinkedList<Grupo> listaG = new LinkedList<Grupo>();
    LinkedList<Preguntas> listaP = new LinkedList<Preguntas>();
    LinkedList<TipoPreguntas> listaTP = new LinkedList<TipoPreguntas>();
    LinkedList<Valores> listaV = new LinkedList<Valores>();
    LinkedList<Respuestas> listaR = new LinkedList<Respuestas>();
    FormPersona fp = new FormPersona();
    String pidmS = request.getParameter("pidm");
    int pidm = Integer.parseInt(pidmS);
    int Cod = 0;
    int CodFP = 0;
    int CodFP1 = 0;

    int iteracion = 0;
    String NombreF = request.getParameter("cod");
    if (NombreF != null) {
        Cod = Integer.parseInt(NombreF);
    }
    String NombreF2 = request.getParameter("codfp1");
   
    String NombreF1 = request.getParameter("codfp");
   
    String itera = request.getParameter("iteracion");
    if (itera != null) {
        iteracion = Integer.parseInt(itera);
    }

    String BorrarF = request.getParameter("Borrar");
    if (BorrarF != null) {
        Cod = Integer.parseInt(BorrarF);
    }   /*aqui obtengo el "codigo form persona" que pertenece al "formulario" que seleccion y el "pidm"*/
     if (NombreF2 != null) {
        CodFP = Integer.parseInt(NombreF2);
    }else{
        CodFP = Integer.parseInt(NombreF1);
    }
     
    try {
        //JOptionPane.showMessageDialog(null, "try: ");
        ResultSet rest = co.prepareStatement("select * from UTIC.uzgtrespuestas where codigo_uzgtformularios=" + Cod + " and spriden_pidm=" + pidm + " and CODIGO_UZGTFORMULARIOS_PERSONA='" + CodFP + "'").executeQuery();
        while (rest.next()) {
            //JOptionPane.showMessageDialog(null, "codigo fp: "+rest.getInt(2));
            fp.setCodFormP(rest.getInt(2));
        }
        rest.close();
    } catch (SQLException er) {
    }
    /*obtener datos del formulario*/
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
    rs = co.prepareStatement("SELECT * FROM UTIC.UZGTPREGUNTAS WHERE codigo_UZGTFORMULARIOS = '" + Cod + "' order by codigo_UZGTPREGUNTAS ASC").executeQuery();
    while (rs.next()) {
        Preguntas P = new Preguntas();
        P.setCodigo_formulario(rs.getInt(1));
        P.setCodigo_grupo(rs.getInt(2));
        P.setCodigo_preguntas(rs.getInt(3));
        P.setCodigo_tipo_pregunta(rs.getInt(7));
        P.setLabel_pregunta(rs.getString(8));
        listaP.add(P);
    }
    rs.close();
    rs = co.prepareStatement("SELECT * FROM UTIC.UZGTVALORES WHERE codigo_UZGTFORMULARIOS = '" + Cod + "' order by codigo_UZGTPREGUNTAS ASC").executeQuery();
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
    /*selecciono las respuestas de acuerdo al "pidm", "cod_form_persona" y "codigo_form"*/
    int conC = 0;

    rs = co.prepareStatement("select * from UTIC.uzgtrespuestas where codigo_UZGTFORMULARIOS=" + Cod + " and codigo_uzgtformularios_persona=" + CodFP + " and spriden_pidm=" + pidm + " and uzgtrespuestas_iteracion=" + iteracion + " ORDER BY CODIGO_UZGTRESPUESTAS ASC").executeQuery();
    while (rs.next()) {
        Respuestas res = new Respuestas();
        //res.setPidm_usuario(1234);
        res.setCodigo_persona(rs.getInt(2));
        res.setCodigo_formulario(rs.getInt(3));
        res.setCodigo_grupo(rs.getInt(4));
        res.setCodigo_preguntas(rs.getInt(5));
        res.setCodigo_Respuestas(rs.getInt(6));
        res.setValor_Respuestas(rs.getString(7));
        listaR.add(res);
    }
    rs.close();
    
    
    
   
    if (ConstantesForm.admin.contains(PIDM) || ConstantesForm.helpDesk.contains(PIDM)) {%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Formulario-Respuesta</title>

    </head>
    <body>
            <%             try {

                    if (listaR.isEmpty()) {
                        out.print("<div id=\"imprimir\">");
                        out.print("<div class=\"row bg-default\">");
                        out.print("<div class=\"col-md-2\"></div>");
                        out.print("</div>");
                        out.print("<ul class=\"nav nav-tabs\" role=\"tablist\">");
                        out.print("</ul>");
                        out.print("<div class=\"container\">");
                        out.print("<center><div class=\"alert alert-info\">El usuario con el pidm seleccionado no ha llenado el formulario</div></center>");
            } else {
            %>
        <div id="imprimir">
            <div class="row bg-default">
                <div class="col-md-2"><center><img src="Imagenes/espelogo.jpg"/></center></div>
                <div class="col-md-2"></div>
            </div>
            <ul class="nav nav-tabs" role="tablist">
            </ul>
            <!--PARTE AGREGADA PARA PROBAR IMPRESION JUNTO CON RESPUESTAS EDIT-->
            <div class="container" class="col-md-10">

                <%          try {
                            out.println("<div class=\"row\">");
                            out.println("<div class=\"col-md-offset-2 col-md-8\"><center><h5 class=\"text-uppercase\">" + listaF.getFirst().getNombre_formulario() + "</h5></center></div>");
                            out.println("<div class=\"col-md-12\"><h6 class=\"text-success text-uppercase\">" + " *" + listaF.getFirst().getDescripcion_formulario() + "</h6></div>");
                            out.println("</div>");
                        } catch (Exception e) {
                            System.out.println("cabeceras" + e.getMessage());
                        }
                        int numT1 = 0;
                        int numC1 = 0;
                        int numR1 = 0;
                        int numL1 = 0;
                        int numFech1 = 0;
                        int numN1 = 0;
                        int numA = 0;
                        int contRM = 1;
                        int numDC = 0;
                        int codR = 0;
                        try {
                            for (int i = 0; i < listaG.size(); i++) {
                                out.println("<div class=\"col-md-offset-2 col-md-8 panel panel-info panel-heading\"><center><h5 class=\"panel-title\">" + listaG.get(i).getNombre_grupo() + "</h5></center></div>");
                                out.println("<div class=\"col-md-12\"><h6 class=\"text-success text-uppercase\">" + " *" + listaG.get(i).getDescripcion_grupo() + "</h6></div>");
                                try {
                                    for (int j = 0; j < listaP.size(); j++) {
                                        if (listaP.get(j).getCodigo_grupo() == listaG.get(i).getCodigo_grupo()) {
                                            out.println("<p></p><div class=\"col-md-offset-2 col-md-4 text-right\"><b>" + listaP.get(j).getLabel_pregunta() + " :</b></div>");

                                            int codP = listaP.get(j).getCodigo_preguntas();
                                            ////////////////////////////////TIPO TEXTO//////////////////////////////////
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 1) {
                                                    out.println("<div class=\"col-md-4\">" + listaR.get(codR).getValor_Respuestas() + ":</div>");
                                                    codR++;
                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P1" + e.getMessage());
                                            }
                                            /*DATOS COMUNES*/
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 9) {
                                                    out.println("<p></p><div class=\"col-md-4\">" + listaR.get(codR).getValor_Respuestas() + ".</div>");
                                                    numDC++;
                                                    codR++;
                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P9" + e.getMessage());
                                            }
                                            //////////////////////////////RADIO BUTTON/////////////////////////////////////////////
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 2) {
                                                    for (int k = 0; k < listaV.size(); k++) {
                                                        if (listaV.get(k).getCodigo_Preguntas() == listaP.get(j).getCodigo_preguntas()) {
                                                            //recorrer lista de respuestas
                                                            if (listaV.get(k).getValores().equals(listaR.get(codR).getValor_Respuestas())) {
                                                                out.println("<li class=\"col-md-offset-6 col-md-4\">&nbsp&nbsp" + listaV.get(k).getValores() + "</li>");
                                                                codR++;
                                                            }

                                                        }

                                                    }
                                                }//cierre del Radiobottom
                                            } catch (Exception e) {
                                                System.out.println("Exception P2" + e.getMessage());
                                            }
                                            try {
                                                ///////////////////////////CHECKBOX///////////////////
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 3) {
                                                    out.println("<div class=\"col-md-6\">" + listaR.get(codR).getValor_Respuestas() + "</div>");
                                                    codR++;
                                                }
                                            } catch (Exception e) {
                                                System.out.println("ERROR P3 L249" + e);
                                            }
                                            ////////////////////////LISTA QUERY///////////////////////////////////////////////
                                            System.out.println(" P3 lista.codR: " + listaR.get(codR).getValor_Respuestas());

                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 5) {
                                                    out.println("<div class=\"col-md-6\">" + listaR.get(codR).getValor_Respuestas() + ".</div>");
                                                    codR++;
                                                    //System.out.println("Exception P5 codR" + codR);

                                                }
                                            } catch (Exception e) {
                                                //System.out.println("Exception P5" + e);
                                            }
                                            ////////////////////////////////Guardar Archivo/////////////////////////////////
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 6) {
                                                    numA++;
                                                    out.println("<form name = \"asd\" action=\"downloadFileServlet\" method=\"POST\" >");
                                                    out.println("<input type=\"hidden\" name=\"codigo\" value=\"" + Cod + "\">");
                                                    out.println("<input type=\"hidden\" name=\"codForm\" value=\"" + fp.getCodFormP() + "\">");
                                                    out.println("<input type=\"hidden\" name=\"pidm\" value=\"" + pidm + "\">");
                                                    out.println("<input type=\"hidden\" name=\"pregunta\" value=\"" + listaP.get(j).getCodigo_preguntas() + "\">");
                                                    out.println("<input type=\"hidden\" name=\"iter\" value=\"" + iteracion + "\">");
                                                    out.println("<div class=\"col-md-6\"><center<button class=\"btn btn-success\"type=\"submit\" name=\"archivo\">Descargar</button></center></div>");
                                                    out.println("</form>");
                                                    codR++;
                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P6" + e.getMessage());
                                            }
                                            ////////////////////////TIPO DATE///////////////////////////////////////////////
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 7) {
                                                    out.println("<div class=\"col-md-4\">" + listaR.get(codR).getValor_Respuestas() + "</div>");
                                                    codR++;
                                                    System.out.println("Respuestas lista Fecha: P7" + listaR.get(codR).getValor_Respuestas());
                                                    System.out.println("Respuestas CodR P7" + codR++);

                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P7" + e.getMessage());
                                            }
                                            //////////////////////Tipo Numerico////////////////////////////////////////////
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 8) {
                                                    out.println("<div class=\"col-md-4\">" + listaR.get(codR).getValor_Respuestas() + "</div>");
                                                    codR++;
                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P8" + e.getMessage());
                                            }
                                            try {
                                                ////////////////////////////////////////////Matriz////////////////////////////////////
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 4) {
                                                    ResultSet rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTMATRIZ WHERE codigo_UZGTPREGUNTAS = '" + listaP.get(j).getCodigo_preguntas() + "'order by codigo_uzgtmatriz ASC").executeQuery();
                                                    LinkedList<Matriz> ListaMatriz = new LinkedList<Matriz>();
                                                    LinkedList<Cabecera> ListaCabeceras = new LinkedList<Cabecera>();
                                                    while (rs2.next()) {
                                                        try {
                                                            Matriz Mat = new Matriz(rs2.getInt(1), rs2.getInt(2), rs2.getInt(3), rs2.getInt(4), rs2.getInt(5), rs2.getInt(6), rs2.getString(7));
                                                            ListaMatriz.add(Mat);
                                                        } catch (Exception e) {
                                                            System.out.println("Exception M select" + e.getMessage());
                                                        }
                                                    }
                                                    rs2.close();
                                                    int mat = ListaMatriz.getFirst().getCodigo_matriz();
                                                    int filas = ListaMatriz.getFirst().getFila() + 1;
                                                    int columnas = ListaMatriz.getFirst().getColumna() + 1;
                                                    ResultSet rs3 = co.prepareStatement("SELECT * FROM UTIC.UZGTCABECERAS WHERE codigo_UZGTMATRIZ = '" + mat + "' order by codigo_uzgtcabezera ASC").executeQuery();
                                                    while (rs3.next()) {
                                                        try {
                                                            Cabecera Cab = new Cabecera(rs3.getInt(1), rs3.getInt(2), rs3.getString(3), rs3.getInt(4), rs3.getInt(5));
                                                            ListaCabeceras.add(Cab);
                                                        } catch (Exception e) {
                                                            System.out.println("Exception M select" + e.getMessage());
                                                        }
                                                    }
                                                    rs3.close();
                                                    try {
                                                        out.println("<div class=\"col-md-12 table-responsive\"><table class=\"table table-bordered\">");
                                                    } catch (Exception e) {
                                                        System.out.println("Exception M select" + e.getMessage());
                                                    }
                                                    int puntero = 0;
                                                    for (int n = 0; n < filas; n++) {
                                                        out.println("<tr>");
                                                        for (int m = 0; m < columnas; m++) {
                                                            if (puntero < ListaCabeceras.size() && ListaCabeceras.get(puntero).getPosicionX() == n && ListaCabeceras.get(puntero).getPosicionY() == m) {
                                                                out.println("<th>" + ListaCabeceras.get(puntero).getValor_cabecera() + "</th>");
                                                                puntero++;
                                                            } else {
                                                                if (n == 0 && m == 0) {
                                                                    out.println("<td><input type=\"text\" name=\"Texto\" placeholder=\"Item\"' disabled></td>");
                                                                } else {
                                                                    try {
                                                                        out.println("<td><input type=\"text\" name=\"Texto" + contRM + "\" placeholder=\"" + listaR.get(codR).getValor_Respuestas() + "\"' disabled></td>");
                                                                        numDC++;
                                                                        contRM++;
                                                                        codR++;

                                                                    } catch (Exception e) {
                                                                        System.out.println("error mostrar mru." + e.getMessage());
                                                                    }
                                                                }
                                                            }

                                                        }

                                                    }
                                                    out.println("</tr>");
                                                    out.println("</table>");
                                                    out.println("</div>");

                                                }
                                            } catch (Exception e) {
                                                System.out.println("error Matriz" + e.getMessage());
                                            }
                                            //cierre if de la matriz

                                        }
                                    }
                                } catch (Exception e) {
                                    System.out.println("Error for j" + e);
                                }
                            }
                        } catch (Exception e) {
                            System.out.println("Total" + e.getMessage());
                        }
                        out.println("<div class=\"row\">");
                        out.println("<br><div class=\"col-md-4\"></div>");
                        out.println("</div>");
                    }//cierre de else en caso de que existan respuestas para el usuario
                    con.closeConexion();
                %>
            </div>
            <script type="text/javascript">
                function info() {
                    pulsado = document.elegir.radio;
                    for (i = 0; i < pulsado.length; i++) {
                        valor = pulsado[i].checked;
                        if (valor == true) {
                            elegido = pulsado[i].value;
                        }
                    }
                }
                function Imprimir_Contenido()
                {
                    var ficha = document.getElementById("imprimir");
                    var Ventana_Impresion = window.open(' ', 'popimpr');
                    Ventana_Impresion.document.write(ficha.innerHTML);
                    Ventana_Impresion.document.close();
                    Ventana_Impresion.print();
                    Ventana_Impresion.close();
                }
            </script>
            <br>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-6"> <center><a href="javascript:Imprimir_Contenido()" class="btn btn-success btn-lg">
                            <span  class="d-inline-block" tabindex="0" data-toggle="tooltip" title="Imprimir" class="glyphicon glyphicon-print  /*alert alert-info*/">
                                <i class='fas fa-print'style='font-size:35px' ></i></span>  
                        </a><center></center></div>
                <button style='display:scroll; position:fixed; bottom:30px; right:0px;' class="btn btn-info" data-toggle="tooltip" data-placement="top" title="Volver"> 
                    <a href="mostrarRespuesta.jsp">
                        <i class='fa fa-angle-double-left' style='font-size:40px;color:white;'></i></a>
                </button>
            </div> 
            <%             } catch (Exception e) {
                    System.out.println("error final mruHD." + e);
                }
            %>
    </body>
</html>
<%} ///////////////////////////////////////////MOSTRAR RESPUEST//////////////////////////////////////////////
else {
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <%             try {

                if (listaR.isEmpty()) {
                    out.print("<div id=\"imprimir\">");
                    out.print("<div class=\"row bg-default\">");
                    out.print("<div class=\"col-md-2\"><center><img src=\"espelogo.jpg\"/></center></div>");
                    out.print("<div class=\"col-md-2\"></div>");
                    out.print("</div>");
                    out.print("<ul class=\"nav nav-tabs\" role=\"tablist\">");
                    out.print("<button align=\"center\" class=\"btn btn-primary\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Volver\"><div class=\"col-md-3\"><a href=\"mostrarRespuesta.jsp?Submit=" + Cod + " \"><i class=\"fas fa-arrow-left\" style=\"font-size:40px;color:white\"></i></a></button>");
                    out.print("</ul>");
                    out.print("<div class=\"container\">");
                    out.print("<center><div class=\"alert alert-info\">El usuario con el pidm seleccionado no ha llenado el formulario</div></center>");
                } else {
        %>
        <div id="imprimir">
            <div class="row bg-default">
                <div class="col-md-2"><center><img src="Imagenes/espelogo.jpg"/></center></div>
                <div class="col-md-2"></div>
            </div>
            <ul class="nav nav-tabs" role="tablist">
            </ul>

            <!--PARTE AGREGADA PARA PROBAR IMPRESION JUNTO CON RESPUESTAS EDIT-->
            <div class="container" class="col-md-10">
                <%                    try {
                            out.println("<div class=\"row\">");
                            out.println("<div class=\"col-md-offset-2 col-md-8\"><center><h5 class=\"text-uppercase\">" + listaF.getFirst().getNombre_formulario() + "</h5></center></div>");
                            out.println("<div class=\"col-md-12\"><h6 class=\"text-success text-uppercase\">" + " *" + listaF.getFirst().getDescripcion_formulario() + "</h6></div>");
                            out.println("</div>");
                        } catch (Exception e) {
                            System.out.println("cabeceras" + e.getMessage());
                        }
                        int numT1 = 0;
                        int numC1 = 0;
                        int numR1 = 0;
                        int numL1 = 0;
                        int numFech1 = 0;
                        int numN1 = 0;
                        int numA = 0;
                        int contRM = 0;
                        int numDC = 0;
                        int codR = 0;
                        try {
                            for (int i = 0; i < listaG.size(); i++) {
                                out.println("<div class=\"col-md-offset-2 col-md-8 panel panel-info panel-heading\"><center><h5 class=\"panel-title\">" + listaG.get(i).getNombre_grupo() + "</h5></center></div>");
                                out.println("<div class=\"col-md-12\"><h6 class=\"text-success text-uppercase\">" + " *" + listaG.get(i).getDescripcion_grupo() + "</h6></div>");
                                try {
                                    for (int j = 0; j < listaP.size(); j++) {
                                        if (listaP.get(j).getCodigo_grupo() == listaG.get(i).getCodigo_grupo()) {
                                            out.println("<p></p><div class=\"col-md-offset-2 col-md-4 text-right\"><b>" + listaP.get(j).getLabel_pregunta() + " :</b></div>");

                                            int codP = listaP.get(j).getCodigo_preguntas();
                                            ////////////////////////////////TIPO TEXTO//////////////////////////////////
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 1) {
                                                    out.println("<div class=\"col-md-4\">" + listaR.get(codR).getValor_Respuestas() + ":</div>");
                                                    codR++;
                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P1" + e.getMessage());
                                            }
                                            /*DATOS COMUNES*/
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 9) {
                                                    out.println("<p></p><div class=\"col-md-4\">" + listaR.get(codR).getValor_Respuestas() + ".</div>");
                                                    numDC++;
                                                    codR++;
                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P9" + e.getMessage());
                                            }
                                            /////////////////////////////////////RADIO BUTTON//////////////////////////////////////
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 2) {
                                                    for (int k = 0; k < listaV.size(); k++) {
                                                        if (listaV.get(k).getCodigo_Preguntas() == listaP.get(j).getCodigo_preguntas()) {
                                                            //recorrer lista de respuestas
                                                            if (listaV.get(k).getValores().equals(listaR.get(codR).getValor_Respuestas())) {
                                                                out.println("<div class=\"row\">");
                                                                out.println("<li class=\"col-md-offset-6 col-md-4 \">&nbsp&nbsp" + listaV.get(k).getValores() + "</li>");
                                                                out.println("</div>");
                                                                codR++;
                                                            }

                                                        }

                                                    }
                                                }//cierre del Radio Button
                                            } catch (Exception e) {
                                                System.out.println("Exception P2" + e.getMessage());
                                            }
                                            try {
                                                ////////////////////////////////CHECKBOX/////////////////////////////////

                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 3) {
                                                    out.println("<div class=\"col-md-4\">" + listaR.get(codR).getValor_Respuestas() + "</div>");
                                                    codR++;
                                                }
                                            } catch (Exception e) {
                                                System.out.println("ERROR P3 L637" + e);
                                            }
                                            try {
                                                ///////////////////////////////LISTA QUERY/////////////////////////////////

                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 5) {
                                                    out.println("<div class=\"row\">");
                                                    out.println("<div class=\"col-md-6\">" + listaR.get(codR).getValor_Respuestas() + ".</div>");
                                                    codR++;
                                                    //System.out.println("Exception P5 codR" + codR);

                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P5" + e.getMessage());
                                            }
                                            /////////////////////////////////////////////////////////////////
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 6) {
                                                    numA++;
                                                    out.println("<form name = \"asd\" action=\"downloadFileServlet\" method=\"POST\" >");
                                                    out.println("<input type=\"hidden\" name=\"codigo\" value=\"" + Cod + "\">");
                                                    out.println("<input type=\"hidden\" name=\"codForm\" value=\"" + fp.getCodFormP() + "\">");
                                                    out.println("<input type=\"hidden\" name=\"pidm\" value=\"" + pidm + "\">");
                                                    out.println("<input type=\"hidden\" name=\"pregunta\" value=\"" + listaP.get(j).getCodigo_preguntas() + "\">");
                                                    out.println("<input type=\"hidden\" name=\"iter\" value=\"" + iteracion + "\">");
                                                    out.println("<div class=\"col-md-6\"><center><button class=\"btn btn-success\"type=\"submit\" name=\"archivo\">Descargar</button></center></div>");
                                                    out.println("</form>");
                                                    codR++;
                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P6" + e.getMessage());
                                            }
                                            ////////////////////////FECHA///////////////////////////////////////////////
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 7) {
                                                    out.println("<div class=\"col-md-4\">" + listaR.get(codR).getValor_Respuestas() + "</div>");
                                                    codR++;

                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P7" + e.getMessage());
                                            }
                                            //////////////////////Tipo Numerico////////////////////////////////////////////
                                            try {
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 8) {
                                                    out.println("<div class=\"col-md-4\">" + listaR.get(codR).getValor_Respuestas() + "</div>");
                                                    codR++;
                                                }
                                            } catch (Exception e) {
                                                System.out.println("Exception P8" + e.getMessage());
                                            }
                                            try {
                                                ////////////////////////////////////////////////////////////////////////////////
                                                if (listaP.get(j).getCodigo_tipo_pregunta() == 4) {
                                                    ResultSet rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTMATRIZ WHERE codigo_UZGTPREGUNTAS = '" + listaP.get(j).getCodigo_preguntas() + "'order by codigo_uzgtmatriz ASC").executeQuery();
                                                    LinkedList<Matriz> ListaMatriz = new LinkedList<Matriz>();
                                                    LinkedList<Cabecera> ListaCabeceras = new LinkedList<Cabecera>();
                                                    while (rs2.next()) {
                                                        try {
                                                            Matriz Mat = new Matriz(rs2.getInt(1), rs2.getInt(2), rs2.getInt(3), rs2.getInt(4), rs2.getInt(5), rs2.getInt(6), rs2.getString(7));
                                                            ListaMatriz.add(Mat);
                                                        } catch (Exception e) {
                                                            System.out.println("Exception M select" + e.getMessage());
                                                        }
                                                    }
                                                    rs2.close();
                                                    int mat = ListaMatriz.getFirst().getCodigo_matriz();
                                                    int filas = ListaMatriz.getFirst().getFila() + 1;
                                                    int columnas = ListaMatriz.getFirst().getColumna() + 1;
                                                    ResultSet rs3 = co.prepareStatement("SELECT * FROM UTIC.UZGTCABECERAS WHERE codigo_UZGTMATRIZ = '" + mat + "' order by codigo_uzgtcabezera ASC").executeQuery();
                                                    while (rs3.next()) {
                                                        try {
                                                            Cabecera Cab = new Cabecera(rs3.getInt(1), rs3.getInt(2), rs3.getString(3), rs3.getInt(4), rs3.getInt(5));
                                                            ListaCabeceras.add(Cab);
                                                        } catch (Exception e) {
                                                            System.out.println("Exception M select" + e.getMessage());
                                                        }
                                                    }
                                                    rs3.close();
                                                    try {
                                                        out.println("<div class=\"col-md-12 table-responsive\"><table class=\"table table-bordered\">");
                                                    } catch (Exception e) {
                                                        System.out.println("Exception M select" + e.getMessage());
                                                    }
                                                    int puntero = 0;
                                                    for (int n = 0; n < filas; n++) {
                                                        out.println("<tr>");
                                                        for (int m = 0; m < columnas; m++) {
                                                            if (puntero < ListaCabeceras.size() && ListaCabeceras.get(puntero).getPosicionX() == n && ListaCabeceras.get(puntero).getPosicionY() == m) {
                                                                out.println("<th>" + ListaCabeceras.get(puntero).getValor_cabecera() + "</th>");
                                                                puntero++;
                                                            } else {
                                                                if (n == 0 && m == 0) {
                                                                    out.println("<td><input type=\"text\" name=\"Texto\" placeholder=\"Item\"' disabled></td>");
                                                                } else {
                                                                    try {
                                                                        //JOptionPane.showMessageDialog(null, request.getParameter("Texto" + contRM));
                                                                        // out.println("<td><input type=\"text\" name=\"Texto" + listaR.get(contRM).getValor_Respuestas() + "\" placeholder=\"Texto\"'></td>");
                                                                        out.println("<td><input type=\"text\" name=\"Texto" + contRM + "\" placeholder=\"" + listaR.get(codR).getValor_Respuestas() + "\"' disabled></td>");
                                                                        codR++;
                                                                        contRM++;
                                                                    } catch (Exception e) {
                                                                        System.out.println("error mostrar mru." + e.getMessage());
                                                                    }
                                                                }

                                                            }
                                                        }

                                                    }
                                                    out.println("</tr>");
                                                    out.println("</table>");
                                                    out.println("</div>");

                                                }
                                            } catch (Exception e) {
                                                System.out.println("error Matriz" + e.getMessage());
                                            }

                                            //cierre if de la matriz
                                            //}
                                        }
                                    }
                                } catch (Exception e) {
                                    System.out.println("Exception for j" + e.getMessage());
                                }
                            }
                        } catch (Exception e) {
                            System.out.println("Total" + e.getMessage());
                        }
                        out.println("<div class=\"row\">");
                        out.println("<br><div class=\"col-md-4\"></div>");
                        out.println("</div>");
                    }//cierre de else en caso de que existan respuestas para el usuario
                    con.closeConexion();
                %>
            </div>
            <script type="text/javascript">
                function info() {
                    pulsado = document.elegir.radio;
                    for (i = 0; i < pulsado.length; i++) {
                        valor = pulsado[i].checked;
                        if (valor == true) {
                            elegido = pulsado[i].value;
                        }
                    }
                }
                function Imprimir_Contenido()
                {
                    var ficha = document.getElementById("imprimir");
                    var Ventana_Impresion = window.open(' ', 'popimpr');
                    Ventana_Impresion.document.write(ficha.innerHTML);
                    Ventana_Impresion.document.close();
                    Ventana_Impresion.print( );
                    Ventana_Impresion.close();
                }
            </script>
            <br>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-6"> <center><a href="javascript:Imprimir_Contenido()" class="btn btn-success btn-lg">
                            <span  class="d-inline-block" tabindex="0" data-toggle="tooltip" title="Imprimir" class="glyphicon glyphicon-print  /*alert alert-info*/">
                                <i class='fas fa-print'style='font-size:35px' ></i></span>  
                        </a><center></center></div>
                <button style='display:scroll; position:fixed; bottom:30px; right:0px;' class="btn btn-info" data-toggle="tooltip" data-placement="top" title="Volver"> 
                    <a href="GRes_Usuarios.jsp">
                        <i class='fa fa-angle-double-left' style='font-size:40px;color:white;'></i></a>
                </button>
            </div> 
            <%             } catch (Exception e) {
                    System.out.println("error final mruHD." + e);
                }
            %>
    </body>
</html>
<%
    }
%>