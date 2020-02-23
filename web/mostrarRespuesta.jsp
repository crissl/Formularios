<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="espe.edu.ec.util.LoginServlet"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.models.Usuario"%> <!-- import de Usuario -->
<%@page session="true" %> <!-- Se agrega a modo de validacion -->

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
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
    int PIDM = Integer.parseInt(pidm);
    if (ConstantesForm.admin.contains(PIDM)) { %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html" charset=UTF-8">
        <title>Mostrar-Formularios</title>
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
        %>
    </head>

    <p></p><body>
        <div class="container-fluid">
            <nav class="navbar navbar-default" role="tablist">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                            data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand"><b>Respuestas</b> </a>
                </div>
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
                        <li role="presentation">
                            <a href="NewForm.jsp">
                                <i class="fas fa-">&#xf0fe</i>&nbsp<strong>Nuevo</strong></a>
                        </li>
                        <li role="presentation">
                            <a href="mostrarFormulario.jsp">
                                <i class="fas fa-tools"></i> Gestion</a>
                        </li>
                        <li role="presentation">
                            <a href="mostrarGRes.jsp">
                                <i class="fas fa-chalkboard-teacher"></i> Mis Formularios</a>
                        </li>
                        <!--<li role="presentation">
                            <a href="mostrarRespuesta.jsp">
                                <i class="fas fa-file-archive"></i> Respuestas</a>
                        </li>-->
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a><% out.print(id);%></a></li>
                    </ul> 
                </div><!-- /.navbar-collapse -->

            </nav>

            <!-- --------------------------------Fin Navbar superior-------------------------------------------  -->
            <center> 
                <form action="LoginServlet" class="form-horizontal" method="POST" >

                    <div>
                        <form action="" method="POST" target="_self" id="mr" style="display:inline;">
                            <div class="row">
                                <div class="col-xs-12 col-md-4">
                                    <div class="form-group has-success has-feedback">
                                        <span id="helpBlock" class="help-block">1.- Ingrese el ID del usuario a consultar: </span><label class="control-label col-sm-3" for="inputGroupSuccess2"> </label>

                                        <div class="input-group">
                                            <span class="input-group-addon"><strong>ID</strong></span>
                                            <input type="text"  class="form-control" name="idbusqueda" value="" minlength="9" maxlength="9" required></span>
                                        </div>

                                    </div>
                                </div>
                                <div class="col-xs-12 col-md-8">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-xs-12 col-md-4">
                                    <div class="form-group has-success has-feedback">
                                        <span id="helpBlock" class="help-block">2.- Seleccione el formulario a consultar : </span>             
                                    </div>
                                </div>
                                <div class="col-xs-12 col-md-8">
                                </div>
                            </div>

                            <table id="example" class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th class="text-center">CODIGO</th>
                                        <th class="text-center">TIPO DE FORMULARIO</th>
                                        <th class="text-center">NOMBRE</th>
                                        <th class="text-center">OPCIONES</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%

                                        PreparedStatement st;
                                        ResultSet ts;
                                        st = co.prepareStatement("SELECT * FROM UTIC.UZGTFORMULARIOS ORDER BY codigo_UZGTFORMULARIOS ASC");
                                        ts = st.executeQuery();
                                        //      Formularios_Connection con = F
                                        while (ts.next()) {
                                            String cod = "";

                                    %>
                                    <tr>
                                        <td class="text-center"><%= ts.getInt("CODIGO_UZGTFORMULARIOS")%> </td>
                                        <td class="text-center"> 
                                            <%if ("N".equalsIgnoreCase(ts.getString("UZGTFORMULARIOS_ESTADO_LLENADO"))) {
                                                    out.print("<div class=\"btn-group col-md-auto\"><button class=\"btn btn-warning\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"No modificable\" class= \"btn btn-default\"><i class= \"glyphicon glyphicon-ban-circle\" style='font-size:20px' required></i></button></div>");
                                                } else if ("S".equalsIgnoreCase(ts.getString("UZGTFORMULARIOS_ESTADO_LLENADO"))) {
                                                    out.print("<div class=\"btn-group col-md-auto\"><button class=\"btn btn-success\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Secuencial\" class= \"btn btn-default\"><i class= \"glyphicon glyphicon-retweet\" style='font-size:20px' required></i></button></div>");
                                                } else {
                                                                                                        

                                                    out.print("<div class=\"btn-group col-md-auto\"><button class=\"btn btn-primary\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Modificable\" class= \"btn btn-primary\"><i class= \"fas fa-pen\" style='font-size:20px' required></i></button></div>");
                                                }%></td>
                                        <td class="text-center"><%= ts.getString("UZGTFORMULARIOS_NOMBRE")%> </td>
                                        <td class="text-center">

                                <center><div class="btn-group col-md-auto "><button class="btn btn-info" data-toggle="tooltip" data-placement="top" title="Ver" class="btn btn-default" type="submit" name="Submit" onclick="this.form.action = 'mostrarFormularioUsuario.jsp';" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS")%>"><i class="fas fa-eye" style='font-size:20px' required></i></button></div></center>
                                <!--   <div class="col-md-0 center-block"></div>
                                    <center><div class="btn-group col-md-1"><button class="btn btn-danger" data-toggle="tooltip" data-placement="top" title="Borrar" class="btn btn-default" type="submit" name="Submit" onclick="this.form.action = 'mostrarFormulariosnNoLlenos.jsp';" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS")%>" required><i class="fas fa-trash" style='font-size:20px'></i></button></div></center>
                                    <div class="col-md-1 center-block"></div>
                                </div> --->
                                </td>
                                </tr>
                        </form> 
                        <% }
                            ts.close();
                        %> 
                        </tbody>
                        </table>

                </form>  
            </center>
        </div>    
    </body>
</html>
<% } //---------------------------------MOSTRAR RESPUESTAHD-----------------------------------
else {
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html" charset=UTF-8">
        <title>Mostrar-Formularios</title>
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
        %>
    </head>
    <br>
    <body>
        <div class="container-fluid">
            <nav class="navbar navbar-default" role="tablist">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                            data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand"><b>Respuestas</b> </a>
                </div>
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">   
                        <li role="presentation">
                            <a href="mostrarFormulario.jsp">
                                <i class="fas fa-tools"></i> Gestion</a>
                        </li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a><% out.print(id);%></a></li>
                    </ul> 
                </div><!-- /.navbar-collapse -->


            </nav>
            <!-- --------------------------------Fin Navbar superior-------------------------------------------  -->
            <center> 
                <form action="LoginServlet" class="form-horizontal" method="POST" >

                    <div>
                        <form action=" " method="POST" target="_self" id="mr" style="display:inline;">
                            <div class="row">
                                <div class="col-xs-12 col-md-4">
                                    <div class="form-group has-success has-feedback">
                                        <span id="helpBlock" class="help-block">1.- Ingrese el ID del usuario a consultar: </span>
                                        <label class="control-label col-sm-3" for="inputGroupSuccess2">ID: </label>

                                        <div class="input-group">
                                            <span class="input-group-addon"><i class="fab fa-digital-ocean"></i></span>
                                            <input type="text"  class="form-control" name="idbusqueda" value="" minlength="9" maxlength="9" required></span>
                                        </div>

                                    </div>
                                </div>
                                <div class="col-xs-12 col-md-8">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-xs-12 col-md-4">
                                    <div class="form-group has-success has-feedback">
                                        <span id="helpBlock" class="help-block">2.- Seleccione el formulario a consultar : </span>             
                                    </div>
                                </div>
                                <div class="col-xs-12 col-md-8">
                                </div>
                            </div>

                            <table id="example" class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th class="text-center">CODIGO</th>
                                        <th class="text-center">NOMBRE</th>
                                        <th class="text-center">OPCIONES</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        PreparedStatement st;
                                        ResultSet ts;
                                        st = co.prepareStatement("SELECT * FROM UTIC.UZGTFORMULARIOS ORDER BY codigo_UZGTFORMULARIOS ASC");
                                        ts = st.executeQuery();
                                        //      Formularios_Connection con = F
                                        while (ts.next()) {
                                            String cod = "";
                                    %>
                                    <tr>
                                        <td class="text-center"><%= ts.getInt("CODIGO_UZGTFORMULARIOS")%> </td>
                                        <td class="text-center"><%= ts.getString("UZGTFORMULARIOS_NOMBRE")%> </td>
                                        <td>
                                            <div class="btn-toolbar text-center" role="toolbar">
                                                <div class="row">
                                                    <div class="col-md-1 center-block"></div>
                                                    <center><div class="btn-group col-md-1"><button class="btn btn-info" data-toggle="tooltip" data-placement="top" title="Ver" class="btn btn-default" type="submit" name="Submit" onclick="this.form.action = 'mostrarFormularioUsuario.jsp';" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS")%>"><i class="fas fa-eye" style='font-size:20px'></i></button></div></center>
                                                    <div class="col-md-1 center-block"></div>
                                                    <!--   <div class="col-md-0 center-block"></div>
                               <center><div class="btn-group col-md-1"><button class="btn btn-danger" data-toggle="tooltip" data-placement="top" title="Borrar" class="btn btn-default" type="submit" name="Submit" onclick="this.form.action = 'mostrarFormulariosnNoLlenos.jsp';" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS")%>" required><i class="fas fa-trash" style='font-size:20px'></i></button></div></center>
                               <div class="col-md-1 center-block"></div>
                           </div> --->
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    </form> 
                                    <% }
                                        ts.close();
                                    %> 
                                </tbody>
                            </table>
                        </form>  
                        </center>
                        </body>
                        </html>
                        <% }
                            con.closeConexion();
                        %>
