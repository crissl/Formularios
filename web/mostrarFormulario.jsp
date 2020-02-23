<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.models.Usuario"%> <!-- import de Usuario -->
<%@page session="true" %> <!-- Se agrega a modo de validacion -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<% DB2 con = DB2.getInstancia();
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
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<p></p>
<div class="container-fluid">
    <nav class="navbar navbar-default" role="tablist">
        <div>
            <div class="navbar-header">
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
                <ul class="nav navbar-nav">
                    <li role="presentation">
                        <a href="NewForm.jsp">
                            <i class="fas fa-">&#xf0fe</i>&nbsp<strong>Nuevo</strong></a>
                    </li>
                    <li role="presentation">
                        <a href="mostrarGRes.jsp">
                            <i class="fas fa-chalkboard-teacher"></i> Mis Formularios</a>
                    </li>
                    <li role="presentation">
                        <a href="mostrarRespuesta.jsp">
                            <i class="fas fa-file-archive"></i> Respuestas</a>
                    </li>

                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li><a><% out.print(id);%></a></li>
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
    <!-- --------------------------------Fin Navbar superior-------------------------------------------  -->
    <meta http-equiv="Content-Type" content="text/html" charset=UTF-8">
    <title>Mostrar-Formularios</title>
    <%
        out.println(ConstantesForm.Css);
        out.println(ConstantesForm.js);
    %>
</head>
<body>
    <p></p>
    <form action="LoginServlet" method="POST">
        <br><div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-3"></div>
        </div>
        <center> <div class= "col-3 .col-md-7">
                <table id="example" class="table table-striped table-bordered" >
                    <thead>
                        <tr >
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
                    <form action="" method="POST" target="_self" id="mr" style="display:inline;">
                        <tr>
                            <td class="text-center"><%= ts.getInt("CODIGO_UZGTFORMULARIOS")%> </td>
                            <td class="text-center"><%= ts.getString("UZGTFORMULARIOS_NOMBRE")%> </td>
                            <td>
                                <div class="btn-toolbar text-center" role="toolbar">
                                    <div class="row">
                                        <div class="col-md-1 center-block"></div>
                                        <div class="btn-group col-md-12">
                                            <div class="col-md-3"><button class="btn btn-warning" data-toggle="tooltip" data-placement="top" title="Ver"  type="text" name="Submit" onclick="this.form.action = 'mostrar.jsp';" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS")%>"><i class="fas fa-eye" style='font-size:20px'></i></button></div>
                                            <div class="col-md-3"><button class="btn btn-info" data-toggle="tooltip" data-placement="top" title="editar"  type="text" name="Submit" onclick="this.form.action = 'modificar.jsp';" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS")%>"><i class="fas fa-pen" style='font-size:20px'></i></button></div>
                                            <div class="col-md-3"><button class="btn btn-danger" data-toggle="tooltip" data-placement="top" title="borrar" type="text" name="Submit" onclick="this.form.action = 'eliminar.jsp';this.form.submit();" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS")%>"><i class="fas fa-trash" style='font-size:20px'></i></button></div>
                                            <div class="col-md-3"><button class="btn btn-success" data-toggle="tooltip" data-placement="top" title="publicar" type="text" name="Submit" onclick="this.form.action = 'publicarUsuario.jsp';" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS")%>"><i class="fas fa-chalkboard-teacher" style='font-size:20px'></i></button></div>
                                        </div>
                                        <div class="col-md-1 center-block"></div>
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
            </div>
        </center>
</div>
</form>
</body>
<% } //-----------------------------------------Mostrar FormularioHD----------------------------------
//-----------------------------------------Mostrar FormularioHD----------------------------------
else if (ConstantesForm.helpDesk.contains(PIDM)) {
%>
<head>
    </br>
<div class="container-fluid">
    <nav class="navbar navbar-default" role="tablist">
        <div>
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                        data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand"><b>Gestion de Formularios</b> </a>
            </div>
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li role="presentation">
                        <a href="mostrarGRes.jsp">
                            <i class="fas fa-chalkboard-teacher"></i> Mis Formularios</a>
                    </li> 
                    <li role="presentation">
                        <a href="mostrarRespuesta.jsp">
                            <i class="fas fa-file-archive"></i> Respuestas</a>
                    </li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li><a><% out.print(id);%></a></li>
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
    <!-- --------------------------------Fin Navbar superior-------------------------------------------  -->
    <meta http-equiv="Content-Type" content="text/html" charset=UTF-8">
    <title>Mostrar-Formularios</title>
    <%
        out.println(ConstantesForm.Css);
        out.println(ConstantesForm.js);
    %>
</head>
<body>
    </br>
    <form action="LoginServlet" method="POST">
        <br><div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-3"></div>
        </div>
        <center> <div class= "col-3 .col-md-7">
                <table id="example" class="table table-striped table-bordered" >
                    <thead>
                        <tr >
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
                    <form action="" method="POST" target="_self" id="mr" style="display:inline;">
                        <tr>
                            <td class="text-center"><%= ts.getInt("CODIGO_UZGTFORMULARIOS")%> </td>
                            <td class="text-center"><%= ts.getString("UZGTFORMULARIOS_NOMBRE")%> </td>
                            <td>
                                <div class="btn-toolbar text-center" role="toolbar">
                                    <div class="row">
                                        <div class="col-md-1 center-block"></div>
                                        <div class="btn-group col-md-12">
                                            <div class="col-md-6"><button class="btn btn-warning" data-toggle="tooltip" data-placement="top" title="Ver" class="btn btn-default" type="text" name="Submit" onclick="this.form.action = 'mostrar.jsp';" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS")%>"><i class="fas fa-eye" style='font-size:20px'></i></button></div>
                                            <div class="col-md-3"><button class="btn btn-success" data-toggle="tooltip" data-placement="top" title="publicar" class="btn btn-default" type="text" name="Submit" onclick="this.form.action = 'publicarUsuario.jsp';" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS")%>"><i class="fas fa-chalkboard-teacher" style='font-size:20px'></i></button></div>
                                        </div>
                                        <div class="col-md-1 center-block"></div>
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
        </center>        
</div>
</form> 
</body>
<% } else { %>
<h1>ERROR USUARIO NO AUTORIZADO</h1>
<%}
    con.closeConexion();
%>
