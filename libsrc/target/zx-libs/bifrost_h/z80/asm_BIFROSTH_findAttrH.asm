; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; INCLUDED IN C INTERFACE DO NOT ADD TO LIST FILE

SECTION code_clib
SECTION code_bifrost_h

PUBLIC asm_BIFROSTH_findAttrH

asm_BIFROSTH_findAttrH:

; L=lin
; C=col
        ld h,0
        add hl,hl       ; HL=lin*2
        ld de,57696     ; reference 'attribs' inside BIFROST*
        add hl,de
        ld e,(hl)
        inc l
        ld d,(hl)       ; DE=59075 + (lin-16)*41
        ld l,c          ; L=col
        ld h,$e4        ; reference 'deltas' inside BIFROST*
        ld l,(hl)       ; L=delta
        ld h,0          ; HL=delta
        add hl,de       ; HL=59075 + (lin-16)*41 + delta
        ret
