<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="java.sql.SQLException"%>
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
        <div class="row bg-default">
            <div class="col-md-8"><center><h1>Formularios Genericos</h1></center></div>
            <div class="col-md-2"></div>
        </div>
        <ul class="nav nav-tabs" role="tablist">         
            <li role="presentation"><a href="pregunta.jsp">Nueva Pregunta</a></li>
        </ul>
        <form action="listavalores.jsp" method="POST">
            <div class="row">
                <div class="col-md-6">                
                    <h1>Servidor origen</h1>
                    <table class = "table table-condensed">
                        <textarea name="query" rows="5" cols="180" class="panel-body" placeholder="Ingrese el query de búsqueda"></textarea>
                        <tr>
                            <td><button class="btn btn-default" type="submit" name="Submit" value="ejecutar">Ejecutar</button></td>
                        </tr>
                    </table>
                </div>
                <%                    try {
                        DB2 con = DB2.getInstancia();
                        Connection co = con.getConnection();
                        LinkedList<String> listaO = new LinkedList<String>();
                        //String tabla=request.getParameter("tabla");
                        //String columna=request.getParameter("columna");
                        String sql = request.getParameter("query");
                        ResultSet result = co.prepareStatement(sql).executeQuery();
                        while (result.next()) {
                            listaO.add(result.getString(1));
                        }
                        result.close();
                        con.closeConexion();
                    } catch (SQLException e) {
                        System.out.print("error" + e.getMessage());
                    }
                %>
            </div>
        </form>
        <%             } catch (Exception e) {
                System.out.println("ERROR Lista Datos: " + e);
            }
        %>
    </body>
</html>