;
; Plotting in tilemap mode
;

	SECTION	code_graphics
	PUBLIC	pointxy_MODE64


pointxy_MODE64:
	defc    NEEDpoint = 1
; We enter here with: hl = x, de = y
; We fold them down into the standard narrow parameters
        ld      h,l
        ld      l,e
	INCLUDE	"gfx/gencon/pixel.inc"
