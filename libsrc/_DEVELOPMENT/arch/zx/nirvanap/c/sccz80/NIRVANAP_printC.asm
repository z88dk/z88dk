; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_printC(unsigned int ch, unsigned char *attrs, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_printC

EXTERN asm_NIRVANAP_printC

NIRVANAP_printC:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; col
   	inc hl
   	inc hl
   	ld d,(hl)       ; lin
   	inc hl
   	inc hl
   	ld c,(hl)
   	inc hl
   	ld b,(hl)       ; attrs
   	inc hl
   	ld a,(hl)       ; ch

   	jp asm_NIRVANAP_printC
