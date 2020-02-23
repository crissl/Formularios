<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <title>Solicitud Estudiante</title>
        <%
            Date date = new Date();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
            int CodT = 5;
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
            ResultSet rs = co.prepareStatement("SELECT SPBPERS_SSN FROM SPBPERS WHERE SPBPERS_PIDM ='" + pidm + "'").executeQuery();
            while (rs.next()) {

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
                                <li><a href="solicitudReforzamiento.jsp"><i class="glyphicon glyphicon-open-file"></i>Solicitud de tutoria de Reforzamiento </a></li>
                                <li><a href="confirmacionTutoria.jsp"><i class="glyphicon glyphicon-check">&nbsp</i>Confirmación de la Tutoria</a></li>

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
    <div class="container">
        <center><h3><b class="text-success">SOLICITUD DE TUTORÍA DE ACOMPAÑAMIENTO</b><span class="label label-default text-success"></span></h3></center>
        <h6>*SOLICITUD DE TUTORÍA POR PARTE DEL ESTUDIANTE<span class="label label-default"></span></h6>
        <form action="ptutorias.jsp" method="POST">
            <div class="alert alert-info" role="alert"><center>DATOS DEL ESTUDIANTE</center></div>
            <h6>DATOS GENERALES DEL ESTUDIANTE<span class="label label-default"></span></h6>
            <div class="form-group">
                <label for="Input" class="col-md-3 control-label">CÉDULA DE IDENTIDAD</label>
                <label for="Input" class="col-sm-5 control-label">APELLIDOS Y NOMBRES</label>
                <label for="Input" class="col-sm-4 control-label">CARRERA DE ESTUDIO</label>


                <div class="col-md-3">
                    <input class="form-control" id="Input" name="cedula" type="text" value="<%out.print(rs.getNString("SPBPERS_SSN"));
                        }
                        rs.close(); %>" readonly><br>
                </div>
            </div>
            <%
                ResultSet rs1 = co.prepareStatement("SELECT SUBSTR(f_format_name(SPRIDEN_PIDM,'LFMI'),1,45) FROM SPRIDEN WHERE SPRIDEN_CHANGE_IND IS NULL AND SPRIDEN_PIDM = '" + pidm + "' ").executeQuery();
                while (rs1.next()) {
            %>
            <div class="form-group">
                <div class="col-md-5">
                    <input class="form-control" id="Input" name="nombres" type="text" value=" <%out.print(rs1.getNString("SUBSTR(f_format_name(SPRIDEN_PIDM,'LFMI'),1,45)"));
                        }
                        rs1.close();%>" readonly><br>
                </div>
            </div> 
            <%
                ResultSet rs2 = co.prepareStatement("SELECT SMRPRLE_PROGRAM_DESC FROM SGBSTDN G, SMRPRLE WHERE G.ROWID = BANINST1.fz_get_sgbstdn_rowid(G.SGBSTDN_PIDM, (NVL((SELECT MAX(SGBSTDN_TERM_CODE_EFF) FROM SGBSTDN WHERE SGBSTDN_PIDM = G.SGBSTDN_PIDM AND SGBSTDN_LEVL_CODE = G.SGBSTDN_LEVL_CODE),'999999')), G.SGBSTDN_LEVL_CODE) AND G.SGBSTDN_PROGRAM_1 = SMRPRLE_PROGRAM AND G.SGBSTDN_LEVL_CODE IN ('UG','TC','GR') AND G.SGBSTDN_TERM_CODE_EFF = (SELECT MAX(SGBSTDN_TERM_CODE_EFF) FROM SGBSTDN WHERE SGBSTDN_PIDM = G.SGBSTDN_PIDM) AND G.SGBSTDN_PIDM ='" + pidm + "' ").executeQuery();
                while (rs2.next()) {
            %>
            <div class="form-group">
                <div class="col-md-4    ">
                    <input class="form-control" id="Input" name="carreraestudio" type="text" value="<%out.print(rs2.getNString("SMRPRLE_PROGRAM_DESC"));
                        }
                        rs2.close();%>" readonly><br>
                </div>
            </div>

            <%
                ResultSet rs3 = co.prepareStatement("SELECT GOREMAL_EMAIL_ADDRESS  FROM GOREMAL WHERE GOREMAL.GOREMAL_EMAL_CODE = 'STAN' AND GOREMAL.GOREMAL_PIDM ='" + pidm + "' ").executeQuery();
                while (rs3.next()) {
            %>
            <div class="form-group" style="display: none"> 
                <input class="form-control" id="Input" name="emaili" type="text" value="<%out.print(rs3.getNString("GOREMAL_EMAIL_ADDRESS"));
                    }
                    rs3.close();%>"
            </div>   
    </div>

    <%
        ResultSet rs4 = co.prepareStatement("SELECT GOREMAL_EMAIL_ADDRESS FROM GOREMAL WHERE GOREMAL.GOREMAL_EMAL_CODE = 'PERS' AND GOREMAL.GOREMAL_PIDM ='" + pidm + "' ").executeQuery();
        while (rs4.next()) {
    %>
    <div class="form-group" style="display: none">
        <input class="form-control" id="Input" name="emailp" type="text" value="<%out.print(rs4.getNString("GOREMAL_EMAIL_ADDRESS"));
            }
            rs4.close();%>"
    </div> 
</div>

</div>
<div class="container">
    <div class="alert alert-info" role="alert"><center>DATOS DE LA TUTORÍA</center></div>
    <h6>*INGRESE LOS DATOS CON LA INFORMACIÓN DE LA TUTORÍA<span class="label label-default"></span></h6>
    <div class="form-group">
        <label for="Input" class="col-sm-6 control-label"> TEMA A TRATAR</label>
        <div class="col-md-12">
            <input class="form-control text-uppercase" name="tema" id="Input" type="text" placeholder="COMO SE PIERDE POR ASISTENCIAS" >
        </div>
    </div>
</div>
<div class="container">
    <br><div class="alert alert-info" role="alert"><center>DATOS DEL REGISTRO</center></div>
    <h6>*DATOS GENERALES DEL REGISTRO DE LA TUTORÍA<span class="label label-default"></span></h6>
    <div class="form-group">
        <label for="Input" class="col-sm-9 control-label">OBSERVACIONES GENERALES</label>
        <label for="Input" class="col-sm-3 control-label">FECHA DE REGISTRO</label>
        <div class="col-md-9">
            <input class="form-control" id="Input" name="observaciones" type="text" placeholder="SOLICITO DAR ATENCION A MI PEDIDO" ><br>
        </div>
    </div>
    <div class="form-group">
        <div class="col-md-3">
            <input class="form-control" name="fecharegistro" id="Input" type="date" value="<%=dateFormat.format(date)%>" readonly ><br>
        </div>
    </div>
</div>

<% out.println("<div class=\"col-md-12\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action='ptutorias.jsp';\" value=\"" + CodT + "\">Enviar</button></center></div>");%>
</form>
</div>
</body>
<% co.close();
    con.closeConexion();
%>
</html>
