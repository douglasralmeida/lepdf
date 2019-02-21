module lePdf {
	requires java.base;
	requires java.desktop;
	requires jdk.jdwp.agent;
	requires itextpdf.kernel;
	requires itextpdf.io;
	requires itextpdf.layout;
	
	requires transitive slf4j.api;

	exports lePdf;
}