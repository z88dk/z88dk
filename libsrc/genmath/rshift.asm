;
;       Z88dk Generic Floating Point Math Library
;
;	Shift c ix de b right by a
;
;       $Id: rshift.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:


		XLIB	rshift

		XDEF	rsh8


.RSHIFT LD      B,0
.RSH2   SUB     8
        JR      C,RSH4  ;c => 7 or fewer shifts remain
        LD      B,E     ;shift  c ix de b  right by 8...
        LD      E,D
        DEFB    $DD
        LD      D,L
        EX      AF,AF'
        DEFB    $DD
        LD      A,H
        DEFB    $DD
        LD      L,A
        EX      AF,AF'
        DEFB    $DD
        LD      H,C
        LD      C,0     ;...end of shifting
        JR      RSH2
;
.RSH4   ADD     A,9
        LD      L,A
.RSH6   XOR     A
        DEC     L
        RET     Z       ;z => requested shift is complete
        LD      A,C
.RSH8   RRA             ;shift  c ix de b  right by one...
        LD      C,A
        DEFB    $DD
        LD      A,H
        RRA
        DEFB    $DD
        LD      H,A
        DEFB    $DD
        LD      A,L
        RRA
        DEFB    $DD
        LD      L,A
        RR      D
        RR      E
        RR      B       ;...end of shifting
        JR      RSH6


