; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; INCLUDED IN C INTERFACE DO NOT ADD TO LIST FILE

SECTION code_clib
SECTION code_bifrost_l

PUBLIC asm_BIFROSTL_findAttrH

asm_BIFROSTL_findAttrH:

; E=lin
; C=col
        ld d,0
		  ld b,d
        ld hl,$e540     ; reference 'deltas' inside BIFROST*
        add hl,bc
        ld c,(hl)       ; BC=delta
        ld h,d
        ld l,e          ; HL=lin
        add hl,hl       ; HL=lin*2
        add hl,hl       ; HL=lin*4
        add hl,de       ; HL=lin*5
        add hl,hl       ; HL=lin*10
        add hl,hl       ; HL=lin*20
        add hl,hl       ; HL=lin*40
        add hl,de       ; HL=lin*41
        add hl,bc       ; HL=lin*41 + delta
        ld de,58419     ; DE=59075 - 16*41
        add hl,de       ; HL=59075 + (lin-16)*41 + delta
        ret
