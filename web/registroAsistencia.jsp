<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.css" />
        <title>Confirmacion de Haber recibido tutoria</title>
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

            int CodT = 4;
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
                    <a class="navbar-brand"><b>REGISTRO ASISTENCIA</b> </a>
                </div>
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">

                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#"><b>Tutorias</b>
                                <span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="planificacioReforzamiento.jsp"><i class="	glyphicon glyphicon-file">&nbsp</i>Planificación de tutoria de Reforzamiento</a></li>
                                <li><a href="planificacionAcompanamiento.jsp"><i class="glyphicon glyphicon-user">&nbsp</i>Planificación de Tutoria Acompañamiento</a></li>                         

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
    <form action="registroA.jsp" method="POST">
        <% switch (CodT) {
                case 4:
                    ResultSet rsT = co.prepareStatement("SELECT * FROM UTIC.UZTPLANIF WHERE  SPRIDEN_PIDM='" + pidm + "' AND UZTPLANIF_TITOTUTORIA='ACOMPAÑAMIENTO' AND CODIGO_UZGTFORMULARIOS=3 AND UZTPLANIF_ESTADO='A' ORDER BY CODIGO_UZTPLANIF ASC").executeQuery();%>

        <br><div class="form-group">
            <label for="Input" class="col-md-offset-3 col-md-6 text-success"><b>SELECCIONE LA TUTORIA DE ACOMPAÑAMIENTO A REGISTRAR</b></label><br>
            <div class="col-md-offset-3 col-md-6">
                <select class="form-control" id="sel" name="nrcdr">
                    <%while (rsT.next()) {
                    %>
                    <option>
                        <%out.print(rsT.getString("CODIGO_UZTPLANIF") + " - " + rsT.getString("UZTPLANIF_TEMA"));
                            }
                            rsT.close();%>
                    </option>
                </select>
                <br>
            </div>
        </div> 
        <%out.println("<div class=\"col-md-12\"><center><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" onclick=\"this.form.action=registroA.jsp';\" value=\"" + CodT + "\">Siguiente</button></center></div>");
                    break;
                case 6:

                    break;
            }
            co.close();
            con.closeConexion();
        %>



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