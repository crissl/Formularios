<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.Formulario"%>
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
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            LinkedList<Formulario> listaF = new LinkedList<Formulario>();
            ResultSet rs = co.prepareStatement("SELECT * FROM UTIC.UZGTFORMULARIOS ORDER BY codigo_UZGTFORMULARIOS ASC").executeQuery();
            while (rs.next()) {
                Formulario F = new Formulario();
                F.setCodigo_formulario(rs.getInt(1));
                F.setNombre_formulario(rs.getString(2));
                F.setDescripcion_formulario(rs.getString(3));
                F.setFecha_formulario(rs.getDate(4));
                F.setObjetivo_formulario(rs.getString(5));
                F.setBase_formulario(rs.getString(6));
                listaF.add(F);
            }
            rs.close();
        %>
    </head>
    <body>
        <%
            try {
        %> 
        <div class="row bg-default">
            <div class="col-md-8"><center><h1>Formularios</h1></center></div>
            <div class="col-md-2"></div>
        </div>
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" ><a href="nuevoFormulario.html">Nuevo Formulario</a></li>
            <li role="presentation"><a href="mostrarFormulario.jsp">Gestión Formulario</a></li>
            <li role="presentation"><a href="mostrarRespuesta.jsp">Mostrar Respuestas</a></li>
            <li role="presentation"><a href="index.jsp">Volver</a></li>
        </ul>
        <div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-6"><h4>Seleccione el formulario a eliminar: </h4></div>
            <div class="col-md-3"></div>
        </div>
        <%                        for (int i = 0; i < listaF.size(); i++) {
                    String cod = "";
                    out.println("<form action=\"eliminar.jsp\" method=\"POST\" target=\"_self\">");
                    out.println("<div class=\"row\">");
                    out.println("<div class=\"col-md-1\"></div>");
                    out.println("<div class=\"col-md-2\"><center><p id=\"cod\">" + listaF.get(i).getCodigo_formulario() + "</p></center></div>");
                    out.println("<div class=\"col-md-6\"><p name=\"nombre\">" + listaF.get(i).getNombre_formulario() + "</p></div>");
                    out.println("<div class=\"col-md-3\"><button class=\"btn btn-default\" type=\"text\" name=\"Submit\" value='" + cod + listaF.get(i).getCodigo_formulario() + "'>Eliminar</button></div>");
                    out.println("</div></form>");
                }
                con.closeConexion();
            } catch (Exception e) {
                System.out.println("ERROR Eliminar Formulario: " + e);
            }
        %>
    </body>
</html>