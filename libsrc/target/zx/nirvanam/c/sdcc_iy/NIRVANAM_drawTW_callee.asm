; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_drawTW(unsigned char tile, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_drawTW_callee

EXTERN asm_NIRVANAM_drawTW_di

_NIRVANAM_drawTW_callee:

   pop hl
   pop de          ; d = line
   ld a,e          ; a = tile
   dec sp
   ex (sp),hl
   ld e,h          ; e = col

	jp asm_NIRVANAM_drawTW_di
