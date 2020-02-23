<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.util.ArrayList"%>
<%@page import="espe.edu.ec.models.Grupo"%>
<%@page import="java.util.List"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.models.ParametrosBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Nuevo Grupo</title>
    </head>
    <body>
        <%             try {
                DB2 con = DB2.getInstancia();
                Connection co = con.getConnection();
                java.util.Date date = new java.util.Date();
                long t = date.getTime();
                java.sql.Date sqlDate = new java.sql.Date(t);
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
                LinkedList<Formulario> listaF = new LinkedList<Formulario>();
                LinkedList<Grupo> listaG = new LinkedList<Grupo>();
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
                ResultSet rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTGRUPO ORDER BY codigo_UZGTGRUPO ASC").executeQuery();
                while (rs2.next()) {
                    Grupo G = new Grupo();
                    G.setCodigo_formulario(rs2.getInt(1));
                    G.setCodigo_grupo(rs2.getInt(2));
                    G.setNombre_grupo(rs2.getString(3));
                    G.setDescripcion_grupo(rs2.getString(4));

                    listaG.add(G);
                }
                rs2.close();
                request.setCharacterEncoding("UTF-8");
                String nombreG = request.getParameter("nombre");
                String descripcionG = request.getParameter("descripcion");
                int cod = listaF.getLast().getCodigo_formulario();
                int codg = 0;
                if (listaG.isEmpty()) {
                    codg = 1;
                } else {
                    codg = listaG.getLast().getCodigo_grupo() + 1;
                }
                try {
                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTGRUPO (codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,UZGTGRUPO_nombre,UZGTGRUPO_descripcion,UZGTGRUPO_FECHA_CREA,UZGTGRUPO_USUA_CREA)"
                            + " VALUES (?,?,?,?,?,?)");
                    ps.setInt(1, cod);
                    ps.setInt(2, codg);
                    ps.setString(3, nombreG);
                    ps.setString(4, descripcionG);
                    ps.setDate(5, sqlDate);
                    ps.setString(6, pidm);
                    ps.executeUpdate();
                    ps.close();
        %>    
        <script type="text/javascript">
            window.location = "pregunta.jsp";
        </script>
        <%
            } catch (Exception ex) {
                out.println(ex);
            }
            con.closeConexion();
        %>
        <%             } catch (Exception e) {
                System.out.println("error nuevo Grupo" + e);
            }
        %>
</html>
