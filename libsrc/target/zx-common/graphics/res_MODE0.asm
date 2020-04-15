;
; Plotting in Timex/ZX modes
;

	SECTION	code_graphics
	PUBLIC	res_MODE0


res_MODE0:
	defc    NEEDunplot = 1
	INCLUDE	"pixel_MODE0.inc"
