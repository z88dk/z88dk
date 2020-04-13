;
; Plotting in tilemap mode
;

	SECTION	code_graphics
	PUBLIC	plot_MODE64


plot_MODE64:
	defc    NEEDplot = 1
; We enter here with: hl = x, de = y
; We fold them down into the standard narrow parameters
        ld      h,l
        ld      l,e
	INCLUDE	"gfx/gencon/pixel.inc"
