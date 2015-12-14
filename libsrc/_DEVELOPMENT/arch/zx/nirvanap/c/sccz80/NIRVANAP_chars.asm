; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_chars(unsigned char *addr)
; fastcall

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_chars

EXTERN asm_NIRVANAP_chars

defc NIRVANAP_chars = asm_NIRVANAP_chars
