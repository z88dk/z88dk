; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROST2_getAnimGroup(unsigned int tile)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_getAnimGroup

EXTERN asm_BIFROST2_getAnimGroup

_BIFROST2_getAnimGroup:

        pop af
        pop hl
        push hl
        push af

        jp asm_BIFROST2_getAnimGroup
