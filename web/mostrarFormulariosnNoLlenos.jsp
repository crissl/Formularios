<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="espe.edu.ec.util.LoginServlet"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.models.Usuario"%> <!-- import de Usuario -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
    DB2 con = DB2.getInstancia();
    Connection co = con.getConnection();
    String idFormulario = null;
    idFormulario = request.getParameter("idbusqueda");
    int Cod = 0;
    String NombreF = request.getParameter("Submit");
    if (NombreF != null) {
        Cod = Integer.parseInt(NombreF);
    }
    int PIDM = Integer.parseInt(pidm);
    if (ConstantesForm.admin.contains(PIDM) || ConstantesForm.helpDesk.contains(PIDM)) { %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html" charset=UTF-8">
        <title>Mostrar-Formularios</title>
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
        %>
    </head>
    <body>
        <div class="container-fluid">
            <nav class="navbar navbar-default"role="tablist">
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
                <form action="" method="POST" target="_self" id="mr" style="display:inline;">
                    <div>
                        <div class="row">
                            <div class="col-xs-12 col-md-4">

                            </div>
                            <div class="col-xs-12 col-md-8">
                            </div>
                        </div>
                        <table id="example" class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th class="text-center">CODIGO</th>
                                    <th class="text-center">ID</th>
                                    <th class="text-center">NOMBRE FORMULARIO</th>
                                    <th class="text-center">Codigo de Formulario</th>
                                    <th class="text-center">OPCIONES</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    PreparedStatement st;
                                    ResultSet ts;
                                    st = co.prepareStatement("select * from UTIC.UZGTFORMULARIO_PERSONA P, SATURN.SPRIDEN S, UTIC.UZGTFORMULARIOS F "
                                            + "WHERE S.SPRIDEN_PIDM = P.SPRIDEN_PIDM "
                                            + "AND S.SPRIDEN_CHANGE_IND IS NULL "
                                            + "AND P.UZGTFORMULARIOS_ESTADO_LLENADO = 'N' "
                                            + "AND F.CODIGO_UZGTFORMULARIOS = P.CODIGO_UZGTFORMULARIOS "
                                            + "AND F.codigo_UZGTFORMULARIOS ='" + Cod + "'"
                                            + "AND SPRIDEN_ID= '" + idFormulario + "'"
                                            + "ORDER BY P.CODIGO_UZGTFORMULARIOS_PERSONA DESC");
                                    ts = st.executeQuery();
//      Formularios_Connection con = F
                                    while (ts.next()) {
                                        String cod = "";
                                %>
                                <tr>
                                    <td class="text-center"><%= ts.getInt("CODIGO_UZGTFORMULARIOS")%> </td>
                                    <td class="text-center"><%= ts.getString("SPRIDEN_ID")%> </td>
                                    <td class="text-center"><%= ts.getString("UZGTFORMULARIOS_NOMBRE")%> </td>
                                    <td class="text-center"><%= ts.getString("CODIGO_UZGTFORMULARIOS_PERSONA")%> </td>
                                    <td>
                                        <div class="btn-toolbar text-center" role="toolbar">
                                            <div class="row">
                                                <div class="col-md-1 center-block"></div>
                                                <center><div class="btn-group col-md-1"><button class="btn btn-danger" data-toggle="tooltip" data-placement="top" title="Borrar" class="btn btn-default" type="submit" name="codfp" onclick="this.form.action = 'EliminarFormularioPersona.jsp'" value="<%= ts.getInt("CODIGO_UZGTFORMULARIOS_PERSONA")%>"><i class="fas fa-trash" style='font-size:20px'></i></button></div></center>
                                                <div class="col-md-1 center-block"></div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <% }
                                    ts.close();
                                    con.closeConexion();
                                %> 
                            </tbody>
                        </table>
                        </center>
                    </div>  
                        </body>
                        </html>
                        <% } else {
                        %>
                        <html>
                            <head>
                                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                                <title>No Autorizado</title>
                            </head>
                            <body>
                                <%             try {
                                %>
                                <ul class="nav nav-tabs" role="tablist">
                                    <div class="col-md-4">Error! Usuario no autorizado</div>
                                </ul>
                                <%             } catch (Exception e) {
                                        System.out.println("error." + e.getMessage());
                                    }
                                %>
                            </body>
                        </html>
                        <% }
                        %>