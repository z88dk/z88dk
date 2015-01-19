;
;       Z88dk Generic Floating Point Math Library
;
;	increment c ix de
;
;       $Id: incr.asm,v 1.4 2015-01-19 01:32:56 pauloscustodio Exp $:

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




