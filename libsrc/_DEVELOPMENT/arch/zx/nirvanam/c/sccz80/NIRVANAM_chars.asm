; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_chars(unsigned char *addr)
; fastcall

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_chars

EXTERN asm_NIRVANAM_chars

defc NIRVANAM_chars = asm_NIRVANAM_chars
