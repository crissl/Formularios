<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.css" />
        <title>Confirmaci�n de Haber recibido tutoria</title>
        <%  //conexion a la base de datos
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            //importacion de librerias
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
            //Obtencion de valores de las cookies
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

            Date date = new Date();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            int CodT = 3;

        %>
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
                </div>
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">

                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#"><b>Tutorias</b>
                                <span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="planificacioReforzamiento.jsp"><i class="	glyphicon glyphicon-file">&nbsp</i>Planificaci�n de tutoria de Reforzamiento</a></li>
                                <li><a href="registroAsistencia.jsp"><i class="glyphicon glyphicon-edit">&nbsp</i>Registro de ejecuci�n tutoria de Acompa�amiento </a></li>

                            </ul>
                        </li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a><% out.print(id);%></a></li>
                    </ul>
                </div><!-- /.navbar-collapse -->
            </div><!-- /.container-fluid -->
        </nav>
        <!-- --------------------------------Fin Navbar superior-------------------------------------------  -->
    </div>
</head>
<body>  
    <form action="1.jsp" method="POST">
        <div class="container">
            <center><h3><b class="text-success">PLANIFICACI�N DE TUTOR�A DE ACOMPA�AMIENTO</b><span class="label label-default text-success"></span></h3></center>
            <h6>*PLANIFICACI�N DE LA TUTOR�A DE ACOMPA�AMIENTO ACAD�MICO<span class="label label-default"></span></h6>
            <div class="alert alert-info" role="alert"><center>DATOS DEL TUTOR</center></div>
            <h6>*DATOS GENERALES DEL TUTOR DE ACOMPA�AMIENTO ACAD�MICO.<span class="label label-default"></span></h6>
                <%ResultSet rs = co.prepareStatement("SELECT SPBPERS_SSN FROM SPBPERS WHERE SPBPERS_PIDM ='" + pidm + "'").executeQuery();
                    while (rs.next()) {%>
            <div class="form-group">
                <label for="Input" class="col-sm-3 control-label">C�DULA DE IDENTIDAD</label>
                <label for="Input" class="col-sm-5 control-label">APELLIDOS Y NOMBRES</label>
                <label for="Input" class="col-sm-4 control-label">UNIDAD O DEPARTAMENTO EN QUE LABORA</label>

                <div class="col-md-3">
                    <input class="form-control" id="Input" name="cedula" type="text" value="<%out.print(rs.getNString("SPBPERS_SSN"));
                        }
                        rs.close();%>" readonly><br>
                </div>
            </div>
            <%
                ResultSet rs1 = co.prepareStatement("SELECT SUBSTR(f_format_name(SPRIDEN_PIDM,'LFMI'),1,45) FROM SPRIDEN WHERE SPRIDEN_CHANGE_IND IS NULL AND SPRIDEN_PIDM = '" + pidm + "' ").executeQuery();
                while (rs1.next()) {
            %>
            <div class="form-group">
                <div class="col-md-5">
                    <input class="form-control" id="Input" name="nombres" type="text" value="<%out.print(rs1.getString("SUBSTR(f_format_name(SPRIDEN_PIDM,'LFMI'),1,45)"));
                        }
                        rs1.close();%>" readonly><br>
                </div>
            </div> 
            <%
                ResultSet rs2 = co.prepareStatement("SELECT FTVORGN_TITLE FROM PEBEMPL, FTVORGN WHERE FTVORGN_ORGN_CODE = PEBEMPL_ORGN_CODE_HOME AND PEBEMPL_PIDM ='" + pidm + "' ").executeQuery();
                while (rs2.next()) {
            %>
            <div class="form-group">
                <div class="col-md-4">
                    <input class="form-control" id="Input" type="text" name="labora" value="<%out.print(rs2.getString("FTVORGN_TITLE")); %>
                           " readonly><br> <%}
                               rs2.close();%>
                </div>
            </div>

            <%
                ResultSet rs6 = co.prepareStatement("SELECT GOREMAL_EMAIL_ADDRESS FROM GOREMAL WHERE GOREMAL.GOREMAL_EMAL_CODE = 'PERS' AND GOREMAL.GOREMAL_PIDM ='" + pidm + "' ").executeQuery();
                while (rs6.next()) {
            %>
            <div class="form-group" style="display: none">
                <input class="form-control" id="Input" name="emailp" type="text" value="<%out.print(rs6.getString("GOREMAL_EMAIL_ADDRESS"));
                    }
                    rs6.close();%>"
            </div> 
        </div>

        <%
            ResultSet rs3 = co.prepareStatement("SELECT GOREMAL_EMAIL_ADDRESS  FROM GOREMAL WHERE GOREMAL.GOREMAL_EMAL_CODE = 'STAN' AND GOREMAL.GOREMAL_PIDM ='" + pidm + "' ").executeQuery();
            while (rs3.next()) {
        %>
        <div class="form-group" style="display: none"> 
            <input class="form-control" id="Input" name="emaili" type="text" value="<%out.print(rs3.getString("GOREMAL_EMAIL_ADDRESS"));
                }
                rs3.close();%>"
        </div>   
    </div>
</div>
<div class="container">
    <div class="alert alert-info" role="alert"><center>DATOS DE LA TUTOR�A</center></div>
    <div class="col-md-12">
        <h6>*INGRESE LA INFORMACI�N REFERENTE A LA TUTOR�A DE ACOMPA�AMIENTO ACAD�MICO<span class="label label-default"></span></h6>
    </div>
    <div class="form-group">
        <label for="Input" class="col-sm-9 control-label">TEMA A TRATAR</label>
        <label for="Input" class="col-sm-3 control-label">FECHA DE LA TUTOR�A</label>

        <div class="col-md-9">
            <input class="form-control text-uppercase" id="Input" name="tema" type="text" placeholder="BASES DE DATOS" >
        </div>
        <div class="form-group">
            <div class="col-sm-3">
                <input class="form-control" id="Input" type="date" name="fecha" value="<%=dateFormat.format(date)%>" >
            </div>
        </div> 
    </div>
</div> <div class="container">
    <div class="form-group">
        <label class="col-sm-3 control-label">A QUI�N DAR� LA TUTOR�A</label>
        <label for="Input" class="col-sm-9 control-label">SELECIONE EL CAMPUS</label>

        <div class="col-md-3">
            <div class="radio">
                <label><input type="radio" name="optradio" value="T" checked>TODOS</label>
            </div>
            <div class="radio">
                <label><input type="radio" name="optradio" value="S">SOLICITADOS POR LOS ESTUDIANTES</label>
            </div>
        </div>
    </div>
    <%
        ResultSet rsAu5 = co.prepareStatement("SELECT DISTINCT STVCAMP_CODE AS CODIGO,\n"
                + "STVCAMP_CODE ||' - ' || STVCAMP_DESC AS CAMPUS\n"
                + "FROM SLBBLDG, SLBRDEF, STVCAMP\n"
                + "WHERE SLBRDEF_BLDG_CODE = SLBBLDG_BLDG_CODE\n"
                + "AND SLBBLDG_CAMP_CODE = STVCAMP_CODE\n"
                + "AND SLBRDEF_RMST_CODE = 'AC'\n"
                + "AND SLBRDEF_ROOM_TYPE = 'C' ORDER BY 1").executeQuery();
    %>
        <div class="col-md-4">
            <select class="form-control"  name="campus"id="Input">
                <option selected="selected" value="">Seleccione el Aula y el Horario</option>
                <% while (rsAu5.next()) {%>
                <option>
                    <% out.print(rsAu5.getString("CAMPUS"));
                        }
                        rsAu5.close();%></option>
            </select>
        </div>

    <div class="form-group"  style="display: none;">
        <label for="Input" class="col-sm-12 control-label">FECHA DE REGISTRO</label><br>
        <div class="col-md-3">
            <input class="form-control" name="fecharegistro" id="Input" type="date" value="<%=dateFormat.format(date)%>" readonly ><br>
        </div>
    </div>
    <br>

    <% out.println("<div class=\"col-md-10\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action=1.jsp';\" value=\"" + CodT + "\">Siguiente</button></center></div>");%>
</div>
</form>
<br>
<div class="container">
    <div class="progress">
        <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:20%">
            30% de la Planificacion Completada
        </div>
    </div>
</div>
</body>
<%co.close();
    con.closeConexion();%>
<script>
    $(document).ready(function () {
        $("#aula").click(function () {
            $("#div1").hide();
            $("#div2").show();
        });

        $("#sitio").click(function () {
            $("#div1").show();
            $("#div2").hide();
        });

        $('#timepicker1').timepicker();
        $('#timepicker2').timepicker();
    });
</script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/js/bootstrap-timepicker.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/js/bootstrap-timepicker.min.js"></script>
</html>