; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_start(void)

SECTION code_lib
SECTION code_nirvanap

PUBLIC NIRVANA_start

EXTERN asm_NIRVANA_start

defc NIRVANA_start = asm_NIRVANA_start
