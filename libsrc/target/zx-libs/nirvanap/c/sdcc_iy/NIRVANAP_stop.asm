; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_stop(void)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_stop

EXTERN asm_NIRVANAP_stop

defc _NIRVANAP_stop = asm_NIRVANAP_stop
