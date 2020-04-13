;
; Plotting in Timex Hires
;

	SECTION	code_graphics
	PUBLIC	plot_MODE6


plot_MODE6:
	defc    NEEDplot = 1
	INCLUDE	"pixel_MODE6.inc"
