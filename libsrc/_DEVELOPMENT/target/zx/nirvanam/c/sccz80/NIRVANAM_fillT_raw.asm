; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_fillT_raw(unsigned int attr, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_fillT_raw

EXTERN asm_NIRVANAM_fillT

NIRVANAM_fillT_raw:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; col
   	inc hl
   	inc hl
   	ld d,(hl)       ; lin
   	inc hl
   	inc hl
   	ld a,(hl)       ; attr

   	jp asm_NIRVANAM_fillT
