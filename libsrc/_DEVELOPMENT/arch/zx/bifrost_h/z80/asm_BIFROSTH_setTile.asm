; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; INCLUDED IN C INTERFACE DO NOT ADD TO LIST FILE

SECTION code_clib
SECTION code_bifrost_h

PUBLIC asm_BIFROSTH_setTile

EXTERN _BIFROSTH_tilemap

asm_BIFROSTH_setTile:

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
        ld h,_BIFROSTH_tilemap/256
        ld (hl),e
        ret
