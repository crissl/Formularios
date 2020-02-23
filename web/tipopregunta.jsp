<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.models.TipoPreguntas"%>
<%@page import="espe.edu.ec.models.ParametrosBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tipo Pregunta</title>
    </head>
    <body>

        <%
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            String seleccion = request.getParameter("seleccion");
            String codigo = request.getParameter("codigo");
            int cod = Integer.parseInt(codigo);
            out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
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
            String currentUser = pidm;
            java.util.Date date = new java.util.Date();
            long t = date.getTime();
            java.sql.Date sqlDate = new java.sql.Date(t);
            try {
                PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTIPOPREGUNTAS (codigo_UZGTIPOPREGUNTAS,codigo_UZGTIPOPREGUNTAS_RESPUESTA,UZGTIPOPREGUNTAS_FECHA_CREA,UZGTIPOPREGUNTAS_USUA_CREA) VALUES (?,?,?,?)");
                ps.setInt(1, Integer.parseInt(codigo));
                ps.setString(2, seleccion);
                ps.setDate(3, sqlDate);
                ps.setString(4, pidm);
                ps.executeUpdate();
        %>
        <h1>FUNCIONO</h1>
        <%
            } catch (javax.xml.ws.WebServiceException ex) {
                out.println("No hay conexión con el webservice");
            } catch (Exception ex) {
                out.println(ex);
            }
            con.closeConexion();
        %>
    </body>
</html>
