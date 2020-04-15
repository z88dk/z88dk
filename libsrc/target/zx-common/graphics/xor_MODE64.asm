;
; Plotting in tilemap mode
;

IF FORzxn
	SECTION	code_graphics
	PUBLIC	xor_MODE64


xor_MODE64:
	defc    NEEDxor = 1
        INCLUDE "pixel_MODE64.inc"
ENDIF
