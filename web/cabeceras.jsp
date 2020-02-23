<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.models.Matriz"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
        %>
    </head>
    <body>
        <%
            try {
        %> 
        <div class="container">
            <nav class="navbar navbar-default" role="tablist">
                <div class="container-fluid">
                    <!-- Brand and toggle get grouped for better mobile display -->
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                                data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand"><b>Valores de Cabeceras</b> </a>
                    </div>
                    <!-- Collect the nav links, forms, and other content for toggling -->
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">

                    </div><!-- /.navbar-collapse -->
                </div><!-- /.container-fluid -->
            </nav>
        </div>
        <%      request.setCharacterEncoding("UTF-8");
                DB2 con = DB2.getInstancia();
                Connection co = con.getConnection();
                String codigoTP = request.getParameter("tipo");
                LinkedList<Matriz> ListaMatriz = new LinkedList<Matriz>();
                LinkedList<Integer> ListaCabeceras = new LinkedList<Integer>();
                ResultSet rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTMATRIZ ORDER BY codigo_UZGTMATRIZ ASC").executeQuery();
                while (rs2.next()) {
                    Matriz Mat = new Matriz(rs2.getInt(1), rs2.getInt(2), rs2.getInt(3), rs2.getInt(4), rs2.getInt(5), rs2.getInt(6), rs2.getString(7));
                    ListaMatriz.add(Mat);
                }
                rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTCABECERAS ORDER BY codigo_UZGTCABEZERA ASC").executeQuery();
                while (rs2.next()) {
                    int Cab = rs2.getInt(1);
                    ListaCabeceras.add(Cab);
                }
                rs2.close();
                out.println("<form action=\"nuevacabecera.jsp\" method=\"POST\">");
                out.println("<div class=\"row\">");
                out.println("<div class=\"col-md-5\"></div>");
                out.println("<div class=\"col-md-3\"><h4>Item columna</h4></div>");
                out.println("</div>");
                for (int i = 0; i < ListaMatriz.getLast().getColumna(); i++) {
                    String cabecera = "V";
                    out.println("<p></p><div class=\"row\">");
                    out.println("<div class=\"col-md-5\"></div>");
                    out.println("<div class=\"col-md-3\"><input class=\"form-control\" type=\"text\" name='" + cabecera + i + "' required/  placeholder='" + cabecera + i + "'></div>");
                    out.println("<div class=\"col-md-4\"></div>");
                    out.println("</div>");
                }
                out.println("<p></p><div class=\"row\">");
                out.println("<div class=\"col-md-5\"></div>");
                out.println("<div class=\"col-md-3\"><h4>Item fila</h4></div>");
                out.println("</div>");
                for (int i = 0; i < ListaMatriz.getLast().getFila(); i++) {
                    String cabecera = "H";
                    out.println("<p></p><div class=\"row\">");
                    out.println("<div class=\"col-md-5\"></div>");
                    out.println("<div class=\"col-md-3\"><input class=\"form-control\" type=\"text\" name='" + cabecera + i + "' required/ placeholder='" + cabecera + i + "'> </div>");
                    out.println("</div>");
                }
                out.println("<p></p><div class=\"row\">");
                out.println("<div class=\"col-md-5\"></div>");
                out.println("<div class=\"col-md-3\"><button class=\"btn btn-success\" type=\"submit\" name=\"Submit\" value=\"guardar\"><strong>Aceptar</strong></button></div>");
                out.println("</div>");
                out.println("</form>");
                con.closeConexion();
            } catch (Exception e) {
                System.out.println("ERROR Cabeceras: " + e);
            }
        %>
    </body>
</html>