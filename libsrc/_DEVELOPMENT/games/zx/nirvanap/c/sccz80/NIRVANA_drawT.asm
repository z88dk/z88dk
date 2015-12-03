; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_drawT(unsigned int tile, unsigned int lin, unsigned int col)

SECTION code_lib
SECTION code_nirvanap

PUBLIC NIRVANA_drawT

EXTERN asm_NIRVANA_drawT

NIRVANA_drawT:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; col
   	inc hl
   	inc hl
   	ld d,(hl)       ; lin
   	inc hl
   	inc hl
   	ld a,(hl)       ; tile
   	
   	jp asm_NIRVANA_drawT
