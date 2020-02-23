<%@page import="java.sql.SQLException"%>
<%@page import="espe.edu.ec.connection.DB2"%>
<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="espe.edu.ec.models.Formulario"%>
<%@page import="java.sql.Connection"%>
<%@page import="espe.edu.ec.models.Usuario"%> <!-- import de Usuario -->
<%@page session="true" %> <!-- Se agrega a modo de validacion -->
<!DOCTYPE html>
<% DB2 con = DB2.getInstancia();
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

    int PIDM = Integer.parseInt(pidm);%>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">

<div class="container-fluid">
   <!-- --------------------------------Fin Navbar superior-------------------------------------------  -->
    <title>Mostrar-Formularios</title>
    <%
        out.println(ConstantesForm.Css);
        out.println(ConstantesForm.js);
    %>
</head>
<body>

    <%=pidm%>
    <%

      //ResultSet rs = co.prepareStatement("delete from UTIC.UZTPLANIF").executeQuery(); 
      //ResultSet rs1 = co.prepareStatement("delete from UTIC.UZTASISTENTES").executeQuery(); 

        /*  try{
              String sql1 = "INSERT INTO UTIC.UZTASISTENTES(UZTASISTENTES_CODIGO,CODIGO_UZTPLANIF,CODIGO_UZGTFORMULARIOS,UZTASISTENTES_ITERACION,SPRIDEN_PIDM,UZTASISTENTES_FECHATUTORIA,UZTASISTENTES_FECHAREGISTRO,UZTASISTENTES_ASISTESN,UZTASISTENTES_COMENTARIO,UZTASISTENTES_OBSERVACION,UZTASISTENTES_USUA_CREA,UZTASISTENTES_ESTADO,UZTASISTENTES_ID,UZTASISTENTES_ESTUDIANTE,UZTASISTENTES_EMAIL,UZTASISTENTES_CEDULA)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                           PreparedStatement ps1 = co.prepareStatement(sql1);
                           ps1.setInt(1, 2);
                           ps1.setInt(2, 1);
                           ps1.setInt(3, 1);
                           ps1.setInt(4, 0);
                           ps1.setInt(5, 2401);  //cambiar string a int// x prueba
                           ps1.setString(6, "15/11/2019");
                           ps1.setString(7, "");
                           ps1.setString(8, "");
                           ps1.setString(9, "");
                           ps1.setString(10, "");
                           ps1.setString(11, pidm);
                           ps1.setString(12, "A");
                           ps1.setString(13, "L00043");
                           ps1.setString(14, "PRUEBA");
                           ps1.setString(15, "PRUEBA");
                           ps1.setString(16, "PRUEBA");
                           ps1.executeUpdate();
                       System.out.println(" insertado correctamente formulario: 3"); */%>
    <% //   } catch (SQLException e) {
                //System.out.println("Error insertar tutoria FORMULARIO 3: " + e); %>
    <%  //}    %>
       <%
            ResultSet rsT = co.prepareStatement("SELECT * FROM UTIC.UZTASISTENTES a, UTIC.UZTPLANIF p WHERE  a.CODIGO_UZTPLANIF=p.CODIGO_UZTPLANIF AND a.SPRIDEN_PIDM= '" + pidm + "' AND a.CODIGO_UZGTFORMULARIOS=3 AND UZTASISTENTES_ESTADO='A' ORDER BY p.CODIGO_UZTPLANIF ASC").executeQuery();%>
        <div class="form-group">
            <H1><label for="Input" class="col-md-offset-3 col-md-6 control-label text-success panel panel-success"><center>TUTORIA DE CONFIRMACIÓN</center></label><br></H1>
            <label for="Input" class="col-md-offset-3 col-md-6 control-label"><center>SELECIONE LA TUTORIA DE ACOMPAÑAMIENTO A CONFIRMAR </center></label><br>
            <div class="col-md-6">
                <select class="col-md-offset-6 col-md-3 form-control" id="sel" name="nrcdr">
                    <%while (rsT.next()) {
                    %>
                    <option>
                        <%out.print(rsT.getString("CODIGO_UZTPLANIF") + " - " + rsT.getString("UZTPLANIF_TEMA") + " - " + rsT.getString("UZTASISTENTES_CODIGO"));
                            }
                            rsT.close();%>
                    </option>
                </select>

            </div>
    
    <br><div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-3"></div>
    </div>
