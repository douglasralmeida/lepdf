package winapi;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.WString;

import lePdf.TipoGeracao;

public class Shell {
	private interface Shell32 extends Library {
		public int ShellExecuteW(int hwnd,
	                             WString Operation,
	                             WString File,
	                             WString Parameters,
	                             WString Directory,
	                             int ShowCmd);
	}

	public static void abrir(String comando, TipoGeracao modo) {
		int i;
		
		if (modo == TipoGeracao.TIPOGERACAO_SEGUNDOPLANO)
			i = 7;
		else
			i = 1;
		Shell32 lib = (Shell32)Native.load("Shell32", Shell32.class);
		lib.ShellExecuteW(0, new WString("open"), new WString(comando), null, null, i);
	}
	
	public static void executar(String pasta, String exe, String param) {
		Shell32 lib = (Shell32)Native.load("Shell32", Shell32.class);
		lib.ShellExecuteW(0, new WString("open"), new WString(exe), new WString(param), new WString(pasta), 7);
	}
}