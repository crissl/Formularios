<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="espe.edu.ec.models.Respuestas"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.Valores"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.models.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- import de Usuario -->
<%@page session="true" %>
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
    String currentUser = pidm;
    if (currentUser != null) { %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Usuario-Formulario</title>
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
        %>
    </head>
    <p></p>
    <!-- --------------------------------Navbar superior-------------------------------------------  -->
    <div class="container-fluid">
        <nav class="navbar navbar-default" role="tablist">
            <div>
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                            data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand"><b>Formularios</b> </a>
                </div>
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
                        <li role="presentation">
                            <a href="mostrarRespuesta.jsp">
                                <i class="fas fa-file-archive"></i> Respuestas</a>
                        </li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a><% out.print(id);%></a></li>
                    </ul>
                </div>
                <!-- /.navbar-collapse -->
            </div><!-- /.container-fluid -->
        </nav>

        <!-- --------------------------------Fin Navbar superior-->
    </head>

    <body>

        <%
            String idFormulario = null;

            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            LinkedList<Formulario> listaF = new LinkedList<Formulario>();
            LinkedList<Usuario> listaU = new LinkedList<Usuario>();
            LinkedList<Respuestas> listaR = new LinkedList<Respuestas>();
            int Cod = 0;
            String NombreF = request.getParameter("Submit");
            if (NombreF != null) {
                Cod = Integer.parseInt(NombreF);
            }
            int CodFP = 0;
            ResultSet rs = co.prepareStatement("SELECT * FROM UTIC.UZGTFORMULARIOS WHERE codigo_UZGTFORMULARIOS = '" + Cod + "'").executeQuery();
            while (rs.next()) {
                Formulario F = new Formulario();
                F.setCodigo_formulario(rs.getInt(1));
                F.setNombre_formulario(rs.getString(2));
                F.setDescripcion_formulario(rs.getString(3));
                F.setFecha_formulario(rs.getDate(4));
                F.setObjetivo_formulario(rs.getString(5));
                F.setBase_formulario(rs.getString(6));
                F.setTipoFormulario(rs.getString(11));
                listaF.add(F);
            }
            rs.close();

            /*Recogo los pidm para mostrarlos segun su usuario*/
            ResultSet rs1 = co.prepareStatement(
                    "select * from UTIC.UZGTFORMULARIO_PERSONA P, SATURN.SPRIDEN S, UTIC.UZGTFORMULARIOS F "
                    + "WHERE S.SPRIDEN_PIDM = P.SPRIDEN_PIDM "
                    + "AND P.SPRIDEN_PIDM ='" + pidm + "'"
                    + "AND F.CODIGO_UZGTFORMULARIOS = P.CODIGO_UZGTFORMULARIOS "
                    + "AND P.UZGTFORMULARIOS_ESTADO_LLENADO = 'L' "
                    + "AND P.codigo_UZGTFORMULARIOS ='" + Cod + "'"
                    //+ "AND SPRIDEN_ID= '" + idFormulario + "'"
                    + "ORDER BY P.CODIGO_UZGTFORMULARIOS_PERSONA DESC").executeQuery();
            while (rs1.next()) {
                Usuario usuario = new Usuario();
                usuario.setPIDM(rs1.getInt(1));
                usuario.setCodFP(rs1.getString(2));
                usuario.setEstLn(rs1.getString(6));
                usuario.setIdEst(rs1.getString(12));
                usuario.setNombreUsuario(rs1.getString(13) + " " + rs1.getString(14));
                listaU.add(usuario);
            }

            rs1 = co.prepareStatement("SELECT R.UZGTRESPUESTAS_ITERACION FROM UTIC.UZGTRESPUESTAS R WHERE R.CODIGO_UZGTFORMULARIOS=" + Cod + " AND R.SPRIDEN_PIDM= '" + pidm + "'  "
                    + "GROUP BY R.UZGTRESPUESTAS_ITERACION order by R.uzgtrespuestas_iteracion asc").executeQuery();
            while (rs1.next()) {
                Respuestas res = new Respuestas();
                res.setIteracionRespuesta(rs1.getInt(1));
                listaR.add(res);
            }
            rs1.close();
            if (listaU.isEmpty()) {
        %>
        <div>
            <div class="alert alert-danger" role="alert">No existen Pidms asignados a este formulario</div>
        </div>
        <%} else {
        %>
        <div>
            <div class="row">
                <div class="col-md-2"></div> 
                <div class="col-md-8">
                    <center>
                        <div class="alert alert-success" role="alert">FORMULARIO: <%= listaF.getFirst().getNombre_formulario()%></div>
                    </center>
                </div>
                <div class="col-md-2"></div>
            </div>
        </div>
        <!--/*muestro los codigo de formulario, el usuario y su "pidm"*/-->
        <%
            if (listaF.getFirst().getTipoFormulario().equals("N") || listaF.getFirst().getTipoFormulario().equals("M")) {
        %>
        <div>
            <form action="" method="POST" target="_self" id="mr" style="display:inline;">
                <div class="form-control" style="display:none">
                    <input name="cod" value="<%=Cod%>">
                </div>
                <table id="example" class="table table-striped table-bordered" style="width:100%">
                    <thead>
                        <tr>
                            <!-- <th class="text-center">Codigo Formulario</th> -->
                            <!-- <th class="text-center">Usuario</th> -->
                            <th class="text-center">PIDM</th>
                            <th class="text-center">ID</th>
                            <th class="text-center">Nombres</th>
                            <th class="text-center">Código 1</th>
                            <th class="text-center">Opciones</th>
                        </tr>
                    </thead> 
                    <tbody>        
                        <%
                            for (int i = 0; i < listaU.size(); i++) {
                        %>
                        <tr>
                            <td class="text-center"><input type="hidden"  class="form-control" name="pidm" value="<%= listaU.get(i).getPIDM()%>"><%= listaU.get(i).getPIDM()%></td>
                            <td class="text-center"><input type="hidden"  class="form-control" name="id" value="<%= listaU.get(i).getIdEst()%>"><%= listaU.get(i).getIdEst()%></td>
                            <td class="text-center"><input type="hidden"  class="form-control" name="nombres" value="<%= listaU.get(i).getNombreUsuario()%>"><%= listaU.get(i).getNombreUsuario()%></td>
                            <td class="text-center"><input type="hidden"  class="form-control" name="codfp" value="<%= listaU.get(i).getCodFP()%>"><%= listaU.get(i).getCodFP()%></td>
                            <td>
                                <div class="btn-toolbar text-center" role="toolbar">
                                    <div class="row">
                                        <div class="col-md-2 center-block"></div>
                                        <div class="btn-group col-md-8" >
                                            <button type="text" class="btn btn-info form-control" name="codfp1" data-toggle="tooltip" data-placement="top" title="Ver"
                                                    onclick="this.form.action = 'mostrarRespuestaUsuario.jsp';" value="<%=listaU.get(i).getCodFP()%>" >
                                                <span class="fas fa-eye"></span>
                                            </button>
                                            <button type="text" class="btn btn-danger form-control" name="codfp" data-toggle="tooltip" data-placement="top" title="Borrar"
                                                    onclick="this.form.action = 'EliminarFormularioPersona.jsp';" value="<%= listaU.get(i).getCodFP()%>" >
                                                <span class="fas fa-trash"></span>
                                            </button>
                                        </div>
                                        <div class="col-md-2 center-block"></div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </form> 
        </div>
        <%
            }
            //cierre if modificable y no modificable
            if (listaF.getFirst().getTipoFormulario().equals("S")) {
        %>  
        <div>
            <form action="" method="POST" target="_self" id="mr" style="display:inline;">
                <div class="form-control" style="display: none">
                </div>
                <table id="example" class="table table-striped table-bordered" style="width:100%">
                    <thead>
                        <tr>
                            <th class="text-center">#</th>
                            <th class="text-center">PIDM</th>
                            <th class="text-center">ID</th>            
                            <th class="text-center">Nombres</th>
                            <th class="text-center">Codigo</th>
                            <th class="text-center">Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int aux = 0;
                            for (int i = 0; i < listaR.size(); i++) {
                                for (int j = 0; j < listaU.size(); j++) {
                                    if (aux != listaR.get(i).getIteracionRespuesta()) {
                                        if (listaU.get(j).getEstLn().equals("L")) {
                        %>
                    <div class="form-control" style="display: none" >
                        <input name="cod" value="<%=Cod%>">
                        <input name="codfp" value="<%=listaU.get(j).getCodFP()%>">
                    </div>
                    <tr>
                        <td class="text-center"><input type="hidden"  class="form-control" name="iter" value=""><%= listaR.get(i).getIteracionRespuesta()%></td>
                        <td class="text-center"><input type="hidden"  class="form-control" name="pidm" value="<%= listaU.get(j).getPIDM()%>"><%= listaU.get(j).getPIDM()%></td>
                        <td class="text-center"><input type="hidden"  class="form-control" name="id" value="<%= listaU.get(j).getIdEst()%>"><%= listaU.get(j).getIdEst()%></td>
                        <td class="text-center"><input type="hidden"  class="form-control" name="nombres" value="<%= listaU.get(j).getNombreUsuario()%>"><%= listaU.get(j).getNombreUsuario()%></td>
                        <td class="text-center"><input type="hidden"  class="form-control" name="nombres" value="<%= listaU.get(j).getCodFP()%>"><%= listaU.get(j).getCodFP()%></td>
                        <td>
                            <div class="btn-toolbar text-center" role="toolbar">
                                <div class="row">
                                    <div class="col-md-2 center-block"></div>
                                    <div class="btn-group col-md-8" >
                                        <button type="text" class="btn btn-info form-control" name="iteracion" data-toggle="tooltip" data-placement="top" title="Ver"
                                                onclick="this.form.action = 'mostrarRespuestaUsuario.jsp';" value="<%= listaR.get(i).getIteracionRespuesta()%>" >
                                            <span class="fas fa-eye"></span>
                                        </button>
                                        <button type="text" class="btn btn-danger form-control" name="codfp" data-toggle="tooltip" data-placement="top" title="Borrar"
                                                onclick="this.form.action = 'EliminarFormularioPersona.jsp';" value="<%= listaU.get(j).getCodFP()%>" >
                                            <span class="fas fa-trash"></span>
                                        </button>
                                    </div>
                                    <div class="col-md-2 center-block"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <%
                                        aux = listaR.get(i).getIteracionRespuesta();
                                    }//if llenados
                                }
                            }//cierre for lista pidm
                        }
                    %> 
                    </tbody>
                </table>
            </form> 
        </div>
        <%
                    //cierra for para mostrar resultados por iteracion
                }//cierre del else if secuencial
            }//cierre de lista usuario con elementos
        %>
    </body>
</html>
<% } else {

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/bootstrap.min.css" rel="stylesheet"></link>
        <title>No Autorizado</title>
    </head>
    <body>
        <ul class="nav nav-tabs" role="tablist">
            <div class="col-md-4">Error! Usuario no autorizado</div>
        </form>
    </ul>
</div>      
</body>
</html>



<% }

%>