; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_chars(unsigned char *addr)
; fastcall

SECTION code_lib
SECTION code_nirvanap

PUBLIC NIRVANA_chars

EXTERN asm_NIRVANA_chars

defc NIRVANA_chars = asm_NIRVANA_chars
