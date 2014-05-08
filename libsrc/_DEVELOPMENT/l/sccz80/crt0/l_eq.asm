;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;       13/5/99 djm Added carry conditions...

                PUBLIC    l_eq
                EXTERN     l_cmp

;
;
; DE == HL
; carry set if true

.l_eq

	and	a
	sbc	hl,de
	ccf
	ret z
	and     a
	ret
	
IF 0
        call    l_cmp
        scf
        ret   z
        ccf
        dec   hl
        ret
ENDIF