<center> <div class= "col-3 .col-md-7">
        <table id="example" class="table table-striped table-bordered" >
            <thead>
                <tr >
                    <th class="text-center">CODIGO P</th>
                    <th class="text-center">CODIGO F</th>
                    <th class="text-center">ITERACION</th>
                    <th class="text-center">FECHAR</th>
                    <th class="text-center">TIPOP</th>
                    <th class="text-center">TIPOT</th>
                    <th class="text-center">PIDM</th>
                    <th class="text-center">TEMA</th>
                    <th class="text-center">PUBLICO</th>
                    <th class="text-center">NRC</th>
                    <th class="text-center">COD_ASIGNA</th>
                    <th class="text-center">ASIGNATURA</th>
                    <th class="text-center">PERIODO</th>
                    <th class="text-center">NIVEL</th>
                    <th class="text-center">AULA</th>
                    <th class="text-center">FECHAT</th>
                    <th class="text-center">HORAI</th>
                    <th class="text-center">HORAF</th>
                    <th class="text-center">OBSERVACION</th>
                    <th class="text-center">ESTADO</th>
                    <th class="text-center">CAMPUS CODE</th>
                </tr>
            </thead>
            <tbody>
                <%
                    PreparedStatement st;
                    ResultSet ts;
                    st = co.prepareStatement("SELECT * FROM UTIC.UZTPLANIF ORDER BY CODIGO_UZTPLANIF ASC");
                    ts = st.executeQuery();
                    //      Formularios_Connection con = F
                    while (ts.next()) {
                %>
                <tr>
                    <td class="text-center"><%= ts.getInt("CODIGO_UZTPLANIF")%> </td>
                    <td class="text-center"><%= ts.getInt("CODIGO_UZGTFORMULARIOS")%> </td>
                    <td class="text-center"><%= ts.getInt("UZGTRESPUESTAS_ITERACION")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_FECHAFORM")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_TIPOPERSONA")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_TITOTUTORIA")%> </td>
                    <td class="text-center"><%= ts.getInt("SPRIDEN_PIDM")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_TEMA")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_PUBLICO")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_NRC")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_CODIGO_ASIGNATURA")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_ASIGNATURA")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_PERIODO")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_NIVEL")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_AULA")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_FECHATUTORIA")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_HORAINICIO")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_HORAFIN")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_OBSERVACION")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_ESTADO")%> </td>
                    <td class="text-center"><%= ts.getDate("UZTPLANIF_FECHA_CREA")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_USUA_CREA")%> </td>
                    <td class="text-center"><%= ts.getDate("UZTPLANIF_FECHA_MODIF")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_USUA_MODIF")%> </td>
                    <td class="text-center"><%= ts.getString("UZTPLANIF_CAMP_CODE")%> </td>
                </tr>
                <% }
                    ts.close();
                %> 
                </tbody>
        </table>
    </div>
</center>
</div>
<div class="container-fluid">
    <table class="table table-condensed" >
        <thead>
            <tr >
                <th class="text-center">CODIGO A</th>
                <th class="text-center">CODIGO P</th>
                <th class="text-center">CODIGO F</th>
                <th class="text-center">ITERACION</th>
                <th class="text-center">PIDM</th>
                <th class="text-center">FECHAT</th>
                <th class="text-center">FECHAR</th>
                <th class="text-center">ASISTENTESN</th>
                <th class="text-center">COMENTARIO</th>
                <th class="text-center">OBSERVACION</th>
                <th class="text-center">FECHAC</th>
                <th class="text-center">USUAC</th>
                <th class="text-center">FECHAM</th>
                <th class="text-center">USUAM</th>
                <th class="text-center">ESTADO</th>
                <th class="text-center">ID</th>
                <th class="text-center">ESTUDIANTE</th>
                <th class="text-center">EMAIL</th>
                <th class="text-center">CEDULA</th>
                <th class="text-center">CONDIRMACION</th>
            </tr>
        </thead>
        <tbody>
            <%
                PreparedStatement st1;
                ResultSet ts1;
                st1 = co.prepareStatement("SELECT * FROM UTIC.UZTASISTENTES ORDER BY UZTASISTENTES_CODIGO ASC");
                ts1 = st1.executeQuery();
                //      Formularios_Connection con = F
                while (ts1.next()) {
                    String cod = "";

            %>
        <form action="" method="POST" target="_self" id="mr" style="display:inline;">
            <tr>
                <td class="text-center"><%= ts1.getInt("UZTASISTENTES_CODIGO")%> </td>
                <td class="text-center"><%= ts1.getInt("CODIGO_UZTPLANIF")%> </td>
                <td class="text-center"><%= ts1.getInt("CODIGO_UZGTFORMULARIOS")%> </td>
                <td class="text-center"><%= ts1.getInt("UZTASISTENTES_ITERACION")%> </td>
                <td class="text-center"><%= ts1.getInt("SPRIDEN_PIDM")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_FECHATUTORIA")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_FECHAREGISTRO")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_ASISTESN")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_COMENTARIO")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_OBSERVACION")%> </td>
                <td class="text-center"><%= ts1.getDate("UZTASISTENTES_FECHA_CREA")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_USUA_CREA")%> </td>
                <td class="text-center"><%= ts1.getDate("UZTASISTENTES_FECHA_MODIF")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_USUA_MODIF")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_ESTADO")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_ID")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_ESTUDIANTE")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_EMAIL")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_CEDULA")%> </td>
                <td class="text-center"><%= ts1.getString("UZTASISTENTES_CONFIRMACION")%> </td>
            </tr>
            <% }
                ts1.close();
                co.close();
                con.closeConexion();
            %> 


            </tbody>
    </table>

</div>

</body>
</html>