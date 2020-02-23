/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package espe.edu.ec.util;

import espe.edu.ec.connection.DB2;
import espe.edu.ec.models.Cabecera;
import espe.edu.ec.models.FormPersona;
import espe.edu.ec.models.Formulario;
import espe.edu.ec.models.Grupo;
import espe.edu.ec.models.Matriz;
import espe.edu.ec.models.Preguntas;
import espe.edu.ec.models.Respuestas;
import espe.edu.ec.models.TipoPreguntas;
import espe.edu.ec.models.Valores;
import java.io.IOException;
import java.io.InputStream;
import static java.lang.System.out;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.LinkedList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.ResultSet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Part;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;

@WebServlet("/uploadServlet")
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB

public class FileUpload extends HttpServlet {

    private final static Logger LOGGER = Logger.getLogger("bitacora.subnivel.Control");

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        String message = "";
        try {
            DB2 con = DB2.getInstancia();
            Connection co = con.getConnection();
            LOGGER.log(Level.INFO, "conexion" + co);
            java.util.Date date = new java.util.Date();
            long t = date.getTime();
            java.sql.Date sqlDate = new java.sql.Date(t);
            LinkedList<Formulario> listaF = new LinkedList<Formulario>();
            LinkedList<Grupo> listaG = new LinkedList<Grupo>();
            LinkedList<Preguntas> listaP = new LinkedList<Preguntas>();
            LinkedList<TipoPreguntas> listaTP = new LinkedList<TipoPreguntas>();
            LinkedList<Valores> listaV = new LinkedList<Valores>();
            LinkedList<Respuestas> listaR = new LinkedList<Respuestas>();
            LinkedList<FormPersona> listaFP = new LinkedList<FormPersona>();
            LinkedList<FormPersona> listaFP1 = new LinkedList<FormPersona>();

            int usPidm = Integer.parseInt(request.getParameter("param"));
            LOGGER.log(Level.INFO, "uspidm: " + usPidm);
            int codFP = 0;
            int codFP1 = 0;
            String NombreF = request.getParameter("Submit");
            int Cod = Integer.parseInt(NombreF);
            LOGGER.log(Level.INFO, "Cod: " + Cod);
            try {
                ResultSet rs = co.prepareStatement("SELECT * FROM UTIC.UZGTFORMULARIOS WHERE codigo_UZGTFORMULARIOS = '" + Cod + "'").executeQuery();
                while (rs.next()) {
                    Formulario F = new Formulario();
                    F.setCodigo_formulario(rs.getInt(1));
                    F.setNombre_formulario(rs.getString(2));
                    F.setDescripcion_formulario(rs.getString(3));
                    F.setFecha_formulario(rs.getDate(4));
                    F.setObjetivo_formulario(rs.getString(5));
                    F.setBase_formulario(rs.getString(6));
                    F.setEstadoLlenado(rs.getString(11));
                    listaF.add(F);
                }
                LOGGER.log(Level.INFO, "rs1: " + listaF.getFirst().getCodigo_formulario());
                rs.close();
                rs = co.prepareStatement("SELECT * FROM UTIC.UZGTGRUPO WHERE codigo_UZGTFORMULARIOS = '" + Cod + "' order by codigo_UZGTGRUPO ASC").executeQuery();
                while (rs.next()) {
                    Grupo G = new Grupo();
                    G.setCodigo_formulario(rs.getInt(1));
                    G.setCodigo_grupo(rs.getInt(2));
                    G.setNombre_grupo(rs.getString(3));
                    G.setDescripcion_grupo(rs.getString(4));
                    listaG.add(G);
                }
                LOGGER.log(Level.INFO, "rs1: " + listaG);
                rs.close();
                rs = co.prepareStatement("SELECT * FROM UTIC.UZGTPREGUNTAS WHERE codigo_UZGTFORMULARIOS = '" + Cod + "' order by codigo_UZGTPREGUNTAS ASC").executeQuery();
                while (rs.next()) {
                    Preguntas P = new Preguntas();
                    P.setCodigo_formulario(rs.getInt(1));
                    P.setCodigo_grupo(rs.getInt(2));
                    P.setCodigo_preguntas(rs.getInt(3));
                    P.setCodigo_tipo_pregunta(rs.getInt(7));
                    P.setLabel_pregunta(rs.getString(8));
                    listaP.add(P);
                }
                LOGGER.log(Level.INFO, "rs1: " + listaP);
                rs.close();
                rs = co.prepareStatement("SELECT * FROM UTIC.UZGTVALORES WHERE codigo_UZGTFORMULARIOS = '" + Cod + "' order by codigo_UZGTVALORES ASC").executeQuery();
                while (rs.next()) {
                    Valores Val = new Valores();
                    Val.setCodigo_Valores(rs.getInt(1));
                    Val.setCodig_Formularios(rs.getInt(2));
                    Val.setCodigo_Grupo(rs.getInt(3));
                    Val.setCodigo_Preguntas(rs.getInt(4));
                    Val.setValores(rs.getString(5));
                    listaV.add(Val);
                }
                LOGGER.log(Level.INFO, "rs1: " + listaV);
                rs.close();
                rs = co.prepareStatement("SELECT * FROM UTIC.UZGTRESPUESTAS WHERE codigo_UZGTFORMULARIOS = '" + Cod + "' AND SPRIDEN_PIDM=" + usPidm + " order by codigo_UZGTRESPUESTAS ASC").executeQuery();
                while (rs.next()) {
                    Respuestas res = new Respuestas();
                    res.setPidm_usuario(usPidm);
                    res.setCodigo_persona(rs.getInt(2));
                    res.setCodigo_formulario(rs.getInt(3));
                    res.setCodigo_grupo(rs.getInt(4));
                    res.setCodigo_preguntas(rs.getInt(5));
                    res.setCodigo_Respuestas(rs.getInt(6));
                    res.setValor_Respuestas(rs.getString(7));
                    res.setIteracionRespuesta(rs.getInt(9));
                    res.setFecha_crea(rs.getDate(10));
                    res.setUsua_crea(rs.getString(11));
                    listaR.add(res);
                }
                LOGGER.log(Level.INFO, "rs1: " + listaR);
                rs.close();
                co.close();
                co = con.getConnection();
                //SELECT DEL CODIGO FORMULARIO_PERSONA
                String estadoLL = null;
                ResultSet rs1 = co.prepareStatement("SELECT CODIGO_UZGTFORMULARIOS_PERSONA,UZGTFORMULARIOS_ESTADO_LLENADO FROM UTIC.UZGTFORMULARIO_PERSONA WHERE codigo_UZGTFORMULARIOS= '" + Cod + "' AND SPRIDEN_PIDM='" + usPidm + "' ").executeQuery();
                while (rs1.next()) {
                    FormPersona fp = new FormPersona();
                    fp.setCodFormP(rs1.getInt(1));
                    fp.setEstadoLlenado(rs1.getString(2));
                    codFP = rs1.getInt(1);
                    estadoLL = rs1.getString(2);
                    listaFP.add(fp);
                }
                LOGGER.log(Level.WARN, "listaFP: " + listaFP);
                rs1.close();
                rs1.clearWarnings();

                ResultSet rs2 = co.prepareStatement("SELECT CODIGO_UZGTFORMULARIOS_PERSONA,UZGTFORMULARIOS_ESTADO_LLENADO FROM UTIC.UZGTFORMULARIO_PERSONA WHERE codigo_UZGTFORMULARIOS= '" + Cod + "' AND SPRIDEN_PIDM='" + usPidm + "' AND UZGTFORMULARIOS_ESTADO_LLENADO='N'  ").executeQuery();
                while (rs2.next()) {
                    FormPersona fp1 = new FormPersona();
                    fp1.setCodFormP(rs2.getInt(1));
                    fp1.setEstadoLlenado(rs2.getString(2));
                    codFP1 = rs2.getInt(1);
                    estadoLL = rs2.getString(2);
                    listaFP1.add(fp1);
                }
                LOGGER.log(Level.WARN, "listaFP: " + listaFP);
                rs1.close();
                rs1.clearWarnings();

            } catch (Exception e) {
                System.out.println("Error rs1: " + e);
            }
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //System.out.println("pasa selects");
            /////////////////////////////////////////////////////////////////////////////////////
            request.setCharacterEncoding("UTF-8");

            int codR;
            if (listaR.isEmpty()) {
                codR = 1;
            } else {
                codR = listaR.getLast().getCodigo_Respuestas() + 1;
            }
            LOGGER.log(Level.INFO, "listaFP: " + listaFP);
            LOGGER.log(Level.INFO, "listaFP: " + listaFP1);
            LOGGER.log(Level.INFO, "CodR: " + codR);
            request.setCharacterEncoding("UTF-8");
            int numT = 0;
            int numR = 0;
            int numC = 0;
            int numL = 0;
            int numFech = 0;//num fecha
            int numN = 0;
            int numA = 0;
            int codPre;
            int numM = 0;
            int numDC = 0;
            int contRM = 0;
            int contC = 0;
            /*FORMULARIOS NO MODIFICABLES*/
            //ingreso respuestas
            ///grupo
            //  JOptionPane.showMessageDialog(null, "Tipo: "+listaF.getFirst().getTipoFormulario());
            /*FORMULARIOS NO MODIFICABLES*/
            if (listaF.getFirst().getEstadoLlenado().equals("N") && listaFP1.getFirst().getEstadoLlenado().equals("N")) {
                try {
                    for (int i = 0; i < listaG.size(); i++) {
                        ////////////////////////////////////////////////////////////////////////////////////
                        //////////////////////RESPUESTAS/////////////////////////////////////////////////////
                        for (int j = 0; j < listaP.size(); j++) {
                            if (listaP.get(j).getCodigo_grupo() == listaG.get(i).getCodigo_grupo()) {
                                /*RESPUESTAS DATOS COMUNES*/
                                if (listaP.get(j).getCodigo_tipo_pregunta() == 9) {
                                    try {
                                        numDC++;
                                        String num = "text" + numDC;
                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM,codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS,codigo_UZGTRESPUESTAS,UZGTRESPUESTAS_valor,UZGTRESPUESTAS_ITERACION,UZGTRESPUESTAS_FECHA_CREA,UZGTRESPUESTAS_USUA_CREA)"
                                                + " VALUES (?,?,?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP1.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, request.getParameter(num));
                                        ps.setInt(8, 0);
                                        ps.setDate(9, sqlDate);
                                        ps.setString(10, Integer.toString(usPidm));
                                        codR++;
                                        LOGGER.log(Level.INFO, "CodR9++: " + codR++);
                                        ps.executeUpdate();
                                    } catch (Exception ex) {
                                        System.out.println("Error 9: " + ex);
                                        LOGGER.log(Level.INFO, "error9 " + ex);
                                    }
                                }/*FIN IF DATO COMUNES*/
                                if (listaP.get(j).getCodigo_tipo_pregunta() == 1) {
                                    try {
                                        numT++;
                                        String num = "valor" + numT;
                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion,UZGTRESPUESTAS_FECHA_CREA,UZGTRESPUESTAS_USUA_CREA)"
                                                + " VALUES (?,?,?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP1.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, request.getParameter(num));
                                        ps.setInt(8, 0);
                                        ps.setDate(9, sqlDate);
                                        ps.setString(10, Integer.toString(usPidm));
                                        codR++;
                                        ps.executeUpdate();
                                        LOGGER.log(Level.INFO, "CodR1++: " + codR++);
                                    } catch (Exception ex) {
                                        System.out.println("Error 1: " + ex);

                                        LOGGER.log(Level.INFO, "error1 " + ex);
                                    }
                                }
                                /////////////////////////////////////////////////////////////////////////////////////////////
                                ////////////////////CHECKBOX/////////////////////////////////////////////////////////////////
                                ////////////////////////////////////////////////////////////////////////////////////////////
                                if (listaP.get(j).getCodigo_tipo_pregunta() == 2) {
                                    numC++;
                                    String[] select = request.getParameterValues("seleccion" + numC);
                                    for (String tempSelect : select) {
                                        try {
                                            PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion,UZGTRESPUESTAS_FECHA_CREA,UZGTRESPUESTAS_USUA_CREA)"
                                                    + " VALUES (?,?,?,?,?,?,?,?,?,?)");
                                            ps.setInt(1, usPidm);
                                            ps.setInt(2, listaFP1.getFirst().getCodFormP());
                                            ps.setInt(3, Cod);
                                            ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                            ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                            ps.setInt(6, codR);
                                            ps.setString(7, tempSelect);
                                            ps.setInt(8, 0);
                                            ps.setDate(9, sqlDate);
                                            ps.setString(10, Integer.toString(usPidm));
                                            //codPre++;//sube codigo pregunta
                                            codR++;
                                            ps.executeUpdate();
                                            LOGGER.log(Level.INFO, "CodR2++: " + codR++);
                                        } catch (Exception ex) {
                                            System.out.println("Error 2: " + ex);

                                            LOGGER.log(Level.INFO, "error2 " + ex);
                                        }
                                    }
                                }
                                ////////////////////////////////////////////////////////////////////////////
                                //////////////////RADIO////////////////////////////////////////////////////
                                ///////////////////////////////////////////////////////////////////////////
                                if (listaP.get(j).getCodigo_tipo_pregunta() == 3) {
                                    numR++;
                                    String[] selecte = request.getParameterValues("radio" + numR);
                                    for (String tempSelecte : selecte) {
                                        try {
                                            PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion,UZGTRESPUESTAS_FECHA_CREA,UZGTRESPUESTAS_USUA_CREA)"
                                                    + " VALUES (?,?,?,?,?,?,?,?,?,?)");
                                            ps.setInt(1, usPidm);
                                            ps.setInt(2, listaFP1.getFirst().getCodFormP());
                                            ps.setInt(3, Cod);
                                            ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                            ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                            ps.setInt(6, codR);
                                            ps.setString(7, tempSelecte);
                                            ps.setInt(8, 0);
                                            ps.setDate(9, sqlDate);
                                            ps.setString(10, Integer.toString(usPidm));
                                            codR++;
                                            ps.executeUpdate();
                                            //numR++;
                                            LOGGER.log(Level.INFO, "CodR3++: " + codR++);
                                        } catch (Exception ex) {
                                            System.out.println("Error 3: " + ex);

                                            LOGGER.log(Level.INFO, "error3 " + ex);
                                        }
                                    }
                                }
                                ///////////////////////////////////////////////////////////////////////
                                /////////////////////////////COMBO BOX////////////////////////////////
                                ///////////////////////////////////////////////////////////////////////
                                if (listaP.get(j).getCodigo_tipo_pregunta() == 5) {
                                    numL++;
                                    String[] selecte = request.getParameterValues("lista" + numL);
                                    for (String tempSelecte : selecte) {
                                        try {
                                            PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion,UZGTRESPUESTAS_FECHA_CREA,UZGTRESPUESTAS_USUA_CREA)"
                                                    + " VALUES (?,?,?,?,?,?,?,?,?,?)");
                                            ps.setInt(1, usPidm);
                                            ps.setInt(2, listaFP1.getFirst().getCodFormP());
                                            ps.setInt(3, Cod);
                                            ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                            ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                            ps.setInt(6, codR);
                                            ps.setString(7, tempSelecte);
                                            ps.setInt(8, 0);
                                            ps.setDate(9, sqlDate);
                                            ps.setString(10, Integer.toString(usPidm));
                                            codR++;
                                            ps.executeUpdate();
                                            //numR++;
                                            LOGGER.log(Level.INFO, "CodR5++: " + tempSelecte);
                                            System.out.println("CodR5 5: " + tempSelecte);
                                        } catch (Exception ex) {
                                            System.out.println("Error 5: " + ex);
                                            LOGGER.log(Level.INFO, "error5 " + ex);
                                        }
                                    }
                                }
                                ///////////////////////////////////////
                                //ARCHIVOS
                                if (listaP.get(j).getCodigo_tipo_pregunta() == 6) {
                                    try {
                                        numA++;
                                        InputStream inputStream = null; // input stream of the upload file
                                        // obtains the upload file part in this multipart request
                                        Part filePart = request.getPart("archivo" + numA);
                                        String nombre = request.getParameter("fileN");
                                        if (filePart != null) {
                                            LOGGER.log(Level.INFO, "fgetName() " + filePart.getName());
                                            LOGGER.log(Level.INFO, "fgetSize() " + filePart.getSize());
                                            LOGGER.log(Level.INFO, "fgetContentType() " + filePart.getContentType());
                                            // obtains input stream of the upload file
                                            inputStream = filePart.getInputStream();
                                        }
                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTARCHIVO_valor, uzgtrespuestas_iteracion, uzgtmime,UZGTRESPUESTAS_FECHA_CREA,UZGTRESPUESTAS_USUA_CREA)"
                                                + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP1.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, nombre);
                                        //ps.setString(7, filePart.getSubmittedFileName());
                                        ps.setBlob(8, filePart.getInputStream(), filePart.getSize());
                                        ps.setInt(9, 0);
                                        ps.setString(10, filePart.getContentType());
                                        ps.setDate(11, sqlDate);
                                        ps.setString(12, Integer.toString(usPidm));
                                        codR++;
                                        ps.executeUpdate();
                                        LOGGER.log(Level.INFO, "CodR6++: " + codR++);
                                    } catch (Exception ex) {
                                        System.out.println("Error 6: " + ex);

                                        LOGGER.log(Level.INFO, "error6 " + ex);
                                    }
                                }//fin ciclo numerico
                                /////////////////////////////////////////////////////////////////////////
                                /////////////////////FECHA GUARDAR///////////////////////////////////////
                                /////////////////////////////////////////////////////////////////////////
                                if (listaP.get(j).getCodigo_tipo_pregunta() == 7) {
                                    try {
                                        numFech++;
                                        String num = "fechaInicio" + numFech;
                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion,UZGTRESPUESTAS_FECHA_CREA,UZGTRESPUESTAS_USUA_CREA)"
                                                + " VALUES (?,?,?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP1.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, request.getParameter(num + ""));
                                        ps.setInt(8, 0);
                                        ps.setDate(9, sqlDate);
                                        ps.setString(10, Integer.toString(usPidm));
                                        codR++;
                                        ps.executeUpdate();
                                        LOGGER.log(Level.INFO, "CodR7++: " + num);
                                        System.out.println("CodR7 7: " + num);

                                    } catch (Exception ex) {
                                        System.out.println("Error 7: " + ex);

                                        LOGGER.log(Level.INFO, "error7 " + ex);
                                    }
                                }//fin ciclo fecha
                                ////////////////////////////////////////////////////////////////////
                                //////////////////////////////TIPO NUMERICO/////////////////////////
                                ////////////////////////////////////////////////////////////////////
                                if (listaP.get(j).getCodigo_tipo_pregunta() == 8) {
                                    try {
                                        numN++;
                                        String num = "num" + numN;
                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion,UZGTRESPUESTAS_FECHA_CREA,UZGTRESPUESTAS_USUA_CREA)"
                                                + " VALUES (?,?,?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP1.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, request.getParameter(num + ""));
                                        ps.setInt(8, 0);
                                        ps.setDate(9, sqlDate);
                                        ps.setString(10, Integer.toString(usPidm));
                                        codR++;
                                        ps.executeUpdate();
                                        LOGGER.log(Level.INFO, "CodR78++: " + codR++);
                                    } catch (Exception ex) {
                                        System.out.println("Error 8: " + ex);

                                        LOGGER.log(Level.INFO, "error8 " + ex);
                                    }
                                }
