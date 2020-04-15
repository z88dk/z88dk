;
; Plotting in Timex Hires mode
;

	SECTION	code_graphics
	PUBLIC	xor_MODE6


xor_MODE6:
	defc    NEEDxor = 1
	INCLUDE	"pixel_MODE6.inc"
