	INCLUDE	"graphics/grafix.inc"
	
        SECTION code_clib
	PUBLIC	w_line_fast

	EXTERN	w_line_r_fast

	EXTERN	__gfx_coords

;
;	$Id: w_line_fast.asm $
;

; ******************************************************************************
;
;	Draw a pixel line from (x0,y0) defined in COORDS (word,word) - the starting point coordinate,
;	to the end point (HL,DE).
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;

.w_line_fast
		ex	de,hl
		ld	bc,(__gfx_coords+2)
		or	a
		sbc	hl,bc
		ex	de,hl

		ld	bc,(__gfx_coords)
		or	a
		sbc	hl,bc

		jp	w_line_r_fast
