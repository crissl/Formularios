<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.css" />
        <title>PLANIFICACIÓN DE LA TUTORÍA DE REFORZAMIENTO ACADÉMICO</title>
        <% //conexion a la base de datos
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
            //Obtecion de los valores de los formularios
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
            String Cedula = request.getParameter("cedula");
            String Tema = request.getParameter("tema");
            String Optradio = request.getParameter("optradio");
            String Nrcd = request.getParameter("nrcd");
            String fecha = request.getParameter("fecha");
            String Email = request.getParameter("emaili");
            String par_emailp = request.getParameter("emailp");

            //Funcion para convertir el formato de fecha a dd/MM/yyyy
            Date date = new Date();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            DateFormat originalFormat = new SimpleDateFormat("yyyy-MM-dd");
            int CodT = 1;


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

                                <li><a href="planificacionAcompanamiento.jsp"><i class="glyphicon glyphicon-user">&nbsp</i>Planificación de Tutoria Acompañamiento</a></li>
                                <li><a href="registroAsistencia.jsp"><i class="glyphicon glyphicon-edit">&nbsp</i>Registro de ejecución tutoria de Acompañamiento </a></li>

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
    <form action="ptutoriasdocentes.jsp" method="POST">
        <div class="container">
            <center><h3><b class="text-success">PLANIFICACIÓN DE TUTORÍA DE REFORZAMIENTO</b><span class="label label-default text-success"></span></h3></center>
            <h6>*PLANIFICACIÓN DE LA TUTORÍA DE REFORZAMIENTO ACADÉMICO.<span class="label label-default"></span></h6>
            <div class="alert alert-info" role="alert"><center>DATOS DEL TUTOR</center></div>
            <h6>DATOS GENERALES DEL TUTOR DE REFORZAMIENTO ACADÉMICO.<span class="label label-default"></span></h6>
                <% ResultSet rs = co.prepareStatement("SELECT SPBPERS_SSN FROM SPBPERS WHERE SPBPERS_PIDM ='" + pidm + "'").executeQuery();
                    while (rs.next()) {%>
            <div class="form-group">
                <label for="Input" class="col-sm-3 control-label">CÉDULA DE IDENTIDAD</label>
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
                    <input class="form-control" id="Input" name="nombres" type="text" value="<%out.print(rs1.getNString("SUBSTR(f_format_name(SPRIDEN_PIDM,'LFMI'),1,45)"));
                        }
                        rs1.close();%>" readonly><br>
                </div>
            </div> <%
                ResultSet rs2 = co.prepareStatement("SELECT FTVORGN_TITLE FROM PEBEMPL, FTVORGN WHERE FTVORGN_ORGN_CODE = PEBEMPL_ORGN_CODE_HOME AND PEBEMPL_PIDM ='" + pidm + "' ").executeQuery();
                while (rs2.next()) {
            %>
            <div class="form-group">
                <div class="col-md-4">
                    <input class="form-control" id="Input" type="text" name="labora" value="<%out.print(rs2.getNString("FTVORGN_TITLE"));
                        }
                        rs2.close();%>" readonly><br>
                </div>
            </div>
            <%
                ResultSet rs5 = co.prepareStatement("SELECT GOREMAL_EMAIL_ADDRESS  FROM GOREMAL WHERE GOREMAL.GOREMAL_EMAL_CODE = 'STAN' AND GOREMAL.GOREMAL_PIDM ='" + pidm + "' ").executeQuery();
                while (rs5.next()) {
            %>
            <div class="form-group" style="display: none"> 
                <input class="form-control" id="Input" name="emaili" type="text" value="<%out.print(rs5.getNString("GOREMAL_EMAIL_ADDRESS"));
                    }
                    rs5.close();%>"
            </div>   
        </div>

        <%
            ResultSet rs6 = co.prepareStatement("SELECT GOREMAL_EMAIL_ADDRESS FROM GOREMAL WHERE GOREMAL.GOREMAL_EMAL_CODE = 'PERS' AND GOREMAL.GOREMAL_PIDM ='" + pidm + "' ").executeQuery();
            while (rs6.next()) {
        %>
        <div class="form-group" style="display: none">
            <input class="form-control" id="Input" name="emailp" type="text" value="<%out.print(rs6.getNString("GOREMAL_EMAIL_ADDRESS"));
                }
                rs6.close();%>"
        </div> 
    </div>

