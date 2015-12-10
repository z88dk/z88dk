; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_start(void)

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_start

EXTERN asm_NIRVANA_start

defc _NIRVANA_start = asm_NIRVANA_start
