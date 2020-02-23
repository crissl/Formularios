<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="espe.edu.ec.util.Uztasistentes"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="espe.edu.ec.models.PlanificacionTutorias"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.css" />
        <% //Obtencion de los valores de las Cookies
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

            //conexion a la base de datos
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            //importacion de Css y Js
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
            //Obtecion de los valores de los formularios
            String nomF = request.getParameter("Submit");
            int CodT = Integer.parseInt(nomF);
            String Cedula = request.getParameter("cedula");
            String Tema = request.getParameter("tema");
            String Optradio = request.getParameter("optradio");
            String Nrcd = request.getParameter("nrcd");
            String fecha = request.getParameter("fecha");
            String Aula = request.getParameter("aula");
            String Lugar = request.getParameter("lugar");
            String Email = request.getParameter("emaili");
            String par_emailp = request.getParameter("emailp");
            Date date = new Date();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            switch (CodT) {
                case 1:%>
    </head>
    <body>
        <form action="ptutoriasdocentes.jsp" method="POST"> 
            <div class="form-group" style="display: none"> 
                <input class="form-control" id="Input" name="emaili" type="text" value="<%=Email%>">
            </div>   
        </div>
        <div class="form-group" style="display: none">
            <input class="form-control" id="Input" name="emailp" type="text" value="<%=par_emailp%>">
        </div> 
        <div class="container">
            <center><h3>PLANIFICACIÓN DE TUTORÍA DE REFORZAMIENTO<span class="label label-default"></span></h3></center>
            <h6>*PLANIFICACIÓN DE LA TUTORÍA DE REFORZAMIENTO ACADÉMICO<span class="label label-default"></span></h6>
            <div class="alert alert-info" role="alert"><center>DATOS DEL TUTOR</center></div>
            <h6>DATOS GENERALES DEL TUTOR DE REFORZAMIENTO ACADÉMICO<span class="label label-default"></span></h6>
            <div class="form-group">
                <label for="Input" class="col-sm-3 control-label">CÉDULA DE IDENTIDAD</label>
                <label for="Input" class="col-sm-5 control-label">APELLIDOS Y NOMBRES</label>
                <label for="Input" class="col-sm-4 control-label">UNIDAD O DEPARTAMENTO EN QUE LABORA</label>
                <div class="col-md-3">
                    <input class="form-control" id="Input" name="cedula" type="text" value="<%=Cedula%>" readonly>
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
                        rs1.close();%>" readonly>
                </div>
            </div> <%
                ResultSet rs2 = co.prepareStatement("SELECT FTVORGN_TITLE FROM PEBEMPL, FTVORGN WHERE FTVORGN_ORGN_CODE = PEBEMPL_ORGN_CODE_HOME AND PEBEMPL_PIDM ='" + pidm + "' ").executeQuery();
                while (rs2.next()) {
            %>
            <div class="form-group">
                <div class="col-md-4">
                    <input class="form-control" id="Input" type="text" name="labora" value="<%out.print(rs2.getNString("FTVORGN_TITLE"));
                        }
                        rs2.close();%>" readonly>
                </div>
            </div>
        </div><br>
        <div class="container">
            <div class="alert alert-info" role="alert"><center>DATOS DE LA TUTORÍA</center></div>
            <div class="col-md-12">
                <h6>*INGRESE LA INFORMACIÓN REFERENTE A LA TUTORIA DE REFORZAMIENTO ACADÉMICA<span class="label label-default"></span></h6>
            </div>
            <div class="form-group">
                <label for="Input" class="col-sm-6 control-label">TEMA A TRATAR</label>
                <label for="Input" class="col-sm-6 control-label">INGRESE EL NRC DEL QUE REQUIERE TUTORÍA</label>

                <div class="col-md-6">
                    <input class="form-control" id="Input" name="tema" type="text" placeholder="BASES DE DATOS" value="<%=Tema%>" readonly>
                </div>
            </div>
            <div class="form-group">
                <div class="col-md-6">
                    <select class="form-control" id="sel" name="nrcd" readonly>
                        <option>
                            <%=Nrcd%>
                        </option>
                    </select>
                </div>
            </div>
        </div><br>
        <div class="container">
            <div class="form-group">
                <label class="col-sm-3 control-label">A QUIÉN DARÁ LA TUTORÍA</label>
                <label for="Input" class="col-sm-3 control-label">FECHA DE LA TUTORÍA</label>
                <label for="Input" class="col-sm-6 control-label">LUGAR EN LA QUE SE DARÁ LA TUTORÍA</label>

                <div class="col-md-3">
                    <%
                        if ("T".equalsIgnoreCase(Optradio)) {
                    %>
                    <div class="radio">
                        <label><input type="radio" name="optradio" value="<%=Optradio%>" checked>TODOS</label>
                    </div>
                    <%} else if ("M".equalsIgnoreCase(Optradio)) {%>
                    <div class="radio">
                        <label><input type="radio" name="optradio" value="<%=Optradio%>" checked> ALUMNOS NOTAS <14</label>
                    </div>
                    <%} else {%>
                    <div class="radio">
                        <label><input type="radio" name="optradio" value="<%=Optradio%>" checked>SOLICITADOS POR EL ESTUDIANTE</label>
                    </div>
                    <%}%>
                </div>
            </div>
            <div class="form-group">
                <div class="col-md-3">
                    <input class="form-control" id="Input" type="date" name="fecha" value="<%=fecha%>" readonly>
                </div>
            </div>
            <div class="form-group"  style="display: none;">
                <label for="Input" class="col-sm-12 control-label">FECHA DE REGISTRO</label>
                <div class="col-md-3">
                    <input class="form-control" name="fecharegistro" id="Input" type="date" value="<%=dateFormat.format(date)%>" readonly ><br>
                </div>
            </div>
            <%if (Aula.equals("")) {%>
            <div class="form-group" id="div1">
                <div class="col-md-5">
                    <input type="text" class="form-control" name="lugar"  placeholder="Ingrese el Lugar" value="<%=Lugar%>" readonly></input>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="form-group">
                <label for="Input" class="col-md-3 control-label">HORA INICIO DE LA TUTORÍA :</label>
                <label for="Input" class="col-md-7 control-label">HORA FIN DE LA TUTORÍA:</label>
                <label for="Input" class="col-md-2 control-label"></label>
                <div class="col-md-3">
                    <input id = "timepicker1" type = "text" name="hinicia" class ="form-control input-small">   
                </div>
                <div class="col-md-3">
                    <input id = "timepicker2" type = "text" name="hfin" class="form-control input-small">   
                </div>
            </div>
        </div>
        <%} else {
            String stringa = Aula;
            String[] partsa = stringa.split(" - ");
            String bloque = partsa[0]; // 123
            String aula = partsa[1];
            String hinicia = partsa[2]; // 123
            String hfin = partsa[3];
            DateFormat outputFormat = new SimpleDateFormat("HH:mm a");
            DateFormat inputFormat = new SimpleDateFormat("HHmm");
            //Formato de conversion de hora
            String hinicias = hinicia;
            Date HORAINICIA = inputFormat.parse(hinicias);
            String HINICIA = outputFormat.format(HORAINICIA);
            //Formato de conversion de hora
            String horafin = hfin;
            Date HORAFIN = inputFormat.parse(horafin);
            String HFIN = outputFormat.format(HORAFIN);%>
        <div class="form-group" id="div1"> 
            <div class="col-md-5">
                <input type="text" class="form-control" name="aula"  placeholder="Ingrese el Lugar" value="<%=Aula%>" readonly></input>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="form-group">
            <label for="Input" class="col-md-3 control-label">HORA INICIO DE LA TUTORÍA :</label>
            <label for="Input" class="col-md-7 control-label">HORA FIN DE LA TUTORÍA:</label>
            <label for="Input" class="col-md-2 control-label"></label>

            <div class="col-md-3">
                <input id="1" type="text" name="hinicia" class ="form-control input-small" value="<%=HINICIA%>" readonly>   
            </div>
            <div class="col-md-3">
                <input id="2" type="text" name="hfin" class="form-control input-small" value="<%=HFIN%>" readonly>   
            </div>
        </div>
    </div>
    <%  }%> 
    <div class="container">
        <br><div class="alert alert-info" role="alert"><center>DATOS DEL REGISTRO</center></div>
        <h6>*DATOS GENERALES DEL REGISTRO DE LA TUTORÍA<span class="label label-default"></span></h6>
        <div class="form-group">
            <label for="Input" class="col-sm-12 control-label">OBSERVACIONES GENERALES</label><br>
            <div class="col-md-12">
                <input class="form-control" id="Input" type="text" name="observaciones" placeholder="TRAER MODELO DE BASE DE DATOS DE ACUERDO A SU PROYECTO" ><br>
            </div>
        </div>
        <% out.println("<div class=\"col-md-12\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action=ptutoriasdocentes.jsp';\" value=\"" + CodT + "\">Terminar</button></center></div>");%>
</form>
</div>
<div class="container">
    <div class="progress" >
        <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:90%">
            90% de la Planificacion Completada
        </div>
    </div
</div>


</body>
<% break;
    case 2:
        break;
    case 3:%>
<body>
    <form action="ptutoriasdocentes.jsp" method="POST"> 
        <div class="form-group" style="display: none"> 
            <input class="form-control" id="Input" name="emaili" type="text" value="<%=Email%>">
        </div>   
    </div>
    <div class="form-group" style="display: none">
        <input class="form-control" id="Input" name="emailp" type="text" value="<%=par_emailp%>">
    </div> 
    <div class="container">
        <center><h3><b class="text-success">PLANIFICACIÓN DE TUTORÍA DE ACOMPAÑAMIENTO</b><span class="label label-default text-success"></span></h3></center>
        <h6>*PLANIFICACIÓN DE LA TUTORÍA DE ACOMPAÑAMIENTO ACADÉMICO<span class="label label-default"></span></h6>


        <div class="alert alert-info" role="alert"><center>DATOS DEL ESTUDIANTE</center></div>
        <h6>DATOS DEL TUTOR<span class="label label-default"></span></h6>
        <div class="form-group">
            <label for="Input" class="col-sm-3 control-label">CÉDULA DE IDENTIDAD</label>
            <label for="Input" class="col-sm-5 control-label">APELLIDOS Y NOMBRES</label>
            <label for="Input" class="col-sm-4 control-label">UNIDAD O DEPARTAMENTO EN QUE LABORA</label>
            <div class="col-md-3">
                <input class="form-control" id="Input" name="cedula" type="text" value="<%=Cedula%>" readonly><br>
            </div>
        </div>
        <%
            ResultSet rs3 = co.prepareStatement("SELECT SUBSTR(f_format_name(SPRIDEN_PIDM,'LFMI'),1,45) FROM SPRIDEN WHERE SPRIDEN_CHANGE_IND IS NULL AND SPRIDEN_PIDM = '" + pidm + "' ").executeQuery();
            while (rs3.next()) {
        %>
        <div class="form-group">
            <div class="col-md-5">
                <input class="form-control" id="Input" name="nombres" type="text" value="<%out.print(rs3.getNString("SUBSTR(f_format_name(SPRIDEN_PIDM,'LFMI'),1,45)"));
                    }
                    rs3.close();%>" readonly><br>
            </div>
        </div> <%
            ResultSet rs4 = co.prepareStatement("SELECT FTVORGN_TITLE FROM PEBEMPL, FTVORGN WHERE FTVORGN_ORGN_CODE = PEBEMPL_ORGN_CODE_HOME AND PEBEMPL_PIDM ='" + pidm + "' ").executeQuery();
            while (rs4.next()) {
        %>
        <div class="form-group">
            <div class="col-md-4">
                <input class="form-control" id="Input" type="text" name="labora" value="<%out.print(rs4.getNString("FTVORGN_TITLE"));
                    }
                    rs4.close();%>" readonly><br>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="alert alert-info" role="alert"><center>DATOS DE LA TUTORÍA</center></div>
        <div class="col-md-12">
            <h6>*INGRESE LA INFORMACIÓN REFERENTE A LA TUORIA DE ACOMPAÑAMIENTO ACADÉMICO<span class="label label-default"></span></h6>
        </div>
        <br>
        <div class="form-group">
            <label for="Input" class="col-sm-6 control-label">TEMA A TRATAR</label>
            <label class="col-sm-3 control-label">A QUIEN DARÁ LA TUTORÍA</label>
            <label for="Input" class="col-sm-3 control-label">FECHA DE LA TUTORÍA</label>
            <div class="col-md-6">
                <input class="form-control" id="Input" name="tema" type="text" placeholder="BASES DE DATOS" value="<%=Tema%>" readonly>
            </div>
        </div>
        <div class="form-group">
            <div class="col-md-3">
                <%
                    if ("T".equalsIgnoreCase(Optradio)) {
                %>
                <div class="radio">
                    <label><input type="radio" name="optradio" value="<%=Optradio%>" checked>TODOS</label>
                </div>
                <%} else {%>
                <div class="radio">
                    <label><input type="radio" name="optradio" value="<%=Optradio%>" checked>SOLICITADOS POR EL ESTUDIANTE</label>
                </div>  
                <%}%>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-3">
                <input class="form-control" id="Input" type="date" name="fecha" value="<%=fecha%>" readonly>
            </div>
        </div>
        <div class="form-group"  style="display: none;">
            <label for="Input" class="col-sm-12 control-label">FECHA DE REGISTRO</label><br>
            <div class="col-md-3">
                <input class="form-control" name="fecharegistro" id="Input" type="date" value="<%=dateFormat.format(date)%>" readonly ><br>
            </div>
        </div>
        <%if (Aula.equals("")) {%>

        <div class="form-group" id="div1"> 
            <label for="Input" class="col-sm-6 control-label">LUGAR EN LA QUE SE DARÁ LA TUTORÍA</label>
            <label for="Input" class="col-md-3 control-label">HORA INICIO DE LA TUTORÍA:</label>
            <label for="Input" class="col-md-3 control-label">HORA FIN DE LA TUTORÍA:</label>
            <div class="col-md-6">
                <input type="text" class="form-control" name="lugar"  placeholder="Ingrese el Lugar" value="<%=Lugar%>" readonly></input>
            </div>
        </div>
        <div class="form-inline">
            <div class="col-md-3">
                <input id = "timepicker1" type = "text" name="hinicia" class ="form-control input-small">   
            </div>
        </div>
        <div class="col-md-3">
            <input id = "timepicker2" type = "text" name="hfin" class="form-control input-small">   
        </div>
    </div>

    <%} else {
        String stringa = Aula;
        String[] partsa = stringa.split(" - ");
        String bloque = partsa[0]; // 123
        String aula = partsa[1];
        String hinicia = partsa[2]; // 123
        String hfin = partsa[3];
        DateFormat outputFormat = new SimpleDateFormat("HH:mm a");
        DateFormat inputFormat = new SimpleDateFormat("HHmm");

        String hinicias = hinicia;
        Date HORAINICIA = inputFormat.parse(hinicias);
        String HINICIA = outputFormat.format(HORAINICIA);

        String horafin = hfin;
        Date HORAFIN = inputFormat.parse(horafin);
        String HFIN = outputFormat.format(HORAFIN);%>
    <div class="form-group" id="div2"> 
        <label for="Input" class="col-sm-6 control-label">AULA EN LA QUE SE DARÁ LA TUTORÍA</label>
        <label for="Input" class="col-md-3 control-label">HORA INICIO DE LA TUTORÍA:</label>
        <label for="Input" class="col-md-3 control-label">HORA FIN DE LA TUTORÍA:</label>
        <div class="col-md-6"> <input type="text" class="form-control" name="aula"  placeholder="Ingrese el Lugar" value="<%=Aula%>" readonly></input>
        </div>
    </div>
    <br><div class="form-inline">
        <div class="col-md-3">
            <input id = "1" type = "text" name="hinicia" class ="form-control input-small" value="<%=HINICIA%>" readonly>   
        </div>
    </div>
    <div class="col-md-3">
        <input id = "2" type = "text" name="hfin" class="form-control input-small" value="<%=HFIN%>" readonly>   
    </div>
</div>
<%  }%> 
<div class="container">
    <br><div class="alert alert-info" role="alert"><center>DATOS DEL REGISTRO</center></div>
    <h6>*DATOS GENERALES DEL REGISTRO DE LA TUTORÍA<span class="label label-default"></span></h6>
    <div class="form-group">
        <label for="Input" class="col-sm-12 control-label">OBSERVACIONES GENERALES</label><br>
        <div class="col-md-9">
            <input class="form-control" id="Input" type="text" name="observaciones" placeholder="TRAER MODELO DE BASE DE DATOS DE ACUERDO A SU PROYECTO" ><br>
        </div>
    </div>

    <% out.println("<div class=\"col-md-10\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action=ptutoriasdocentes.jsp';\" value=\"" + CodT + "\">Terminar</button></center></div>");%>
</div>
</form>
<div class="container">
    <div class="progress">
        <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:90%">
            90% de la Planificacion Completada
        </div>
    </div>
</div> 
</body>
<%  break;
    }
    co.close();
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
</head>
</html>