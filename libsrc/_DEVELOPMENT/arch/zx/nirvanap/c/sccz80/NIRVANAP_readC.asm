; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_readC(unsigned char *attrs, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_readC

EXTERN asm_NIRVANAP_readC

NIRVANAP_readC:

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

   	jp asm_NIRVANAP_readC
