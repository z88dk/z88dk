; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_fillT_raw(unsigned char attr, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_fillT_raw_callee

EXTERN asm_NIRVANAP_fillT

_NIRVANAP_fillT_raw_callee:

   pop hl
   pop de          ; d = lin
   ld a,e          ; a = attr
   dec sp
   ex (sp),hl
   ld e,h          ; e = col

	jp asm_NIRVANAP_fillT
