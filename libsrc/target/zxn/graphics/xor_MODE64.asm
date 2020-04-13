;
; Plotting in tilemap mode
;

	SECTION	code_graphics
	PUBLIC	xor_MODE64


xor_MODE64:
	defc    NEEDxor = 1
        INCLUDE "target/zxn/graphics/pixel_MODE64.inc"
