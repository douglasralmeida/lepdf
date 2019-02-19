module lepdf {
	requires java.base;
	requires java.desktop;
	requires itextpdf;
	requires pdfbox;

    exports main.java;
}