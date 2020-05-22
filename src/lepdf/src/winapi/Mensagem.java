package winapi;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.WString;

public class Mensagem {
	
	static int MB_ICONERROR = 16;

	private interface user32 extends Library {
        public int MessageBoxW(int algo, WString texto, WString titulo, int flags);
    }
	public static void exibir(String texto, String titulo) {
		user32 lib = (user32) Native.load("user32", user32.class);
		lib.MessageBoxW(0, new WString(texto), new WString(titulo), MB_ICONERROR);
	}
	
}
