package espe.edu.ec.constant;
import java.util.ArrayList;
public class ConstantesForm {
//  Archivos y rutas CSS
    public static final String Css = "<link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css\"\n"
            + "  integrity=\"sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu\" crossorigin=\"anonymous\">\n"
            + "<link rel=\"stylesheet\" href=\"https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap.min.css\">\n"
            + "<link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap-theme.min.css\"\n"
            + "  integrity=\"sha384-6pzBo3FDv/PJ8r2KRkGHifhEocL+1X2rVCTTkUfGk7/0pbek5mMa1upzvWbrUbOZ\" crossorigin=\"anonymous\">\n"
            + "<link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.7.0/css/all.css'\n"
            + "  integrity='sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ' crossorigin='anonymous'>\n"
            + "<link rel=\"stylesheet\" href=\"css/style.css\">";
    //  + "<link type=\"text/css\" href=\"css/bootstrap-timepicker.min.css\" />";
//  Archivos y rutas JavaScript
    public static final String js = "<script src=\"https://code.jquery.com/jquery-3.3.1.js\"></script>\n"
            + "<script src=\"https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js\"></script>\n"
            + "<script src=\"https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap.min.js\"></script>\n"
            + "<script src=\"https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js\"\n"
            + "  integrity=\"sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd\"\n"
            + "  crossorigin=\"anonymous\"></script>\n"
            + "<script src=\"js/dataoracle.js\"></script>\n"
            + "<script> $(document).ready(function(){ $( '[data-toggle=\"tooltip\"]').tooltip();}); </script>"
            + "<script type=\"text/javascript\">\n"
            + "jQuery(document).ready(function($) {\n"
            + "    $.post('https://www.silversites.es/wp-admin/admin-ajax.php', {action: 'mts_view_count', id: '248'});\n"
            + "});\n"
            + "</script>";  //381643
    public static int pidmUser = 2401;//2401;//luis 334571----- estudiante-//303921----anita//287393---//Administrador prueba 2401
    public static String id = "L00001826"; //"L000384902";//"L0001826";//"L00290697";   //366498

    public static ArrayList<Integer> admin = new ArrayList<Integer>() {
        {
            add(7683); // Ing. Anita Torres
            add(334571); // Ing. Luis Rocha
            add(2401); // Ing. Monica Pullas
            add(12646); //Ing. NELLY CEVALLOS
        }
    };
    //admin Integer[] pidmsAdministrador  = {7683, 334571, 2401, 12646, 294223};
    // } else if (PIDM == 12649 || PIDM == 385472 || PIDM == 14266 || PIDM == 12653 || PIDM == 294223 || PIDM == 385472) {       //if (isValid(user)) {
    public static ArrayList<Integer> helpDesk = new ArrayList<Integer>() {
        {
            add(12649); //CULANATA LUCIA
            add(385472); //RAMOS P AUL
            add(14266); //ACOSTA MARIA DEL CARMEN
            add(12646); // NELLY CEVALLOS
            add(12653); // CHRISTIAN HIDALGO
            add(69474); // GUALOTUÑA HUGO
            add(14274); // PICHUCHO EFREN
            add(12628); // PEÑAFIEL JHONNY
            add(294223); // CALLE KLEVER
        }
    };

}
//7395 Docente
