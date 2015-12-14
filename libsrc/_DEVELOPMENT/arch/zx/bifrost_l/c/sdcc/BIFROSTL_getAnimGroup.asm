; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTL_getAnimGroup(unsigned int tile)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_getAnimGroup

EXTERN asm_BIFROSTL_getAnimGroup

_BIFROSTL_getAnimGroup:

        pop af
        pop hl
        push hl
        push af

        jp asm_BIFROSTL_getAnimGroup
