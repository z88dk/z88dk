; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_drawTW_raw(unsigned char tile, unsigned char lin, unsigned char col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_drawTW_raw

EXTERN asm_NIRVANAM_drawTW

_NIRVANAM_drawTW_raw:

   ld hl,2
   add hl,sp
   ld a,(hl)       ; tile
   inc hl
   ld d,(hl)       ; lin
   inc hl
   ld e,(hl)       ; col

   jp asm_NIRVANAM_drawTW
