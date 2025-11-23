; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_drawW_raw(unsigned char tile, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_drawW_raw_callee

EXTERN asm_NIRVANAP_drawW

_NIRVANAP_drawW_raw_callee:

   pop hl
   dec sp
   pop af          ; a = tile
   ex (sp),hl
   ld d,l          ; d = lin
   ld e,h          ; e = col

	jp asm_NIRVANAP_drawW
