;
; Plotting in Timex Hires mode
;

	SECTION	code_graphics
	PUBLIC	pointxy_MODE6


pointxy_MODE6:
	defc    NEEDpoint = 1
	INCLUDE	"pixel_MODE6.inc"
