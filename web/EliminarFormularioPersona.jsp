<%-- 
    Document   : EliminarFormularioPersona
    Created on : 26/09/2019, 19:29:34
    Author     : kencruga
--%>

<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    DB2 con = DB2.getInstancia();
    Connection co = con.getConnection();
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
    int PIDM = Integer.parseInt(pidm);
    if (ConstantesForm.admin.contains(PIDM) || ConstantesForm.helpDesk.contains(PIDM)) { %>
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
            try{
            int Codfp = 0;
            String NombreF = request.getParameter("codfp");
            if (NombreF != null) {
                Codfp = Integer.parseInt(NombreF);
                ResultSet rs = co.prepareStatement("delete from UTIC.UZGTRESPUESTAS WHERE CODIGO_UZGTFORMULARIOS_PERSONA='" + Codfp + "' ").executeQuery();
                co.prepareStatement("delete from UTIC.UZGTFORMULARIO_PERSONA WHERE CODIGO_UZGTFORMULARIOS_PERSONA='" + Codfp + "'").executeQuery();
                out.println("<meta http-equiv='refresh' content='1;URL=Test.jsp'>");//redirects after 4 seconds    
            
        %>
        <div class="container">
            
            <div class="text alert alert-success" style = "text-align: center;"><strong> 
                    <p> Formulario <%= Codfp%> Borrado Existosamente   
                    </p> </strong>
            </div>
        </div> 
        <%  } }catch(Exception e){
                    System.out.println("Error Borrar Formulario: "+e);
                    }%>
    </body>
</html>
<%
} else { %> 
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>No Autorizado</title>
    </head>
    <body>
        <%             try {
        %>
        <ul class="nav nav-tabs" role="tablist">
            <div class="col-md-4">Error! Usuario no autorizado</div>
        </ul>
        <%             } catch (Exception e) {
                System.out.println("error." + e.getMessage());
            }
        %>
    </body>
</html>
<%  }%>



