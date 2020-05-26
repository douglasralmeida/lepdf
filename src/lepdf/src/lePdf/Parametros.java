package lePdf;

import java.io.File;
import java.io.IOException;

import org.ini4j.Ini;
import org.ini4j.InvalidFileFormatException;

public class Parametros {
	public String nomePDFSaida = "";
	public boolean usarParametros = false;
	
	Parametros() {
		File arquivo = new File(Variaveis.pastaOrigem + Variaveis.nomeArquivoParam);
		Ini ini = new Ini();
			
	    if (arquivo.exists() && !arquivo.isDirectory()) {
		  try {
			ini.load(arquivo);
		  } catch (InvalidFileFormatException e) {
		    usarParametros = false;
		  } catch (IOException e) {
			usarParametros = false;
		  }
		  processar(ini);
		  usarParametros = true;
		}
		else
		  usarParametros = false;
	}
	
	private void processar(Ini ini) {
		Ini.Section configuracoes = ini.get("Pametros");
			
		String nomearquivosaida = configuracoes.get("NomeArquivoSaida");
		if (nomearquivosaida.length() > 0)
		  nomePDFSaida = nomearquivosaida;
	  }
}