;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                XLIB    l_ule
                LIB     l_ucmp

;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; DE <= HL [unsigned]
.l_ule
        call    l_ucmp
        ret     c
	ret	nz	;nc is set
        scf
        ret
