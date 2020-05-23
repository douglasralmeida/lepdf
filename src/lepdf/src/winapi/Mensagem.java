package winapi;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.WString;
import com.sun.jna.ptr.IntByReference;

public class Mensagem {
	
	static int TD_ERROR_ICON = 0xFFFE;

	private interface comctl32 extends Library {
		public int TaskDialog(int algo, int algo2, WString titulo, WString texto, WString subtexto, int flags, int icone, IntByReference botaopressionado);
	}

	public static void exibir(String texto, String titulo) {
		comctl32 lib = (comctl32) Native.load("comctl32", comctl32.class);
		lib.TaskDialog(0, 0, new WString(titulo), new WString(texto), new WString(""), 0, TD_ERROR_ICON, new IntByReference());
	}
	
}
