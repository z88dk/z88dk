;
; Plotting in Timex/ZX modes
;

	SECTION	code_graphics
	PUBLIC	pointxy_MODE0


pointxy_MODE0:
	defc    NEEDpoint = 1
	INCLUDE	"pixel_MODE0.inc"
