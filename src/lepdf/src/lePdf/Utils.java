package lePdf;

import com.sun.jna.platform.win32.Shell32Util;
import com.sun.jna.platform.win32.ShlObj;

public class Utils {

	public static String obterPastaDados() {
		return Shell32Util.getFolderPath(ShlObj.CSIDL_LOCAL_APPDATA) + '\\';
	}
	
	public static String obterPastaPrograma() {
		return Shell32Util.getFolderPath(ShlObj.CSIDL_PROGRAM_FILES) + '\\';
	}

}