/////////////////////////////////////////MATRIZ
                                if (listaP.get(j).getCodigo_tipo_pregunta() == 4) {
                                    numM++;
                                    //contador++ ;
                                    ResultSet rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTMATRIZ WHERE codigo_UZGTPREGUNTAS = '" + listaP.get(j).getCodigo_preguntas() + "'order by codigo_uzgtmatriz ASC").executeQuery();
                                    LinkedList<Matriz> ListaMatriz = new LinkedList<Matriz>();
                                    LinkedList<Cabecera> ListaCabeceras = new LinkedList<Cabecera>();
                                    while (rs2.next()) {
                                        Matriz Mat = new Matriz(rs2.getInt(1), rs2.getInt(2), rs2.getInt(3), rs2.getInt(4), rs2.getInt(5), rs2.getInt(6), rs2.getString(7));
                                        ListaMatriz.add(Mat);
                                    }
                                    rs2.close();
                                    int mat = ListaMatriz.getFirst().getCodigo_matriz();
                                    int filas = ListaMatriz.getFirst().getFila() + 1;
                                    int columnas = ListaMatriz.getFirst().getColumna() + 1;
                                    ResultSet rs3 = co.prepareStatement("SELECT * FROM UTIC.UZGTCABECERAS WHERE codigo_UZGTMATRIZ = '" + mat + "' order by codigo_uzgtcabezera ASC").executeQuery();
                                    while (rs3.next()) {
                                        Cabecera Cab = new Cabecera(rs3.getInt(1), rs3.getInt(2), rs3.getString(3), rs3.getInt(4), rs3.getInt(5));
                                        ListaCabeceras.add(Cab);
                                    }
                                    rs3.close();
                                    int puntero = 0;
                                    for (int n = 0; n < filas; n++) {
                                        for (int m = 0; m < columnas; m++) {
                                            if (puntero < ListaCabeceras.size() && ListaCabeceras.get(puntero).getPosicionX() == n && ListaCabeceras.get(puntero).getPosicionY() == m) {
                                                puntero++;
                                            } else {
                                                if (n == 0 && m == 0) {
                                                } else {
                                                    try {
                                                        //numN++;
                                                        contRM++;
                                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION, CODIGO_UZGTCABECERA, CODIGO_UZGTMATRIZ, CODIGO_POSICIONX, CODIGO_POSICIONY,UZGTRESPUESTAS_FECHA_CREA,UZGTRESPUESTAS_USUA_CREA)"
                                                                + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
                                                        ps.setInt(1, usPidm);
                                                        ps.setInt(2, listaFP1.getFirst().getCodFormP());
                                                        ps.setInt(3, Cod);
                                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                                        ps.setInt(6, codR);
                                                        ps.setString(7, request.getParameter("Texto" + contRM));
                                                        ps.setInt(8, 0);
                                                        ps.setInt(9, ListaCabeceras.get(puntero - 1).getCodigo_cabecera());
                                                        ps.setInt(10, ListaCabeceras.get(puntero - 1).getCodigo_matriz());
                                                        ps.setInt(11, ListaCabeceras.get(puntero - 1).getPosicionX());
                                                        ps.setInt(12, m);
                                                        ps.setDate(13, sqlDate);
                                                        ps.setString(14, Integer.toString(usPidm));
                                                        codR++;
                                                        contC++;
                                                        ps.executeUpdate();
                                                        LOGGER.log(Level.INFO, "CodR4++: " + codR++);
                                                    } catch (Exception ex) {
                                                        LOGGER.log(Level.INFO, "Catch4: " + ex);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }//FIN IF MATRIZ
                            }
                        }
                    }//for para guardar respuestas

                    co.prepareStatement("UPDATE UTIC.UZGTFORMULARIO_PERSONA SET UZGTFORMULARIOS_ESTADO_LLENADO ='L' WHERE CODIGO_UZGTFORMULARIOS =" + Cod + " AND SPRIDEN_PIDM=" + usPidm).executeUpdate();
                } catch (Exception e) {
                    System.out.println("Error Formulario no Modificable: " + e);
                }
            }//if para formularios no modificables (llenado unico)
            //FORMULARIO MODIFICABLE
            else if (listaF.getFirst().getEstadoLlenado().equals("M")) {
                for (int i = 0; i < listaG.size(); i++) {
                    ////////////////////////////////////////////////////////////////////////////////////
                    //////////////////////RESPUESTAS/////////////////////////////////////////////////////
                    for (int j = 0; j < listaP.size(); j++) {
                        if (listaP.get(j).getCodigo_grupo() == listaG.get(i).getCodigo_grupo()) {

                            /*RESPUESTAS DATOS COMUNES*/
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 9) {

                                try {
                                    numDC++;
                                    String num = "text" + numDC;
                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION)"
                                            + " VALUES (?,?,?,?,?,?,?,?)");
                                    ps.setInt(1, usPidm);
                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                    ps.setInt(3, Cod);
                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                    ps.setInt(6, codR);
                                    ps.setString(7, request.getParameter(num));

                                    ps.setInt(8, 0);
                                    codR++;
                                    ps.executeUpdate();

                                } catch (Exception ex) {
                                    out.println("Error en tipo texto " + ex.getMessage());
                                }

                            }/*FIN IF DATO COMUNES*/


                            if (listaP.get(j).getCodigo_tipo_pregunta() == 1) {

                                try {
                                    numT++;
                                    String num = "valor" + numT;
                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion)"
                                            + " VALUES (?,?,?,?,?,?,?,?)");
                                    ps.setInt(1, usPidm);
                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                    ps.setInt(3, Cod);
                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());

                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                    ps.setInt(6, codR);
                                    ps.setString(7, request.getParameter(num));
                                    ps.setInt(8, 0);
                                    codR++;
                                    ps.executeUpdate();

                                } catch (Exception ex) {
                                    out.println(ex);
                                }

                            }
                            /////////////////////////////////////////////////////////////////////////////////////////////
                            ////////////////////CHECKBOX/////////////////////////////////////////////////////////////////
                            ////////////////////////////////////////////////////////////////////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 2) {
                                numC++;
                                //for(int k=0; k<1;k++)
                                //{
                                //if(listaV.get(k).getCodigo_Preguntas()== listaP.get(j).getCodigo_preguntas())
                                //{
                                String[] select = request.getParameterValues("seleccion" + numC);
                                for (String tempSelect : select) {
                                    try {

                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion)"
                                                + " VALUES (?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());

                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, tempSelect);
                                        ps.setInt(8, 0);
                                        //codPre++;//sube codigo pregunta
                                        codR++;
                                        ps.executeUpdate();

                                    } catch (Exception ex) {
                                        out.println(ex);
                                    }

                                }
                                //}
                                //}
                            }
                            ////////////////////////////////////////////////////////////////////////////
                            //////////////////RADIO////////////////////////////////////////////////////
                            ///////////////////////////////////////////////////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 3) {
                                numR++;
                                //out.println("</div>");
                                //for(int k=0; k<;k++)
                                //{

                                //if(listaP.get(i).getCodigo_preguntas()== listaP.get(j).getCodigo_preguntas())
                                //{
                                String[] selecte = request.getParameterValues("radio" + numR);
                                for (String tempSelecte : selecte) {

                                    try {

                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion)"
                                                + " VALUES (?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());

                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, tempSelecte);
                                        ps.setInt(8, 0);
                                        codR++;
                                        ps.executeUpdate();
                                        //numR++;
                                    } catch (Exception ex) {
                                        out.print(ex.getMessage());
                                    }

                                }
                                //}
                                //}
                            }
                            ///////////////////////////////////////////////////////////////////////
                            /////////////////////////////COMBO BOX////////////////////////////////
                            ///////////////////////////////////////////////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 5) {
                                numL++;
                                //out.println("</div>");
                                //for(int k=0; k<;k++)
                                //{

                                //if(listaP.get(i).getCodigo_preguntas()== listaP.get(j).getCodigo_preguntas())
                                //{
                                String[] selecte = request.getParameterValues("lista" + numL);
                                for (String tempSelecte : selecte) {

                                    try {

                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion)"
                                                + " VALUES (?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());

                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, tempSelecte);
                                        ps.setInt(8, 0);
                                        codR++;
                                        ps.executeUpdate();
                                        //numR++;
                                    } catch (Exception ex) {
                                        out.print(ex.getMessage());
                                    }

                                }
                                //}
                                //}
                            }
                            ///////////////////////////////////////
                            //ARCHIVOS
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 6) {

                                try {

                                    numA++;
                                    InputStream inputStream = null; // input stream of the upload file

                                    // obtains the upload file part in this multipart request
                                    Part filePart = request.getPart("archivo" + numA);
                                    String nombre = request.getParameter("fileN");
                                    if (filePart != null) {
                                        // prints out some information for debugging
                                        System.out.println(filePart.getName());
                                        System.out.println(filePart.getSize());
                                        System.out.println(filePart.getContentType());

                                        // obtains input stream of the upload file
                                        inputStream = filePart.getInputStream();

                                    }

                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTARCHIVO_valor, uzgtrespuestas_iteracion,uzgtmime)"
                                            + " VALUES (?,?,?,?,?,?,?,?,?,?)");
                                    ps.setInt(1, usPidm);
                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                    ps.setInt(3, Cod);
                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                    ps.setInt(6, codR);

                                    // ps.setString(7, filePart.getName());
                                    //ps.setString(7, filePart.getSubmittedFileName());
                                    ps.setString(7, nombre);
                                    //ps.setString(7, filePart.getSubmittedFileName());

                                    ps.setBlob(8, filePart.getInputStream(), filePart.getSize());
                                    ps.setInt(9, 0);
                                    ps.setString(10, filePart.getContentType());

                                    codR++;
                                    ps.executeUpdate();

                                } catch (Exception ex) {
                                    out.println(ex);
                                }

                            }//fin ciclo numerico
                            /////////////////////////////////////////////////////////////////////////
                            /////////////////////FECHA GUARDAR///////////////////////////////////////
                            /////////////////////////////////////////////////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 7) {

                                try {
                                    numFech++;
                                    String num = "fechaInicio" + numFech;
                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion)"
                                            + " VALUES (?,?,?,?,?,?,?,?)");
                                    ps.setInt(1, usPidm);
                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                    ps.setInt(3, Cod);
                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());

                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                    ps.setInt(6, codR);
                                    ps.setString(7, request.getParameter(num + ""));
                                    ps.setInt(8, 0);
                                    //JOptionPane.showMessageDialog(null, request.getParameter(num+""));
                                    codR++;
                                    ps.executeUpdate();

                                } catch (Exception ex) {
                                    out.println(ex);
                                }

                            }//fin ciclo fecha
                            ////////////////////////////////////////////////////////////////////
                            //////////////////////////////TIPO NUMERICO/////////////////////////
                            ////////////////////////////////////////////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 8) {

                                try {
                                    numN++;
                                    String num = "num" + numN;
                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, uzgtrespuestas_iteracion)"
                                            + " VALUES (?,?,?,?,?,?,?,?)");
                                    ps.setInt(1, usPidm);
                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                    ps.setInt(3, Cod);
                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                    ps.setInt(6, codR);
                                    ps.setString(7, request.getParameter(num + ""));
                                    ps.setInt(8, 0);
                                    //JOptionPane.showMessageDialog(null, request.getParameter(num+""));
                                    codR++;
                                    ps.executeUpdate();

                                } catch (Exception ex) {
                                    out.println(ex);
                                }

                            }//fin ciclo numerico
                            //LISTA MATRIZ
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 4) {
                                //JOptionPane.showMessageDialog(null, "Entra a matriz modificable ingreso: ");
                                numM++;
                                //contador++ ;
                                ResultSet rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTMATRIZ WHERE codigo_UZGTPREGUNTAS = '" + listaP.get(j).getCodigo_preguntas() + "'order by codigo_uzgtmatriz ASC").executeQuery();
                                LinkedList<Matriz> ListaMatriz = new LinkedList<Matriz>();
                                LinkedList<Cabecera> ListaCabeceras = new LinkedList<Cabecera>();
                                while (rs2.next()) {
                                    Matriz Mat = new Matriz(rs2.getInt(1), rs2.getInt(2), rs2.getInt(3), rs2.getInt(4), rs2.getInt(5), rs2.getInt(6), rs2.getString(7));
                                    ListaMatriz.add(Mat);
                                }
                                rs2.close();
                                int mat = ListaMatriz.getFirst().getCodigo_matriz();
                                int filas = ListaMatriz.getFirst().getFila() + 1;
                                int columnas = ListaMatriz.getFirst().getColumna() + 1;
                                ResultSet rs3 = co.prepareStatement("SELECT * FROM UTIC.UZGTCABECERAS WHERE codigo_UZGTMATRIZ = '" + mat + "' order by codigo_uzgtcabezera ASC").executeQuery();
                                while (rs3.next()) {
                                    Cabecera Cab = new Cabecera(rs3.getInt(1), rs3.getInt(2), rs3.getString(3), rs3.getInt(4), rs3.getInt(5));
                                    ListaCabeceras.add(Cab);
                                }
                                rs3.close();
                                //out.println("<div class=\"col-md-6 table-responsive\"><table class=\"table table-bordered\" name=\"matriz"+numM+"\">");

                                int puntero = 0;

                                //String num = request.getParameter("matriz"+numM);
                                //int contador = Integer.parseInt(num);
                                //String aux="matriz"+numM+contador;
                                //JOptionPane.showMessageDialog(null,request.getParameter(aux)+contador);
                                for (int n = 0; n < filas; n++) {
                                    for (int m = 0; m < columnas; m++) {

                                        if (puntero < ListaCabeceras.size() && ListaCabeceras.get(puntero).getPosicionX() == n && ListaCabeceras.get(puntero).getPosicionY() == m) {
                                            //out.println("<th>"+ListaCabeceras.get(puntero).getValor_cabecera()+"</th>");
                                            puntero++;
                                        } else {
                                            if (n == 0 && m == 0) {
                                                //out.println("<td><input type=\"text\" name=\"Texto\" placeholder=\"Texto\"' disabled></td>");
                                            } else {
                                                //JOptionPane.showMessageDialog(null, request.getParameter("Texto"+contRM));
                                                try {
                                                    //numN++;
                                                    //String num="num"+numN;
                                                    //JOptionPane.showMessageDialog(null,request.getParameter("Texto"+contRM));
                                                    contRM++;
                                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION, CODIGO_UZGTCABECERA, CODIGO_UZGTMATRIZ, CODIGO_POSICIONX, CODIGO_POSICIONY)"
                                                            + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?)");
                                                    ps.setInt(1, usPidm);
                                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                                    ps.setInt(3, Cod);
                                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                                    ps.setInt(6, codR);
                                                    ps.setString(7, request.getParameter("Texto" + contRM));
                                                    ps.setInt(8, 0);
                                                    ps.setInt(9, ListaCabeceras.get(puntero - 1).getCodigo_cabecera());
                                                    ps.setInt(10, ListaCabeceras.get(puntero - 1).getCodigo_matriz());
                                                    ps.setInt(11, ListaCabeceras.get(puntero - 1).getPosicionX());
                                                    ps.setInt(12, m);
                                                    //JOptionPane.showMessageDialog(null, "Valor: "+request.getParameter("Texto"+contRM));
                                                    codR++;
                                                    contC++;
                                                    ps.executeUpdate();

                                                } catch (Exception ex) {
                                                    out.println(ex);
                                                }
                                            }
                                        }
                                    }
                                    //out.println("</tr>");
                                }
                                //out.println("</table></div>");
                                //out.println("</div>");
                            }//FIN IF MATRIZ

                        }
                    }
                }//for para guardar respuestas
                co.prepareStatement("UPDATE UZGTFORMULARIO_PERSONA SET UZGTFORMULARIOS_ESTADO_LLENADO ='L'  WHERE CODIGO_UZGTFORMULARIOS =" + Cod + " AND SPRIDEN_PIDM=" + usPidm).executeUpdate();
            }//if para formularios modificables (varias modificaciones)
            /*FORMULARIOS SECUENCIALES*/ //else if (listaF.getFirst().getTipoFormulario().equals("M")) {
            else if (listaF.getFirst().getEstadoLlenado().equals("S")) {
                int iteracion = 0;
                if (listaFP.getFirst().getEstadoLlenado().equals("N")) {
                    iteracion = 1;
                } else {
                    iteracion = listaR.getLast().getIteracionRespuesta() + 1;
                }
                for (int i = 0; i < listaG.size(); i++) {
                    for (int j = 0; j < listaP.size(); j++) {
                        if (listaP.get(j).getCodigo_grupo() == listaG.get(i).getCodigo_grupo()) {
                            /*RESPUESTAS DATOS COMUNES*/
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 9) {
                                try {
                                    numDC++;
                                    String num = "text" + numDC;
                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION)"
                                            + " VALUES (?,?,?,?,?,?,?,?)");
                                    ps.setInt(1, usPidm);
                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                    ps.setInt(3, Cod);
                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                    ps.setInt(6, codR);
                                    ps.setString(7, request.getParameter(num));

                                    ps.setInt(8, iteracion);
                                    codR++;
                                    ps.executeUpdate();

                                } catch (Exception ex) {
                                    out.println("Error en tipo texto " + ex.getMessage());
                                }

                            }/*FIN IF DATO COMUNES*/


                            //////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 1) {

                                try {
                                    numT++;
                                    String num = "valor" + numT;
                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION)"
                                            + " VALUES (?,?,?,?,?,?,?,?)");
                                    ps.setInt(1, usPidm);
                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                    ps.setInt(3, Cod);
                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                    ps.setInt(6, codR);
                                    ps.setString(7, request.getParameter(num));

                                    ps.setInt(8, iteracion);
                                    codR++;
                                    ps.executeUpdate();

                                } catch (Exception ex) {
                                    out.println("Error en tipo texto " + ex.getMessage());
                                }

                            }
                            /////////////////////////////////////////////////////////////////////////////////////////////
                            ////////////////////CHECKBOX/////////////////////////////////////////////////////////////////
                            ////////////////////////////////////////////////////////////////////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 2) {
                                numC++;
                                //for(int k=0; k<1;k++)
                                //{
                                //if(listaV.get(k).getCodigo_Preguntas()== listaP.get(j).getCodigo_preguntas())
                                //{
                                String[] select = request.getParameterValues("seleccion" + numC);
                                for (String tempSelect : select) {
                                    try {

                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION)"
                                                + " VALUES (?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());

                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, tempSelect);
                                        ps.setInt(8, iteracion);
                                        //codPre++;//sube codigo pregunta
                                        codR++;
                                        ps.executeUpdate();

                                    } catch (Exception ex) {
                                        out.println("Error tipo check " + ex.getMessage());
                                    }

                                }
                                //}
                                //}
                            }
                            ////////////////////////////////////////////////////////////////////////////
                            //////////////////RADIO////////////////////////////////////////////////////
                            ///////////////////////////////////////////////////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 3) {
                                numR++;
                                //out.println("</div>");
                                //for(int k=0; k<;k++)
                                //{

                                //if(listaP.get(i).getCodigo_preguntas()== listaP.get(j).getCodigo_preguntas())
                                //{
                                String[] selecte = request.getParameterValues("radio" + numR);
                                for (String tempSelecte : selecte) {

                                    try {

                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION)"
                                                + " VALUES (?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());

                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, tempSelecte);
                                        ps.setInt(8, iteracion);
                                        codR++;
                                        ps.executeUpdate();
                                        //numR++;
                                    } catch (Exception ex) {
                                        out.print("Error en Radio " + ex.getMessage());
                                    }

                                }
                                //}
                                //}
                            }
                            ///////////////////////////////////////////////////////////////////////
                            /////////////////////////////COMBO BOX////////////////////////////////
                            ///////////////////////////////////////////////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 5) {
                                numL++;
                                //out.println("</div>");
                                //for(int k=0; k<;k++)
                                //{

                                //if(listaP.get(i).getCodigo_preguntas()== listaP.get(j).getCodigo_preguntas())
                                //{
                                String[] selecte = request.getParameterValues("lista" + numL);
                                for (String tempSelecte : selecte) {

                                    try {

                                        PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION)"
                                                + " VALUES (?,?,?,?,?,?,?,?)");
                                        ps.setInt(1, usPidm);
                                        ps.setInt(2, listaFP.getFirst().getCodFormP());
                                        ps.setInt(3, Cod);
                                        ps.setInt(4, listaG.get(i).getCodigo_grupo());

                                        ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                        ps.setInt(6, codR);
                                        ps.setString(7, tempSelecte);
                                        ps.setInt(8, iteracion);
                                        codR++;
                                        ps.executeUpdate();
                                        //numR++;
                                    } catch (Exception ex) {
                                        out.print("Error Combo" + ex.getMessage());
                                    }

                                }
                                //}
                                //}
                            }
                            ///////////////////////////////////////
                            //ARCHIVOS
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 6) {

                                try {

                                    numA++;
                                    InputStream inputStream = null; // input stream of the upload file

                                    // obtains the upload file part in this multipart request
                                    Part filePart = request.getPart("archivo" + numA);
                                    String nombre = request.getParameter("fileN");
                                    //JOptionPane.showMessageDialog(null, nombre);
                                    if (filePart != null) {
                                        // prints out some information for debugging
                                        System.out.println(filePart.getName());
                                        System.out.println(filePart.getSize());
                                        System.out.println(filePart.getContentType());

                                        // obtains input stream of the upload file
                                        inputStream = filePart.getInputStream();
                                        //JOptionPane.showMessageDialog(null,"CodFormulario Persona  "+listaFP.getFirst().getCodFormP());
                                    }

                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTARCHIVO_VALOR, UZGTRESPUESTAS_ITERACION,uzgtmime)"
                                            + " VALUES (?,?,?,?,?,?,?,?,?,?)");
                                    ps.setInt(1, usPidm);
                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                    ps.setInt(3, Cod);
                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                    ps.setInt(6, codR);
                                    ps.setString(7, nombre);
                                    ps.setBlob(8, filePart.getInputStream(), filePart.getSize());
                                    ps.setInt(9, iteracion);
                                    ps.setString(10, filePart.getContentType());
                                    codR++;
                                    ps.executeUpdate();

                                } catch (Exception ex) {
                                    out.println("Error en archivo " + ex.getMessage());
                                }

                            }//fin ciclo numerico
                            /////////////////////////////////////////////////////////////////////////
                            /////////////////////FECHA GUARDAR///////////////////////////////////////
                            /////////////////////////////////////////////////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 7) {

                                try {
                                    numFech++;
                                    String num = "fechaInicio" + numFech;
                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION)"
                                            + " VALUES (?,?,?,?,?,?,?,?)");
                                    ps.setInt(1, usPidm);
                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                    ps.setInt(3, Cod);
                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());

                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                    ps.setInt(6, codR);
                                    ps.setString(7, request.getParameter(num + ""));
                                    //JOptionPane.showMessageDialog(null, request.getParameter(num+""));
                                    ps.setInt(8, iteracion);
                                    codR++;
                                    ps.executeUpdate();

                                } catch (Exception ex) {
                                    out.println("Error Fecha " + ex.getMessage());
                                }

                            }//fin ciclo fecha
                            ////////////////////////////////////////////////////////////////////
                            //////////////////////////////TIPO NUMERICO/////////////////////////
                            ////////////////////////////////////////////////////////////////////
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 8) {

                                try {
                                    numN++;
                                    String num = "num" + numN;
                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION)"
                                            + " VALUES (?,?,?,?,?,?,?,?)");
                                    ps.setInt(1, usPidm);
                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                    ps.setInt(3, Cod);
                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                    ps.setInt(6, codR);
                                    ps.setString(7, request.getParameter(num + ""));
                                    //JOptionPane.showMessageDialog(null, request.getParameter(num+""));
                                    ps.setInt(8, iteracion);
                                    codR++;
                                    ps.executeUpdate();

                                } catch (Exception ex) {
                                    out.println("Error tipo numerico" + ex.getMessage());
                                }

                            }//fin ciclo numerico
                            int contador = 0;

                            /////////////////////////////////////////MATRIZ
                            if (listaP.get(j).getCodigo_tipo_pregunta() == 4) {
                                numM++;
                                contador++;
                                ResultSet rs2 = co.prepareStatement("SELECT * FROM UTIC.UZGTMATRIZ WHERE codigo_UZGTPREGUNTAS = '" + listaP.get(j).getCodigo_preguntas() + "'order by codigo_uzgtmatriz ASC").executeQuery();
                                LinkedList<Matriz> ListaMatriz = new LinkedList<Matriz>();
                                LinkedList<Cabecera> ListaCabeceras = new LinkedList<Cabecera>();
                                while (rs2.next()) {
                                    Matriz Mat = new Matriz(rs2.getInt(1), rs2.getInt(2), rs2.getInt(3), rs2.getInt(4), rs2.getInt(5), rs2.getInt(6), rs2.getString(7));
                                    ListaMatriz.add(Mat);
                                }
                                rs2.close();
                                int mat = ListaMatriz.getFirst().getCodigo_matriz();
                                int filas = ListaMatriz.getFirst().getFila() + 1;
                                int columnas = ListaMatriz.getFirst().getColumna() + 1;
                                ResultSet rs3 = co.prepareStatement("SELECT * FROM UTIC.UZGTCABECERAS WHERE codigo_UZGTMATRIZ = '" + mat + "' order by codigo_uzgtcabezera ASC").executeQuery();
                                while (rs3.next()) {
                                    Cabecera Cab = new Cabecera(rs3.getInt(1), rs3.getInt(2), rs3.getString(3), rs3.getInt(4), rs3.getInt(5));
                                    ListaCabeceras.add(Cab);
                                }
                                rs3.close();
                                //out.println("<div class=\"col-md-6 table-responsive\"><table class=\"table table-bordered\" name=\"matriz"+numM+"\">");

                                int puntero = 0;

                                //String num = request.getParameter("matriz"+numM);
                                //int contador = Integer.parseInt(num);
                                //String aux="matriz"+numM+contador;
                                //JOptionPane.showMessageDialog(null,request.getParameter(aux)+contador);
                                for (int n = 0; n < filas; n++) {
                                    for (int m = 0; m < columnas; m++) {

                                        if (puntero < ListaCabeceras.size() && ListaCabeceras.get(puntero).getPosicionX() == n && ListaCabeceras.get(puntero).getPosicionY() == m) {
                                            //out.println("<th>"+ListaCabeceras.get(puntero).getValor_cabecera()+"</th>");
                                            puntero++;
                                        } else {
                                            if (n == 0 && m == 0) {
                                                //out.println("<td><input type=\"text\" name=\"Texto\" placeholder=\"Texto\"' disabled></td>");
                                            } else {
                                                //JOptionPane.showMessageDialog(null, request.getParameter("Texto"+contRM));
                                                try {
                                                    //numN++;
                                                    //String num="num"+numN;
                                                    //JOptionPane.showMessageDialog(null,request.getParameter("Texto"+contRM));
                                                    contRM++;
                                                    PreparedStatement ps = co.prepareStatement("INSERT INTO UTIC.UZGTRESPUESTAS (SPRIDEN_PIDM, codigo_UZGTFORMULARIOS_PERSONA,codigo_UZGTFORMULARIOS,codigo_UZGTGRUPO,codigo_UZGTPREGUNTAS, codigo_UZGTRESPUESTAS, UZGTRESPUESTAS_valor, UZGTRESPUESTAS_ITERACION, CODIGO_UZGTCABECERA, CODIGO_UZGTMATRIZ, CODIGO_POSICIONX, CODIGO_POSICIONY)"
                                                            + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?)");
                                                    ps.setInt(1, usPidm);
                                                    ps.setInt(2, listaFP.getFirst().getCodFormP());
                                                    ps.setInt(3, Cod);
                                                    ps.setInt(4, listaG.get(i).getCodigo_grupo());
                                                    ps.setInt(5, listaP.get(j).getCodigo_preguntas());
                                                    ps.setInt(6, codR);
                                                    ps.setString(7, request.getParameter("Texto" + contRM));
                                                    ps.setInt(8, iteracion);
                                                    ps.setInt(9, ListaCabeceras.get(puntero - 1).getCodigo_cabecera());
                                                    ps.setInt(10, ListaCabeceras.get(puntero - 1).getCodigo_matriz());
                                                    ps.setInt(11, ListaCabeceras.get(puntero - 1).getPosicionX());
                                                    ps.setInt(12, m);
                                                    //JOptionPane.showMessageDialog(null, request.getParameter(num+""));
                                                    codR++;
                                                    contC++;
                                                    ps.executeUpdate();

                                                } catch (Exception ex) {
                                                    out.println(ex);
                                                }
                                            }
                                        }
                                    }
                                    //out.println("</tr>");
                                }
                                //out.println("</table></div>");
                                //out.println("</div>");
                            }//FIN IF MATRIZ

                        }// cierre if de las respuestas
                    }
                }//for para guardar respuestas
                co.prepareStatement(" UPDATE UZGTFORMULARIO_PERSONA SET UZGTFORMULARIOS_ESTADO_LLENADO ='L'  WHERE CODIGO_UZGTFORMULARIOS ='" + Cod + "' AND SPRIDEN_PIDM=" + usPidm).executeUpdate();
            }//if para formularios secuenciales (ingreso de nuevas respuestas)

            message = "Se guardo correctamente";
            request.setAttribute("Message", message);
            co.close();
            con.closeConexion();

            //llamar al procedimiento para que se ejecute el workflow dependiente del tipo de formulario
            //LlamadaWf lwf = new LlamadaWf();
            //lwf.llamarWF(Cod, usPidm);
            // forwards to the message page
            getServletContext().getRequestDispatcher("/almacenarR.jsp").forward(request, response);

        } catch (Exception e) {

            System.out.println("error   " + e.getMessage());
            message = "Error! No se guardó las respuestas";
            request.setAttribute("Message", message);
            // forwards to the message page

            getServletContext().getRequestDispatcher("/mostrarGRes.jsp").forward(request, response);

            //  JOptionPane.showMessageDialog(null, message);
        }

    }

}
