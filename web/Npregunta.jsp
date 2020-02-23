<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="espe.edu.ec.models.datoComun"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.awt.List"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.TipoPreguntas"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <hea
        d>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pregunta</title>
        <%  out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            String nombreg = request.getParameter("codg");
            int codgf = Integer.parseInt(nombreg);
            String NombreF = request.getParameter("Submit");
            int Cod = Integer.parseInt(NombreF);
            LinkedList<TipoPreguntas> listaTP = new LinkedList<TipoPreguntas>();
            LinkedList<datoComun> listaDC = new LinkedList<datoComun>();
            ResultSet rs = co.prepareStatement("SELECT * FROM UTIC.UZGTIPOPREGUNTAS ORDER BY codigo_UZGTIPOPREGUNTAS").executeQuery();
            while (rs.next()) {
                TipoPreguntas TP = new TipoPreguntas();
                TP.setCodigo_tipopregunta(rs.getInt(1));
                TP.setNombre_tipopregunta(rs.getString(2));
                listaTP.add(TP);
            }
            rs.close();
            ResultSet rs1 = co.prepareStatement("SELECT * FROM UTIC.UZGTDATOSCOMUNES ORDER BY codigo_UZGTDATOSCOMUNES").executeQuery();
            while (rs1.next()) {
                datoComun DC = new datoComun();
                DC.setEtiqueta(rs1.getString(2));
                DC.setQuery(rs1.getString(3));
                listaDC.add(DC);
            }
            rs1.close();
            con.closeConexion();

        %>
    </head>
    <body>

        <%             try {

        %>


        <p></p>
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
                        <a class="navbar-brand"><b>Nuevo Formulario</b> </a>
                    </div>
                    <!-- Collect the nav links, forms, and other content for toggling -->
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav">
                            <li role="presentation">
                                <a href="Html/nuevoGrupo.html">
                                    <i class="fas fa-calendar-plus"></i>&nbsp<strong>Nuevo Grupo</strong></a>
                            </li>
                        </ul>
                        <ul class="nav navbar-nav">
                            <li role="presentation">
                                <a href="mostrarFormulario.jsp">
                                    <i class="fas fa-check"></i>&nbsp<strong>Finalizar Formulario</strong></a>
                            </li>
                        </ul>

                    </div><!-- /.navbar-collapse -->
                </div><!-- /.container-fluid -->
            </nav>


            <form action="nuevaPregrunta_M.jsp" method="POST">          
                <div>
                    <div class="row">
                        <div class="col-md-3"></div>
                        <div class="col-md-3"><h4>Pregunta: </h4></div>
                        <div class="col-md-3"><center><input id="pregunta" type="text" name="pregunta" class="form-control" placeholder="pregunta" required/></center></div>
                    </div>
                    <div class="row">
                        <div class="col-md-3"></div>
                        <div class="col-md-3"><h4>Pregunta Vigente: </h4></div>
                        <div class="col-md-3"><center><select type = "text" name="vigente" class="form-control" required>
                                    <option selected>S</option>
                                    <option>N</option>
                                </select></center>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3"></div>
                        <div class="col-md-3"><h4>Tipo de Ingreso: </h4></div>
                        <div class="col-md-3"><center><select type = "text" name="vigente" class="form-control" required>
                                    <option selected>NINGUNO</option>
                                    <option>UPPERCASE</option>
                                    <option>LOWERCASE</option>
                                </select></center>
                        </div>
                    </div>            
                    <div class="row">
                        <div class="col-md-3"></div>
                        <div class="col-md-3"><h4>Tipo Pregunta: </h4></div>
                        <div class="col-md-3"><center><select type = "text" id="tipo" name="tipo" onchange="yesnoCheck(this);" class="form-control" required>
                                    <%                        for (int i = 0; i < listaTP.size(); i++) {

                                            out.println("<option>" + listaTP.get(i).getNombre_tipopregunta() + "</option>");
                                        }
                                    %>
                                </select></center>
                        </div>
                        <div id="ifYes" style="display: none;">
                            <div class="col-md-3"><center><select type = "text" id="etiqueta" name="etiqueta"  class="form-control" required>
                                        <%
                                            for (int i = 0; i < listaDC.size(); i++) {

                                                out.println("<option>" + listaDC.get(i).getEtiqueta() + "</option>");
                                            }
                                        %>
                                    </select></center>
                            </div>                
                        </div>
                    </div>
                    <div style="display: none">
                        <input name="codg" value="<%=codgf%>" >
                    </div> 
                    <div class="col-md-3"></div>
                    <div class="col-md-3"><center><button class="btn btn-success" type="submit" name="Submit" value="<%=Cod%>" >Aceptar</button></center></div>
                </div>
        </div>
        <h1>asasdasd<%=codgf%></h1>
        </form>
        <%             } catch (Exception e) {
                System.out.println("ERROR Pregunta: " + e);
            }
        %>
        </div>
    </body>
    <script>
        function yesnoCheck(that) {
            if (that.value == "DATOS COMUNES") {

                document.getElementById("ifYes").style.display = "block";
            } else {
                document.getElementById("ifYes").style.display = "none";
            }
        }
    </script>
</html>
