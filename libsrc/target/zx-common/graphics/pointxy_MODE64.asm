;
; Plotting in tilemap mode
;

IF FORzxn
	SECTION	code_graphics
	PUBLIC	pointxy_MODE64


pointxy_MODE64:
	defc    NEEDpoint = 1
        INCLUDE "pixel_MODE64.inc"
ENDIF
