package lePdf;

import java.nio.file.Path;

import com.sun.jna.platform.win32.Shell32Util;
import com.sun.jna.platform.win32.ShlObj;

public class Variaveis {
	
  static String modeloArquivoConfig = "prismapdf.prc";
  static String nomeArquivoConfig = "prismapdf.ini";
  static String nomeArquivoParam = "pdfparam.ini";
  static String nomeOrganizacao = "Aplicativos do INSS";
  static String nomeAplicativo = "Prisma";
  public static String pastaOrigem = "C:\\cnislinha\\";
  static String pastaAppData = Shell32Util.getFolderPath(ShlObj.CSIDL_LOCAL_APPDATA) + '\\';
  static String pastaAppFiles = Shell32Util.getFolderPath(ShlObj.CSIDL_PROGRAM_FILES) + '\\';;
  static String pastaDesktop = Shell32Util.getFolderPath(ShlObj.CSIDL_DESKTOPDIRECTORY) + '\\';;
  public static Path pastaDados = Path.of(pastaAppData, nomeOrganizacao, nomeAplicativo);
  public static Path pastaAplicativo = Path.of(pastaAppFiles, nomeOrganizacao, nomeAplicativo);
  public static Path arquivoConfig = Path.of(pastaDados.toString(), nomeArquivoConfig);
  public static Path arquivoModelo = Path.of(pastaAplicativo.toString(), "modelos", modeloArquivoConfig);

}
