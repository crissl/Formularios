<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Confirmación de Haber recibido tutoria</title>
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
            int CodT = 6;
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

            Date date = new Date();
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String tutoria = request.getParameter("nrcdr");

            ResultSet rs = co.prepareStatement("SELECT SPBPERS_SSN FROM SPBPERS WHERE SPBPERS_PIDM ='" + pidm + "'").executeQuery();
            while (rs.next()) {
        %>
    </head>
    <body>
        <div class="container">
            <center><h3>CONFIRMACIÓN DE HABER RECIBIDO LA TUTORÍA DE ACOMPAÑAMIENTO<span class="label label-default"></span></h3></center>
            <h6>*CONFIRMACIÓN POR PARTE DEL ESTUDIANTE, LUEGO DE HABER ASISTIDO A LA TUTORÍA DE ACOMPAÑAMIENTO ACADÉMICO<span class="label label-default"></span></h6>
            <form action="/ptutorias.jsp" method="POST">
                <div class="alert alert-info" role="alert"><center>DATOS DEL ESTUDIANTE</center></div>
                <h6>DATOS GENERALES DEL ESTUDIANTE<span class="label label-default"></span></h6>
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
                    <div class="col-md-4">
                        <input class="form-control" id="Input" name="carreraest" type="text" value="<%out.print(rs2.getNString("SMRPRLE_PROGRAM_DESC"));
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
    <h6>*DATOS GENERALES DEL REGISTRO DE LA TUTORÍA<span class="label label-default"></span></h6>
    <div class="form-group">
        <label class="col-sm-12 control-label">RECIBIÓ LA TUTORÍA</label><br>
        <div class="col-md-12">
            <div class="radio">
                <label><input type="radio" name="optradio" value="S" checked>SI</label>
            </div>
            <div class="radio">
                <label><input type="radio" name="optradio" value="N"> NO</label>
            </div>
        </div>
    </div>
    <div class="form-group">
        <label for="Input" class="col-sm-6 control-label">COMENTARIOS DE LA TUTORÍA</label><br>
        <div class="col-md-12">
            <input class="form-control" id="Input" name="comentariot" type="text" placeholder="ME QUEDO CLARO TODO EL PROCESO" ><br>
        </div>
    </div>
</div>
<div class="container">
    <br><div class="alert alert-info" role="alert"><center>DATOS DEL REGISTRO</center></div>
    <h6>*DATOS GENERALES DEL REGISTRO DE LA TUTORÍA<span class="label label-default"></span></h6>
    <div class="form-group">
        <label for="Input" class="col-sm-6 control-label">OBSERVACIONES GENERALES</label><br>
        <div class="col-md-12">
            <input class="form-control" name="observaciones" id="Input" type="text" placeholder="GRACIAS AL TUTOR" ><br>
        </div>
    </div>
    <div class="form-group">
        <label for="Input" class="col-sm-12 control-label">FECHA DE REGISTRO</label><br>
        <div class="col-md-3">
            <input class="form-control" id="Input" name="fecharegistro" type="date" value="<%=dateFormat.format(date)%>" readonly <br>
        </div>
    </div>
</div>
<div class="form-control" style="display:none ">
    <input name="ncrdc" value="<%=tutoria%>">
</div>
<br>
<div class="container">
    <% out.println("<div class=\"col-md-10\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action='ptutorias.jsp';\" value=\"" + CodT + "\">Enviar</button></center></div>");%>
</div>
</form>
</div>
</body>
</html>
