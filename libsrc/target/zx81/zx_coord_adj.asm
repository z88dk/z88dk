;
;       ZX81 libraries - Stefano
;
;----------------------------------------------------------------
; adjust coordinates from-to ZX81 ROM style:
; ROM expects (0,0) close to the bottom-left corner, Z88DK
; wants it in the top-left
;----------------------------------------------------------------
;
;  $Id: zx_coord_adj.asm,v 1.6 2016-06-26 20:32:08 dom Exp $
;
;----------------------------------------------------------------

        SECTION code_clib
	PUBLIC    zx_coord_adj

IF FORzx80
	DEFC   COLUMN=$4024    ; S_POSN_x
	DEFC   ROW=$4025       ; S_POSN_y
ELSE
	DEFC    COLUMN=$4039    ; S_POSN_x
	DEFC    ROW=$403A       ; S_POSN_y
ENDIF

zx_coord_adj:      	
			    ; adjust coordinates from-to ZX81 ROM style
	ld  hl,$1821       ; (33,24) = top left screen posn
	ld  de,(COLUMN)
	and a
	sbc hl,de
	ld  (COLUMN),hl
	ret
