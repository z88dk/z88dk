;
;       Z88dk Generic Floating Point Math Library
;
;	increment c ix de
;
;       $Id: incr.asm,v 1.5 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	incr

.incr   INC     E       ;increment c ix de
        RET     NZ
        INC     D
        RET     NZ
        INC     IXL
        RET     NZ
        INC     IXH
        RET     NZ
        INC     C
        RET     NZ      ;z => carry
        LD      C,$80   ;set high order bit
        INC     (HL)    ;   and increment exponent
        RET     NZ
        ret
;        JP      OFLOW




