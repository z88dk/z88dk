;
;       Z88dk Generic Floating Point Math Library
;
;       ???
;
;       $Id: int2.asm,v 1.5 2016-06-21 21:16:49 dom Exp $:


        SECTION code_fp
	PUBLIC	int2

	EXTERN	rshift
	EXTERN	incr
	EXTERN	ldbcfa
	EXTERN	minusbc
	EXTERN	unpack

.int2   LD      B,A     ;if a==0, return with  bc ix de = 0...
        LD      C,A
        LD      D,A
        LD      E,A
        LD      IXH,A
        LD      IXL,A
        OR      A
        RET     Z
        PUSH    HL
        CALL    ldbcfa  ;copy FA into bc ix de,
        CALL    unpack  ; restore hidden bits
        XOR     (HL)
        LD      H,A     ;put sign in msb of h
        JP      P,INT4 ;p => positive number
        DEC     DE      ;decrement c ix de...
        LD      A,D
        AND     E
        INC     A
        JR      NZ,INT4
        DEC     IX
        LD      A,IXH
        AND     IXL
        INC     A
        JR      NZ,INT4
        DEC     C       ;...end of c ix de decrementing
;
.INT4   LD      A,$A8  ;shift  c ix de  right so bits to
        SUB     B       ; the right of the binary point
        CALL    rshift  ; are discarded
        LD      A,H
        RLA
        CALL    C,incr  ;c => negative, increment  c ix de
        LD      B,0
        CALL    C,minusbc ;negate the fraction c ix de
        POP     HL
        RET


