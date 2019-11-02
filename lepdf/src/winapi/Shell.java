package winapi;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.WString;

public class Shell {
	private interface Shell32 extends Library {
		public int ShellExecuteW(int hwnd,
	                             WString Operation,
	                             WString File,
	                             WString Parameters,
	                             WString Directory,
	                             int ShowCmd);
	}

	public static void executar(String comando) {
		Shell32 lib = (Shell32)Native.load("Shell32", Shell32.class);
		lib.ShellExecuteW(0, new WString("open"), new WString(comando), null, null, 1);
	}
}