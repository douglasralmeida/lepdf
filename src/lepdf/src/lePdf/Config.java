package lePdf;

import java.io.File;
import java.io.IOException;

import org.ini4j.Ini;
import org.ini4j.InvalidFileFormatException;

public class Config {
  boolean excluirNome = false;	
  String arquivoPDF24 = "";
  String argumentosPDF24 = "";
  String sequenciaAExcluir = "";
  String nomeFonte = "";
  boolean usarPDFParam = false;
  TipoGeracao modoGeracao = TipoGeracao.TIPOGERACAO_PRIMEIROPLANO; 
	
  public boolean carregar() {
	File arquivo = new File(Variaveis.arquivoConfig.toString());
	Ini ini = new Ini();
		
    if (arquivo.exists() && !arquivo.isDirectory()) {
	  try {
		ini.load(arquivo);
	  } catch (InvalidFileFormatException e) {
		winapi.Mensagem.exibir("O arquivo de configurações está num formato inválido.", "Componente PDF");
		return false;
	  } catch (IOException e) {
		winapi.Mensagem.exibir(e.getMessage(), "Componente PDF");
		return false;
	  }
	  processar(ini);
	  return true;
	}
	else
	  return false;
  }
	
  private void processar(Ini ini) {
	Ini.Section configuracoes = ini.get("Configuracoes");
		
	String nomeapagar = configuracoes.get("SequenciaApagar");
	if (configuracoes.containsKey("SequenciaApagar") && nomeapagar.length() > 0) {
	  excluirNome = true;
	  sequenciaAExcluir = nomeapagar;
	}

	String modogeracao = configuracoes.get("ModoGeracao");
	try {	
	 int i = Integer.parseInt(modogeracao);
	 modoGeracao = TipoGeracao.values()[i];
	}
	catch (Exception e) {
      e.printStackTrace();
	}

	String localpdf24 = configuracoes.get("LocalizacaoPDF24");
	if (localpdf24.length() > 0)
	  arquivoPDF24 = localpdf24;
		
	String localargpdf24 = configuracoes.get("ArgumentosPDF24");
	if (localargpdf24.length() > 0)
		argumentosPDF24 = localargpdf24;
		
	String localNomeFonte = configuracoes.get("NomeFonte");
	if (localNomeFonte.length() > 0)
	  nomeFonte = localNomeFonte;
	
	String localUsarParam = configuracoes.get("UsarParamINI");
	if (localUsarParam.length() > 0)
      usarPDFParam = localUsarParam.equals("1");  
  }
}