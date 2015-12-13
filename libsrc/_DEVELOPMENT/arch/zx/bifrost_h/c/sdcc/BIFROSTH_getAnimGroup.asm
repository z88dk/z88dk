; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTH_getAnimGroup(unsigned int tile)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_getAnimGroup

EXTERN asm_BIFROSTH_getAnimGroup

_BIFROSTH_getAnimGroup:

        pop af
        pop hl
        push hl
        push af

        jp asm_BIFROSTH_getAnimGroup
