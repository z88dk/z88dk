;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                XLIB    l_cmp

; signed compare of DE and HL
;   carry is sign of difference [set => DE < HL]
;   zero is zero/non-zero
.l_cmp 
        ld a,e
        sub   l
        ld e,a
        ld a,d
        sbc   a,h
        ld hl,1                 ;preset true
	jp m,_cmp1             ;Should it be M or c, does it make a diffence
;        jr c,l_cmp1
        or      e       ;resets carry
        ret
.l_cmp1
        or e
        scf             ;signal minus
        ret
