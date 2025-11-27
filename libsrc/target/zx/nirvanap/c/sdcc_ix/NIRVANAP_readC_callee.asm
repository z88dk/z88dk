; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_readC(void *attrs, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_readC_callee

EXTERN asm_NIRVANAP_readC

_NIRVANAP_readC_callee:

   pop hl
   pop bc          ; bc = attrs
   ex (sp),hl
   ld d,l          ; d = lin
   ld e,h          ; e = col

	jp asm_NIRVANAP_readC
