;
;       Z88dk Generic Floating Point Math Library
;
;       Normalise 48bit number in c ix de b
;	current exponent in fa+5
;	Result -> fa +5
;
;       $Id: norm_noaf.asm,v 1.4 2016-06-21 21:16:49 dom Exp $:


        SECTION code_fp
	PUBLIC	norm

	EXTERN	pack
	EXTERN	norm4
	EXTERN	afswap

	EXTERN	fa

.norm   LD      L,B
        LD      H,E
        XOR     A
.NORM2  LD      B,A
        LD      A,C
        OR      A
        JR      NZ,NORM12  ;nz => 7 or fewer shifts needed
;                       shift c ix d hl  left by one byte
        LD      C,IXH
        LD      A,IXL
        LD      IXH,A
        LD      IXL,D
        XOR     A
        LD      D,H
        LD      H,L
        LD      L,A     ;...end of shifting
;
        LD      A,B
        SUB     8       ;adjust exponent
        CP      $D0
        JR      NZ,NORM2
        jp      norm4

;
.NORM8  DEC     B
;                       shift  c ix d hl  left one bit...
        ADD     HL,HL
        RL      D
        ;EX      AF,AF'
		call	afswap
        ADD     IX,IX
        ;EX      AF,AF'
		call	afswap
        JR      NC,NORM10
        INC     IX
.NORM10 ;EX      AF,AF'
		call	afswap
        RL      C       ;...end of shifting
;
.NORM12 JP      P,NORM8 ;p => high order bit still zero
        LD      A,B
;                       move number to  c ix de b
        LD      E,H
        LD      B,L
        OR      A
        JP      Z,pack  ;z => exponent unchanged
        LD      HL,fa+5         ;update exponent
        ADD     A,(HL)
        LD      (HL),A
        JP      NC,norm4        ;nc => underflow (set to 0)
        RET     Z               ;z => underflow (leave as 0)
        jp      pack
