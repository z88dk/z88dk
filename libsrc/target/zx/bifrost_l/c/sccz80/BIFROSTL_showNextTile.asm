; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_showNextTile()

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_showNextTile

EXTERN asm_BIFROSTL_showNextTile

defc BIFROSTL_showNextTile = asm_BIFROSTL_showNextTile

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _BIFROSTL_showNextTile
defc _BIFROSTL_showNextTile = BIFROSTL_showNextTile
ENDIF

