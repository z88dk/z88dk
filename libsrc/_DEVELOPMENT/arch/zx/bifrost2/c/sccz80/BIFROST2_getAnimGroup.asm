; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROST2_getAnimGroup(unsigned int tile)

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_getAnimGroup

EXTERN asm_BIFROST2_getAnimGroup

defc BIFROST2_getAnimGroup = asm_BIFROST2_getAnimGroup
