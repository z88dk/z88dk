;
;       Z88dk Generic Floating Point Math Library
;
;	increment c ix de
;
;       $Id: incr.asm,v 1.3 2014-04-08 07:06:20 stefano Exp $:

		XLIB	incr

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




