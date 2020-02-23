<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Confirmacion de Haber recibido tutoria</title>
        <%  //Conexion a la base de datos
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();

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

            //importacion de las librerias
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);

            Date date = new Date();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            int CodT = 2;
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
                                <li><a href="solicitudAcompanamiento.jsp"><i class="glyphicon glyphicon-user">&nbsp</i>Solicitud de tutoria de Acompañamiento</a></li>
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
        <center><h3><b class="text-success">SOLICITUD DE TUTORÍA DE REFORZAMIENTO</b><span class="label label-default text-success"></span></h3></center>        <h6>*SOLICITUD DE TUTORÍA POR PARTE DEL ESTUDIANTE<span class="label label-default"></span></h6>
        <form action="ptutorias.jsp" method="POST">
            <div class="alert alert-info" role="alert"><center>DATOS DEL ESTUDIANTE</center></div>
            <h6>*DATOS GENERALES DEL ESTUDIANTE<span class="label label-default"></span></h6>
                <%   ResultSet rs = co.prepareStatement("SELECT SPBPERS_SSN FROM SPBPERS WHERE SPBPERS_PIDM ='" + pidm + "'").executeQuery();
                    while (rs.next()) {%>
            <div class="form-group">
                <label for="Input" class="col-sm-3 control-label">CÉDULA DE IDENTIDAD</label>
                <label for="Input" class="col-sm-5 control-label">APELLIDOS Y NOMBRES</label>
                <label for="Input" class="col-sm-4 control-label">CARRERA DE ESTUDIO</label>
                <div class="col-md-3">
                    <input class="form-control" id="Input" name="cedula" type="text" value="<%out.print(rs.getNString("SPBPERS_SSN"));
                        }
                        rs.close(); %>" readonly><br>
                </div>
            </div>
            <%ResultSet rs1 = co.prepareStatement("SELECT SUBSTR(f_format_name(SPRIDEN_PIDM,'LFMI'),1,45) FROM SPRIDEN WHERE SPRIDEN_CHANGE_IND IS NULL AND SPRIDEN_PIDM = '" + pidm + "' ").executeQuery();
                while (rs1.next()) {%>
            <div class="form-group">

                <div class="col-md-5">
                    <input class="form-control" id="Input" name="nombres" type="text" value=" <%out.print(rs1.getNString("SUBSTR(f_format_name(SPRIDEN_PIDM,'LFMI'),1,45)"));
                        }
                        rs1.close();%>" readonly><br>
                </div>
            </div> 
            <% ResultSet rs2 = co.prepareStatement("SELECT SMRPRLE_PROGRAM_DESC FROM SGBSTDN G, SMRPRLE WHERE G.ROWID = BANINST1.fz_get_sgbstdn_rowid(G.SGBSTDN_PIDM, (NVL((SELECT MAX(SGBSTDN_TERM_CODE_EFF) FROM SGBSTDN WHERE SGBSTDN_PIDM = G.SGBSTDN_PIDM AND SGBSTDN_LEVL_CODE = G.SGBSTDN_LEVL_CODE),'999999')), G.SGBSTDN_LEVL_CODE) AND G.SGBSTDN_PROGRAM_1 = SMRPRLE_PROGRAM AND G.SGBSTDN_LEVL_CODE IN ('UG','TC','GR') AND G.SGBSTDN_TERM_CODE_EFF = (SELECT MAX(SGBSTDN_TERM_CODE_EFF) FROM SGBSTDN WHERE SGBSTDN_PIDM = G.SGBSTDN_PIDM) AND G.SGBSTDN_PIDM ='" + pidm + "' ").executeQuery();
                while (rs2.next()) {%>
            <div class="form-group">
                <div class="col-md-4">
                    <input class="form-control" id="Input" name="carreraestudio" type="text" value="<%out.print(rs2.getNString("SMRPRLE_PROGRAM_DESC"));
                        }
                        rs2.close();%>" readonly>
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
        <label for="Input" class="col-sm-6 control-label">TEMA A TRATAR</label>
        <label for="Input" class="col-sm-6 control-label">INGRESE EL NRC DEL QUE REQUIERE TUTORÍA</label> 
        <div class="col-md-6">
            <input class="form-control text-uppercase" name="tema" id="Input" type="text" placeholder="BASES DE DATOS" >
        </div>
        <% //PIDM
            ResultSet rsu = co.prepareStatement("SELECT DISTINCT SFRSTCR_CRN AS NRC,\n"
                    + "A.SCBCRSE_SUBJ_CODE || A.SCBCRSE_CRSE_NUMB || ' - ' || A.SCBCRSE_TITLE AS ASIGNATURA,\n"
                    + "SFRSTCR_CAMP_CODE AS CAMPUS,\n"
                    + "SFRSTCR_TERM_CODE AS PERIODO,\n"
                    + "SFRSTCR_LEVL_CODE AS NIVEL\n"
                    + "FROM SFRSTCR, SSBSECT, SCBCRSE A\n"
                    + "WHERE SFRSTCR_PIDM  ='" + pidm + "'\n" //pidm
                    + "AND SFRSTCR_TERM_CODE = SSBSECT_TERM_CODE\n"
                    + "AND SFRSTCR_CRN = SSBSECT_CRN\n"
                    + "AND SSBSECT_PTRM_END_DATE >= SYSDATE\n"
                    + "AND SSBSECT_SUBJ_CODE = A.SCBCRSE_SUBJ_CODE\n"
                    + "AND SSBSECT_CRSE_NUMB = A.SCBCRSE_CRSE_NUMB\n"
                    + "AND A.SCBCRSE_EFF_TERM = (SELECT MAX( SCBCRSE_EFF_TERM)\n"
                    + "FROM  SCBCRSE\n"
                    + "WHERE SCBCRSE_SUBJ_CODE = A.SCBCRSE_SUBJ_CODE\n"
                    + "AND SCBCRSE_CRSE_NUMB = A.SCBCRSE_CRSE_NUMB)").executeQuery();
        %>
        <div class="form-group">
            <div class="col-md-6">
                <select class="form-control" id="sel1" name="nrc"id="Input">
                    <% while (rsu.next()) {%><option>
                        <%out.print(rsu.getString("NRC") + " - " + rsu.getString("ASIGNATURA") + " - " + rsu.getString("CAMPUS") + " - " + rsu.getString("PERIODO") + " - " + rsu.getString("NIVEL"));
                            }
                            rsu.close();%>
                    </option>
                </select>
            </div>
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
            <input class="form-control" name="observaciones" id="Input" type="text" placeholder="SOLICITO DAR ATENCION A MI PEDIDO" ><br>
        </div>
    </div>
    <div class="form-group">
        <div class="col-md-3">
            <input class="form-control" name="fecharegistro" id="Input" type="date" value="<%=dateFormat.format(date)%>" readonly ><br>
        </div>
    </div>
</div>
<div class="container">
    <% out.println("<div class=\"col-md-10\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action='ptutorias.jsp';\" value=\"" + CodT + "\">Enviar</button></center></div>");%>
</div>
</form>
</div>
</body>
<% co.close();
    con.closeConexion();
%>
</html>
