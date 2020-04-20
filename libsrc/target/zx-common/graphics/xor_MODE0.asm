;
; Plotting in Timex/ZX modes
;

	SECTION	code_graphics
	PUBLIC	xor_MODE0


xor_MODE0:
	defc    NEEDxor = 1
	INCLUDE	"pixel_MODE0.inc"
