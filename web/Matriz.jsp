<%@page import="espe.edu.ec.constant.ConstantesForm"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>        
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <%      out.println(ConstantesForm.Css);
            out.println(ConstantesForm.js);
        %>
        <script>
            function genMatrices(fil, col) {
                                c = new String();
                                e = document.getElementById('Matriz');
                                c += '<table name"tblMatriz" id="tblMatriz" border=1>';
                                c += '<tr>';
                    
                                c += '<td align="center" valing="middle">';
                                c += '<table name="tblMtz">';
                                for (i = 0; i <= fil; i++) {
                                        c += '<tr>';
                                        for (j = 0; j <= col; j++) {
                                                c += '<td><input type="text" name=' + i + j + ' id=' + i + j + ' size="30" maxlength="30" placeholder=' + i + j + '></td>';
                                        }
                                        c += '</tr>';
                                }
                                c += '</table>';
                                c += '</td>';
                                e.innerHTML = c;     
                        }
        </script>
    </head>
    <body>
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
                        <a class="navbar-brand"><b>Generador de matriz</b> </a>
                    </div>
                    <!-- Collect the nav links, forms, and other content for toggling -->
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav">
                            <li role="presentation">
                                <a href="pregunta.jsp">
                                    <i class="fas fa-calendar-plus"></i>&nbsp<strong>Nueva pregunata</strong></a>
                            </li>
                        </ul>
                    </div><!-- /.navbar-collapse -->
                </div><!-- /.container-fluid -->
            </nav>
            <form action="nuevaMatriz.jsp" name="frmArreglo" id="frmArreglo">
                <hr/>
                <h2 align="center"><strong><h3 class="text-success">DESCRIPCION MATRIZ</h3></strong></h2>
                <table align="center" border="2">
                    <tr>
                        <td>
                            <table>
                                <tr>
                                <div class="col-md-6"><h5>Descripcion de la Matriz: </h5></div>
                                <div class="col-md-6"><center><input class="form-control" id="descripcion" type="text" name="descripcion" class="form-control" placeholder="DESCRIPCION MATRIZ" required/></center></div>
                    </tr>
                </table></td>
                </tr>
                </table>
                <h2 align="center"><strong><h3 class="text-success">INGRESO DE MATRICES</h3></strong></h2>
                <table align="center" border="3">
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td align="center" colspan="4"><b>MATRIZ A GENERAR</b></td>
                                </tr>
                                <tr>
                                    <td><strong>Filas:</strong></td><td>
                                        <div class="col-md-8"><center><input class="form-control" id="filas" type="number" name="filas" class="form-control-label" placeholder="numero de filas" required/></center></div>
                                        </div>
                                    </td>
                                    <td><strong>Columnas:</strong></td><td>
                                        <div class="col-md-10"><center><input class="form-control" id="columnas" type="number" name="columnas" class="form-control-label" placeholder="numero de columnas" required/></center></div>
                                        </div>
                                    </td>
                                </tr>
                            </table></td>
                    </tr>
                </table>
                <br />
                <div align="center">
                    <button class="btn btn-success" type="submit" name="Submit" value="guardar"><strong>Aceptar</strong></button>
                </div>
                <br/>
                <div id="Matriz">
                </div>
            </form>
        </div>
    </body>
</html>
