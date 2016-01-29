; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_wides(unsigned char *addr)
; fastcall

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_wides

EXTERN asm_NIRVANAM_wides

defc NIRVANAM_wides = asm_NIRVANAM_wides
