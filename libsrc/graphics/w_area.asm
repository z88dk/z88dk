
;
;       Z88 Graphics Functions - Stefano, 2019
;       Generic Rectangular area fill with high resolution mode coordinates
;
;       Written around the Interlogic Standard Library
;
;
;	$Id: w_area.asm $
;


 	SECTION code_graphics
	PUBLIC    w_area

	
.w_area

; IN:  HL,DE = (x,y).  HL' = width, DE' = height

		;exx
		push de		; y delta
		exx
		pop	bc		; y delta
		exx
		;inc hl
		
		
.xloop
		exx
		
		push de
		push bc
		
.yloop
		push bc
		push hl
		push de
		ld	bc, p_RET1
		push	bc
		jp	(ix)	;	execute PLOT at (hl,de)
.p_RET1
		pop de
		pop hl
		pop bc
		
		inc de
		dec bc		; y delta
		ld	a,b
		or c
		jr	nz,yloop
		
		pop bc
		pop de
		
		inc hl
		
		exx
		dec hl		; x delta
		ld	a,h
		or	l
		jr	nz,xloop
		
		ret

