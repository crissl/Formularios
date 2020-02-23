<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="espe.edu.ec.models.Usuario"%> <!-- import de Usuario -->
<%@page session="true" %> <!-- Se agrega a modo de validacion -->
<!DOCTYPE html>
<%Cookie cookie = null;
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
    if (currentUser != null) { %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Nuevo Formulario</title>
    </head>
    <body>
	
        <% 
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            LinkedList<Formulario> listaF = new LinkedList<Formulario>();
            ResultSet rs = co.prepareStatement("SELECT * FROM UTIC.UZGTFORMULARIOS ORDER BY codigo_UZGTFORMULARIOS ASC").executeQuery();
            while(rs.next())
            {
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
            int cod =0;
            if(listaF.isEmpty()){
                cod=1;
            }else{
                cod = listaF.getLast().getCodigo_formulario()+1;
            }
            request.setCharacterEncoding("UTF-8");
            String nombreF= request.getParameter("nombre");            
            String descripcionF = request.getParameter("descripcion");
            String objetivoF = request.getParameter("objetivo");
            String Base = request.getParameter("seleccion");
            String tipoFormulario=request.getParameter("seleccionTipo");
            Date Fecha = new Date();
            java.sql.Date FechaSql = new java.sql.Date(Fecha.getYear(),Fecha.getMonth(),Fecha.getDate());
            try
            {
                PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTFORMULARIOS(codigo_UZGTFORMULARIOS,UZGTFORMULARIOS_nombre,UZGTFORMULARIOS_descripcion"
                        + ",UZGTFORMULARIOS_FECHA,UZGTFORMULARIOS_objetivo,UZGTFORMULARIOS_base_datos, UZGTFORMULARIOS_FECHA_INICIO, UZGTFORMULARIOS_FECHA_FIN, UZGTFORMULARIOS_ESTADO, UZGTFORMULARIOS_EO, UZGTFORMULARIOS_ESTADO_LLENADO,UZGTFORMULARIOS_FECHA_CREA,UZGTFORMULARIOS_USUA_CREA)"
                        + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)");
                ps.setInt(1, cod);
                ps.setString(2, nombreF);
                ps.setString(3, descripcionF);
                ps.setString(5, objetivoF);
                ps.setDate(4, FechaSql);
                ps.setString(6, Base);
                ps.setString(7, null);
                ps.setString(8, null);
                ps.setInt(9, 0);
                ps.setInt(10, 0);
                ps.setString(11, tipoFormulario);
                ps.setDate(12, FechaSql);
                ps.setString(13, pidm);
                ps.executeUpdate();      
        %>    
        <script type="text/javascript">
        window.location="Html/nuevoGrupo.html";
        </script>
        <%
            }
            catch (Exception ex)
            {
                out.println("error nuevo formulario : "+ex);
            }
           con.closeConexion();
    %>
    </body>
</html>
<% }
                   else{        
                  %>
                  
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

                    
                </form>
                
                
            </ul>
 <%             } catch (Exception e) {
                System.out.println("ERROR Nuevo Formulario: " + e);

        }
    %>
    </body>
</html>
                  
                  
                  
                  <% } %>
