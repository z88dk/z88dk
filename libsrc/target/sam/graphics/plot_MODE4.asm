;
; Plotting in Sam modes
;

	SECTION	code_graphics
	PUBLIC	plot_MODE4


plot_MODE4:
	defc    NEEDplot = 1
	INCLUDE	"pixel_MODE4.inc"
