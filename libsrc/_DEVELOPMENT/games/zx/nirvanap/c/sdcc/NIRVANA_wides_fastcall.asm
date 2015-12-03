; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_wides(unsigned char *addr)
; fastcall

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_wides_fastcall

EXTERN asm_NIRVANA_wides

defc _NIRVANA_wides_fastcall = asm_NIRVANA_wides
