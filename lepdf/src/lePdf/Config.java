package lePdf;

import java.io.File;
import java.io.IOException;

import org.ini4j.Ini;
import org.ini4j.InvalidFileFormatException;

import com.sun.jna.platform.win32.Shell32Util;
import com.sun.jna.platform.win32.ShlObj;

public class Config {

	String arquivoConfig;
	
	boolean excluirNome = false;
	
	String arquivoPDF24 = "";
	
	String nomeAExcluir = "";
	
	String nomeFonte = "";
	
	TipoGeracao modoGeracao = TipoGeracao.TIPOGERACAO_PRIMEIROPLANO; 
	
	public Config() {
		String pastaDados = Shell32Util.getFolderPath(ShlObj.CSIDL_LOCAL_APPDATA) + '\\';
		arquivoConfig = pastaDados + "Aplicações do INSS\\Componente PrismaPDF\\config.ini"; 
		carregarConfig();
	}
	
	private boolean carregarConfig() {
		File f = new File(arquivoConfig);
		Ini ini = new Ini();
		
		if (f.exists() && !f.isDirectory()) {
			try {
				ini.load(f);
			} catch (InvalidFileFormatException e) {
				winapi.Mensagem.exibir("O arquivo de configurações está num formato inválido.", "Componente PDF");
			} catch (IOException e) {
				winapi.Mensagem.exibir(e.getMessage(), "Componente PDF");
			}
			processarConfig(ini);
			return true;
		}
		else
			return false;
	}
	
	private void processarConfig(Ini ini) {
		Ini.Section configuracoes = ini.get("Configuracoes");
		
		String nomeapagar = configuracoes.get("NomeApagar");
		if (nomeapagar.length() > 0) {
			excluirNome = true;
			nomeAExcluir = nomeapagar;
		}
		
		String modogeracao = configuracoes.get("ModoGeracao");
		if (modogeracao.length() > 0) {
			if (modogeracao.toLowerCase().equals("segundoplano"))
				modoGeracao = TipoGeracao.TIPOGERACAO_SEGUNDOPLANO;
			else if (modogeracao.toLowerCase().equals("diretopdf24"))
				modoGeracao = TipoGeracao.TIPOGERACAO_DIRETA;
			else 
				modoGeracao = TipoGeracao.TIPOGERACAO_PRIMEIROPLANO;
		}
		
		String localpdf24 = configuracoes.get("LocalPDF24");
		if (localpdf24.length() > 0) {
			arquivoPDF24 = localpdf24;
		}
		
		String localNomeFonte = configuracoes.get("NomeFonte");
		if (localNomeFonte.length() > 0) {
			nomeFonte = localNomeFonte;
		}
	}
}
