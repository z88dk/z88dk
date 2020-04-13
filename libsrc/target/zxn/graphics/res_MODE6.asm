;
; Plotting in Timex Hires mode
;

	SECTION	code_graphics
	PUBLIC	res_MODE6


res_MODE6:
	defc    NEEDunplot = 1
	INCLUDE	"pixel_MODE6.inc"
