public class testePalavra {
  public static void main(String[] args) throws Exception {
    String palavra = null;
    palavra = "RELACOES ENTRE MEDICOS NUMEROS NUMERAL NUMERAIS ";
    System.out.println(palavra);
    while (palavra.indexOf(" ") != -1) {
      int pos = palavra.indexOf(" ");
      String dado = palavra.substring(0, pos);
      System.out.println(dado);
      String palavraCorrigida = null;
      palavraCorrigida = lePdf.corrigePalavra(dado);
      palavra = palavra.substring(pos + 1, palavra.length());
      System.out.println(dado + "   " + palavraCorrigida + "  " + palavra);
    }
  }
}
