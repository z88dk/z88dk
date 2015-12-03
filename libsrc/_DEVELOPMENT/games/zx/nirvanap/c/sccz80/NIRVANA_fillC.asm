; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_fillC(unsigned int attr, unsigned int lin, unsigned int col)

SECTION code_lib
SECTION code_nirvanap

PUBLIC NIRVANA_fillC

EXTERN asm_NIRVANA_fillC

NIRVANA_fillC:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; col
   	inc hl
   	inc hl
   	ld d,(hl)       ; lin
   	inc hl
   	inc hl
   	ld c,(hl)       ; attr

   	jp asm_NIRVANA_fillC
