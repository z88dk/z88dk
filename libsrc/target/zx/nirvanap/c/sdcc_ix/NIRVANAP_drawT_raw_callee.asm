; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_drawT_raw(unsigned char tile, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_drawT_raw_callee

EXTERN asm_NIRVANAP_drawT

_NIRVANAP_drawT_raw_callee:

   pop hl
   pop de          ; d = line
   ld a,e          ; a = tile
   dec sp
   ex (sp),hl
   ld e,h          ; e = col

	jp asm_NIRVANAP_drawT
