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
    </head>

    <body>
        <%
            //conexion a la base de datos
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();

            //Obtencion de los valores de las Cookies
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
            String nomF = request.getParameter("Submit");
            int CodT = Integer.parseInt(nomF);
            String Cedula = request.getParameter("cedula");
            String Tema = request.getParameter("tema");
            String Optradio = request.getParameter("optradio");
            String Nrcd = request.getParameter("nrcd");
            String fecha = request.getParameter("fecha");
            String Email = request.getParameter("emaili");
            String par_emailp = request.getParameter("emailp");
            String Campus = request.getParameter("campus");

            //Funcion para convertir el formato de fecha a dd/MM/yyyy
            Date date = new Date();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            DateFormat originalFormat = new SimpleDateFormat("yyyy-MM-dd");
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
            switch (CodT) {
                case 1:
                    String stringd = Nrcd;
                    String[] partsd = stringd.split(" - ");
                    String nrcd = partsd[0]; // 123
                    String codasignaturad = partsd[1];
                    String asignaturad = partsd[2]; // 123
                    String campusd = partsd[3];
                    String periodod = partsd[4];


        %>
        <form action="2.jsp" method="POST">
            <div class="form-group" style="display: none"> 
                <input class="form-control" id="Input" name="emaili" type="text" value="<%=Email%>">
            </div>   

            <div class="form-group" style="display: none">
                <input class="form-control" id="Input" name="emailp" type="text" value="<%=par_emailp%>">
            </div> 
            <div class="container">
                <center><h3>PLANFICACIÓN DE TUTORÍA DE REFORZAMIENTO<span class="label label-default"></span></h3></center>
                <h6>*PLANFICACIÓN DE LA TUTORÍA DE REFORZAMIENTO ACADÉMICO<span class="label label-default"></span></h6>

                <div class="alert alert-info" role="alert"><center>DATOS  DEL TUTOR</center></div>
                <h6>DATOS GENERALES DEL TUTOR DE REFORZAMIENTO ACADÉMICO.<span class="label label-default"></span></h6>
                <div class="form-group">
                    <label for="Input" class="col-sm-3 control-label">CÉDULA DE IDENTIDAD</label>
                    <label for="Input" class="col-sm-5 control-label">APELLIDOS Y NOMBRES</label>
                    <label for="Input" class="col-sm-4 control-label">UNIDAD O DEPARTAMENTO EN QUE LABORA</label>
                    <div class="col-md-3">
                        <input class="form-control" id="Input" name="cedula" type="text" value="<%=Cedula%>" readonly><br>
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
            </div>
            <div class="container">
                <div class="alert alert-info" role="alert"><center>DATOS DE LA TUTORÍA</center></div>
                <div class="col-md-12">
                    <h6>*INGRESE LA INFORMACIÓN REFERENTE A LA TUORIA DE REFORZAMIENTO ACADÉMICO<span class="label label-default"></span></h6>
                </div>
                <br>
                <div class="form-group">
                    <label for="Input" class="col-sm-6 control-label">TEMA A TRATAR</label>
                    <label for="Input" class="col-sm-6 control-label">NRC QUE REQUIERE TUTORÍA</label>
                    <div class="col-md-6">
                        <input class="form-control" id="Input" name="tema" type="text" placeholder="BASES DE DATOS" value="<%=Tema%>" readonly><br>
                    </div>
                    <div class="col-md-6">
                        <select class="form-control" id="sel" name="nrcd" readonly>
                            <option>
                                <%=Nrcd%>
                            </option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="container">      
                <div class="form-group">
                    <label class="col-sm-3 control-label">A QUIÉN DARÁ LA TUTORÍA</label>
                    <label  class="col-sm-3 control-label">FECHA DE LA TUTORÍA</label>
                    <label for="Input" class="col-sm-6 control-label">AULA/LUGAR EN LA QUE SE DARÁ LA TUTORÍA</label>

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

                <div class="form-group">
                    <div class="col-md-6">
                        <input type="radio" name="opciones" value="aula" id="aula"> Aula 
                        <input type="radio" name="opciones" value="sitio" id="sitio"> Lugar
                    </div>
                </div></div><br>
            <div class="container">
                <div id="div1" style="display:none"> 
                    <label for="Input" class="col-sm-12 control-label">INGRESE EL LUGAR EN LA QUE SE DARÁ LA TUTORÍA</label>
                    <div class="col-md-6">
                        <input type="text" class="form-control" name="lugar"  placeholder="Ingrese el Lugar"><br>
                    </div>
                </div>
                <%  String campus1 = "01";
                    if (campusd.equalsIgnoreCase("12") || campusd.equalsIgnoreCase("20")) {
                        ResultSet rsAu = co.prepareStatement("SELECT DISTINCT SZARPGN_CAMPVAR3 ||' - '||SZARPGN_CAMPVAR4 AS AULA, SZARPGN_CAMPVAR7 ||' - '||SZARPGN_CAMPVAR8 AS HORARIO, SZARPGN_CAMPVAR7 AS HORA_INICIO, SZARPGN_CAMPVAR8 AS HORA_FIN FROM SATURN.SZARPGN, SLBRDEF WHERE SZARPGN_IDREPORT = 'AULAS_'|| '" + campus1 + "' AND SLBRDEF_BLDG_CODE = SZARPGN_CAMPVAR3 AND SLBRDEF_ROOM_NUMBER = SZARPGN_CAMPVAR4 AND SLBRDEF_RMST_CODE = 'AC' AND SLBRDEF_ROOM_TYPE = 'C' AND " + dia + " IS NOT NULL ORDER BY 3,4,1").executeQuery(); %>
                <div id="div2" style="display:none" disabled>
                    <label for="Input" class="col-sm-12 control-label">SELECIONE EL AULA Y EL HORARIO EN LA QUE SE DARÁ LA TUTORÍA</label>
                    <div class="col-md-4">
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
                    ResultSet rsAu = co.prepareStatement("SELECT DISTINCT SZARPGN_CAMPVAR3 ||' - '||SZARPGN_CAMPVAR4 AS AULA, SZARPGN_CAMPVAR7 ||' - '||SZARPGN_CAMPVAR8 AS HORARIO, SZARPGN_CAMPVAR7 AS HORA_INICIO, SZARPGN_CAMPVAR8 AS HORA_FIN FROM SATURN.SZARPGN, SLBRDEF WHERE SZARPGN_IDREPORT = 'AULAS_'|| '01' AND SLBRDEF_BLDG_CODE = SZARPGN_CAMPVAR3 AND SLBRDEF_ROOM_NUMBER = SZARPGN_CAMPVAR4 AND SLBRDEF_RMST_CODE = 'AC' AND SLBRDEF_ROOM_TYPE = 'C' AND " + dia + " IS NOT NULL ORDER BY 3,4,1").executeQuery(); %>
                <div id="div2" style="display:none" disabled>
                    <label for="Input" class="col-sm-12 control-label">SELECIONE EL AULA Y EL HORARIO EN LA QUE SE DARÁ LA TUTORÍA</label>
                    <div class="col-md-4">
                        <select class="form-control"  name="aula"id="Input">
                            <option selected="selected" value="">Seleccione el Aula y el Horario</option>

                            <% while (rsAu.next()) {%>
                            <option >
                                <% out.print(rsAu.getString("AULA") + " - " + rsAu.getString("HORA_INICIO") + " - " + rsAu.getString("HORA_FIN"));
                                    }
                                    rsAu.close();%></option>
                        </select><br>
                    </div>
                </div>
                <%}
                    out.println("<div class=\"col-md-12\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action=2.jsp';\" value=\"" + CodT + "\">Siguiente</button></center></div>"); %>
            </div>
        </form>
        <div class="container">
            <div class="progress">
                <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="70" aria-valuemin="50" aria-valuemax="100" style="width:60%">
                    60% DE LA PLANIFICACIÓN DE REFORZAMINETO COMPLETADA
                </div>
            </div>
        </div> 
        <%break;
            case 2:
                break;
            case 3:
                String stringc = Campus;
                String[] partsdc = stringc.split(" - ");
                String ccampus = partsdc[0]; // 123
                String nombrec = partsdc[1];
        %>
        <form action="2.jsp" method="POST">
            <div class="form-group" style="display: none"> 
                <input class="form-control" id="Input" name="emaili" type="text" value="<%=Email%>">
            </div>   
        </div>
        <div class="form-group" style="display: none">
            <input class="form-control" id="Input" name="emailp" type="text" value="<%=par_emailp%>">
        </div> 

        <div class="container">
            <center><h3><b class="text-success">PLANIFICACIÓN DE TUTORÍA DE ACOMPAÑAMIENTO</b><span class="label label-default text-success"></span></h3></center>
            <h6>*PLANFICACIÓN DE LA TUTORÍA DE ACOMPAÑAMIENTO ACADÉMICO<span class="label label-default"></span></h6>
            <div class="alert alert-info" role="alert"><center>DATOS DEL TUTOR</center></div>
            <h6>DATOS GENERALES DEL TUTOR DE REFORZAMIENTO ACADÉMICO<span class="label label-default"></span></h6>
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
                        rs4.close();%>" readonly>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="alert alert-info" role="alert"><center>DATOS DE LA TUTORÍA</center></div>
            <div class="col-md-12">
                <h6>*INGRESE LA INFORMACIÓN REFERENTE A LA TUTORIA DE ACOMPAÑAMIENTO ACADÉMICO<span class="label label-default"></span></h6>
            </div>
            <div class="form-group">
                <label for="Input" class="col-sm-6 control-label">TEMA A TRATAR</label>
                <label for="Input" class="col-sm-3 control-label">FECHA DE LA TUTORÍA</label>
                <label class="col-sm-3 control-label">A QUIÉN DARÁ LA TUTORÍA</label>
            </div>
            <div class="col-md-6">
                <input class="form-control" id="Input" name="tema" type="text" placeholder="BASES DE DATOS" value="<%=Tema%>" readonly>
            </div>
            <div class="col-sm-3">
                <input class="form-control" id="Input" type="date" name="fecha" value="<%=fecha%>" readonly>
            </div>
            <div classd="col-md-3">
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
        </div> <br>
        <div class="container">
            <div class="form-group">
                <label for="Input" class="col-sm-7 control-label">AULA/LUGAR EN LA QUE SE DARÁ LA TUTORÍA</label>
            </div>
            <div class="col-sm-7">
                <input type="radio" name="opciones" value="aula" id="aula"> Aula 
                <input type="radio" name="opciones" value="sitio" id="sitio"> Lugar 
            </div>
            <div id="div1" style="display:none"> 
                <label for="Input" class="col-sm-12 control-label">INGRESE EL LUGAR EN LA QUE SE DARÁ LA TUTORÍA</label>
                <div class="col-md-5">
                    <input type="text" class="form-control" name="lugar"  placeholder="Ingrese el Lugar"></input>
                </div>
            </div>

            <%
                ResultSet rsAu5 = co.prepareStatement("SELECT DISTINCT SZARPGN_CAMPVAR3 ||' - '||SZARPGN_CAMPVAR4 AS AULA,\n"
                        + " SZARPGN_CAMPVAR7 ||' - '||SZARPGN_CAMPVAR8 AS HORARIO,\n"
                        + "SZARPGN_CAMPVAR7 AS HORA_INICIO,\n"
                        + "SZARPGN_CAMPVAR8 AS HORA_FIN\n"
                        + "FROM SATURN.SZARPGN, SLBRDEF WHERE "
                        + "SZARPGN_IDREPORT = 'AULAS_'||'" + ccampus + "' \n"
                        + "AND SLBRDEF_BLDG_CODE = SZARPGN_CAMPVAR3\n"
                        + "AND SLBRDEF_ROOM_NUMBER = SZARPGN_CAMPVAR4\n"
                        + "AND SLBRDEF_RMST_CODE = 'AC' AND SLBRDEF_ROOM_TYPE = 'C'\n"
                        + "AND '" + dia + "'\n"
                        + "IS NOT NULL ORDER BY 3,4,1").executeQuery();
            %>
            <div id="div2" style="display:none" disabled>
                <label for="Input" class="col-sm-12 control-label">SELECIONE EL AULA Y EL HORARIO EN LA QUE SE DARÁ LA TUTORÍA</label>
                <div class="col-md-4">
                    <select class="form-control"  name="aula"id="Input">
                        <option selected="selected" value="">Seleccione el Aula y el Horario</option>
                        <% while (rsAu5.next()) {%>
                        <option>
                            <% out.print(rsAu5.getString("AULA") + " - " + rsAu5.getString("HORA_INICIO") + " - " + rsAu5.getString("HORA_FIN"));
                                }
                                rsAu5.close();%></option>
                    </select>
                </div>
            </div>



            <div class="form-group"  style="display: none;">
                <label for="Input" class="col-sm-12 control-label">FECHA DE REGISTRO</label>
                <div class="col-md-3">
                    <input class="form-control" name="fecharegistro" id="Input" type="date" value="<%=dateFormat.format(date)%>" readonly ><br>
                </div>
            </div>


            <% out.println("<div class=\"col-md-12\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action=2.jsp';\" value=\"" + CodT + "\">Siguiente</button></center></div>"); %>
        </div>
    </form>
    <div class="container">
        <div class="progress">
            <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:60%">
                60% de la Planificacion Completada
            </div>
        </div>
    </div> 
</body>
<%break;
    }
    co.close();
    con.closeConexion();
%> 



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
    });
</script> 
</html>