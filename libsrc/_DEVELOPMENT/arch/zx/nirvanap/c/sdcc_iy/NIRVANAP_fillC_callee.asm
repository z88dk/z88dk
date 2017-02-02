; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_fillC(unsigned char attr, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_fillC_callee

EXTERN asm_NIRVANAP_fillC

_NIRVANAP_fillC_callee:

   pop hl
   pop de          ; d = lin
   ld c,e          ; c = attr
   dec sp
   ex (sp),hl
   ld e,h          ; e = col

	jp asm_NIRVANAP_fillC
