;       Generic Z80 Floating point routines
;       For Small C+ compiler


        SECTION code_fp
        PUBLIC     float

        EXTERN     norm
        EXTERN      l_long_neg

        PUBLIC    float1
        EXTERN    fasign
        EXTERN    fa

;
;       convert the integer in hl to
;       a floating point number in FA
;
;       This routine will need to be rewritten slightly to handle
;       long ints..hopefully fairly OKish..

.float  LD      A,d     ;fetch MSB
.float1
        CPL             ;reverse sign bit
        LD      (fasign),A ;save sign (msb)
        RLA             ;move sign into cy
        JR      C,FL4   ;c => nonnegative number
        call	l_long_neg
; fp number is c ix de b
.FL4	ld	c,d
        ld	ixh,e
        ld	a,h
        ld	ixl,a
        ld	d,l
        ld	e,0
        ld	b,e
        LD      A,32+128
        LD      (fa+5),A ;preset exponent
        JP      norm    ;go normalize c ix de b

