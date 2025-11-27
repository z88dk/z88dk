; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_printC(unsigned char ch, void *attrs, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_printC_callee

EXTERN asm_NIRVANAP_printC

_NIRVANAP_printC_callee:

   pop hl
   dec sp
   pop af          ; a = ch
   pop bc          ; bc = attrs
   ex (sp),hl
   ld d,l          ; d = lin
   ld e,h          ; e = col

	jp asm_NIRVANAP_printC
