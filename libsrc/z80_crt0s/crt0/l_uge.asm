;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;
;       13/5/99 djm, inverted carry conditions

                XLIB    l_uge
                LIB     l_ucmp

;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; DE >= HL [unsigned]
.l_uge
        call    l_ucmp
        ccf
        ret     c
;        ret     nc

        dec     hl
        ret

