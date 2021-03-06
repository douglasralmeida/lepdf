package lePdf;

/* Motivação:
 * As configurações do usuário sem privilégios são salvas em sua pasta local 
 * O instalador não consegue instalar uma cópia na pasta de cada usuário.
 * Além disso, novos usuários podem ser adicionados ao computador após a instalação.
 * 
 * A classe PrimeiroUso será a responsável por criar a pasta e o arquivo de configurações
 * quando o Componente PDF estiver sendo executado pela primeira vez por um usuário.
 */

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

public class PrimeiroUso {
  public static boolean testar() {
    if (Files.notExists(Variaveis.pastaDados, LinkOption.NOFOLLOW_LINKS))
      return true;
	
    if (Files.notExists(Variaveis.arquivoConfig, LinkOption.NOFOLLOW_LINKS))
	  return true;
		
	return false;
  }
	
  public static boolean processar() {
	if (Files.notExists(Variaveis.pastaDados, LinkOption.NOFOLLOW_LINKS)) {
	  try {
		Files.createDirectories(Variaveis.pastaDados);
	  } catch (IOException e) {
		winapi.Mensagem.exibir("Ocorreu um erro desconhecido ao configurar o Componente PrismaPDF para o primeiro uso. Reinstale o componente para resolver este problema.", "Componente PrismaPDF");
		e.printStackTrace();
		return false;
	  }
	}
	  try {
		Files.copy(Variaveis.arquivoModelo, Variaveis.arquivoConfig, StandardCopyOption.REPLACE_EXISTING);
	  } catch (IOException e) {
		winapi.Mensagem.exibir("Ocorreu um erro desconhecido ao configurar o Componente PrismaPDF para o primeiro uso. Reinstale o componente para resolver este problema.", "Componente PrismaPDF");
		e.printStackTrace();
		return false;
	  }
	return true;
  }
}
