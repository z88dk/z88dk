; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_drawW_raw(unsigned char tile, unsigned char lin, unsigned char col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_drawW_raw

EXTERN asm_NIRVANAP_drawW

_NIRVANAP_drawW_raw:

	ld hl,2
	add hl,sp
	ld a,(hl)       ; tile
	inc hl
	ld d,(hl)       ; lin
	inc hl
	ld e,(hl)       ; col

	push ix
	
   call asm_NIRVANAP_drawW

	pop ix
	ret
