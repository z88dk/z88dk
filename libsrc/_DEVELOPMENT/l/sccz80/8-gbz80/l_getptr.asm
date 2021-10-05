;       Z88 Small C+ Run Time Library 
;
;       Get Long Pointer from Near Memory

SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_getptr


;Fetch 3 byte pointer from (hl)

.l_getptr
    ld a,(hl+)
    ld e,a
    ld a,(hl+)
    ld d,a
    ld a,(hl)
    ld h,d
    ld l,e
    ld e,a
    ld d,0
    ret
