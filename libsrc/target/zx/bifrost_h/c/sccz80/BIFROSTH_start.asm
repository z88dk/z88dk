; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROST_start()

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_start

EXTERN asm_BIFROSTH_start

defc BIFROSTH_start = asm_BIFROSTH_start

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _BIFROSTH_start
defc _BIFROSTH_start = BIFROSTH_start
ENDIF

