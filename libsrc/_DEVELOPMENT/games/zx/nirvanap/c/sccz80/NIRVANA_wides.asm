; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_wides(unsigned char *addr)
; fastcall

SECTION code_lib
SECTION code_nirvanap

PUBLIC NIRVANA_wides

EXTERN asm_NIRVANA_wides

defc NIRVANA_wides = asm_NIRVANA_wides