</div>
<div class="container">
    <div class="alert alert-info" role="alert"><center>DATOS DE LA TUTORÍA</center></div>
    <div class="col-md-12">
        <h6>*INGRESE LA INFORMACIÓN REFERENTE A LA TUTORÍA DE REFORZAMIENTO ACADÉMICO<span class="label label-default"></span></h6>
    </div>
    <br>
    <div class="form-group">
        <label for="Input" class="col-sm-6 control-label">TEMA A TRATAR</label>
        <label for="Input" class="col-sm-6 control-label">INGRESE EL NRC DEL QUE REQUIERE TUTORÍA</label>
        <div class="col-md-6">
            <input class="form-control text-uppercase" id="Input" name="tema" type="text" placeholder="BASES DE DATOS" >
        </div>
    </div>
    <%
        ResultSet rsT = co.prepareStatement("SELECT DISTINCT SIRASGN_CRN AS NRC,\n"
                + "A.SCBCRSE_SUBJ_CODE || A.SCBCRSE_CRSE_NUMB || ' - ' || A.SCBCRSE_TITLE AS ASIGNATURA,\n"
                + "SSBSECT_CAMP_CODE AS CAMPUS,\n"
                + "SSBSECT_TERM_CODE AS PERIODO\n"
                + "FROM SIRASGN, SSBSECT, SCBCRSE A\n"
                + "WHERE SIRASGN_PIDM  = '" + pidm + "'\n"
                + "AND SIRASGN_TERM_CODE = SSBSECT_TERM_CODE\n"
                + "AND SIRASGN_CRN = SSBSECT_CRN\n"
                + "AND SSBSECT_PTRM_END_DATE >= SYSDATE\n"
                + "AND SSBSECT_SUBJ_CODE = A.SCBCRSE_SUBJ_CODE\n"
                + "AND SSBSECT_CRSE_NUMB = A.SCBCRSE_CRSE_NUMB\n"
                + "AND A.SCBCRSE_EFF_TERM = (SELECT MAX( SCBCRSE_EFF_TERM)\n"
                + "FROM  SCBCRSE\n"
                + "WHERE SCBCRSE_SUBJ_CODE = A.SCBCRSE_SUBJ_CODE\n"
                + "AND SCBCRSE_CRSE_NUMB = A.SCBCRSE_CRSE_NUMB)").executeQuery();%>
    <div class="form-group">
        <div class="col-md-6">
            <select class="form-control" id="sel" name="nrcd">
                <%while (rsT.next()) {
                %>
                <option>
                    <%out.print(rsT.getString("NRC") + " - " + rsT.getString("ASIGNATURA") + " - " + rsT.getString("CAMPUS") + " - " + rsT.getString("PERIODO"));
                        }
                        rsT.close();%>
                </option>
            </select>
        </div>
    </div>
    <%            String stringd = Nrcd;
        String[] partsd = stringd.split(" - ");
        String nrcd = partsd[0]; // 123
        String codasignaturad = partsd[1];
        String asignaturad = partsd[2]; // 123
        String campusd = partsd[3];
    String periodod = partsd[4];%>
    <div class="form-group">
        <label class="col-sm-12 control-label">A QUIÉN DARÁ LA TUTORÍA</label><br>
        <div class="col-md-12">
            <div class="radio">
                <label><input type="radio" name="optradio" value="T" checked>TODOS</label>
            </div>
            <div class="radio">
                <label><input type="radio" name="optradio" value="M"> ALUMNOS NOTAS <14</label>
            </div>
            <div class="radio">
                <label><input type="radio" name="optradio" value="S">SOLICITADOS POR LOS ESTUDIANTES</label>
            </div>
        </div>
    </div>
    <div class="form-group">
        <label for="Input" class="col-sm-12 control-label">FECHA DE LA TUTORÍA</label>
        <div class="col-sm-3">
            <input class="form-control" id="Input" type="date" name="fecha" value="<%=dateFormat.format(date)%>" >
        </div>
    </div>
    <%
        Date Fecha = originalFormat.parse(fecha);
        String dia = "";
        String nombre = "";
        GregorianCalendar fechaCalendario = new GregorianCalendar();
        fechaCalendario.setTime(Fecha);
        int diaSemana = fechaCalendario.get(Calendar.DAY_OF_WEEK);

        //Validacion para obtener el dia segun la fecha de la tutoria
        if (diaSemana == 1) {
            dia = "SZARPGN_CAMPVA15";
            nombre = "Domingo";
        } else if (diaSemana == 2) {
            dia = "SZARPGN_CAMPVAR9";
            nombre = "Lunes";
        } else if (diaSemana == 3) {
            dia = "SZARPGN_CAMPVA10";
            nombre = "Martes";
        } else if (diaSemana == 4) {
            dia = "SZARPGN_CAMPVA11";
            nombre = "Miercoles";
        } else if (diaSemana == 5) {
            dia = "SZARPGN_CAMPVA12";
            nombre = "Jueves";
        } else if (diaSemana == 6) {
            dia = "SZARPGN_CAMPVA13";
            nombre = "Viernes";
        } else if (diaSemana == 7) {
            dia = "SZARPGN_CAMPVA14";
            nombre = "Sabado";
        }
    %>
    <div class="form-group"  style="display: none;">
        <label for="Input" class="col-sm-12 control-label">FECHA DE REGISTRO</label><br>
        <div class="col-md-3">
            <input class="form-control" name="fecharegistro" id="Input" type="date" value="<%=dateFormat.format(date)%>" readonly ><br>
        </div>
    </div>
    <br>
    <div class="form-group">
        <label for="Input" class="col-sm-12 control-label">AULA/LUGAR EN LA QUE SE DARÁ LA TUTORÍA</label>
        <div class="col-md-12">
            <input type="radio" name="opciones" value="aula" id="aula"> Aula <br>
            <input type="radio" name="opciones" value="sitio" id="sitio"> Lugar <br>
        </div>
        <div id="div1" style="display:none"> 
            <label for="Input" class="col-sm-12 control-label">INGRESE EL LUGAR EN LA QUE SE DARÁ LA TUTORÍA</label>
            <div class="col-md-12">
                <input type="text" class="form-control" name="lugar"  placeholder="Ingrese el Lugar"></input>
            </div>
        </div>
    </div>
    <%  String campus1 = "01";
        if (campusd.equalsIgnoreCase("12") || campusd.equalsIgnoreCase("20")) {
            ResultSet rsAu = co.prepareStatement("SELECT DISTINCT SZARPGN_CAMPVAR3 ||' - '||SZARPGN_CAMPVAR4 AS AULA, SZARPGN_CAMPVAR7 ||' - '||SZARPGN_CAMPVAR8 AS HORARIO, SZARPGN_CAMPVAR7 AS HORA_INICIO, SZARPGN_CAMPVAR8 AS HORA_FIN FROM SATURN.SZARPGN, SLBRDEF WHERE SZARPGN_IDREPORT = 'AULAS_'|| '" + campus1 + "' AND SLBRDEF_BLDG_CODE = SZARPGN_CAMPVAR3 AND SLBRDEF_ROOM_NUMBER = SZARPGN_CAMPVAR4 AND SLBRDEF_RMST_CODE = 'AC' AND SLBRDEF_ROOM_TYPE = 'C' AND " + dia + " IS NOT NULL ORDER BY 3,4,1").executeQuery(); %>
    <div id="div2" style="display:none" disabled>
        <label for="Input" class="col-sm-12 control-label">SELECIONE EL AULA 1 Y EL HORARIO EN LA QUE SE DARÁ LA TUTORÍA</label>
        <div class="col-md-8">
            <select class="form-control"  name="aula"id="Input">
                <option selected="selected" value="">Seleccione el Aula y el Horario</option>
                <% while (rsAu.next()) {%>
                <option >
                    <% out.print(rsAu.getString("AULA") + " - " + rsAu.getString("HORA_INICIO") + " - " + rsAu.getString("HORA_FIN"));
                        }
                        rsAu.close();%></option>
            </select>
        </div>
    </div>
    <% } else {
        ResultSet rsAu = co.prepareStatement("SELECT DISTINCT SZARPGN_CAMPVAR3 ||' - '||SZARPGN_CAMPVAR4 AS AULA, SZARPGN_CAMPVAR7 ||' - '||SZARPGN_CAMPVAR8 AS HORARIO, SZARPGN_CAMPVAR7 AS HORA_INICIO, SZARPGN_CAMPVAR8 AS HORA_FIN FROM SATURN.SZARPGN, SLBRDEF WHERE SZARPGN_IDREPORT = 'AULAS_'|| '" + campusd + "' AND SLBRDEF_BLDG_CODE = SZARPGN_CAMPVAR3 AND SLBRDEF_ROOM_NUMBER = SZARPGN_CAMPVAR4 AND SLBRDEF_RMST_CODE = 'AC' AND SLBRDEF_ROOM_TYPE = 'C' AND " + dia + " IS NOT NULL ORDER BY 3,4,1").executeQuery(); %>
    <div id="div2" style="display:none" disabled>
        <label for="Input" class="col-sm-12 control-label">SELECIONE EL AULA Y EL HORARIO EN LA QUE SE DARÁ LA TUTORÍA</label>
        <div class="col-md-8">
            <select class="form-control"  name="aula"id="Input">
                <option selected="selected" value="">Seleccione el Aula y el Horario</option>

                <% while (rsAu.next()) {%>
                <option >
                    <% out.print(rsAu.getString("AULA") + " - " + rsAu.getString("HORA_INICIO") + " - " + rsAu.getString("HORA_FIN"));
                        }
                        rsAu.close();%></option>
            </select>
        </div>
    </div>
    <%}%>
    <% out.println("<div class=\"col-md-10\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action=1.jsp';\" value=\"" + CodT + "\">Siguiente</button></center></div>");%>
</div>
</form>
</body>
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