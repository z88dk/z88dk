;
; Plotting in Timex/ZX modes
;

	SECTION	code_graphics
	PUBLIC	plot_MODE0


plot_MODE0:
	defc    NEEDplot = 1
	INCLUDE	"pixel_MODE0.inc"
