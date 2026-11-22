; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_start(void)

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_start

EXTERN asm_NIRVANAM_start

defc NIRVANAM_start = asm_NIRVANAM_start

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _NIRVANAM_start
defc _NIRVANAM_start = NIRVANAM_start
ENDIF

