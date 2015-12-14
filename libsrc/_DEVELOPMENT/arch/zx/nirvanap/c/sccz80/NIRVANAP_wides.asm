; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_wides(unsigned char *addr)
; fastcall

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_wides

EXTERN asm_NIRVANAP_wides

defc NIRVANAP_wides = asm_NIRVANAP_wides
