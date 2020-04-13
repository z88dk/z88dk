;
; Plotting in tilemap mode
;

	SECTION	code_graphics
	PUBLIC	pointxy_MODE64


pointxy_MODE64:
	defc    NEEDpoint = 1
        INCLUDE "target/zxn/graphics/pixel_MODE64.inc"
