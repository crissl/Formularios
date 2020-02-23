<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="espe.edu.ec.models.Valores"%>
<%@page import="espe.edu.ec.models.TipoPreguntas"%>
<%@page import="espe.edu.ec.models.Preguntas"%>
<%@page import="espe.edu.ec.models.Grupo"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="espe.edu.ec.models.FormPersona"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%
    DB2 con = DB2.getInstancia();
    Connection co = con.getConnection();
    Date date = new Date();
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
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
    int PIDM = Integer.parseInt(pidm);
    if (ConstantesForm.admin.contains(PIDM)) { %>

<html>
    <head>
        <title>Publicar Formulario</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
        %>
    </head>
    <body>
        <%             try {
        %>
        <p></p><div class="container-fluid">
            <nav class="navbar navbar-default" role="tablist">
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
            <!-- --------------------------------Fin Navbar superior-------------------------------------------  -->

            <%
                LinkedList<Formulario> listaF = new LinkedList<Formulario>();
                LinkedList<Grupo> listaG = new LinkedList<Grupo>();
                LinkedList<Preguntas> listaP = new LinkedList<Preguntas>();
                LinkedList<TipoPreguntas> listaTP = new LinkedList<TipoPreguntas>();
                LinkedList<Valores> listaV = new LinkedList<Valores>();
                String NombreF = request.getParameter("Submit");
                String eF = request.getParameter("estadoSeg");
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
                    F.setQueryP(rs.getString(12));
                    F.setEstadoPublicacion(rs.getInt(9));
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
                con.closeConexion();
            %>
            <%if (listaF.getFirst().getEstadoPublicacion() == 0) {%>
            <form action="estadoPublicacion.jsp" method="POST">
                <div class="container">
                    <%
                        out.println("<div class=\"offset-md-3 col-md-12\"><h4 class=\"text-success\"><center>" + "Nombre del Formulario: <strong>" + listaF.getFirst().getNombre_formulario() + "</strong></center></h4></div>");
                    %>
                    <div class="col-md-15">
                        <input type="radio" name="opciones" value="individual" id="multiples"> Multiples <br>
                        <input type="radio" name="opciones" value="multiples" id="individual"> Individual <br>
                        <div id="div1" style="display:none"> 
                            <textarea name="query1" rows="5" cols="150" class="panel-body" placeholder="Ingrese el query de restriccion"></textarea>
                        </div>
                        <div id="div2">  <label for="ID">ID</label>
                            <input type="text" class="form-control" name="query"  placeholder="Ingrese Id"></input>
                        </div>
                    </div>
                    <br>
                    <div class="col-md-2 text-right"><h4>Desde:</h4></div>
                    <div class="col-md-2"><label for="fechaInicio" class="sr-only">fechaInicio</label><input value="<%=dateFormat.format(date)%>" id="fechaInicio" type="date" name="fechaInicio" class="form-control" placeholder="fechaInicio" required/></div>
                    <div class="col-md-2 text-right"><h4>Hasta:</h4></div>
                    <div class="col-md-2"><label for="fechaFin" class="sr-only">fechaFin</label><input value="<%=dateFormat.format(date)%>" id="fechaFin" type="date" name="fechaFin" class="form-control" placeholder="fechaFin" required/></div>
                    <div class="col-md-2 text-right"><h4>Tipo Formulario:</h4></div>
                    <div class="col-md-2"><select  name="tipoFormulario" onchange="yesnoCheck(this);" class="form-control" required>
                            <!--option selected value="1">Obligatorio</option>-->
                            <option selected value="0">Opcional</option>
                        </select>
                    </div>
                    <br><br>
                    <%
                        out.println("<div class=\"col-md-10\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action='estadoPublicacion.jsp';\" value=\"" + Cod + "\">Publicar</button></center></div>");
                    %>          
                </div>
            </form>
            <%} else {%>
            <form action="estadoPublicacion.jsp" method="POST">
                <div class="container">
                    <%
                        out.println("<div class=\"offset-md-3 col-md-12\"><h4 class=\"text-success\"><center>" + " Formulario ya publicado: <strong>" + listaF.getFirst().getNombre_formulario() + "</strong></center></h4></div></br></br>");
                    %>
                    <h4>Selecciona el/los grupos de usuarios:</h4> 
                    <input type="radio" name="opciones" value="multiples" id="multiples"> Multiples <br>
                    <input type="radio"  name="opciones" value="individual" id="individual">Individual <br>
                    <div id="div1" style="display:none"> 
                        <textarea name="query1" rows="5" cols="150" class="panel-body" placeholder="Selecciona el/los grupos de usuarios:"></textarea>
                    </div>
                    <div id="div2">  <label for="ID">ID</label>
                        <input type="text"  class="form-control " name="query"  placeholder="Ingrese Id"></input>
                    </div>
                    <br>
                    <br>
                    <div class="col-md-1 text-right"><h4>Desde:</h4></div>
                    <div class="col-md-2"><label for="fechaInicio" class="sr-only">fechaInicio</label><input value="<%=dateFormat.format(date)%>" id="fechaInicio" type="date" name="fechaInicio" class="form-control" placeholder="fechaInicio" required/></div>
                    <div class="col-md-2 text-right"><h4>Hasta:</h4></div>
                    <div class="col-md-2"><label for="fechaFin" class="sr-only">fechaFin</label><input value="<%=dateFormat.format(date)%>" id="fechaFin" type="date" name="fechaFin" class="form-control" placeholder="fechaFin" required/></div>
                    <div class="col-md-2 text-right"><h4>Tipo Formulario:</h4></div>
                    <div class="col-md-2"><select  name="tipoFormulario" onchange="yesnoCheck(this);" class="form-control" required>
                            <!--option selected value="1">Obligatorio</option>-->
                            <option selected value="0">Opcional</option>
                        </select>
                    </div>
                </div>

                <%
                    out.println("</br><div class=\"col-md-12\"><center><button class=\"btn btn-success btn-lg\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action='estadoPublicacion.jsp';this.form.submit();\" value=\"" + Cod + "\", \"" + eF + "\" >Publicar</button></center></div>");
                %>
            </form>
            <%}
                } catch (Exception e) {
                    System.out.println("ERROR Publicar Usuario: " + e);
                }
                //------------------------PUBLICAR USUARIOHD------------------------
            } else {  %>
            <html>
                <head>
                    <title>Publicar Formulario</title>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <%
                        out.println(ConstantesForm.Css);
                        out.println(ConstantesForm.js);
                    %>
                </head>
                <body>
                    <%             try {

                    %>
                    <p></p><div class="container-fluid">
                        <nav class="navbar navbar-default" role="tablist">
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
                        <!-- --------------------------------Fin Navbar superior-------------------------------------------  -->

                    </div>
                    <%            LinkedList<Formulario> listaF = new LinkedList<Formulario>();
                        LinkedList<Grupo> listaG = new LinkedList<Grupo>();
                        LinkedList<Preguntas> listaP = new LinkedList<Preguntas>();
                        LinkedList<TipoPreguntas> listaTP = new LinkedList<TipoPreguntas>();
                        LinkedList<Valores> listaV = new LinkedList<Valores>();
                        String NombreF = request.getParameter("Submit");
                        String eF = request.getParameter("estadoSeg");
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
                            F.setQueryP(rs.getString(12));
                            F.setEstadoPublicacion(rs.getInt(9));
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
                        con.closeConexion();
                    %>
                    <%if (listaF.getFirst().getEstadoPublicacion() == 0) {%>
                    <form action="estadoPublicacion.jsp" method="POST">


                        <div class="container">
                            <%
                                out.println("<div class=\"row\">");
                                out.println("<div class=\"col-md-3\"></div>");
                                out.println("<div class=\"col-md-6\"><center><h4 class=\"text-success\">" + "Nombre del Formulario: " + listaF.getFirst().getNombre_formulario() + "</h4></center></div>");
                                out.println("</div>");
                            %>
                            <h3>Selecciona el/los grupos de usuarios:</h3> 
                            <div class="col-md-15">

                                <label for="ID    ">ID</label>
                                <input type="text" class="form-control" name="query"  placeholder="Ingrese Id"></input>

                            </div>
                            <h3>Fecha de vigencia</h3><br>
                            <ul><div class="col-md-2"><h4>Desde: </h4></div>
                                <li class="col-md-3"><label for="fechaInicio" class="sr-only">fechaInicio</label><input value="<%=dateFormat.format(date)%>" id="fechaInicio" type="date" name="fechaInicio" class="form-control" placeholder="fechaInicio" required/></li>
                                <div class="col-md-2"><h4>Hasta: </h4></div>
                                <li class="col-md-3"><label for="fechaFin" class="sr-only">fechaFin</label><input value="<%=dateFormat.format(date)%>" id="fechaFin" type="date" name="fechaFin" class="form-control" placeholder="fechaFin" required/></li></ul>
                            <br><br>
                            <h3>Tipo Formulario</h3>
                            <div class="col-md-2"><h4>Elija una opción: </h4></div>
                            <div class="col-md-3"><select  name="tipoFormulario" onchange="yesnoCheck(this);" class="form-control" required>
                                    <!--option selected value="1">Obligatorio</option>-->
                                    <option selected value="0">Opcional</option>
                                </select>
                            </div>

                            <div id="ifYes" style="display: none;">
                                <textarea name="queryRes" rows="1" cols="150" class="panel-body" placeholder="Selecciona el/los grupos de usuarios:"></textarea>
                            </div>
                            <%-- <div class="col-md-3"><button class="btn btn-default" type="submit" name="Submit" value="restriccion">Generar Restricción</button></div>--%> 

                        </div>
        </div><br><br>
        <%
            out.println("<div class=\"col-md-10\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action='estadoPublicacion.jsp';\" value=\"" + Cod + "\">Publicar</button></center></div>");
            //out.println(" <button align=\"center\" class=\"btn btn-primary\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Volver\"> <div class=\"col-md-3\"><a href=\"mostrarRespuesta.jsp?Submit=\"" + Cod + "\" ><i class='fas fa-arrow-left' style='font-size:40px;color:white'></i></a></button>");
        %>          
    </form>
    <%} else {%>
    <form action="estadoPublicacion.jsp" method="POST">


        <div class="container">
            <%
                out.println("<div class=\"row\">");
                out.println("<div class=\"col-md-3\"></div>");
                out.println("<div class=\"col-md-6\"><center><h4 class=\"text-success\">" + "Nombre del Formulario: " + listaF.getFirst().getNombre_formulario() + "</h4></center></div>");
                out.println("<div class=\"col-md-12\"><center><h4 class=\"text-success\">" + "El Formulario ya está PUBLICADO" + "</h4></center></div>");
                out.println("</div>");
            %>
            <h3>Selecciona el/los grupos de usuarios:</h3> 
            <div class="col-md-15">

                <label for="ID    ">ID</label>
                <input type="text" class="form-control" name="query"  placeholder="Ingrese Id"></input>

            </div>
            <h3>Fecha de vigencia</h3><br>
            <div class="col-md-2"><h4>Desde: </h4></div>
            <div class="col-md-3"> <label for="fechaInicio" class="sr-only">fechaInicio</label><input value="<%=dateFormat.format(date)%>" id="fechaInicio" type="date" name="fechaInicio" class="form-control" placeholder="fechaInicio" required/></div>
            <div class="col-md-2"><h4>Hasta: </h4></div>
            <div class="col-md-3"><label for="fechaFin" class="sr-only">fechaFin</label><input value="<%=dateFormat.format(date)%>" id="fechaFin" type="date" name="fechaFin" class="form-control" placeholder="fechaFin" required/></div>
            <br><br>


            <h3>Tipo Formulario</h3>
            <div class="col-md-2"><h4>Elija una opción: </h4></div>
            <div class="col-md-3"><select  name="tipoFormulario" onchange="yesnoCheck(this);" class="form-control" required>
                    <!--option selected value="1">Obligatorio</option>-->
                    <option selected value="0">Opcional</option>
                </select>

            </div>

            <div id="ifYes" style="display: none;">
                <textarea name="queryRes" rows="1" cols="150" class="panel-body" placeholder="Ingrese ID"></textarea>
            </div>
            <%-- <div class="col-md-3"><button class="btn btn-default" type="submit" name="Submit" value="restriccion">Generar Restricción</button></div>--%> 

        </div>
    </div><br><br>
    <%
                out.println("<div class=\"col-md-12\"><center><button class=\"btn btn-success btn-lg\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action='estadoPublicacion.jsp';\" value=\"" + Cod + "\", \"" + eF + "\" >Publicar</button></center></div>");
            }
        } catch (Exception e) {
            System.out.println("ERROR Publicar UsuarioHD:  " + e);
        }
    %>

    </body>
    <%}
    %>
    </body>
    <script>
        $(document).ready(function () {
            $("#individual").click(function () {
                $("#div1").hide();
                $("#div2").show();

            });

            $("#multiples").click(function () {
                $("#div1").show();
                $("#div2").hide();

            });
        });
    </script>
</html>