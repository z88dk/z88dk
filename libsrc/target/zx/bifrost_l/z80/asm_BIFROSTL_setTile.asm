; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost_l

PUBLIC asm_BIFROSTL_setTile

EXTERN _BIFROSTL_tilemap

asm_BIFROSTL_setTile:

; L=px
; C=py
; E=tile
        ld a,l
        add a,a
        add a,a
        add a,a
        add a,l         ; A=px*9
        add a,c         ; A=px*9+py
        inc a           ; instead of: add a,_BIFROST_tilemap%256
        ld l,a
        ld h,_BIFROSTL_tilemap/256
        ld (hl),e
        ret
