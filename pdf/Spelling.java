package pdf;

import java.io.IOException;
import java.io.PrintStream;
import java.util.ResourceBundle;

class Spelling {
  public static void main(String[] args) throws IOException {
    ResourceBundle ptC = ResourceBundle.getBundle("res/palavrasAcentuadas.res");
    System.out.println(ptC.getString("branco"));
  }
}
