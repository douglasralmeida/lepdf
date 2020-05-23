package lePdf;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import com.itextpdf.io.font.FontProgram;
import com.itextpdf.io.font.FontProgramFactory;
import com.itextpdf.io.font.PdfEncodings;
import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.layout.element.Image;
import com.itextpdf.layout.property.HorizontalAlignment;

public class Recursos {
  Config config;	
  String arquivoFonte;
  String arquivoLogotipo;
  PdfFont fonte = null;
  Image logotipo = null;
	
  public Recursos (Config novoconfig) {
	config = novoconfig;
	arquivoFonte = "/resources/" + config.nomeFonte;
	arquivoLogotipo = "/resources/logoINSS.jpg";
  }
	
  public boolean carregar() {
	InputStream fs;
	FontProgram fp = null;
	URL url;
	boolean resultado = true;
		
	// Carrega a fonte do relatório
	fs	= lePdf.class.getResourceAsStream(arquivoFonte);
	try {
	  fp = FontProgramFactory.createFont(fs.readAllBytes());
	} catch (IOException e) {
	  resultado = false;
	  e.printStackTrace();
	}
	if (resultado)
	  fonte = PdfFontFactory.createFont(fp, PdfEncodings.IDENTITY_H);
		
    //Carrega a imagem para o logotipo
	url = lePdf.class.getResource(arquivoLogotipo);
    logotipo = new Image(ImageDataFactory.create(url));
    logotipo.setHorizontalAlignment(HorizontalAlignment.CENTER);
    logotipo.scaleAbsolute(86.0F, 50.0F);
	  
	return resultado;
  }
	
  public PdfFont getFonte() {
	return fonte;
  }
	
  public Image getLogotipo() {
	return logotipo;
  }
}
