module lePdf {
	requires java.base;
	requires jdk.jdwp.agent;
	requires itextpdf.kernel;
	requires itextpdf.io;
	requires itextpdf.layout;
	requires com.sun.jna;
	
	requires transitive org.slf4j;

	exports lePdf;
}