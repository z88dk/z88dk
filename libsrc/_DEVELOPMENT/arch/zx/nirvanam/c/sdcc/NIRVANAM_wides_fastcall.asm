; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_wides(unsigned char *addr)
; fastcall

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_wides_fastcall

EXTERN asm_NIRVANAM_wides

defc _NIRVANAM_wides_fastcall = asm_NIRVANAM_wides
