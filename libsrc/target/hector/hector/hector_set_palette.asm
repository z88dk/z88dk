


SECTION code_clib


PUBLIC hector_set_palette
PUBLIC _hector_set_palette



; 0x1000
; cass motor p2 p2 p2 p0 p0 p0
; 0x1800
; click bright2 p3 p3 p3 p1 p1 p1
;
; p3 = sp +2
; p2 = sp +4
; p1 = sp +6
; p0 = sp + 8

; (p0, p1, p2, p3) __smallc;
hector_set_palette:
_hector_set_palette:
    push    ix
    ld      ix,2
    add     ix,sp
    ld      a,(ix+4)        ;p2
    rlca
    rlca
    rlca
    and     @00111000
    ld      c,a
    ld      a,(ix+8)        ;p0
    and     @00000111
    or      c
    ld      (0x1000),a

    ld      a,(ix+2)        ;p3
    rlca
    rlca
    rlca
    and     @00111000
    ld      c,a
    bit     3,(ix+4)        ;p2
    jr      z,not_bright
    set     6,c             ;Handle the bright bit for colour 2 on the HR machines
not_bright:
    ld      a,(ix+6)        ;p1
    and     @00000111
    or      c
    ld      (0x1800),a
    pop     ix
    ret

