;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;       13/5/99 djm Added carry conditions...

                XLIB    l_eq
                LIB     l_cmp

;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; DE == HL
.l_eq
        call    l_cmp
        scf
        ret   z
        ccf
        dec   hl
        ret
