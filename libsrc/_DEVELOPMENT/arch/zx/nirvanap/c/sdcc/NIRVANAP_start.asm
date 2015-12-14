; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_start(void)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_start

EXTERN asm_NIRVANAP_start

defc _NIRVANAP_start = asm_NIRVANAP_start
