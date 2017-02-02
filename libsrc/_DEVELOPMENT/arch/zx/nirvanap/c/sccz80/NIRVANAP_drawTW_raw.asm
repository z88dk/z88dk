; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_drawTW_raw(unsigned int tile, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_drawTW_raw

EXTERN asm_NIRVANAP_drawTW

NIRVANAP_drawTW_raw:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; col
   	inc hl
   	inc hl
   	ld d,(hl)       ; lin
   	inc hl
   	inc hl
   	ld a,(hl)       ; tile
   	
   	jp asm_NIRVANAP_drawTW
