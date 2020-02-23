<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<!DOCTYPE html>
<html>
    <head>      
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.css" />
        <title>Confirmacion de Haber recibido tutoria</title>
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
            int CodT = 4;
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            Cookie cookie = null;
            Cookie[] cookies = null;
            int pidm = 0;
            cookies = request.getCookies();
            if (cookies != null) {
                for (int i = 0; i < cookies.length; i++) {
                    cookie = cookies[i];
                    if (cookie.getName().equals("pidm")) {
                        pidm = Integer.valueOf(cookie.getValue());
                    }
                }
            } else {
                out.println("<h2>No cookies founds</h2>");
            }
            if (pidm != 0 && pidm == ConstantesForm.pidmUser) {
                pidm = ConstantesForm.pidmUser;
            }
            Date date = new Date();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String Nrcdr = request.getParameter("nrcdr");

            String stringdr = Nrcdr;
            String[] partsdr = stringdr.split(" - ");
            String codr = partsdr[0]; // 123
            String temar = partsdr[1];

            ResultSet rs = co.prepareStatement("SELECT SPBPERS_SSN FROM SPBPERS WHERE SPBPERS_PIDM ='" + pidm + "'").executeQuery();
            while (rs.next()) {
        %>
    </head>
    <body>
        <form action="4.jsp" method="POST">
            <div class="container">
                <center><h3>REGISTRO DE EJECUCIÓN DE LA TUTORÍA DE ACOMPAÑAMIENTO<span class="label label-default"></span></h3></center>
                <h6>*ESTE FORMULARIO SERÁ UTILIZADO PARA REGISTRAR LA TUTORÍA POR PARTE DEL DOCENTE<span class="label label-success"></span></h6>
                <div class="alert alert-info" role="alert"><center>DATOS DEL ESTUDIANTE</center></div>
                <h6>*DATOS DEL TUTOR<span class="label label-success"></span></h6>
                <div class="form-group">
                    <label for="Input" class="col-sm-3 control-label">APELLIDOS Y NOMBRES</label>
                    <label for="Input" class="col-sm-5 control-label">CÉDULA DE IDENTIDAD</label>
                    <label for="Input" class="col-sm-4 control-label">UNIDAD O DEPARTAMENTO EN QUE LABORA</label>
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
        <h6>*INGRESE LOS DATOS CON LA INFORMACIÓN DE LA TUTORÍA <span class="label label-default" ></span></h6>
        <div class="form-group">
            <label for="Input" class="col-sm-6 control-label">TEMA TRATADO</label><br>
            <div class="col-md-12">
                <input class="form-control" name="tematratado" id="Input" type="text" value="<%=temar%>"readonly ><br>
            </div>
            <label for="Input" class="col-sm-6 control-label">RESULTADOS OBTENIDOS</label><br>
            <div class="col-md-12">
                <input class="form-control" name="resultados" id="Input" type="text" placeholder="ESTUDIANTES ENTENDIERON PUNTOS IMPORTANTES DEL REGLAMENTO" required><br>
            </div>
            <% ResultSet rs5 = co.prepareStatement("SELECT * FROM UTIC.UZTPLANIF WHERE CODIGO_UZTPLANIF='" + codr + "' ").executeQuery();
                while (rs5.next()) {
            %>
            <div class="form-group">
                <label for="Input" class="col-sm-6 control-label">FECHA DE LA TUTORÍA</label><br>
                <div class="col-md-12">
                    <input class="form-control" name="fechatutoria" id="Input" type="text" value=" <%out.print(rs5.getString("UZTPLANIF_FECHATUTORIA"));
                        }
                        rs5.close();
                           %>" readonly><br>
                </div>
            </div>
            <div class="form-inline">
                <label for="Input" class="col-md-2 control-label">HORA INICIO DE LA TUTORÍA:</label><br>
                <div class="col-md-3">
                    <input id = "timepicker1" type = "text" name="hinicia" class = "form-control input-small" readonly>   
                </div>
            </div>
            <label for="Input" class="col-md-2 control-label">HORA FIN DE LA TUTORÍA:</label><br>
            <div class="col-md-3">
                <input id = "timepicker2" type = "text" name="hfin" class="form-control input-small" readonly>   
            </div>
        </div>
    </div>

    <div class="container">
        <br><div class="alert alert-info" role="alert"><center>LISTADO DE ESTUDIANTES</center></div>
        <h6>*REGISTRO DEL ID O CÉDULA DE LOS ESTUDIANTES QUE ASISTIERON A LA TUTORÍA<span class="label label-default"></span></h6>
        <div class="form-group">
            <label for="Input" class="col-sm-6 control-label">ID O CÉDULA DELOS ESTUDIANTES</label><br>
            <table class="table">
                <thead>
                    <tr>
                        <td class="text-center"><b>PIDM</b></td>
                        <td class="text-center"><b>ID</b></td>
                        <td class="text-center"><b>ESTUDIANTES</b></td>
                        <td class="text-center"><b>EMAIL</b></td>
                        <td class="text-center"><b>CÉDULA</b></td>
                        <td class="text-center"><b>PRESENTES</b></td>
                    <tr>
                </thead>
                <tbody>
                    <%   PreparedStatement st;
                        ResultSet ts;
                        st = co.prepareStatement("SELECT * FROM UTIC.UZTASISTENTES WHERE CODIGO_UZTPLANIF ='" + codr + "'  AND CODIGO_UZGTFORMULARIOS =3");
                        ts = st.executeQuery();
                        int count = 0;
                        //      Formularios_Connection con = F
                        while (ts.next()) {
                    %> 
                    <tr>
                        <td class="text-center"><%= ts.getInt("SPRIDEN_PIDM")%> </td>
                        <td class="text-center"><%= ts.getString("UZTASISTENTES_ID")%> </td>
                        <td class="text-center"><%= ts.getString("UZTASISTENTES_ESTUDIANTE")%> </td>
                        <td class="text-center"><%= ts.getString("UZTASISTENTES_EMAIL")%> </td>
                        <td class="text-center"><%= ts.getString("UZTASISTENTES_CEDULA")%> </td>
                        <td> <label class="radio-inline">
                                <input type="radio" name="optradio_<%=count%>" value="S" checked required>SI
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="optradio_<%=count%>" value="N" checked required>NO
                            </label>
                        </td>
                    </tr>
                    <%
                            count++;
                        }
                        ts.close();%> 


                </tbody>
            </table> 
        </div>
    </div>
    <div class="form-control" style="display:none">
        <input name="var" value="<%=count%>">
    </div>
    <div class="container">
        <br><div class="alert alert-info" role="alert"><center>DATOS DEL REGISTRO</center></div>
        <h6>*DATOS GENERALES DEL REGISTRO DE LA TUTORÍA<span class="label label-default"></span></h6>
        <div class="form-group">
            <label for="Input" name="observaciones"class="col-sm-6 control-label">OBSERVACIONES GENERALES</label>
            <label for="Input" class="col-sm-6 control-label">FECHA DEL REGISTRO DE LA PLANIFICACIÓN DE LA TUTORÍA</label>

            <div class="col-md-6">
                <input class="form-control" name="observaciones" id="Input" type="text" placeholder="ASISTIERON TODOS LOS ESTUDIANTES DE ACOMPAÑAMIENTO ACADEMICO" ><br>
            </div>
        </div>
        <div class="form-group">
            <div class="col-md-3">
                <input class="form-control" name="fecharegistro" id="Input" type="date" value="<%=dateFormat.format(date)%>" readonly><br>
            </div>
        </div>
    </div>
    <div class="form-control" style="display: none">
        <input type="text" name="nrcdr" value="<%=Nrcdr%>"> 
    </div>
    <br>
    <div class="container">
        <% out.println("<div class=\"col-md-12\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action='4.jsp';\" value=\"" + CodT + "\">Guardar</button></center></div>");%>
    </div>
</form>
</div>
</body>
<% co.close();
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
