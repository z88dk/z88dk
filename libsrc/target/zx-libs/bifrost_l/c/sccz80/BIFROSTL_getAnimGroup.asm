; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTL_getAnimGroup(unsigned int tile)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_getAnimGroup

EXTERN asm_BIFROSTL_getAnimGroup

defc BIFROSTL_getAnimGroup = asm_BIFROSTL_getAnimGroup
