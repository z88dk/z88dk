; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost_l

PUBLIC asm_BIFROSTL_getAnimGroup

asm_BIFROSTL_getAnimGroup:
; L=tile
        bit 7,l         ; compare with BIFROST_STATIC
        ret nz          ; if (static tile) return tile
        srl l
        ld a,(58780)
        and a
        ret z           ; if (2 frames per animation) return tile/2
        srl l
        ret             ; if (4 frames per animation) return tile/4
