; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_fillT(unsigned int attr, unsigned int lin, unsigned int col)

SECTION code_lib
SECTION code_nirvanap

PUBLIC NIRVANA_fillT

EXTERN asm_NIRVANA_fillT

NIRVANA_fillT:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; col
   	inc hl
   	inc hl
   	ld d,(hl)       ; lin
   	inc hl
   	inc hl
   	ld a,(hl)       ; attr

   	jp asm_NIRVANA_fillT
