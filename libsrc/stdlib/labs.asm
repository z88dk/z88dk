;
; Small C z88 stdlib functions
;
; Return absolute value of long


                XLIB    labs
			
		LIB	l_long_neg

;labs(long num)  

.labs
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        bit     7,d
        call    nz,l_long_neg
        ret
