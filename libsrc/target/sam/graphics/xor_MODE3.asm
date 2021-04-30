;
; Plotting in Sam modes
;

	SECTION	code_graphics
	PUBLIC	xor_MODE3


xor_MODE3:
	defc    NEEDxor = 1
	INCLUDE	"pixel_MODE3.inc"
