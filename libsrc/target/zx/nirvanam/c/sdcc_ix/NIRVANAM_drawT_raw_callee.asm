; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_drawT_raw(unsigned char tile, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_drawT_raw_callee

EXTERN asm_NIRVANAM_drawT

_NIRVANAM_drawT_raw_callee:

   pop hl
   pop de          ; d = line
   ld a,e          ; a = tile
   dec sp
   ex (sp),hl
   ld e,h          ; e = col

	jp asm_NIRVANAM_drawT
