; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_spriteT(unsigned char sprite, unsigned char tile, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_spriteT_callee

EXTERN asm_NIRVANAP_spriteT

_NIRVANAP_spriteT_callee:

   pop af
   pop hl          ; l = sprite
   pop bc
   push af
   
   ld a,h          ; a = tile
   ld h,0
   ld d,c          ; d = lin
   ld e,b          ; e = col

	jp asm_NIRVANAP_spriteT
