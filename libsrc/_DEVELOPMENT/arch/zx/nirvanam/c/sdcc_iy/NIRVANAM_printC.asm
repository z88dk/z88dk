; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_printC(unsigned char ch, void *attrs, unsigned char lin, unsigned char col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_printC

EXTERN asm_NIRVANAM_printC

_NIRVANAM_printC:

   ld hl,2
   add hl,sp
   ld a,(hl)       ; a = ch
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)       ; bc = attrs
   inc hl
   ld d,(hl)       ; d = lin
   inc hl
   ld e,(hl)       ; e = col
   
   jp asm_NIRVANAM_printC
