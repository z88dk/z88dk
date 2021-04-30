;
; Plotting in Sam modes
;

	SECTION	code_graphics
	PUBLIC	xor_MODE4


xor_MODE4:
	defc    NEEDxor = 1
	INCLUDE	"pixel_MODE4.inc"
