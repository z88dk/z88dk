; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_spriteT(unsigned int sprite, unsigned int tile, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_spriteT

EXTERN asm_NIRVANAP_spriteT

NIRVANAP_spriteT:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; col
   	inc hl
   	inc hl
   	ld d,(hl)       ; lin
   	inc hl
   	inc hl
   	ld a,(hl)       ; tile
        inc hl
   	inc hl
   	ld l,(hl)       ; sprite
   	ld h,0

   	jp asm_NIRVANAP_spriteT
