;
;       Z88dk Generic Floating Point Math Library
;
;       Normalise 48bit number in c ix de b
;	current exponent in fa+5
;	Result -> fa +5
;
;       $Id: norm.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:


		XLIB	norm

		LIB	pack
		LIB	norm4

		XREF	fa

.NORM   LD      L,B
        LD      H,E
        XOR     A
.NORM2  LD      B,A
        LD      A,C
        OR      A
        JR      NZ,NORM12  ;nz => 7 or fewer shifts needed
;                       shift c ix d hl  left by one byte
        DEFB    $DD
        LD      C,H
        DEFB    $DD
        LD      A,L
        DEFB    $DD
        LD      H,A
        DEFB    $DD
        LD      L,D
        XOR     A
        LD      D,H
        LD      H,L
        LD      L,A     ;...end of shifting
;
        LD      A,B
        SUB     8       ;adjust exponent
        CP      $D0
        JR      NZ,NORM2
	jp	norm4
;
.NORM8  DEC     B
;                       shift  c ix d hl  left one bit...
        ADD     HL,HL
        RL      D
        EX      AF,AF'
        ADD     IX,IX
        EX      AF,AF'
        JR      NC,NORM10
        INC     IX
.NORM10 EX      AF,AF'
        RL      C       ;...end of shifting
;
.NORM12 JP      P,NORM8 ;p => high order bit still zero
        LD      A,B
;                       move number to  c ix de b
        LD      E,H
        LD      B,L
        OR      A
        JP      Z,PACK  ;z => exponent unchanged
        LD      HL,FA+5         ;update exponent
        ADD     A,(HL)
        LD      (HL),A
        Jp      NC,NORM4        ;nc => underflow (set to 0)
        RET     Z               ;z => underflow (leave as 0)
	jp	pack
