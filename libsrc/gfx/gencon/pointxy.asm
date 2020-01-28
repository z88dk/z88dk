;
;       Generic pseudo graphics routines for text-only platforms
;
;       Get pixel at (x,y) coordinate.
;



	SECTION code_clib
	PUBLIC	pointxy


.pointxy
	defc	NEEDpoint = 1
	INCLUDE	"pixel.inc"
