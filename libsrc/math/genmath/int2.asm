;
;       Z88dk Generic Floating Point Math Library
;
;       ???
;
;       $Id: int2.asm,v 1.2 2012-04-17 16:37:46 stefano Exp $:


		XLIB	int2

		LIB	rshift
		LIB	incr
		LIB	ldbcfa
		LIB	minusbc
		LIB	unpack

.INT2   LD      B,A     ;if a==0, return with  bc ix de = 0...
        LD      C,A
        LD      D,A
        LD      E,A
        LD      IXH,A
        LD      IXL,A
        OR      A
        RET     Z
        PUSH    HL
        CALL    LDBCFA  ;copy FA into bc ix de,
        CALL    UNPACK  ; restore hidden bits
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
        CALL    RSHIFT  ; are discarded
        LD      A,H
        RLA
        CALL    C,INCR  ;c => negative, increment  c ix de
        LD      B,0
        CALL    C,MINUSBC ;negate the fraction c ix de
        POP     HL
        RET


