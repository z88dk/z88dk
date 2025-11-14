; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost2

PUBLIC asm_BIFROST2_getAnimGroup

asm_BIFROST2_getAnimGroup:
; L=tile
        bit 7,l         ; compare with BIFROST_STATIC
        ret nz          ; if (static tile) return tile
        srl l
        ld a,(51708)
        and a
        ret z           ; if (2 frames per animation) return tile/2
        srl l
        ret             ; if (4 frames per animation) return tile/4
