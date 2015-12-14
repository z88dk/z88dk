; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_chars(unsigned char *addr)
; fastcall

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_chars_fastcall

EXTERN asm_NIRVANAP_chars

defc _NIRVANAP_chars_fastcall = asm_NIRVANAP_chars
