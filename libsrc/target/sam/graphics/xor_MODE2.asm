;
; Plotting in Sam modes
;

	SECTION	code_graphics
	PUBLIC	xor_MODE2


xor_MODE2:
	defc    NEEDxor = 1
	INCLUDE	"pixel_MODE2.inc"
