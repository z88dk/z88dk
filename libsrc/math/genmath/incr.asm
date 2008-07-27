;
;       Z88dk Generic Floating Point Math Library
;
;	increment c ix de
;
;       $Id: incr.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:

		XLIB	incr

.INCR   INC     E       ;increment c ix de
        RET     NZ
        INC     D
        RET     NZ
        DEFB    $DD
        INC     L
        RET     NZ
        DEFB    $DD
        INC     H
        RET     NZ
        INC     C
        RET     NZ      ;z => carry
        LD      C,$80   ;set high order bit
        INC     (HL)    ;   and increment exponent
        RET     NZ
        ret
;        JP      OFLOW




