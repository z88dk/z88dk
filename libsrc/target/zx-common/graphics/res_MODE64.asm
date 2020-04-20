;
; Plotting in tilemap mode
;

IF FORzxn
	SECTION	code_graphics
	PUBLIC	res_MODE64


res_MODE64:
	defc    NEEDunplot = 1
        INCLUDE "pixel_MODE64.inc"
ENDIF
